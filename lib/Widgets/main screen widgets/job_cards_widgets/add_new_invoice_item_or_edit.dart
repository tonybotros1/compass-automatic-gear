import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/job_card_controller.dart';
import '../../my_text_field.dart';

Widget addNewinvoiceItemsOrEdit({
  required JobCardController controller,
}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        SizedBox(
          width: 200,
          child: myTextFormFieldWithBorder(
            isnumber: true,
            controller: controller.lineNumber,
            labelText: 'Line Number',
            hintText: 'Enter Line Number',
            validate: true,
          ),
        ),
        Form(
          key: controller.formKeyForInvoiceItems,
          child: GetX<JobCardController>(builder: (context) {
            bool isLoading = controller.allInvoiceItemsFromCollection.isEmpty;
            return CustomDropdown(
              hintText: 'Name',
              textcontroller: controller.invoiceItemName.text,
              showedSelectedName: 'name',
              validator: true,
              items:
                  isLoading ? {} : controller.allInvoiceItemsFromCollection,
              itemBuilder: (context, key, value) {
                return ListTile(
                  title: Text(value['name']),
                );
              },
              onChanged: (key, value) {
                controller.invoiceItemName.text = value['name'];
                controller.description.text = value['description'];
                controller.invoiceItemNameId.value = key;
              },
            );
          
          }),
        ),
        myTextFormFieldWithBorder(
          maxLines: 4,
          controller: controller.description,
          labelText: 'Description',
          hintText: 'Enter Description',
          validate: true,
        ),
        SizedBox(
          width: 200,
          child: myTextFormFieldWithBorder(
            onChanged: (_) => controller.updateCalculating(),
            isnumber: true,
            controller: controller.quantity,
            labelText: 'Quantity',
            hintText: 'Enter Quantity',
            validate: true,
          ),
        ),
        SizedBox(
          width: 200,
          child: myTextFormFieldWithBorder(
            onChanged: (_) => controller.updateCalculating(),
            isDouble: true,
            controller: controller.price,
            labelText: 'Price',
            hintText: 'Enter Price',
            validate: true,
          ),
        ),
        SizedBox(
          width: 200,
          child: myTextFormFieldWithBorder(
            onChanged: (_) => controller.updateCalculating(),
            isEnabled: false,
            controller: controller.amount,
            labelText: 'Amount',
            hintText: 'Enter Amount',
            validate: true,
          ),
        ),
        SizedBox(
          width: 200,
          child: myTextFormFieldWithBorder(
            onChanged: (_) => controller.updateCalculating(),
            isDouble: true,
            controller: controller.discount,
            labelText: 'Discount',
            hintText: 'Enter Discount',
            validate: true,
          ),
        ),
        SizedBox(
          width: 200,
          child: myTextFormFieldWithBorder(
            isEnabled: false,
            controller: controller.total,
            labelText: 'Total',
            hintText: 'Enter Total',
            validate: true,
          ),
        ),
        SizedBox(
          width: 200,
          child: myTextFormFieldWithBorder(
            isEnabled: false,
            onChanged: (_) => controller.updateCalculating(),
            isDouble: true,
            controller: controller.vat,
            labelText: 'VAT',
            hintText: 'Enter VAT',
            validate: true,
          ),
        ),
        SizedBox(
          width: 200,
          child: myTextFormFieldWithBorder(
            onChanged: (_) => controller.updateAmount(),
            isDouble: true,
            controller: controller.net,
            labelText: 'Net',
            hintText: 'Enter Net',
            validate: true,
          ),
        ),
      ],
    ),
  );
}
