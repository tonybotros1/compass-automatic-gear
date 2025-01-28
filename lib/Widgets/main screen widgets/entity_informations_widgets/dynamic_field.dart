import 'package:flutter/material.dart';

import '../../../Models/dynamic_field_models.dart';
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
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: config.isDropdown
                ? dropDownValues(
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
    void Function(String)? onChanged}) {
  return TextFormField(
    onChanged: onChanged,
    decoration: InputDecoration(
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
