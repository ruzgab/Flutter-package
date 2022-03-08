library localization;

import 'dart:ui';
import 'package:extensions/extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localization/locale_names.dart';

extension LocaleName on Locale {
  String get name {
    return (localeNames[languageCode] ?? "Unknown").capitalize();
  }

  String get regionalName {
    return (localeNames["${languageCode}_$countryCode"] ?? "Unknown")
        .capitalize();
  }
}

final localesProvider = Provider<List<Locale>>((ref) {
  return const [
    Locale('en', 'US'),
    Locale('fr', 'FR'),
  ];
});

final userLanguageProvider = Provider<String?>((_) => null);

final localeProvider = Provider<Locale>(
  (ref) {
    final availableLocales = ref.read(localesProvider);
    final deviceLocale = window.locale;

    if (availableLocales.isEmpty) {
      throw UnimplementedError();
    }

    final userLanguage = ref.watch(userLanguageProvider);
    var _locales = availableLocales.where(
      (locale) => locale.languageCode == userLanguage,
    );
    if (_locales.isNotEmpty) {
      return _locales.first;
    }

    if (availableLocales.contains(deviceLocale)) {
      return deviceLocale;
    }

    return availableLocales.first;
  },
  dependencies: [localesProvider, userLanguageProvider],
);
