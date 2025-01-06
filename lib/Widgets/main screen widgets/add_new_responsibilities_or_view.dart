import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../Auth screens widgets/register widgets/my_text_form_field.dart';

Widget addNewResponsibilityOrView({
  required BoxConstraints constraints,
  required BuildContext context,
  required controller,
  TextEditingController? responsibilityName,
  TextEditingController? menuName,
}) {
  return SizedBox(
    width: constraints.maxWidth / 2.5,
    height: 150,
    child: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: myTextFormField(
            constraints: constraints,
            obscureText: false,
            controller: responsibilityName ?? controller.responsibilityName,
            labelText: 'Responsibility Name',
            hintText: 'Enter Responsibility name',
            keyboardType: TextInputType.name,
            validate: true,
          ),
        ),
        dropDownValues(
          textController: menuName,
          labelText: 'Menus',
          hintText: 'Select Menu',
          menus: controller.selectFromMenus,
          validate: true,
          controller: controller,
        ),
      ],
    ),
  );
}

Padding dropDownValues({
  required String labelText,
  required String hintText,
  required Map menus,
  required bool validate,
  TextEditingController? textController,
  required controller,
}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
    child: TypeAheadField(
      controller: textController,
      builder: (context, textEditingController, focusNode) => TextFormField(
        validator: validate
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
        onFieldSubmitted: (value) {
          // Check if the entered value exists in the menus list
          if (!menus.values.contains(value)) {
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
                        Navigator.of(context).pop(); // Close the dialog
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
        textController!.text = suggestion.toString();
        menus.entries.where((entry) {
          return entry.value == suggestion.toString();
        }).forEach((entry) {
          controller.menuIDFromList.value = entry.key;
        });
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
    ),
  );
}
