import 'package:flutter/material.dart';
import '../../Models/dynamic_field_models.dart';
import '../my_text_field.dart';
import 'drop_down_menu.dart';

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
                  listValues:config.dropdownConfig?.listValues ?? [],
                    suggestionsController:
                        config.dropdownConfig?.suggestionsController,
                    textController: config.dropdownConfig?.textController,
                    labelText: config.dropdownConfig?.labelText ?? '',
                    hintText: config.dropdownConfig?.hintText ?? '',
                    menus: config.dropdownConfig?.menuValues ?? {},
                    validate: config.dropdownConfig?.validate ?? false,
                    itemBuilder: config.dropdownConfig?.itemBuilder ??
                        (_, __) => const SizedBox(),
                    onSelected: config.dropdownConfig?.onSelected,
                  )
                : myTextFormFieldWithBorder(
                    isDate: config.fieldConfig?.isDate,
                    suffixIcon: config.fieldConfig?.suffixIcon,
                    isDouble: config.fieldConfig?.isDouble,
                    isnumber: config.fieldConfig?.isnumber,
                    isEnabled: config.fieldConfig?.isEnabled,
                    controller: config.fieldConfig?.textController,
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
