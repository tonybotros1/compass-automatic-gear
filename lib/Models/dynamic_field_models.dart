import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

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
  final SuggestionsController<dynamic>? suggestionsController;
  final void Function()? onTap;
  final bool? isEnabled;
  final List? listValues;

  DropdownConfig(
      {required this.labelText,
      required this.hintText,
      required this.menuValues,
      this.validate = false,
      this.flex = 1,
      required this.itemBuilder,
      this.onSelected,
      this.textController,
      this.suggestionsController,
      this.isEnabled,
      this.listValues,
      this.onTap});
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
