// import 'package:flutter/services.dart';

// class DateTextFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     // Always return the old value to prevent any input
//     return oldValue;
//   }
// }

import 'package:flutter/services.dart';

class DateTextFormatter extends TextInputFormatter {
  final RegExp _regExp = RegExp(r'^[0-9/\-]*$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow only digits, slashes, and hyphens
    if (_regExp.hasMatch(newValue.text)) {
      return newValue;
    }
    // If invalid character, keep the old value
    return oldValue;
  }
}
