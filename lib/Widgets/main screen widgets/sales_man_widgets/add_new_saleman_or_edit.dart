import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/sales_man_controller.dart';

Widget addNewSaleManOrEdit({
  required SalesManController controller,
}) {
  return ListView(
    children: [
      SizedBox(
        height: 10,
      ),
      myTextFormFieldWithBorder(
        controller: controller.name,
        labelText: 'Name',
        hintText: 'Enter Sale Man Name',
        validate: true,
      ),
      SizedBox(
        height: 15,
      ),
      myTextFormFieldWithBorder(
        isnumber: true,
        controller: controller.target,
        labelText: 'Target',
        hintText: 'Enter Target',
        validate: true,
      ),
    ],
  );
}
