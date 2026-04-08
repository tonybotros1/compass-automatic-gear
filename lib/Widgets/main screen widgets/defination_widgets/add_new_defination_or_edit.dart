import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/payroll_elements_controller.dart';
import '../../../consts.dart';
import 'element_details_section.dart';

Widget addNewDefinationOrEdit({
  required PayrollElementsController controller,
  required BoxConstraints constraints,
  required BuildContext context,
}) {
  return SingleChildScrollView(
    child: Column(
      children: [
        labelContainer(lable: Text('Element Details', style: fontStyle1)),
        elementDetails(context,controller)
      ],
    ),
  );
}
