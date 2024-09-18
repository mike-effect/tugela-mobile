import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugela/constants/app_assets.dart';
import 'package:tugela/providers/app_provider.dart';
import 'package:tugela/providers/user_provider.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/provider_request.dart';
import 'package:tugela/utils/routes.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() async {
    final provider = context.read<UserProvider>();
    if (!(await provider.canAutoLogin())) {
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, Routes.welcome, (_) => false);
      return;
    }
    await provider.autoLogin();
    if (!mounted) return;
    await ProviderRequest.api(
      context: context,
      request: provider.getUserMe(),
      loadingScreen: false,
      onError: (context) {
        Navigator.pushNamedAndRemoveUntil(context, Routes.login, (_) => false);
      },
      onApiError: (context, errors) {
        Navigator.pushNamedAndRemoveUntil(context, Routes.login, (_) => false);
      },
      postRequest: (context) {
        return Future.wait<dynamic>([
          context.read<AppProvider>().initialize(),
        ]);
      },
      onSuccess: (context, res) async {
        // final biometric = await provider.getBioAuth();
        if (!context.mounted) return;
        final navigator = rootNavigator(context);
        String state = provider.getRouteForUser(res.data);
        // if (state == Routes.appIndex) {
        //   state = Routes.loginWithPin;
        // }
        // if (!biometric) {
        //   state = Routes.appIndex;
        // } else {
        //   final authenticate = await provider.authenticateBio();
        //   if (authenticate) {
        //     state = Routes.appIndex;
        //   } else {
        //     if (context.mounted) {
        //       await showAppDialog(
        //         context,
        //         title: "Biometric Login",
        //         message:
        //             "The automatic attempt to sign you in was not successful. "
        //             "Please try again or manually log in with your email and password to continue.",
        //         footer: (context) {
        //           return Column(
        //             crossAxisAlignment: CrossAxisAlignment.stretch,
        //             children: [
        //               ElevatedButton(
        //                 child: const Text("Try again"),
        //                 onPressed: () async {
        //                   final retry = await provider.authenticateBio();
        //                   if (retry && mounted) {
        //                     state = Routes.appIndex;
        //                     if (!context.mounted) return;
        //                     Navigator.pop(context);
        //                   }
        //                 },
        //               ),
        //               VSizedBox12,
        //               OutlinedButton(
        //                 child: const Text("Log in manually"),
        //                 onPressed: () {
        //                   state = Routes.login;
        //                   Navigator.pop(context);
        //                 },
        //               ),
        //             ],
        //           );
        //         },
        //       );
        //     }
        //   }
        // }
        // if (state == Routes.appIndex && mounted) {
        //   context.read<UserProvider>().getProfile();
        // }
        navigator.pushNamedAndRemoveUntil(state, (_) => false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(AppAssets.images.appIconBackgroundPng),
        ),
      ),
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.asset(
              AppAssets.images.appIconForegroundPng,
              width: 150,
              height: 150,
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 160,
          alignment: Alignment.center,
          child: const SafeArea(
            top: false,
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
