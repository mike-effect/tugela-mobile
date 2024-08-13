import 'package:flutter/material.dart';
import 'package:tugela/extensions/build_context.extension.dart';

class LoadingScreen extends ModalRoute<void> {
  final String message;
  LoadingScreen({Key? key, this.message = "Loading"});

  @override
  RouteSettings get settings => const RouteSettings(name: "/loading-screen");

  @override
  Duration get transitionDuration => const Duration(milliseconds: 350);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black54;

  @override
  String get barrierLabel => "Close";

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(child: _buildOverlayContent(context)),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(30),
        margin: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Theme.of(context).dialogBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: context.theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(width: 20),
            Text(message, style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}
