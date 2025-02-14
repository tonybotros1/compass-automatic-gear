import 'package:flutter/material.dart';

import '../../../Controllers/Main screen controllers/job_card_controller.dart';
import '../../my_text_field.dart';

Widget addNewinvoiceItemsOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required JobCardController controller,
}) {
  return SizedBox(
    width: constraints.maxWidth / 2,
    height: 400,
    child: Column(
      spacing: 20,
      children: [
        myTextFormFieldWithBorder(
          isnumber: true,
          controller: controller.lineNumber,
          labelText: 'Line Number',
          hintText: 'Enter Line Number',
          validate: true,
        ),
        myTextFormFieldWithBorder(
          maxLines: 4,
          controller: controller.description,
          labelText: 'Description',
          hintText: 'Enter Description',
          validate: true,
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: myTextFormFieldWithBorder(
                onChanged: (_) => controller.updateCalculating(),
                isnumber: true,
                controller: controller.quantity,
                labelText: 'Quantity',
                hintText: 'Enter Quantity',
                validate: true,
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                onChanged: (_) => controller.updateCalculating(),
                isDouble: true,
                controller: controller.price,
                labelText: 'Price',
                hintText: 'Enter Price',
                validate: true,
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                onChanged: (_) => controller.updateCalculating(),
                isEnabled: false,
                controller: controller.amount,
                labelText: 'Amount',
                hintText: 'Enter Amount',
                validate: true,
              ),
            ),
          ],
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: myTextFormFieldWithBorder(
                onChanged: (_) => controller.updateCalculating(),
                isDouble: true,
                controller: controller.discount,
                labelText: 'Discount',
                hintText: 'Enter Discount',
                validate: true,
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                isEnabled: false,
                controller: controller.total,
                labelText: 'Total',
                hintText: 'Enter Total',
                validate: true,
              ),
            ),
          ],
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: myTextFormFieldWithBorder(
                onChanged: (_) => controller.updateCalculating(),
                isDouble: true,
                controller: controller.vat,
                labelText: 'VAT',
                hintText: 'Enter VAT',
                validate: true,
              ),
            ),
            Expanded(
              child: myTextFormFieldWithBorder(
                onChanged: (_) => controller.updatevat(),
                isDouble: true,
                controller: controller.net,
                labelText: 'Net',
                hintText: 'Enter Net',
                validate: true,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
