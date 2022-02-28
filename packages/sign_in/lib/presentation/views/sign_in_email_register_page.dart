part of '../../sign_in.dart';

void _handleEmailRegisterEvent(WidgetRef ref, SignInEmailRegisterEvent event) {
  final controller = ref.read(signInEmailRegisterControllerProvider.notifier);
  controller.handleEvent(event);
}

class SignInEmailRegisterPage extends ConsumerWidget {
  const SignInEmailRegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SignInEmailRegisterState>(signInEmailRegisterControllerProvider,
        (_, state) {
      if (state.errorText != null) {
        final l10n = ref.watch(signInLocalizationsProvider);
        showErrorDialog(
          context,
          ref,
          title: l10n.errorTitle,
          content: state.errorText,
        );
      }
    });

    return const SignInEmailRegisterPageBuilder();
  }
}

class SignInEmailRegisterPageBuilder extends ConsumerWidget {
  const SignInEmailRegisterPageBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.read(signInLocalizationsProvider);
    final state = ref.watch(signInEmailRegisterControllerProvider);

    return SignInPageBuilder(
      title: l10n.signInWithEmailRegisterTitle,
      leadingButton: const SignInCloseButton(),
      child: const SignInEmailRegisterPageForm(),
      errorText: state.errorText,
      isLoading: state.isLoading,
    );
  }
}

class SignInEmailRegisterPageForm extends ConsumerStatefulWidget {
  const SignInEmailRegisterPageForm({Key? key}) : super(key: key);

  @override
  createState() => _SignInEmailRegisterPageFormState();
}

class _SignInEmailRegisterPageFormState
    extends ConsumerState<SignInEmailRegisterPageForm> {
  final emailTextController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordTextController = TextEditingController();
  final passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      emailFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ref.watch(signInLocalizationsProvider);
    final canSubmit = ref.watch(
      signInEmailRegisterControllerProvider.select((state) => state.canSubmit),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlatformTextField(
          controller: emailTextController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          placeholder: l10n.signInWithEmailPlaceholder,
          autocorrect: false,
          focusNode: emailFocusNode,
          onChanged: (String value) {
            _handleEmailRegisterEvent(
                ref, SignInEmailRegisterEvent.emailChanged(value));
          },
          onSubmitted: (_) {
            passwordFocusNode.requestFocus();
          },
        ),
        if (isCupertino()) const SignInDivider(),
        const SizedBox(height: 10),
        PlatformTextField(
          controller: passwordTextController,
          placeholder: l10n.signInWithEmailPasswordPlaceholder,
          autocorrect: false,
          obscureText: true,
          focusNode: passwordFocusNode,
          onChanged: (String value) {
            _handleEmailRegisterEvent(
                ref, SignInEmailRegisterEvent.passwordChanged(value));
          },
        ),
        if (isCupertino()) const SignInDivider(),
        const SignInPasswordRequirements(),
        SignInSubmitButton(
          title: l10n.continueButton,
          onPressed: canSubmit
              ? () {
                  _handleEmailRegisterEvent(
                      ref, const SignInEmailRegisterEvent.submit());
                }
              : null,
        ),
        PlatformTextButton(
          title: l10n.signInWithEmailAlreadyAccount,
          onPressed: () {
            final navigator = signInNavigatorKey.currentState!;
            navigator.pushReplacementNamed(SignInRoutes.signInEmailPage);
          },
        ),
      ],
    );
  }
}

class SignInPasswordRequirements extends ConsumerWidget {
  const SignInPasswordRequirements({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.read(signInLocalizationsProvider);
    final state = ref.watch(signInEmailRegisterControllerProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.passwordRequirements, style: const TextStyle(fontSize: 13)),
          SignInPasswordRequirement(
            label: l10n.passwordRequirementMinLength,
            isValid: state.passwordHasMinLength,
          ),
          SignInPasswordRequirement(
            label: l10n.passwordRequirementUppercase,
            isValid: state.passwordHasUppercase,
          ),
          SignInPasswordRequirement(
            label: l10n.passwordRequirementLowercase,
            isValid: state.passwordHasLowercase,
          ),
          SignInPasswordRequirement(
            label: l10n.passwordRequirementDigits,
            isValid: state.passwordHasDigits,
          ),
          SignInPasswordRequirement(
            label: l10n.passwordRequirementSpecialChars,
            isValid: state.passwordHasSpecialChars,
          ),
        ],
      ),
    );
  }
}

class SignInPasswordRequirement extends StatelessWidget {
  const SignInPasswordRequirement({
    Key? key,
    required this.label,
    this.isValid = false,
  }) : super(key: key);

  final bool isValid;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isValid ? "✔️" : "✖️",
          style: TextStyle(
              color: isValid ? Colors.green : Colors.red, fontSize: 13),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ],
    );
  }
}
