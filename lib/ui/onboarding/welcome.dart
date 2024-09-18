import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugela/constants/app_assets.dart';
import 'package:tugela/theme.dart';
import 'package:tugela/utils.dart';
import 'package:tugela/utils/routes.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
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
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: ContentPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.asset(
                    AppAssets.images.appIconForegroundPng,
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
              VSizedBox40,
              Text(
                "Smarter Freelancing,\nEffortless Hiring.",
                style: GoogleFonts.cinzel(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlinedButton(
                onPressed: () {
                  pushNamed(context, Routes.login);
                },
                child: const Text(
                  "Sign In",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              VSizedBox16,
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  pushNamed(context, Routes.signup);
                },
                child: const Text(
                  "Get Started",
                  style: TextStyle(color: AppColors.primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
