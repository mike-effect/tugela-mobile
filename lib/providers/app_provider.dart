import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tugela/providers/contracts/app_provider.contract.dart';
import 'package:tugela/widgets/layout/app_tab_scaffold.dart';

class AppProvider extends AppProviderContract {
  final AppTabController _appTabController = AppTabController();
  ThemeMode _themeMode = ThemeMode.system;

  @override
  AppTabController get appTabController => _appTabController;

  @override
  ThemeMode get themeMode => _themeMode;

  final walkthroughKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];

  final tabScrollControllers = [
    ScrollController(),
    ScrollController(),
    ScrollController(),
    ScrollController(),
  ];

  final navigators = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  Future<void> initialize() async {
    hiveService.getThemeMode().then((value) {
      _themeMode = value;
      notifyListeners();
    });
  }

  @override
  int switchTab(int index) {
    _appTabController.index = index;
    return _appTabController.index;
  }

  @override
  void scrollTabToTop(int index) {
    final scrollController = tabScrollControllers[index];
    if (scrollController.hasClients) {
      HapticFeedback.mediumImpact();
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 800),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    }
  }

  @override
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
    hiveService.setThemeMode(mode);
  }

  @override
  void reset() {}
}
