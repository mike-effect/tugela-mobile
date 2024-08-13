import 'package:flutter/material.dart';

class ConditionalWidget extends StatelessWidget {
  final bool condition;
  final Widget child;
  final Widget Function(BuildContext context, Widget child) builder;
  const ConditionalWidget({
    super.key,
    required this.child,
    required this.condition,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    if (condition) return builder(context, child);
    return child;
  }
}
