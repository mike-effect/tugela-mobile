import 'package:flutter/services.dart';

// ignore: constant_identifier_names
const AmountTextInputType = TextInputType.numberWithOptions(decimal: true);

class AmountInputFormatter extends TextInputFormatter {
  late RegExp regex;
  AmountInputFormatter() {
    regex = RegExp(r'^(\d)*(\.)?([0-9]{1,2})?$');
  }

  factory AmountInputFormatter.crypto() {
    return AmountInputFormatter()
      ..regex = RegExp(r'^(\d)*(\.)?([0-9]{1,18})?$');
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    TextEditingValue newEditingValue = newValue;
    String newString = newValue.text;
    final chunks = newString.split('.');
    String wholeNumber = "";
    if (chunks.isNotEmpty) wholeNumber = chunks.first;
    String decimals = "";
    if (chunks.length > 1) decimals = ".${chunks.last}";
    if (wholeNumber.length > 1 && wholeNumber.startsWith('0')) {
      wholeNumber = "${int.parse(wholeNumber)}";
      newString = "$wholeNumber$decimals";
      newEditingValue = newValue.copyWith(
        text: newString,
        selection: TextSelection.collapsed(
          offset: newValue.selection.extentOffset - 1,
        ),
      );
    }
    if (newString.startsWith('.')) {
      newEditingValue = newValue.copyWith(
        text: '0$newString',
        selection: TextSelection.collapsed(
          offset: newValue.selection.extentOffset + 1,
        ),
      );
    }
    return regex.hasMatch(newString) ? newEditingValue : oldValue;
  }
}
