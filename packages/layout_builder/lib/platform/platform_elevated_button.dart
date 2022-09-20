part of platform;

class PlatformElevatedButton
    extends PlatformWidgetBase<ElevatedButton, CupertinoButton> {
  PlatformElevatedButton({
    this.title,
    this.child,
    this.onPressed,
    this.color,
  })  : assert(child != null || title != null,
            'You must provide a title or a child.'),
        super();

  final String? title;
  final Widget? child;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  ElevatedButton createMaterialWidget(BuildContext context, WidgetRef ref) {
    final elevatedButtonRadius = ref.watch(
      appThemeProvider.select((appTheme) => appTheme.elevatedButtonRadius),
    );
    final elevatedButtonPadding = ref.watch(
      appThemeProvider.select((appTheme) => appTheme.elevatedButtonPadding),
    );
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(elevatedButtonRadius),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(elevatedButtonPadding),
        child: child != null
            ? child
            : Text(
                title!,
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
      ),
      onPressed: onPressed,
    );
  }

  @override
  CupertinoButton createCupertinoWidget(BuildContext context, WidgetRef ref) {
    final elevatedButtonRadius = ref.watch(
      appThemeProvider.select((appTheme) => appTheme.elevatedButtonRadius),
    );
    final elevatedButtonPadding = ref.watch(
      appThemeProvider.select((appTheme) => appTheme.elevatedButtonPadding),
    );
    return CupertinoButton(
      color: color,
      padding: EdgeInsets.all(elevatedButtonPadding),
      onPressed: onPressed,
      borderRadius: BorderRadius.circular(elevatedButtonRadius),
      child: child != null
          ? child!
          : Text(
              title!,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.5,
              ),
            ),
    );
  }
}

class PlatformFullSizedElevatedButton extends StatelessWidget {
  PlatformFullSizedElevatedButton({
    required this.title,
    this.onPressed,
  });

  final String title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: PlatformElevatedButton(
        title: title,
        onPressed: onPressed,
      ),
    );
  }
}
