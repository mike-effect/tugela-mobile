part of 'main.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const androidChannel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  await localNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidChannel);
  try {
    await Firebase.initializeApp(
        // options: DefaultFirebaseOptions.currentPlatform,
        );
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.ensureInitialized();
    await remoteConfig.fetchAndActivate();
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: Duration.zero,
    ));
    final config = (await getRemoteAppConfig())?.forPlatform();
    if (config != null) sl.get<AppConfig>().remotePlatformConfig = config;
    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
      FirebaseCrashlytics
          .instance.pluginConstants['isCrashlyticsCollectionEnabled'] = false;
    } else {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // void handler(RemoteMessage message) {
    //   final notification = message.notification;
    //   final android = message.notification?.android;

    //   if (notification != null && android != null) {
    //     localNotificationsPlugin.show(
    //       notification.hashCode,
    //       notification.title,
    //       notification.body,
    //       NotificationDetails(
    //         android: AndroidNotificationDetails(
    //           androidChannel.id,
    //           androidChannel.name,
    //           channelDescription: androidChannel.description,
    //           icon: android.smallIcon ?? 'ic_notification_icon',
    //         ),
    //       ),
    //     );
    //   }
    // }

    // FirebaseMessaging.onMessage.listen(handler);
  } catch (e, s) {
    handleError(e, stackTrace: s);
  }
}
