import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

enum ThemeType { system, light, dark }

extension ThemeTypeX on ThemeType {
  Brightness get brightness {
    if (this == ThemeType.dark) {
      return Brightness.dark;
    } else if (this == ThemeType.light) {
      return Brightness.light;
    } else {
      return WidgetsBinding.instance!.window.platformBrightness;
    }
  }
}

class ThemeTypeConverter implements JsonConverter<ThemeType, int> {
  const ThemeTypeConverter();

  @override
  ThemeType fromJson(int value) {
    return ThemeType.values[value];
  }

  @override
  int toJson(ThemeType value) => value.index;
}
