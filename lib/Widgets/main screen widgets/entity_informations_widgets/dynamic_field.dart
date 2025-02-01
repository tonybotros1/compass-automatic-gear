import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../Models/dynamic_field_models.dart';
import '../../decimal_text_field.dart';
import '../drop_down_menu.dart';


Widget dynamicFields({
  required List<DynamicConfig> dynamicConfigs,
}) {
  return Row(
    children: [
      ...List.generate(dynamicConfigs.length, (index) {
        final config = dynamicConfigs[index];
        return Expanded(
          flex: config.flex,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: config.isDropdown
                ? dropDownValues(
                  suggestionsController: config.dropdownConfig?.suggestionsController,
                    textController: config.dropdownConfig?.textController,
                    labelText: config.dropdownConfig?.labelText ?? '',
                    hintText: config.dropdownConfig?.hintText ?? '',
                    menus: config.dropdownConfig?.menuValues ?? {},
                    validate: config.dropdownConfig?.validate ?? false,
                    itemBuilder: config.dropdownConfig?.itemBuilder ??
                        (_, __) => const SizedBox(),
                    onSelected: config.dropdownConfig?.onSelected,
                  )
                : typeSection(
                  isDouble: config.fieldConfig?.isDouble,
                  isnumber:config.fieldConfig?.isnumber  ,
                  isEnabled:config.fieldConfig?.isEnabled ,
                  textController: config.fieldConfig?.textController,
                    labelText: config.fieldConfig?.labelText ?? '',
                    hintText: config.fieldConfig?.hintText ?? '',
                    validate: config.fieldConfig?.validate ?? false,
                    onChanged: config.fieldConfig?.onChanged,
                  ),
          ),
        );
      }),
    ],
  );
}

TextFormField typeSection(
    {String? labelText,
    String? hintText,
    bool? validate,
    TextEditingController? textController,
    bool? isEnabled,
    bool? isnumber,
    bool? isDouble,
    void Function(String)? onChanged}) {
  return TextFormField(
    inputFormatters: isnumber == true
    ? [FilteringTextInputFormatter.digitsOnly]
    : isDouble == true
        ? [DecimalTextInputFormatter()]
        : [],
    enabled: isEnabled,
    controller: textController,
    onChanged: onChanged,
    decoration: InputDecoration(
      hintStyle: const TextStyle(color: Colors.grey),
      labelText: labelText,
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
