import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../Controllers/Main screen controllers/contact_informations_controller.dart';
import '../my_text_field.dart';
import 'drop_down_menu.dart';

Widget addNewContactOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required ContactInformationsController controller,
  TextEditingController? name,
  TextEditingController? address,
  bool? canEdit,
}) {
  return SizedBox(
    width: constraints.maxWidth / 2.5,
    child: ListView(
      children: [
        myTextFormField2(
          icon: Icon(
            Icons.person,
            color: Colors.grey,
          ),
          obscureText: false,
          controller: name ?? controller.contactName,
          labelText: 'Name',
          hintText: 'Enter Contact Name',
          validate: true,
        ),
        SizedBox(
          height: 10,
        ),
        myTextFormField2(
          icon: Icon(
            Icons.home,
            color: Colors.grey,
          ),
          obscureText: false,
          controller: address ?? controller.contactAdress,
          labelText: 'Address',
          hintText: 'Enter Contact Address',
          validate: true,
        ),
        SizedBox(
          height: 10,
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: controller.contactPhone.length,
            itemBuilder: (context, i) {
              return AnimatedContainer(
                duration: const Duration(microseconds: 300),
                child: Row(
                  children: [
                    smartField(
                        labelText: '',
                        hintText: '',
                        controller: null,
                        validate: true,
                        obscureText: false)
                  ],
                ),
              );
            })
      ],
    ),
  );
}

Widget smartField(
    {required String labelText,
    required String hintText,
    required controller,
    required validate,
    required obscureText,
    IconButton? icon,
    keyboardType,
    bool? isEnabled}) {
  return Row(
    children: [
      dropDownValues(
          labelText: '',
          hintText: '',
          menus: {},
          validate: false,
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion.toString()),
            );
          },
          onSelected: null),
      TextFormField(
        enabled: isEnabled,
        obscureText: obscureText,
        keyboardType: keyboardType,
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: icon,
          hintStyle: const TextStyle(color: Colors.grey),
          labelText: labelText,
          hintText: hintText,
          labelStyle: TextStyle(color: Colors.grey.shade700),
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
        ),
        validator: validate != false
            ? (value) {
                if (value!.isEmpty) {
                  return 'Please Enter $labelText';
                }
                return null;
              }
            : null,
      ),
    ],
  );
}
