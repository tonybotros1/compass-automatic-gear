import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/payroll_runs_controller.dart';
import 'elements_table_section.dart';
import 'employees_table_section.dart';
import 'information_section.dart';

Widget payrollRunsDetailsScreen({
  required PayrollRunsController controller,
  required BoxConstraints constraints,
  required BuildContext context,
}) {
  return Row(
    spacing: 10,
    children: [
      Expanded(flex: 2, child: employeeTableSection(constraints: constraints,context: context)),
      Expanded(
        child: Column(
          spacing: 5,
          children: [
            Expanded(child: elementsTableSection(constraints: constraints,context: context)),
            Expanded(child: informationTableSection(constraints: constraints)),
          ],
        ),
      ),
    ],
  );
}
