import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';

import '../../../../consts.dart';

class CompanyVariables extends StatelessWidget {
  const CompanyVariables({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding: screenPadding,
          child: Container(
              padding: EdgeInsets.all(16),
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                  child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200,
                    child: myTextFormFieldWithBorder(
                        isDouble: true, labelText: 'Incentive Percentage'),
                  ),
                  SizedBox(
                    width: 200,
                    child: myTextFormFieldWithBorder(
                        isDouble: true, labelText: 'VAT Percentage'),
                  ),
                  SizedBox(
                    width: 200,
                    child: myTextFormFieldWithBorder(labelText: 'TAX Number'),
                  )
                ],
              ))),
        );
      }),
    );
  }
}
