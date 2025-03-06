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
    bool? isEnabled = true}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 2),
        child: Text(
          '$labelText',
          style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 12,
              fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: maxLines == 1 ? 35 : null,
        child: TextFormField(
          style: TextStyle(fontSize: 14, color: Colors.black),
          onTap: () {
            controller!.selection = TextSelection(
              baseOffset: 0,
              extentOffset: controller.text.length,
            );
          },
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
            contentPadding:
                maxLines == 1 ? EdgeInsets.only(left: 10) : EdgeInsets.all(10),
            icon: icon,
            suffixIcon: suffixIcon,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            // labelText: labelText,
            alignLabelWithHint: true,
            // hintText: hintText,

            labelStyle: TextStyle(
              color: isEnabled == false
                  ? Colors.grey.shade500
                  : Colors.grey.shade700,
            ),
            filled: isEnabled == true,
            fillColor: Colors.grey.shade200,
            focusedBorder: OutlineInputBorder(
              // borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey, width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              // borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            disabledBorder: OutlineInputBorder(
              // borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
            ),
            errorBorder: OutlineInputBorder(
              // borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.red, width: 1.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
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
  );
}
