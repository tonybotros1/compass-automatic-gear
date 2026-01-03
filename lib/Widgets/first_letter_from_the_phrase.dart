import 'package:flutter/services.dart';

class FirstWordCapitalizationInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = _capitalizeFirst(newValue.text);

    final diff = newText.length - newValue.text.length;

    final newSelection = newValue.selection.copyWith(
      baseOffset: newValue.selection.baseOffset + diff,
      extentOffset: newValue.selection.extentOffset + diff,
    );

    return TextEditingValue(
      text: newText,
      selection: newSelection.clampTextLength(newText.length),
    );
  }

  String _capitalizeFirst(String input) {
    if (input.isEmpty) return input;

    return input[0].toUpperCase() + input.substring(1);
  }
}

extension on TextSelection {
  TextSelection clampTextLength(int textLength) {
    return TextSelection(
      baseOffset: baseOffset.clamp(0, textLength),
      extentOffset: extentOffset.clamp(0, textLength),
    );
  }
}
