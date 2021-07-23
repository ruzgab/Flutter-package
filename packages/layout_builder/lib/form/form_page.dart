part of 'form.dart';

class FormWithOverlay extends StatelessWidget {
  const FormWithOverlay({
    Key? key,
    required this.child,
    this.isSaving = false,
  }) : super(key: key);

  final bool isSaving;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isSaving ? 0.5 : 1,
      duration: Duration(milliseconds: 200),
      child: AbsorbPointer(
        absorbing: isSaving ? true : false,
        child: SizedBox.shrink(),
      ),
    );

    /*Stack(
      children: <Widget>[
        child,
        FormSavingOverlay(isSaving: isSaving),
      ],
    );*/
  }
}

class FormSavingOverlay extends StatelessWidget {
  const FormSavingOverlay({
    Key? key,
    required this.isSaving,
  }) : super(key: key);

  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isSaving ? 0.5 : 1,
      duration: Duration(milliseconds: 200),
      child: AbsorbPointer(
        absorbing: isSaving ? true : false,
        child: SizedBox.shrink(),
      ),
    );
  }
}

class FormPage extends ConsumerWidget {
  const FormPage({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(builder: (
      BuildContext context,
      BoxConstraints viewportConstraints,
    ) {
      final formTheme = ref.watch(formThemeProvider);
      return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: viewportConstraints.maxHeight,
          ),
          child: Container(
            color: formTheme.backgroundColor,
            padding: EdgeInsets.symmetric(
              horizontal: isCupertino() ? 18 : 0,
              vertical: isCupertino() ? 18 : 0, // 14 si fond blanc
            ),
            child: Column(children: [
              for (var child in children) ...[
                child,
                if (child != children.last) FormSectionDivider(),
                //FormSectionDivider(),
              ],
            ]),
          ),
        ),
      );
    });
  }
}
