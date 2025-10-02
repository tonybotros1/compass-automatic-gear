import 'package:datahubai/Controllers/Main%20screen%20controllers/invoice_items_controller.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';

Widget addNewinvoiceItemsOrEdit({
  required InvoiceItemsController controller,
  bool? canEdit,
}) {
  return ListView(
    children: [
      const SizedBox(height: 10),
      myTextFormFieldWithBorder(
        obscureText: false,
        controller: controller.name,
        labelText: 'Name',
        hintText: 'Enter Name',
      ),

      const SizedBox(height: 10),
      myTextFormFieldWithBorder(
        isDouble: true,
        obscureText: false,
        controller: controller.price,
        labelText: 'Price',
        hintText: 'Enter Price',
      ),
      const SizedBox(height: 10),
      myTextFormFieldWithBorder(
        maxLines: 10,
        obscureText: false,
        controller: controller.description,
        labelText: 'Description',
        hintText: 'Enter Description',
      ),
    ],
  );
}
