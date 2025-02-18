import 'package:datahubai/Widgets/main%20screen%20widgets/drop_down_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/job_card_controller.dart';
import '../../my_text_field.dart';

Widget addNewinvoiceItemsOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required JobCardController controller,
}) {
  return SizedBox(
    width: constraints.maxWidth / 2,
    child: SingleChildScrollView(
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
              return dropDownValues(
                textController: controller.invoiceItemName,
                labelText: 'Name',
                hintText: 'Select Name',
                menus: controller.allInvoiceItemsFromCollection,
                validate: true,
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text('${suggestion['name']}'),
                  );
                },
                onSelected: (suggestion) {
                  controller.invoiceItemName.text = suggestion['name'];
                  controller.description.text = suggestion['description'];
                  controller.allInvoiceItemsFromCollection.entries
                      .where((entry) {
                    return entry.value['name'] == suggestion['name'].toString();
                  }).forEach(
                    (entry) {
                      controller.invoiceItemNameId.value = entry.key;
                    },
                  );
                },
                listValues: controller.allInvoiceItemsFromCollection.values
                    .map((value) => value['name'].toString())
                    .toList(),
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
    ),
  );
}
