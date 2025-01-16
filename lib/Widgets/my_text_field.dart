import 'package:flutter/material.dart';

Widget myTextFormField2({
  required String labelText,
  required String hintText,
  required controller,
  required validate,
  required obscureText,
  IconButton? icon,
  keyboardType,
  bool? isCapital,
}) {
  return TextFormField(
    obscureText: obscureText,
    keyboardType: keyboardType,
    controller: controller,
    decoration: InputDecoration(
      suffixIcon: icon,
      hintStyle: const TextStyle(color: Colors.grey),
      labelText: labelText,
      hintText: hintText,
      labelStyle: TextStyle(color: Colors.grey.shade700),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 2.0),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1.0),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0),
      ),
      focusedErrorBorder: const OutlineInputBorder(
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
