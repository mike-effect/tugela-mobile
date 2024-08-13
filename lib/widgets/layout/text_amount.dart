import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugela/constants/config.dart';
import 'package:tugela/utils.dart';

class TextAmount extends StatelessWidget {
  final Object? value;
  final TextStyle? style;
  final String? symbol;
  final int? factor;
  final NumberFormat? customFormat;
  final bool obscure;
  final int obscureLength;
  final TextScaler? textScaler;
  final bool isCrypto;
  const TextAmount(
    this.value, {
    super.key,
    this.style,
    this.symbol,
    this.factor,
    this.customFormat,
    this.obscure = false,
    this.obscureLength = 4,
    this.textScaler,
    this.isCrypto = false,
  });

  @override
  Widget build(BuildContext context) {
    final s = (symbol ?? AppConfig().currencyCode).toUpperCase();
    final amount = formatAmount(
      value ?? 0.0,
      symbol: s,
      factor: factor,
      customFormat: customFormat,
      isCrypto: isCrypto,
      truncate: false,
    );
    final chunks = amount.split('.');
    final whole = TextSpan(
      text: chunks.first,
      style: style ?? const TextStyle(),
    );

    return Text.rich(
      TextSpan(
        style: whole.style,
        children: [
          if (obscure) ...[
            WidgetSpan(
              child: Row(
                children: [
                  if (!isCrypto)
                    Text(
                      "${amount.replaceAll(RegExp(r'[0-9,\.]'), '')} ",
                      style: whole.style?.copyWith(
                        fontSize: whole.style!.fontSize,
                      ),
                    ),
                  ...List.generate(obscureLength, (index) {
                    return Container(
                      height: whole.style?.height,
                      padding: const EdgeInsets.only(right: 6),
                      child: CircleAvatar(
                        radius: whole.style!.fontSize! / 6,
                        backgroundColor: whole.style?.color,
                      ),
                    );
                  }),
                  if (isCrypto)
                    Text(
                      "${amount.replaceAll(RegExp(r'[0-9,\.]'), '')} ",
                      style: whole.style?.copyWith(
                        fontSize: whole.style!.fontSize,
                      ),
                    ),
                ],
              ),
            ),
          ] else ...[
            whole,
            TextSpan(
              text: ".${chunks.last}",
              style: whole.style?.copyWith(
                fontWeight: FontWeight.w200,
                fontSize: whole.style!.fontSize! / 1.3,
                color: whole.style!.color?.withOpacity(0.6),
              ),
            ),
          ]
        ],
      ),
      textScaler: textScaler,
    );
  }
}
