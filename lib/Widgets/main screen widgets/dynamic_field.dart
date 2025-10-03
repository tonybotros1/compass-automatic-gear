import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:flutter/material.dart';
import '../../Models/dynamic_field_models.dart';
import '../my_text_field.dart';

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
                ? CustomDropdown(
                  onDelete: config.dropdownConfig?.onDelete,
                    showedResult: config.dropdownConfig?.showedResult,
                    showedSelectedName:
                        config.dropdownConfig!.showedSelectedName,
                    onChanged: config.dropdownConfig?.onSelected,
                    textcontroller: config.dropdownConfig!.textController,
                    validator: config.dropdownConfig?.validate ?? false,
                    hintText: config.dropdownConfig?.hintText ?? '',
                    items: config.dropdownConfig?.menuValues ?? {},
                    itemBuilder: config.dropdownConfig?.itemBuilder,
                  )
                // dropDownValues(
                //     listValues: config.dropdownConfig?.listValues ?? [],
                //     suggestionsController:
                //         config.dropdownConfig?.suggestionsController,
                //     textController: config.dropdownConfig?.textController,
                //     labelText: config.dropdownConfig?.labelText ?? '',
                //     hintText: config.dropdownConfig?.hintText ?? '',
                //     menus: config.dropdownConfig?.menuValues ?? {},
                //     validate: config.dropdownConfig?.validate ?? false,
                //     itemBuilder: config.dropdownConfig?.itemBuilder ??
                //         (_, __) => const SizedBox(),
                //     onSelected: config.dropdownConfig?.onSelected,
                //   )
                : myTextFormFieldWithBorder(
                    maxLines: config.fieldConfig?.maxLines,
                    minLines: config.fieldConfig?.minLines,
                    keyboardType: config.fieldConfig?.keyboardType,
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
