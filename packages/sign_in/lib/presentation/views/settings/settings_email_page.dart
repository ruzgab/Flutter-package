part of '../../../sign_in.dart';

class SettingsEmailPage extends ConsumerWidget {
  const SettingsEmailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(signInLocalizationsProvider);
    final isSaving = ref.watch(
      settingsEmailControllerProvider.select((state) => state.isLoading),
    );

    return PlatformScaffold(
      appBar: PlatformNavigationBar(
        title: l10n.settingsEmailTitle,
        trailing: isSaving
            ? const FormLoader()
            : PlatformNavigationBarSaveButton(
                onPressed: () {
                  final controller =
                      ref.read(settingsEmailControllerProvider.notifier);
                  controller.handleEvent(const SettingsEmailEvent.submit());
                },
              ),
      ),
      body: FormWithOverlay(
        isSaving: isSaving,
        child: const _FormContents(),
      ),
    );
  }
}

class _FormContents extends ConsumerStatefulWidget {
  const _FormContents({Key? key}) : super(key: key);

  @override
  createState() => _FormContentsState();
}

class _FormContentsState extends ConsumerState<_FormContents> {
  final textController = TextEditingController();
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
    final controller = ref.read(settingsEmailControllerProvider.notifier);

    return FormPage(
      children: [
        FormSection(
          child: PlatformTextField(
            controller: textController,
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
      ],
    );
  }
}
