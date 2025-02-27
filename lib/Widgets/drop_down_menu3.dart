
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controllers/custom_drop_down_menu_controller.dart';

class CustomDropdown extends StatelessWidget {
  final Map<String, dynamic> items;
  final String hintText;
  final BoxDecoration? dropdownDecoration;
  final void Function(Map<String, dynamic>)? onChanged;
  final Widget Function(BuildContext, Map<String, dynamic>) itemBuilder;
  final DropdownController controller;

  CustomDropdown({super.key, 
    required this.items,
    required this.itemBuilder,
    required this.controller,
    this.hintText = "Select an option",
    this.dropdownDecoration,
    this.onChanged,
  });

  final GlobalKey buttonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          key: buttonKey,
          onTap: () {
            controller.showDropdown(buttonKey, items);
          },
          child: Obx(() => Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: dropdownDecoration ??
                    BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: controller.isValid.value ? Colors.grey : Colors.red),
                      borderRadius: BorderRadius.circular(8),
                    ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.selectedValue.isEmpty ? hintText : controller.selectedValue["name"].toString(),
                      style: TextStyle(
                        color: controller.selectedValue.isEmpty ? Colors.grey : Colors.black,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              )),
        ),
        SizedBox(height: 5),
        Obx(() => controller.isValid.value
            ? SizedBox.shrink()
            : Text("Please select an option", style: TextStyle(color: Colors.red))),
      ],
    );
  }
}