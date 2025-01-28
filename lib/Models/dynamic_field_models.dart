
import 'package:flutter/material.dart';

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
