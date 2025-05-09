import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String newText = newValue.text;

    // Allow optional minus at the start, digits, optional one decimal point, and digits after
    if (RegExp(r'^-?\d*\.?\d*$').hasMatch(newText)) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}
