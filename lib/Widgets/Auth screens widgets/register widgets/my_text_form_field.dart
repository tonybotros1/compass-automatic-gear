
import 'package:flutter/material.dart';

Widget myTextFormField({
  required String labelText,
  required String hintText,
  required controller,
  required validate,
  required obscureText,
  IconButton? icon,
  required constraints,
  keyboardType,
}) {
  return Container(
    constraints: BoxConstraints(
        maxHeight: constraints.maxHeight > 400
            ? constraints.maxHeight / 3
            : constraints.maxHeight / 1.3,
        maxWidth: constraints.maxWidth > 796
            ? constraints.maxWidth / 3
            : constraints.maxWidth < 796 && constraints.maxWidth > 400
                ? constraints.maxWidth / 2
                : constraints.maxWidth / 1.5),
    child: TextFormField(
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
    ),
  );
}