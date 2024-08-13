import 'package:flutter/material.dart';
import 'package:tugela/utils/spacing.dart';

class StatusPage extends StatelessWidget {
  final Widget image;
  final String title;
  final String buttonText;
  final VoidCallback callback;
  const StatusPage({
    super.key,
    required this.title,
    required this.image,
    required this.callback,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: ContentPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            image,
            const Spacer(),
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: ContentPadding,
        child: SafeArea(
          top: false,
          child: ElevatedButton(
            onPressed: callback,
            child: Text(buttonText),
          ),
        ),
      ),
    );
  }
}
