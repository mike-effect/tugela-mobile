import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tugela/utils.dart';

extension TextEditingControllerX on TextEditingController? {
  bool isValidSecretCode({int length = 6}) {
    if (this == null) return false;
    return this?.text.length == length;
  }
}

class PinInput extends StatelessWidget {
  final TextEditingController? controller;
  final bool? autofocus;
  final FocusNode? focusNode;
  final bool obscure;
  final int maxLength;
  final TextInputType inputType;
  final List<TextInputFormatter>? formatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final double addedHeight;
  const PinInput({
    super.key,
    this.autofocus = true,
    this.controller,
    this.focusNode,
    this.obscure = true,
    this.onChanged,
    this.onSubmitted,
    this.maxLength = 6,
    this.inputType = TextInputType.number,
    this.formatters,
    this.validator,
    this.addedHeight = 0,
  });

  static final _defaultNode = FocusNode();
  static final _defaultController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final node = focusNode ?? _defaultNode;
    final codeController = controller ?? _defaultController;
    final height = addedHeight + 68.0;

    return AnimatedBuilder(
      animation: Listenable.merge([node, codeController]),
      builder: (context, _) {
        return FittedBox(
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              AutofillGroup(
                child: SizedBox(
                  height: height + 30,
                  width: media.size.width,
                  child: TextFormField(
                    focusNode: node,
                    controller: codeController,
                    autofocus: autofocus!,
                    validator: validator,
                    autocorrect: false,
                    maxLines: null,
                    expands: true,
                    maxLength: maxLength,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    keyboardType: inputType,
                    inputFormatters:
                        formatters ?? [FilteringTextInputFormatter.digitsOnly],
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.transparent,
                    ),
                    showCursor: false,
                    cursorWidth: 0,
                    enableInteractiveSelection: false,
                    onChanged: (value) {
                      onChanged?.call(value);
                      if (value.length != maxLength) return;
                      HapticFeedback.mediumImpact();
                      onSubmitted?.call(value);
                    },
                    decoration: InputDecoration(
                      counter: const SizedBox(),
                      hintText: "",
                      border: InputBorder.none,
                      fillColor: Colors.transparent,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero.copyWith(bottom: 15),
                      errorStyle: theme.inputDecorationTheme.errorStyle
                          ?.copyWith(fontSize: 14),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height,
                width: media.size.width,
                child: IgnorePointer(
                  ignoring: true,
                  child: Builder(builder: (context) {
                    final code = List<String?>.generate(maxLength, (_) => null);
                    final text = controller?.text.split('') ?? [];
                    code.setRange(0, text.length, text);
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: isTabletView(context)
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.center,
                      children: [
                        ...divideWidgets(
                          divider: isTabletView(context)
                              ? HSizedBox12
                              : const Spacer(),
                          list: code,
                          builder: (index, String? number) {
                            final inputTheme = theme.inputDecorationTheme;
                            final activeColor =
                                inputTheme.focusedBorder!.borderSide.color;
                            Color borderColor =
                                inputTheme.enabledBorder!.borderSide.color;
                            final position = controller?.text.length ?? 0;
                            final isCurrentPosition = position == index;
                            if (node.hasFocus) {
                              if (isCurrentPosition) {
                                borderColor = activeColor;
                              }
                              if (position == maxLength &&
                                  index == maxLength - 1) {
                                borderColor = activeColor;
                              }
                            }
                            String digit = number != null ? '•' : '';
                            if (!obscure && number != null) digit = number;
                            return AspectRatio(
                              aspectRatio: 1 / 1.2,
                              child: AnimatedContainer(
                                alignment: Alignment.center,
                                duration: const Duration(milliseconds: 100),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: borderColor,
                                    width: node.hasFocus && isCurrentPosition
                                        ? inputTheme.focusedBorder!.borderSide
                                                .width +
                                            .7
                                        : inputTheme.enabledBorder!.borderSide
                                                .width +
                                            .4,
                                  ),
                                ),
                                child: Text(
                                  digit,
                                  textScaler: maxTextScale(context, 1.2),
                                  style: TextStyle(
                                    fontSize: obscure ? 32 : 24,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
