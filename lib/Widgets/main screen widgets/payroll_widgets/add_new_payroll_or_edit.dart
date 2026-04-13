import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/payroll_controller.dart';
import '../../../consts.dart';
import 'payroll_details_section.dart';
import 'period_details_section.dart';

Widget addNewPayrollOrEdit({
  required PayrollController controller,
  required BoxConstraints constraints,
  required BuildContext context,
}) {
  return SingleChildScrollView(
    child: ConstrainedBox(
      constraints: BoxConstraints(minHeight: constraints.maxHeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          labelContainer(lable: Text('Payroll Details', style: fontStyle1)),
          parollDetails(controller),
          const SizedBox(height: 10),
          labelContainer(lable: Text('Period Details', style: fontStyle1)),
          SizedBox(
            height: constraints.maxHeight * 0.6,
            child: periodDetailsSection(
              constraints: constraints,
              context: context,
            ),
          ),
        ],
      ),
    ),
  );
}
