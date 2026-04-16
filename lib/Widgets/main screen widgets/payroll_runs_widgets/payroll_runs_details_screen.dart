import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/payroll_runs_controller.dart';
import 'elements_table_section.dart';
import 'employees_table_section.dart';

Widget payrollRunsDetailsScreen({
  required PayrollRunsController controller,
  required BoxConstraints constraints,
}) {
  return Row(
    spacing: 10,
    children: [
      Expanded(flex: 2, child: employeeTableSection(constraints: constraints)),
      Expanded(child: elementsTableSection(constraints: constraints)),
    ],
  );
}
