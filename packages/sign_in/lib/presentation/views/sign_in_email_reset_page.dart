part of '../../sign_in.dart';

void _handleEmailResetEvent(WidgetRef ref, SignInEmailResetEvent event) {
  final controller = ref.read(signInEmailResetControllerProvider.notifier);
  controller.handleEvent(event);
}

class SignInEmailResetPage extends ConsumerWidget {
  const SignInEmailResetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SignInEmailState>(signInEmailControllerProvider, (_, state) {
      if (state.isSuccess) {
      } else if (state.errorText != null) {
        final l10n = ref.watch(signInLocalizationsProvider);
        showErrorDialog(
          context,
          ref,
          title: l10n.errorTitle,
          content: state.errorText,
        );
      }
    });

    return const SignInEmailResetPageBuilder();
  }
}

class SignInEmailResetPageBuilder extends ConsumerWidget {
  const SignInEmailResetPageBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.read(signInLocalizationsProvider);
    final state = ref.watch(signInEmailControllerProvider);

    return SignInPageBuilder(
      title: l10n.emailRecoverTitle,
      subtitle: l10n.emailRecoverSubtitle,
      child: const SignInEmailResetForm(),
      errorText: state.errorText,
      isLoading: state.isLoading,
    );
  }
}

class SignInEmailResetForm extends ConsumerStatefulWidget {
  const SignInEmailResetForm({Key? key}) : super(key: key);

  @override
  createState() => _SignInEmailResetFormState();
}

class _SignInEmailResetFormState extends ConsumerState<SignInEmailResetForm> {
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ref.watch(signInLocalizationsProvider);
    final canSubmit = ref.watch(
      signInEmailResetControllerProvider.select((state) => state.canSubmit),
    );

    return Column(
      children: [
        PlatformTextField(
          controller: TextEditingController(),
          keyboardType: TextInputType.emailAddress,
          placeholder: l10n.signInWithEmailPlaceholder,
          autocorrect: false,
          focusNode: focusNode,
          onChanged: (String value) {
            _handleEmailResetEvent(
                ref, SignInEmailResetEvent.emailChanged(value));
          },
        ),
        if (isCupertino()) const SignInDivider(),
        SignInSubmitButton(
          title: l10n.emailRecoverSubmitButton,
          onPressed: canSubmit
              ? () {
                  _handleEmailResetEvent(
                      ref, const SignInEmailResetEvent.submit());
                }
              : null,
        ),
      ],
    );
  }
}
