import 'package:datahubai/Widgets/capital_letters_field.dart';
import 'package:datahubai/Widgets/decimal_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import '../consts.dart';
import 'date_time_field.dart';

Widget myTextFormFieldWithBorder({
  String? labelText,
  String? hintText,
  TextEditingController? controller,
  bool? validate,
  bool obscureText = false,
  Widget? suffixIcon,
  Icon? icon,
  bool? isnumber,
  bool? isDouble,
  bool? isDate,
  double? width,
  bool? isCapitaLetters,
  FocusNode? focusNode,
  FocusNode? nextFocusNode,
  bool? moneyFormat,
  TextInputAction? textInputAction,
  void Function()? onEditingComplete,
  maxLines = 1,
  TextAlign? textAlign = TextAlign.start,
  int? minLines,
  TextInputType? keyboardType,
  void Function(String)? onChanged,
  void Function(String)? onFieldSubmitted,
  bool? isEnabled = true,
  void Function(PointerDownEvent)? onTapOutside,
  bool? readOnly,
}) {
  return SizedBox(
    width: width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelText != null
            ? Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  labelText,
                  style: textFieldLabelStyle,
                ),
              )
            : const SizedBox(),
        Focus(
          focusNode: focusNode,
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent &&
                (event.logicalKey == LogicalKeyboardKey.tab ||
                    event.logicalKey == LogicalKeyboardKey.enter)) {
              if (nextFocusNode != null) {
                nextFocusNode.requestFocus();
              }
              return KeyEventResult.handled;
            } else if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.shift) {}
            return KeyEventResult.ignored;
          },
          child: TextFormField(
            canRequestFocus: true,
            readOnly: readOnly ?? false,
            onTapOutside: onTapOutside,
            onEditingComplete: onEditingComplete,
            textInputAction: textInputAction,
            // focusNode: focusNode,
            onFieldSubmitted: onFieldSubmitted,
            textAlign: textAlign!,
            style: textFieldFontStyle,
            minLines: minLines,
            maxLines: maxLines,
            onChanged: onChanged,
            inputFormatters: isnumber == true
                ? [FilteringTextInputFormatter.digitsOnly]
                : isDouble == true
                ? [DecimalTextInputFormatter()]
                : isDate == true
                ? [DateTextFormatter()]
                : isCapitaLetters == true
                ? [CapitalLettersOnlyFormatter()]
                : moneyFormat == true
                ? [CurrencyInputFormatter()]
                : null,
            enabled: isEnabled,
            obscureText: obscureText,
            keyboardType: keyboardType,
            controller: controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: !kIsWeb ? 7 : 11,
              ),
              isDense: true,
              icon: icon,
              suffixIcon: ExcludeFocus(child: suffixIcon ?? const SizedBox()),
              suffixIconConstraints: const BoxConstraints(
                maxHeight: 30,
                maxWidth: 40,
              ),
              prefixIconConstraints: const BoxConstraints(
                maxHeight: 15,
                maxWidth: 15,
              ),
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              // labelText: labelText,
              alignLabelWithHint: true,

              hintText: hintText,
              labelStyle: TextStyle(
                color: isEnabled == false
                    ? Colors.grey.shade500
                    : Colors.grey.shade700,
              ),
              fillColor: isEnabled == true
                  ? Colors.white
                  : Colors.grey.shade200,
              filled: true,
              // focusedBorder: const OutlineInputBorder(
              //   // borderRadius: BorderRadius.circular(borderRadius!),
              //   borderSide: BorderSide(color: Colors.grey, width: 2.0),
              // ),
              enabledBorder: const OutlineInputBorder(
                // borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              disabledBorder: OutlineInputBorder(
                // borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
              ),
              errorBorder: const OutlineInputBorder(
                // borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.red, width: 1.0),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                // borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Colors.red, width: 2.0),
              ),
            ),
            validator: validate != false
                ? (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter $labelText';
                    }
                    return null;
                  }
                : null,
          ),
        ),
      ],
    ),
  );
}
