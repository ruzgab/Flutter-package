part of '../../sign_in.dart';

@freezed
class SignInEvent with _$SignInEvent {
  const factory SignInEvent.signInWithFacebook() = _SignInWithFacebook;
  const factory SignInEvent.signInWithGoogle() = _SignInWithGoogle;
  const factory SignInEvent.signInWithApple() = _SignInWithApple;
  const factory SignInEvent.signInWithEmail() = _SignInWithEmail;
  const factory SignInEvent.signInWithEmailLink(String email) =
      _SignInWithEmailLink;
  const factory SignInEvent.signInWithPhone() = _SignInWithPhone;
  const factory SignInEvent.signInAnonymously() = _SignInAnonymously;
}
