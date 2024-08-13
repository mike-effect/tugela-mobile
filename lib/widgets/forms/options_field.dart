import 'package:flutter/material.dart';
import 'package:tugela/extensions/build_context.extension.dart';

class OptionsField extends StatelessWidget {
  final String hint;
  final bool enabled;
  final bool focused;
  final bool expands;
  final String? text;
  final String? label;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  final String? autofillHint;
  final Widget? prefix;
  final Widget? suffixIcon;
  final AutovalidateMode autovalidateMode;

  const OptionsField({
    super.key,
    required this.hint,
    this.enabled = true,
    this.focused = false,
    this.expands = false,
    this.text,
    this.label,
    this.onTap,
    this.validator,
    this.controller,
    this.autofillHint,
    this.prefix,
    this.suffixIcon,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: (enabled && onTap != null)
          ? () {
              FocusScope.of(context).requestFocus(FocusNode());
              onTap?.call();
            }
          : null,
      behavior:
          onTap == null ? HitTestBehavior.deferToChild : HitTestBehavior.opaque,
      child: IgnorePointer(
        ignoring: onTap != null,
        child: TextFormField(
          enabled: (enabled && onTap != null),
          readOnly: true,
          expands: expands,
          maxLines: expands ? null : 1,
          autovalidateMode: autovalidateMode,
          controller: controller ?? TextEditingController(text: text),
          validator: validator,
          autofillHints: [
            if (autofillHint != null) autofillHint!,
          ],
          decoration: InputDecoration(
            hintText: hint,
            labelText: label,
            enabledBorder:
                focused ? theme.inputDecorationTheme.focusedBorder : null,
            disabledBorder: enabled
                ? theme.inputDecorationTheme.border
                : theme.inputDecorationTheme.disabledBorder,
            prefixIcon: prefix,
            suffixIcon: IconTheme(
              data: context.theme.iconTheme.copyWith(
                size: 18,
                color: enabled
                    ? theme.inputDecorationTheme.suffixIconColor
                    : theme
                        .inputDecorationTheme.disabledBorder!.borderSide.color,
              ),
              child:
                  suffixIcon ?? const Icon(Icons.keyboard_arrow_down, size: 24),
            ),
          ),
        ),
      ),
    );
  }
}
