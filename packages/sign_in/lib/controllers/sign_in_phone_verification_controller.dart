part of '../sign_in.dart';

@freezed
class SignInPhoneVerificationEvent with _$SignInPhoneVerificationEvent {
  const factory SignInPhoneVerificationEvent.resendCode() = _ResendCode;
  const factory SignInPhoneVerificationEvent.codeChanged(String input) =
      _CodeChanged;
  const factory SignInPhoneVerificationEvent.verifyCode() = _VerifyCode;
}

@freezed
class SignInPhoneVerificationState with _$SignInPhoneVerificationState {
  const factory SignInPhoneVerificationState({
    @Default(delayBeforeUserCanRequestNewCode) int countdown,
    required Map<String, dynamic> phoneNumber,
    required String verificationId,
    @Default("") String verificationCode,
    @Default(false) bool canSubmit,
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    String? errorText,
  }) = _SignInPhoneVerificationState;
}

/// An object which controls the state of the verification form.
///
/// It uses a [StateNotifier] to return a [SubmitState] and also
/// do more much stuff such as parsing the phone number and submit the form.
///
/// The core of the functions are in the [AuthService] class because
/// these functions are also used in the member section of the app.
class SignInVerificationController
    extends StateNotifier<SignInPhoneVerificationState> {
  SignInVerificationController(
    Map<String, dynamic> phoneNumber,
    String verificationId,
    this._service,
  ) : super(SignInPhoneVerificationState(
          verificationId: verificationId,
          phoneNumber: phoneNumber,
        )) {
    _startTimer();
  }

  final FirebaseAuthService _service;

  String get formattedPhoneNumber =>
      state.phoneNumber['national'].replaceAll(" ", "\u00A0");

  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    state = state.copyWith(countdown: delayBeforeUserCanRequestNewCode);
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (state.countdown == 0) {
          timer.cancel();
        } else {
          state = state.copyWith(countdown: state.countdown - 1);
        }
      },
    );
  }

  void handleEvent(SignInPhoneVerificationEvent event) {
    event.when(
      codeChanged: (input) {
        state = state.copyWith(
          verificationCode: input,
          canSubmit: input.length == 6,
        );
      },
      resendCode: _resendCode,
      verifyCode: _verifyCode,
    );
  }

  Future<void> _resendCode() async {
    state = state.copyWith(isLoading: true);

    try {
      _service.verifyPhone(state.phoneNumber['e164'], (verificationId) {
        state = state.copyWith(
          isLoading: false,
          verificationId: verificationId,
        );
      });
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorText: e.message!,
      );
    }
  }

  Future<void> _verifyCode() async {
    if (!state.canSubmit) return;
    state = state.copyWith(isLoading: true);

    try {
      _service.verifyCode(state.verificationId, state.verificationCode, () {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
        );
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        state = state.copyWith(
          isLoading: false,
          errorText: "INVALID_CODE",
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorText: e.message!,
        );
      }
    }
  }
}
