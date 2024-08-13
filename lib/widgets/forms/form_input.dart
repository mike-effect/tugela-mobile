import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final Widget? title;
  final Widget child;
  final EdgeInsets? margin;
  final bool required;
  final Widget? helper;
  const FormInput({
    super.key,
    required this.child,
    this.title,
    this.margin,
    this.required = false,
    this.helper,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.only(bottom: 20 + (title != null ? 4 : 0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            DefaultTextStyle(
              style: DefaultTextStyle.of(context).style.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
              child: title!,
            ),
            const SizedBox(height: 8),
          ],
          Container(
            alignment: Alignment.centerLeft,
            child: child,
          ),
          if (helper != null) ...[
            const SizedBox(height: 12),
            helper!,
          ],
        ],
      ),
    );
  }
}
