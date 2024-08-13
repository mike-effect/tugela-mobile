import 'package:flutter/material.dart' show ThemeMode;
import 'package:tugela/providers/base_provider.dart';
import 'package:tugela/widgets/layout/app_tab_scaffold.dart';

abstract class AppProviderContract extends BaseProvider {
  AppTabController get appTabController;
  ThemeMode get themeMode;
  int switchTab(int index);
  void setThemeMode(ThemeMode mode);
  void scrollTabToTop(int index);
}
