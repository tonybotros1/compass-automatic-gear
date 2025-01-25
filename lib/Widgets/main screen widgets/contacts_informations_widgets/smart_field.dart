import 'package:flutter/material.dart';

import '../drop_down_menu.dart';

Widget smartField(
    {required String labelTextForDropMenu,
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
      showFirstField == true?
      Expanded(
        flex: 2,
        child: typeSection(labelTextForFirstSection ?? '', hintTextForFirstSection ?? '',
            validateForFirstSection ?? false, onChangedForFirstSection),
      ):SizedBox(),
      SizedBox(
        width: 5,
      ),
      showSecondField == true?
      Expanded(
        flex: 2,
        child: typeSection(labelTextForSecondSection ?? '', hintTextForSecondSection ?? '',
            validateForSecondSection, onChangedForSecondSection),
      ):SizedBox(),
      SizedBox(
        width: 5,
      ),
      AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        child: Expanded(
          flex: 2,
          child: typeSection(labelTextForThirdSection, hintTextForThirdSection,
              validateForThirdSection, onChangedForThirdSection),
        ),
      ),
    ],
  );
}

TextFormField typeSection(String labelText, String hintText,bool validate,
    void Function(String)? onChanged) {
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
