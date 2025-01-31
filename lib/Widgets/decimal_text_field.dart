
import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final String newText = newValue.text;

    // Allow only numbers and one decimal point
    if (RegExp(r'^\d*\.?\d*$').hasMatch(newText)) {
      return newValue;
    } else {
      return oldValue; // Keep the old value instead of clearing it
    }
  }
}