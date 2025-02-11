import 'package:datahubai/Controllers/Main%20screen%20controllers/invoice_items_controller.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';

Widget addNewinvoiceItemsOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required InvoiceItemsController controller,
  bool? canEdit,
}) {
  return SizedBox(
    width: constraints.maxWidth / 2.5,
    height: 400,
    child: Form(
      key: controller.formKeyForAddingNewvalue,
      child: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          myTextFormFieldWithBorder(
            obscureText: false,
            controller: controller.name,
            labelText: 'Name',
            hintText: 'Enter Name',
            validate: true,
          ),
          SizedBox(
            height: 10,
          ),
          myTextFormFieldWithBorder(
            maxLines: 10,
            obscureText: false,
            controller: controller.description,
            labelText: 'Description',
            hintText: 'Enter Description',
            validate: false,
          ),
          SizedBox(
            height: 10,
          ),
          myTextFormFieldWithBorder(
            isDouble: true,
            obscureText: false,
            controller: controller.price,
            labelText: 'Price',
            hintText: 'Enter Price',
            validate: false,
          ),
        ],
      ),
    ),
  );
}
