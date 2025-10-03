import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../decimal_text_field.dart';

Widget myTextFormField({
  required String labelText,
  required String hintText,
  required controller,
  required validate,
  required obscureText,
  IconButton? icon,
  required constraints,
  keyboardType,
  bool? canEdit,
  bool? isnumber,
  bool? isDouble
}) {
  return TextFormField(
   inputFormatters: isnumber == true
    ? [FilteringTextInputFormatter.digitsOnly]
    : isDouble == true
        ? [DecimalTextInputFormatter()]
        : [],

    enabled: canEdit,
    obscureText: obscureText,
    keyboardType: keyboardType,
    controller: controller,
    decoration: InputDecoration(
      suffixIcon: icon,
      hintStyle: const TextStyle(color: Colors.grey),
      labelText: labelText,
      hintText: hintText,
      labelStyle: TextStyle(color: Colors.grey.shade700),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 2.0),
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
