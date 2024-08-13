import 'package:flutter/material.dart';
import 'package:tugela/utils.dart';

class CompletionScreen extends StatelessWidget {
  final String message;
  final VoidCallback? onClose;
  const CompletionScreen({
    super.key,
    required this.message,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
      ),
      body: Column(
        children: [
          const Spacer(),
          const Text(
            "Great Work!",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const Spacer(),
          const FittedBox(
            fit: BoxFit.scaleDown,
            child: Placeholder(),
          ),
          const Spacer(flex: 3),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: ContentPadding,
          child: ElevatedButton(
            child: const Text("Okay!"),
            onPressed: () {
              if (onClose != null) {
                onClose!();
              } else {
                // Navigator.popUntil(
                //   context,
                //   ModalRoute.withName(Routes.appIndex),
                // );
              }
            },
          ),
        ),
      ),
    );
  }
}
