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
  final String hintText;
  final Map menuValues;
  final bool validate;
  final int flex;
  final Widget Function(BuildContext, String, dynamic)? itemBuilder;
  final void Function(String, dynamic)? onSelected;
  final void Function()? onDelete;
  final Widget Function(String, dynamic)? showedResult;
  final String textController;
  final bool? isEnabled;

  final String showedSelectedName;

  DropdownConfig(
      {required this.hintText,
      required this.menuValues,
      this.validate = false,
      this.flex = 1,
      this.itemBuilder,
      this.onDelete,
      this.onSelected,
      this.textController = '',
      this.showedSelectedName = '',
      this.isEnabled,
      this.showedResult});
}

class FieldConfig {
  final String? labelText;
  final String? hintText;
  final bool validate;
  final int flex;
  final void Function(String)? onChanged;
  final TextEditingController? textController;
  final bool? isEnabled;
  final bool? isnumber;
  final bool? isDouble;
  final IconButton? suffixIcon;
  final bool? isDate;
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyboardType;

  FieldConfig({
    this.labelText,
    this.hintText,
    this.validate = false,
    this.flex = 1,
    this.onChanged,
    this.textController,
    this.isEnabled = true,
    this.isnumber,
    this.isDouble,
    this.suffixIcon,
    this.isDate,
    this.keyboardType,
    this.maxLines = 1,
    this.minLines,
  });
}
