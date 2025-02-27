import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

Widget dropDownValues2({
  required String hintText,
  required List<String> list,
  required bool validate,
  required void Function(dynamic)? onSelected,
  SingleSelectController<String>? textController,
}) {
  ScrollController scroll = ScrollController();

  Future<List<String>> search(String query) async {
    return list
        .where((item) =>
            item.toString().toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  return CustomDropdown<String>.searchRequest(
    headerBuilder: (context, selectedItem, enabled) => Text(selectedItem),
    listItemPadding: EdgeInsets.all(0),
    closedHeaderPadding: EdgeInsets.all(14),
    itemsScrollController: scroll,
    futureRequest: search,
    listItemBuilder: (context, item, isSelected, onItemSelect) => ListTile(
      title: Text(item),
    ),
    validator: validate
        ? (value) {
            if (value== null || value.isEmpty) {
              return '    Please Select $hintText';
            }
            return null;
          }
        : null,
        validateOnChange: true,
    enabled: list.isNotEmpty,
    items: list,
    controller: textController,
    onChanged: onSelected,
    hintText: hintText,
    disabledDecoration: CustomDropdownDisabledDecoration(
      
        fillColor: Colors.white12,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.shade400)),
    decoration: CustomDropdownDecoration(
      overlayScrollbarDecoration: ScrollbarThemeData(interactive: true),
      closedErrorBorderRadius: BorderRadius.circular(5),
      errorStyle: TextStyle(fontSize: 12,),
      closedErrorBorder: Border.all(color: Colors.red,width: 1),
      expandedBorderRadius: BorderRadius.circular(5),
      closedBorder: Border.all(color: Colors.grey, width: 1.0),
      closedFillColor: Colors.grey.shade200,
      closedBorderRadius: BorderRadius.circular(5),
      hintStyle: TextStyle(
          color: list.isEmpty ? Colors.grey.shade500 : Colors.grey.shade700,
          fontSize: 16),
    ),
  );
}
