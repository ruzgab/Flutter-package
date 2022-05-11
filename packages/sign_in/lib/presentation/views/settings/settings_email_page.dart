part of '../../../sign_in.dart';

class SettingsEmailPage extends ConsumerWidget {
  const SettingsEmailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(signInLocalizationsProvider);
    final isSaving = ref.watch(
      settingsEmailControllerProvider.select((state) => state.isLoading),
    );
    final canSubmit = ref.watch(
      settingsEmailControllerProvider.select((state) => state.canSubmit),
    );

    ref.listen<SettingsEmailState>(settingsEmailControllerProvider, (_, state) {
      if (state.errorText != null) {
        showErrorDialog(
          context,
          ref,
          title: l10n.errorTitle,
          content: state.errorText,
        );
      } else if (state.isSuccess) {
        Navigator.pop(context);
      }
    });

    return SettingsPageBuilder(
      title: l10n.settingsEmailTitle,
      child: const _SettingsEmailContents(),
      isSaving: isSaving,
      canSubmit: canSubmit,
      onPressed: () {
        final controller = ref.read(settingsEmailControllerProvider.notifier);
        controller.handleEvent(const SettingsEmailEvent.submit());
      },
    );
  }
}

class _SettingsEmailContents extends ConsumerStatefulWidget {
  const _SettingsEmailContents({Key? key}) : super(key: key);

  @override
  createState() => _SettingsEmailContentsState();
}

class _SettingsEmailContentsState
    extends ConsumerState<_SettingsEmailContents> {
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ref.watch(signInLocalizationsProvider);
    final controller = ref.read(settingsEmailControllerProvider.notifier);
    final email = ref.watch(
      settingsEmailControllerProvider.select((state) => state.email),
    );

    return FormPage(
      children: [
        FormSection(
          child: FormRow(
            child: PlatformTextField(
              controller: TextEditingController(text: email),
              keyboardType: TextInputType.emailAddress,
              placeholder: l10n.settingsEmailLabel,
              autocorrect: false,
              focusNode: focusNode,
              onChanged: (String value) {
                controller.handleEvent(SettingsEmailEvent.emailChanged(value));
              },
              onSubmitted: (_) {
                controller.handleEvent(const SettingsEmailEvent.submit());
              },
            ),
          ),
        ),
      ],
    );
  }
}
