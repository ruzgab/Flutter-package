part of theme;

/// The provider of the [AppTheme]
/// Needs to be overridden in the [ProviderScope] of the app.
final appThemeProvider = Provider<AppTheme>((_) => throw UnimplementedError());

/// The provider of the [Brightness]
/// Returns the brightness of the current device layout
/// but can be overridden inside the app by watching a custom setting.
final brightnessProvider = Provider<Brightness>(
  (ref) => WidgetsBinding.instance!.window.platformBrightness,
);

/// This provider is used by [Scaafold] or other widgets that handle
/// an [AnnotatedRegion] to specify the layout of status bars
/// and navigation bar on Android devices.
final systemOverlayStyleProvider = Provider<SystemUiOverlayStyle>((ref) {
  final appTheme = ref.watch(appThemeProvider);

  // workaround because if the user is in dark mode and sets the theme of the app
  // to dark mode, a dark layer is applied to the color passed to systemNavigationBarColor
  // so we cannot get a full white. Instead of producing a weird behaviour with
  // dark buttons and dark background, we skip this feature and keep the black
  // navigation bar. Honestly, so few people will set light mode while their device
  // is in dark mode, isn't it?
  if (appTheme.brightness == Brightness.light &&
      WidgetsBinding.instance!.window.platformBrightness == Brightness.dark) {
    return SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  } else {
    return SystemUiOverlayStyle(
      statusBarColor: Colors.red, //Colors.transparent,
      systemNavigationBarColor:
          appTheme.statusBarColor ?? appTheme.scaffoldBackgroundColor,
      systemNavigationBarIconBrightness: appTheme.brightness,
    );
  }
});

/// The [ThemeData] that will be used in the [MaterialApp]
/// Retrieves all the data from the [AppTheme].
final materialThemeProvider = Provider<ThemeData>((ref) {
  final appTheme = ref.watch(appThemeProvider);
  return ThemeData(
    brightness: appTheme.brightness,
    scaffoldBackgroundColor: appTheme.scaffoldBackgroundColor,
    primaryColor: appTheme.primaryColor,
    accentColor: appTheme.primaryColor,
    toggleableActiveColor: appTheme.primaryColor,
    appBarTheme: AppBarTheme(
      shadowColor: appTheme.scaffoldBackgroundColor,
      backgroundColor: appTheme.navigationBarBackgroundColor,
      backwardsCompatibility: false,
      foregroundColor:
          appTheme.navigationBarBackgroundColor.computeLuminance() > 0.5
              ? Colors.black
              : Colors.white,
      iconTheme: IconThemeData(color: Colors.grey),
    ),
    unselectedWidgetColor: Color(0xFF757575),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: appTheme.scaffoldBackgroundColor,
      elevation: 8,
      selectedIconTheme: IconThemeData(
        color: appTheme.primaryColor,
      ),
      selectedItemColor: appTheme.primaryColor,
    ),
  );
});

/// The [CupertinoThemeData] that will be used in the [CupertinoApp]
/// Retrieves all the data from the [AppTheme].
final cupertinoThemeProvider = Provider<CupertinoThemeData>((ref) {
  final appTheme = ref.watch(appThemeProvider);
  return CupertinoThemeData(
    primaryColor: appTheme.primaryColor,
    scaffoldBackgroundColor: appTheme.scaffoldBackgroundColor,
    barBackgroundColor: appTheme.navigationBarBackgroundColor,
  );
});

/// Theme with specific parameters for List that can be overridden
/// at any part of the app with inside a ProviderScope for specific needs
/// (such as have a greater padding in a view).
final listViewThemeProvider = Provider<ListViewTheme>((_) => ListViewTheme());

/// Theme with specific parameters for Form hat can be overridden
/// at any part of the app with inside a ProviderScope for specific needs
/// (such as a special backgroundColor in one form).
final formThemeProvider = Provider<FormTheme>((ref) {
  final brightness = ref.watch(brightnessProvider);
  if (brightness == Brightness.dark) {
    return FormTheme(
      backgroundColor: Color(0xFF121212),
      rowBackgroundColor: Color(0xFF262626),
      rowDividerColor: Color(0xFF333333),
      sectionDividerColor: Color(0xFF333333),
    );
  } else {
    return FormTheme(
      backgroundColor: isCupertino() ? Color(0xFFF5F5F5) : Color(0xFFFFFFFF),
      rowBackgroundColor: Color(0xFFFFFFFF),
      rowDividerColor: Color(0xFFE6E6E6),
      sectionDividerColor: Color(0xFFE6E6E6),
    );
  }
});
