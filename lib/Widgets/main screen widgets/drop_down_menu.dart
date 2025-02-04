import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

Widget dropDownValues({
  required String labelText,
  required String hintText,
  required Map menus,
  required bool validate,
  required Widget Function(BuildContext, dynamic) itemBuilder,
  required void Function(dynamic)? onSelected,
  TextEditingController? textController,
  suggestionsController,
  required List listValues,
  void Function()? onTapForTypeAheadField,
  icon,
}) {
  FocusNode focusNode = FocusNode(); // ✅ Add a focus node

  // ✅ Listen for focus changes (when the user tabs or clicks away)
  focusNode.addListener(() {
    if (!focusNode.hasFocus) {
      _validateAndShowAlert(focusNode.context!, textController, listValues);
    }
  });

  return TypeAheadField(
    focusNode: focusNode,
    suggestionsController: suggestionsController,
    controller: textController,
    builder: (context, textEditingController, focusNode) => TextFormField(
      onTap: onTapForTypeAheadField,
      validator: validate
          ? (value) {
              if (value!.isEmpty) {
                return 'Please Select $labelText';
              }
              return null;
            }
          : null,
      controller: textEditingController,
      enabled: menus.isNotEmpty,
      focusNode: focusNode, // ✅ Attach the focus node
      decoration: InputDecoration(
        icon: icon,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
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
    itemBuilder: itemBuilder,
    onSelected: onSelected,
    errorBuilder: (context, error) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Error: $error',
          style: const TextStyle(color: Colors.red),
        ),
      );
    },
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


/// ✅ Helper function to validate the input and show an alert if necessary
void _validateAndShowAlert(
    BuildContext context, TextEditingController? textController, List listValues) {
  if (textController == null) return;

  String value = textController.text;
  if (value.isNotEmpty && !listValues.contains(value)) {
  
    textController.clear(); // ✅ Clear the invalid input

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Invalid Value'),
          content: Text('The value "$value" does not exist.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ✅ Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
