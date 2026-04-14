import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/payroll_controller.dart';
import '../../../consts.dart';
import 'payroll_details_section.dart';
import 'period_details_section.dart';
import 'period_dialog.dart';

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
          labelContainer(
            lable: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Period Details', style: fontStyle1),
                newPeriodButton(context, constraints, controller),
              ],
            ),
          ),
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

ElevatedButton newPeriodButton(
  BuildContext context,
  BoxConstraints constraints,
  PayrollController controller,
) {
  return ElevatedButton(
    onPressed: () {
      if (controller.currentPayrollId.value.isEmpty) {
        alertMessage(
          context: context,
          content: 'Please save the payroll first',
        );
        return;
      }
      periodDialog(
        controller: controller,
        onPressed: () {
          controller.addNewPayrollPeriod();
        },
        context: context,
      );
    },
    style: new2ButtonStyle,
    child: const Text("New Periods"),
  );
}
