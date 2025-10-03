import 'package:flutter/services.dart';

class WordCapitalizationInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = _capitalizeWords(newValue.text);

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

  String _capitalizeWords(String input) {
    return input
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
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
