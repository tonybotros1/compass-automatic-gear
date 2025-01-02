import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

Padding dropDownValues({
  required String labelText,
  required String hintText,
  required TextEditingController controller,
  required Map menus,
  // required String selectedValue,
  required bool validate,
  required menuIDFromList,
}) {
  return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      child: TypeAheadField(
        controller: controller,
        // Instead of textFieldConfiguration, we use the builder to return a TextField
        builder: (context, textEditingController, focusNode) => TextFormField(
          validator: validate != false
              ? (value) {
                  if (value!.isEmpty) {
                    return 'Please Select $labelText';
                  }
                  return null;
                }
              : null,
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 2.0),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.0),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2.0),
            ),
            iconColor: Colors.grey.shade700,
            suffixIcon: Icon(
              Icons.arrow_downward_rounded,
              color: Colors.grey.shade700,
            ),
            hintText: hintText,
            labelText: labelText,
            hintStyle: const TextStyle(color: Colors.grey),
            labelStyle: TextStyle(color: Colors.grey.shade700),
          ),
        ),
        suggestionsCallback: (pattern) async {
          return menus.values
              .toList()
              .where((item) =>
                  item.toString().toLowerCase().contains(pattern.toLowerCase()))
              .toList();
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion.toString()),
          );
        },
        onSelected: (suggestion) {
          controller.text = suggestion.toString();
          menus.entries.where((entrye) {
            return entrye.value == controller.text;
          }).map((entry) {
            menuIDFromList.value = entry.key;
          }).toList();
        },
        errorBuilder: (context, error) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Error: $error',
              style: const TextStyle(color: Colors.red),
            ),
          );
        },
        loadingBuilder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
        emptyBuilder: (context) => const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('No items found'),
        ),
        debounceDuration: const Duration(milliseconds: 300),
        direction: VerticalDirection.down,
        hideOnEmpty: true,
        animationDuration: const Duration(milliseconds: 200),
        hideOnSelect: true,
        hideKeyboardOnDrag: true,

        // suggestionsController: SuggestionsController(),
        transitionBuilder: (context, animation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ));
}
