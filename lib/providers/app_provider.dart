import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tugela/models/paginated.dart';
import 'package:tugela/models/skill.dart';
import 'package:tugela/providers/contracts/app_provider.contract.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/widgets/layout/app_tab_scaffold.dart';

class AppProvider extends AppProviderContract {
  final AppTabController _appTabController = AppTabController();
  ThemeMode _themeMode = ThemeMode.system;

  Paginated<Skill> skills = Paginated();

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

  Future<Paginated<Skill>?> getSkills({
    Map<String, dynamic> params = const {},
    PaginatedOptions options = const PaginatedOptions(),
  }) async {
    try {
      final map = {'page_size': 100, ...params};
      final res = await paginatedQuery<Skill>(
        options: options,
        paginated: skills,
        initialRequest: () => apiService.getSkills(params: map),
        loadMoreRequest: () => apiService.getSkills(
          params: map..addAll({'page': skills.pagination?.next}),
        ),
      );
      if (res?.data != null) skills = res!;
      notifyListeners();
      return skills;
    } catch (e, s) {
      handleError(e, stackTrace: s);
      return null;
    }
  }
}
