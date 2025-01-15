import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

Widget dropDownValuesForList({
  required String labelText,
  required String hintText,
  required List values,
  required bool validate,
  required bool isCoutry,
  TextEditingController? textController,
  required controller,
}) {
  return TypeAheadField(
    controller: textController,
    builder: (context, textEditingController, focusNode) => TextFormField(
      enabled: values.isNotEmpty,
      validator: validate
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'Please select $labelText';
              }
              bool isValid = values.any((val) =>
                  val['name'].toString().toLowerCase() == value.toLowerCase());
              if (!isValid) {
                return 'Please select a valid $labelText';
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
      onFieldSubmitted: (value) {
        // Check if the entered value exists in the menus list
        if (!value.contains(value)) {
          // Show an alert dialog if not present
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Invalid Menu'),
                content: Text('The menu "$value" does not exist.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      },
    ),
    suggestionsCallback: (pattern) {
      return values
          .where((item) =>
              item.toString().toLowerCase().contains(pattern.toLowerCase()))
          .toList();
    },
    itemBuilder: (context, suggestion) {
      return ListTile(
        title: Text('${suggestion['name']}'),
      );
    },
    onSelected: (suggestion) {
      try {
        textController!.text = '${suggestion['name']}';
        controller.onSelect(isCoutry, suggestion['code']);
      } catch (e) {
        //
      }
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
    transitionBuilder: (context, animation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
