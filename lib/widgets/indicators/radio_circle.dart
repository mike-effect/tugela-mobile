import 'package:flutter/material.dart';
import 'package:tugela/extensions/build_context.extension.dart';

class RadioCircle extends StatelessWidget {
  final bool isActive;
  const RadioCircle({
    super.key,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? context.colorScheme.secondary.withOpacity(0.5) : null,
        border: isActive
            ? null
            : Border.all(
                width: 2,
                color: context.inputTheme.enabledBorder!.borderSide.color,
              ),
      ),
      child: isActive
          ? Icon(
              Icons.check,
              size: 18,
              color: context.textTheme.bodyMedium?.color,
            )
          : null,
    );
  }
}
