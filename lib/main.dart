import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:tugela/constants/config.dart';
import 'package:tugela/firebase_options.dart';
import 'package:tugela/providers/app_provider.dart';
import 'package:tugela/providers/company_provider.dart';
import 'package:tugela/providers/freelancer_provider.dart';
import 'package:tugela/providers/job_provider.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/services/contracts/api_service.contract.dart';
import 'package:tugela/services/contracts/local_auth.contract.dart';
import 'package:tugela/services/sl.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/ui/onboarding/splash.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/routes.dart';

part 'main.part.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.ensureInitialized();

  setupServiceLocator();

  await _initializeFirebase();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await PackageInfo.fromPlatform().then((info) {
      sl.get<ApiServiceContract>().setAppVersion(info.version);
    }).catchError((e, s) {
      handleError(e, stackTrace: s);
    });
    sl.get<LocalAuthServiceContract>().getBiometricType();
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CompanyProvider()),
        ChangeNotifierProvider(create: (_) => FreelancerProvider()),
        ChangeNotifierProvider(create: (_) => JobProvider()),
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
          title: 'Tugela',
          color: AppColors.black,
          themeMode: context.read<AppProvider>().themeMode,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          home: const Splash(),
          routes: RoutesMap.map,
          builder: (context, child) {
            return MediaQuery.withClampedTextScaling(
              minScaleFactor: 0.8,
              maxScaleFactor: 1.2,
              child: child!,
            );
          },
        );
      }),
    );
  }
}
