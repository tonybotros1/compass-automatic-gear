import 'package:datahubai/Controllers/Main%20screen%20controllers/company_variables_controller.dart';
import 'package:flutter/material.dart';
import '../../my_text_field.dart';

Widget updateVariables({required CompanyVariablesController controller}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 10,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 10,
          children: [
            myTextFormFieldWithBorder(
              width: 150,
              obscureText: false,
              controller: controller.incentivePercentage,
              labelText: 'Incentive Percentage',
              isDouble: true,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.percent, color: Colors.grey.shade700),
            ),
          ],
        ),
        Row(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            myTextFormFieldWithBorder(
              width: 150,
              obscureText: false,
              controller: controller.vatPercentage,
              labelText: 'VAT Percentage',
              isDate: true,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.percent, color: Colors.grey.shade700),
            ),
          ],
        ),
        myTextFormFieldWithBorder(
          width: 150,

          obscureText: false,
          controller: controller.taxNumber,
          labelText: 'TAX Number',
        ),
      ],
    ),
  );
}
