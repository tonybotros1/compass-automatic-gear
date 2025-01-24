import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import '../../Controllers/Main screen controllers/contact_informations_controller.dart';
import '../my_text_field.dart';

Widget addNewContactOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required ContactInformationsController controller,
  TextEditingController? name,
  TextEditingController? address,
  bool? canEdit,
}) {
  return SizedBox(
    width: constraints.maxWidth / 2,
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
        GetX<ContactInformationsController>(builder: (controller) {
          return Column(
            children: [
              AnimatedList(
                key: controller.listKey,
                shrinkWrap: true,
                initialItemCount: controller.contactPhone.length,
                itemBuilder: (context, i, animation) {
                  return buildSmartField(
                      controller, controller.contactPhone[i], animation, i);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.add),
                    color: Colors.grey,
                    onPressed: () {
                      controller.addPhoneLine();
                    },
                  ),
                ],
              )
            ],
          );
        }),
      ],
    ),
  );
}

Widget buildSmartField(ContactInformationsController controller,
    Map<String, dynamic> item, Animation<double> animation, int index,
    {bool isRemoving = false}) {
 
  return SizeTransition(
    sizeFactor: animation,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            SizedBox(
              width: 30,
              child: Icon(
                Icons.phone,
                color: Colors.grey,
                size: 25,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: smartField(
                  onChangedForName: (value) {
                    controller.contactPhone[index]['name'] = value;
                  },
                  onChangedForNumber: (value) {
                    controller.contactPhone[index]['number'] = value;
                  },
                  textControllerForDropMenu:
                      controller.controllers[index].controller,
                  labelTextForDropMenu: 'Type',
                  hintTextForDeopMenu: 'Select Phone Type',
                  menuValues: controller.phoneTypes.isEmpty
                      ? []
                      : controller.phoneTypes,
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text('${suggestion['name']}'),
                    );
                  },
                  onSelected: (value) {
                    controller.contactPhone[index]['type'] = value['name'];
                    controller.controllers[index].controller!.text =
                        value['name'];
                  },
                  labelTextForPhoneSection: 'Phone Number',
                  hintTextForPhoneSection: 'Enter Phone Number',
                  validateForPhoneSection: true,
                  labelTextForNameSection: 'Name',
                  hintTextForNameSection: 'Enter Name',
                  validateForNameSection: true,
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              child: controller.contactPhone.length > 1
                  ? IconButton(
                      key: ValueKey('remove_$index'),
                      onPressed: () {
                        removePhoneFieldWithAnimation(index, controller);
                      },
                      icon: Icon(
                        Icons.remove_circle_outline,
                        color: Colors.red,
                      ),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ],
    ),
  );
}

// =====================================================
void removePhoneFieldWithAnimation(
    int index, ContactInformationsController controller) {
  final removedItem = controller.contactPhone[index];
  controller.removePhoneField(index);
  controller.listKey.currentState?.removeItem(
    index,
    (context, animation) {
      return buildSmartField(controller, removedItem, animation, index,
          isRemoving: true);
    },
    duration: const Duration(milliseconds: 300),
  );
}
// =====================================================

Widget smartField({
  required String labelTextForDropMenu,
  required String hintTextForDeopMenu,
  required List menuValues,
  required Widget Function(BuildContext, dynamic) itemBuilder,
  required void Function(dynamic)? onSelected,
  TextEditingController? textControllerForDropMenu,
  required String labelTextForPhoneSection,
  required String hintTextForPhoneSection,
  required validateForPhoneSection,
  required String labelTextForNameSection,
  required String hintTextForNameSection,
  required validateForNameSection,
  required void Function(String)? onChangedForNumber,
  required void Function(String)? onChangedForName,
}) {
  return Row(
    children: [
      Expanded(
        flex: 1,
        child: TypeAheadField(
          controller: textControllerForDropMenu,
          builder: (context, textEditingController, focusNode) => TextFormField(
            controller: textEditingController,
            enabled: menuValues.isNotEmpty,
            focusNode: focusNode,
            decoration: InputDecoration(
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
              iconColor: Colors.grey.shade700,
              suffixIcon: Icon(
                Icons.arrow_downward_rounded,
                color: Colors.grey.shade700,
              ),
              hintText: hintTextForDeopMenu,
              labelText: labelTextForDropMenu,
              hintStyle: const TextStyle(color: Colors.grey),
              labelStyle: TextStyle(color: Colors.grey.shade700),
            ),
            onFieldSubmitted: (value) {
              // Check if the entered value exists in the menus list
              if (!menuValues.contains(value)) {
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
            return menuValues
                .toList()
                .where((item) => item
                    .toString()
                    .toLowerCase()
                    .contains(pattern.toLowerCase()))
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
      ),
      SizedBox(
        width: 5,
      ),
      Expanded(
        flex: 2,
        child: typeSection(labelTextForPhoneSection, hintTextForPhoneSection,
            validateForPhoneSection, onChangedForNumber),
      ),
      SizedBox(
        width: 5,
      ),
      AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        child: Expanded(
          flex: 2,
          child: typeSection(labelTextForNameSection, hintTextForNameSection,
              validateForNameSection, onChangedForName),
        ),
      ),
    ],
  );
}

TextFormField typeSection(String labelText, String hintText, validate,
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
