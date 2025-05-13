import 'package:flutter/services.dart';

/// A TextInputFormatter that prevents the number from exceeding [maxValue].
class MaxValueInputFormatter extends TextInputFormatter {
  MaxValueInputFormatter(this.maxValue);

  final double maxValue;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
  ) {
    // If the new text is empty, allow it (so they can clear).
    if (newValue.text.isEmpty) return newValue;

    // Try parsing to double; if it fails, reject the edit.
    final parsed = double.tryParse(newValue.text);
    if (parsed == null) return oldValue;

    // If parsed value is > maxValue, reject the edit.
    if (parsed > maxValue) return oldValue;

    // Otherwise allow.
    return newValue;
  }
}
