import 'package:flutter/material.dart';
import 'package:tugela/constants/app_assets.dart';
import 'package:tugela/extensions.dart';
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
    return Scaffold(
      appBar: AppBar(),
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
                  AppAssets.images.appIconPng,
                  width: 150,
                  height: 150,
                ),
              ),
            ),
            VSizedBox40,
            Text(
              "Smarter Freelancing,\nEffortless Hiring.",
              style: context.textTheme.titleLarge,
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
              child: const Text("Sign In"),
            ),
            VSizedBox16,
            ElevatedButton(
              onPressed: () {
                pushNamed(context, Routes.signup);
              },
              child: const Text("Get Started"),
            ),
          ],
        ),
      ),
    );
  }
}
