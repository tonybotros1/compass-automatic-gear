import 'package:flutter/material.dart';

import '../drop_down_menu.dart';

Widget smartField({
  required String labelTextForDropMenu,
  required String hintTextForDeopMenu,
  required Map menuValues,
  required Widget Function(BuildContext, dynamic) itemBuilder,
  required void Function(dynamic)? onSelected,
  TextEditingController? textControllerForDropMenu,
  String? labelTextForFirstSection,
  String? hintTextForFirstSection,
  bool? validateForFirstSection,
  required String labelTextForThirdSection,
  required String hintTextForThirdSection,
  required validateForThirdSection,
  void Function(String)? onChangedForFirstSection,
  required void Function(String)? onChangedForThirdSection,
  String? labelTextForSecondSection,
  String? hintTextForSecondSection,
  validateForSecondSection,
  required validateForTypeSection,
  void Function(String)? onChangedForSecondSection,
  bool showFirstField = false,
  bool showSecondField = false,
}) {
  return Row(
    children: [
      Expanded(
        flex: 1,
        child: dropDownValues(
            textController: textControllerForDropMenu,
            labelText: labelTextForDropMenu,
            hintText: hintTextForDeopMenu,
            menus: menuValues,
            validate: validateForTypeSection,
            itemBuilder: itemBuilder,
            onSelected: onSelected),
      ),
      SizedBox(
        width: 5,
      ),
      showFirstField == true
          ? Expanded(
              flex: 1,
              child: typeSection(
                  labelText: labelTextForFirstSection ?? '',
                  hintText: hintTextForFirstSection ?? '',
                  validate: validateForFirstSection ?? false,
                  onChanged: onChangedForFirstSection),
            )
          : SizedBox(),
      SizedBox(
        width: 5,
      ),
      showSecondField == true
          ? Expanded(
              flex: 2,
              child: typeSection(
                  labelText: labelTextForSecondSection ?? '',
                  hintText: hintTextForSecondSection ?? '',
                  validate: validateForSecondSection,
                  onChanged: onChangedForSecondSection),
            )
          : SizedBox(),
      SizedBox(
        width: 5,
      ),
      AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        child: Expanded(
          flex: 2,
          child: typeSection(
              labelText: labelTextForThirdSection,
              hintText: hintTextForThirdSection,
              validate: validateForThirdSection,
              onChanged: onChangedForThirdSection),
        ),
      ),
    ],
  );
}

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

class DynamicConfig {
  final bool isDropdown;
  final int flex;
  final DropdownConfig? dropdownConfig;
  final FieldConfig? fieldConfig;

  DynamicConfig({
    required this.isDropdown,
    this.flex = 1,
    this.dropdownConfig,
    this.fieldConfig,
  });
}

class DropdownConfig {
  final String labelText;
  final String hintText;
  final Map menuValues;
  final bool validate;
  final int flex;
  final Widget Function(BuildContext, dynamic) itemBuilder;
  final void Function(dynamic)? onSelected;
  final TextEditingController? textController;

  DropdownConfig({
    required this.labelText,
    required this.hintText,
    required this.menuValues,
    this.validate = false,
    this.flex = 1,
    required this.itemBuilder,
    this.onSelected,
    this.textController,
  });
}

class FieldConfig {
  final String? labelText;
  final String? hintText;
  final bool validate;
  final int flex;
  final void Function(String)? onChanged;

  FieldConfig({
    this.labelText,
    this.hintText,
    this.validate = false,
    this.flex = 1,
    this.onChanged,
  });
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
