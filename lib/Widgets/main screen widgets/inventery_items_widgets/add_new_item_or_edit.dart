import 'package:datahubai/Controllers/Main%20screen%20controllers/inventery_items_controller.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';

Widget addNewItemOrEdit({
  required InventeryItemsController controller,
  required bool canEdit,
}) {
  return SingleChildScrollView(
    scrollDirection: Axis.vertical,

    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 10,
        children: [
          SizedBox(
            width: 150,
            child: myTextFormFieldWithBorder(
              controller: controller.code,
              labelText: 'Code',
            ),
          ),
          SizedBox(
            width: 300,
            child: myTextFormFieldWithBorder(
              controller: controller.name,
              labelText: 'Name',
            ),
          ),
          SizedBox(
            width: 150,
            child: myTextFormFieldWithBorder(
              controller: controller.minQuantity,
              labelText: 'Minimum Quantity',
            ),
          ),
        ],
      ),
    ),
  );
}
