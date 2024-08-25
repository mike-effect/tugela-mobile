import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  Brightness get brightness => theme.brightness;

  Color get primaryColor => theme.primaryColor;

  Color get secondaryColor => theme.colorScheme.secondary;

  Color get tertiaryColor => theme.colorScheme.tertiary;

  bool get isDark => brightness == Brightness.dark;

  InputDecorationTheme get inputTheme => theme.inputDecorationTheme;

  Color? get borderColor =>
      theme.inputDecorationTheme.enabledBorder?.borderSide.color;

  TextTheme get textTheme => theme.textTheme;

  IconThemeData get iconTheme => theme.iconTheme;

  ColorScheme get colorScheme => theme.colorScheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  double get mediaHeight => mediaQuery.size.height;

  double get mediaWidth => mediaQuery.size.width;

  void unfocus() => FocusScope.of(this).unfocus();
}
