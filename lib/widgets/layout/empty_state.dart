import 'package:flutter/material.dart';
import 'package:tugela/extensions.dart';
import 'package:tugela/utils.dart';

class EmptyState extends StatelessWidget {
  final Widget? icon;
  final String? title;
  final String? subtitle;
  final String? buttonLabel;
  final Function(BuildContext context)? buttonOnPressed;
  final EdgeInsets margin;
  final Color? backgroundColor;
  const EmptyState({
    super.key,
    this.icon,
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
      // alignment: Alignment.topCenter,
      padding: ContentPadding * 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.inputTheme.enabledBorder!.borderSide.color,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // VSizedBox24,
          // if (icon != null)
          // IconTheme(
          //   data: context.iconTheme.copyWith(
          //     size: 48,
          //     color: context.textTheme.bodySmall?.color?.withOpacity(0.2),
          //   ),
          //   child: icon!,
          // ),
          // VSizedBox24,
          Text(
            title ?? "Nothing to show here yet 🍃",
            // textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (subtitle != null) ...[
            VSizedBox4,
            Text(
              subtitle!,
              // textAlign: TextAlign.center,
              style: TextStyle(
                // fontSize: 14,
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
