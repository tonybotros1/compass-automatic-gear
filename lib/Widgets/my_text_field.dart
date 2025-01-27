import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget myTextFormField2(
    {required String labelText,
    required String hintText,
    required controller,
    required validate,
    required obscureText,
    IconButton? suffixIcon,
    Icon? icon,
    bool? isnumber,
    keyboardType,
    bool? isEnabled}) {
  return TextFormField(
    inputFormatters:
        isnumber == true ? [FilteringTextInputFormatter.digitsOnly] : null,
    enabled: isEnabled,
    obscureText: obscureText,
    keyboardType: keyboardType,
    controller: controller,
    decoration: InputDecoration(
      icon: icon,
      suffixIcon: suffixIcon,
      hintStyle: const TextStyle(color: Colors.grey),
      labelText: labelText,
      hintText: hintText,
      labelStyle: TextStyle(color: Colors.grey.shade700),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey, width: 1.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red, width: 1.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
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
