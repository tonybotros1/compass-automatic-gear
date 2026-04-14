import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/payroll_controller.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';
import '../../my_text_field.dart';

Container parollDetails(PayrollController controller) {
  return Container(
    // height: 245,
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 50,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  myTextFormFieldWithBorder(
                    labelText: 'Name',
                    controller: controller.name,
                    width: 600,
                  ),
                  MenuWithValues(
                    labelText: 'Payment Type',
                    headerLqabel: 'payment Types',
                    dialogWidth: 600,
                    width: 600,
                    controller: controller.paymentType,
                    displayKeys: const ['type'],
                    displaySelectedKeys: const ['type'],
                    onOpen: () {
                      return controller.getPaymentTypes();
                    },
                    onDelete: () {
                      controller.paymentTypeId.value = "";
                      controller.paymentType.clear();
                    },
                    onSelected: (value) {
                      controller.paymentTypeId.value = value['_id'];
                      controller.paymentType.text = value['type'];
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: myTextFormFieldWithBorder(
                maxLines: 7,
                labelText: 'Notes',
                controller: controller.notes,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
