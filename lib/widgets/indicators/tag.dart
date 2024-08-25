import 'package:flutter/material.dart';
import 'package:tugela/theme.dart';

class TagChip extends StatelessWidget {
  final String text;
  final MaterialColor? color;
  final Color? textColor;
  final Color? backgroundColor;
  final double scale;

  const TagChip({
    super.key,
    required this.text,
    this.color,
    this.backgroundColor,
    this.textColor,
    this.scale = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 7, 12, 7) * scale,
      decoration: BoxDecoration(
        color: backgroundColor ??
            AppColors.dynamic(
              context: context,
              light: color?.shade50,
              dark: color?.shade900,
            ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: TextStyle(
          height: 1,
          fontSize: 12 * scale,
          letterSpacing: 0.4,
          fontWeight: FontWeight.w600,
          color: textColor ??
              AppColors.dynamic(
                context: context,
                light: color?.shade800,
                dark: color?.shade100,
              ),
        ),
      ),
    );
  }
}
