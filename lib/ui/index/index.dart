import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tugela/extensions/build_context.extension.dart';
import 'package:tugela/providers/app_provider.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/services/contracts/api_service.contract.dart';
import 'package:tugela/ui/applications/applications_tab.dart';
import 'package:tugela/ui/freelancer/freelancer_tab.dart';
import 'package:tugela/ui/home/home_tab.dart';
import 'package:tugela/ui/profile/profile_tab.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/routes.dart';
import 'package:tugela/widgets/feedback/dialog.dart';
import 'package:tugela/widgets/layout/app_tab_scaffold.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  late StreamSubscription stream;
  late StreamSubscription fcmStream;
  static final analytics = FirebaseAnalytics.instance;
  final observer = FirebaseAnalyticsObserver(analytics: analytics);
  late Timer timer;
  int currentIndex = 0;
  bool sessionExpired = false;

  static final navigators = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  AppProvider get appProvider => context.read<AppProvider>();
  UserProvider get userProvider => context.read<UserProvider>();

  final pages = [
    CupertinoTabView(
      navigatorKey: navigators[0],
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
      routes: {
        Routes.tabIndex: (_) => const HomeTab(),
      },
    ),
    CupertinoTabView(
      navigatorKey: navigators[1],
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
      routes: {
        Routes.tabIndex: (_) => const FreelancerTab(),
      },
    ),
    CupertinoTabView(
      navigatorKey: navigators[2],
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
      routes: {
        Routes.tabIndex: (_) => const ApplicationsTab(),
      },
    ),
    CupertinoTabView(
      navigatorKey: navigators[3],
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
      routes: {
        Routes.tabIndex: (_) => const ProfileTab(),
      },
    ),
  ];

  void initialize() {
    appProvider.initialize();
    userProvider.initialize();
    stream = appProvider.apiService.stream.listen((state) async {
      if ((state == SessionState.hardLogout ||
              state == SessionState.unauthenticated) &&
          !sessionExpired) {
        sessionExpired = true;
        userProvider.apiService.stream.drain();
        reset();
        if (state == SessionState.unauthenticated && mounted) {
          await showAppDialog(
            context,
            title: "Session Expired",
            message: "Your session has expired. Please log in again.",
          );
          if (mounted) {
            await rootNavigator(context)
                .pushNamedAndRemoveUntil(Routes.welcome, (_) => false);
          }
          sessionExpired = false;
        }
        if (state == SessionState.hardLogout && mounted) {
          if (context.mounted) {
            rootNavigator(context).pushNamedAndRemoveUntil(
              Routes.welcome,
              (_) => false,
            );
          }
        }
      }
    });
  }

  void reset() {
    appProvider.reset();
    userProvider.reset();
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    final tabNavigator = navigators[currentIndex].currentState;
    final canPopTab = tabNavigator?.canPop() ?? false;

    return PopScope(
      canPop: canPopTab,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) tabNavigator?.pop();
      },
      child: AppTabScaffold(
        controller: appProvider.appTabController,
        tabBuilder: (_, index) => pages[index],
        tabBar: AppTabBar(
          backgroundColor:
              context.theme.bottomNavigationBarTheme.backgroundColor,
          iconSize: 22,
          border: Border(
            top: BorderSide(
              color: context.theme.dividerColor.withOpacity(0.3),
            ),
          ),
          activeColor: context.secondaryColor,
          onTap: (index) {
            final tabName = {
              0: "home",
              1: "talent",
              2: "applications",
              3: "profile",
            };
            if (currentIndex == index) {
              final nav = navigators[index].currentState;
              if (nav?.canPop() ?? false) {
                nav?.popUntil(ModalRoute.withName(Routes.tabIndex));
              } else {
                appProvider.scrollTabToTop(index);
              }
            } else {
              setState(() {
                currentIndex = index;
                observer.analytics.logScreenView(
                  screenName: '/tab/${tabName[index]}',
                );
              });
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: PhosphorIcon(PhosphorIconsRegular.house),
              activeIcon: PhosphorIcon(PhosphorIconsFill.house),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: PhosphorIcon(PhosphorIconsRegular.magnifyingGlass),
              activeIcon: PhosphorIcon(PhosphorIconsFill.magnifyingGlass),
              label: "Talent",
            ),
            BottomNavigationBarItem(
              icon: PhosphorIcon(PhosphorIconsRegular.briefcase),
              activeIcon: PhosphorIcon(PhosphorIconsFill.briefcase),
              label: "Applications",
            ),
            BottomNavigationBarItem(
              icon: PhosphorIcon(PhosphorIconsRegular.userCircle),
              activeIcon: PhosphorIcon(PhosphorIconsFill.userCircle),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
