import 'package:datahubai/Widgets/decimal_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../consts.dart';
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
    String? initialValue,
    int? minLines,
    TextInputType? keyboardType,
    void Function(String)? onChanged,
    bool? isEnabled = true}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      labelText != null
          ? Padding(
              padding: const EdgeInsets.only(left: 2),
              child: Text(
                  overflow: TextOverflow.ellipsis,
                  labelText,
                  style: textFieldLabelStyle),
            )
          : SizedBox(),
      SizedBox(
        height: maxLines == 1 ? textFieldHeight : null,
        child: TextFormField(
          initialValue: initialValue,
          style: textFieldFontStyle,
          onTap: () {
            if (controller != null) {
              controller.selection = TextSelection(
                baseOffset: 0,
                extentOffset: controller.text.length,
              );
            }
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
            contentPadding: maxLines == 1
                ? const EdgeInsets.only(left: 10)
                : const EdgeInsets.all(10),
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
            focusedBorder: const OutlineInputBorder(
              // borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey, width: 2.0),
            ),
            enabledBorder: const OutlineInputBorder(
              // borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            disabledBorder: OutlineInputBorder(
              // borderRadius: BorderRadius.circular(5),
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
  );
}
