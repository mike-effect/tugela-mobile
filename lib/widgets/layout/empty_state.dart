import 'package:flutter/material.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/utils.dart';

class EmptyState extends StatelessWidget {
  final Widget icon;
  final String? title;
  final String? subtitle;
  final String? buttonLabel;
  final Function(BuildContext context)? buttonOnPressed;
  final EdgeInsets margin;
  final Color? backgroundColor;
  const EmptyState({
    super.key,
    required this.icon,
    this.title,
    this.subtitle,
    this.buttonLabel,
    this.buttonOnPressed,
    this.margin = EdgeInsets.zero,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VSizedBox24,
          icon,
          VSizedBox24,
          if (title != null)
            Text(
              title!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          if (subtitle != null) ...[
            VSizedBox4,
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: TextStyle(
                // fontSize: 13,
                fontWeight: FontWeight.normal,
                color: context.textTheme.bodySmall?.color,
              ),
            )
          ],
          // if (buttonLabel != null) ...[
          //   VSizedBox40,
          //   SizedBox(
          //     width: double.infinity,
          //     child: ElevatedButton(
          //       style: context.theme.elevatedButtonTheme.style?.copyWith(),
          //       child: Text(buttonLabel!),
          //       onPressed: () => buttonOnPressed!(context),
          //     ),
          //   ),
          // ],
        ],
      ),
    );
  }
}
