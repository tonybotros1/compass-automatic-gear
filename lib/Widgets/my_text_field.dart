import 'package:datahubai/Widgets/decimal_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'date_time_field.dart';

Widget myTextFormFieldWithBorder(
    {String? labelText,
    String? hintText,
    TextEditingController? controller,
    bool? validate,
    bool obscureText = false,
    IconButton? suffixIcon,
    Icon? icon,
    bool? isnumber,
    bool? isDouble,
    bool? isDate,
    maxLines = 1,
    int? minLines,
    keyboardType,
    void Function(String)? onChanged,
    bool? isEnabled}) {
  return TextFormField(
    minLines: minLines,
    maxLines: maxLines,
    onChanged: onChanged,
    inputFormatters: isnumber == true
        ? [FilteringTextInputFormatter.digitsOnly]
        : isDouble == true
            ? [DecimalTextInputFormatter()]
            : isDate == true
                ? [DateTextFormatter()]
                : [],
    enabled: isEnabled,
    obscureText: obscureText,
    keyboardType: keyboardType,
    controller: controller,
    decoration: InputDecoration(
      icon: icon,
      suffixIcon: suffixIcon,
      hintStyle: const TextStyle(color: Colors.grey),
      labelText: labelText,
      alignLabelWithHint: true,
      hintText: hintText,
      labelStyle: TextStyle(color: Colors.grey.shade700),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Colors.grey, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Colors.grey, width: 1.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Colors.red, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
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
  );
}
