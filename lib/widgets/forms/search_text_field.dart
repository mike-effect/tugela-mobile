import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tugela/extensions/build_context.extension.dart';
import 'package:tugela/utils/spacing.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final EdgeInsets margin;
  final Color backgroundColor;
  final bool autofocus;
  final TextStyle? placeholderTextStyle;
  final Widget? prefixIcon;

  /// Invoked upon user input.
  final ValueChanged<String>? onChanged;

  /// Invoked upon keyboard submission.
  final ValueChanged<String>? onSubmitted;

  const SearchTextField({
    super.key,
    required this.controller,
    required this.placeholder,
    this.margin = EdgeInsets.zero,
    this.onChanged,
    this.onSubmitted,
    this.backgroundColor = Colors.transparent,
    this.autofocus = false,
    this.placeholderTextStyle,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: CupertinoSearchTextField(
        autofocus: autofocus,
        autocorrect: false,
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        placeholder: placeholder,
        placeholderStyle: placeholderTextStyle,
        padding: const EdgeInsets.all(12),
        prefixIcon: prefixIcon ??
            const Icon(
              Icons.search,
              color: Colors.grey,
            ),
        prefixInsets: EdgeInsets.fromLTRB(ContentPadding.left, 0, 0, 0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: context.inputTheme.enabledBorder!.borderSide.color,
          ),
        ),
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: context.textTheme.bodyMedium?.color,
        ),
      ),
    );
  }
}
