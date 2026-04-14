import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/payroll_runs_controller.dart';
import '../../menu_dialog.dart';

Widget addNewPayrollRunsOrEdit({
  required PayrollRunsController controller,
  required BoxConstraints constraints,
  required BuildContext context,
}) {
  return SingleChildScrollView(
    child: Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MenuWithValues(
          labelText: 'Payroll Name',
          headerLqabel: 'Payroll Names',
          dialogWidth: 600,
          width: 600,
          controller: controller.payrollName,
          displayKeys: const ['name'],
          displaySelectedKeys: const ['name'],
          onOpen: () {
            return controller.getAllPayrlls();
          },
          onDelete: () {
            controller.payrollNameId.value = "";
            controller.payrollName.clear();
          },
          onSelected: (value) {
            controller.payrollNameId.value = value['_id'];
            controller.payrollName.text = value['name'];
          },
        ),
        MenuWithValues(
          labelText: 'Period Name',
          headerLqabel: 'Periods Names',
          dialogWidth: 600,
          width: 600,
          controller: controller.periodName,
          displayKeys: const ['period_name'],
          displaySelectedKeys: const ['period_name'],
          onOpen: () {
            return controller.getPayrollPeriods();
          },
          onDelete: () {
            controller.periodNameId.value = "";
            controller.periodName.clear();
          },
          onSelected: (value) {
            controller.periodNameId.value = value['_id'];
            controller.periodName.text = value['period_name'];
          },
        ),
        MenuWithValues(
          labelText: 'Employee',
          headerLqabel: 'Employees',
          dialogWidth: 600,
          width: 600,
          controller: controller.employeeName,
          displayKeys: const ['full_name'],
          displaySelectedKeys: const ['full_name'],
          onOpen: () {
            return controller.getAllEmployeesForSelectedPayroll();
          },
          onDelete: () {
            controller.employeeId.value = "";
            controller.employeeName.clear();
          },
          onSelected: (value) {
            controller.employeeId.value = value['_id'];
            controller.employeeName.text = value['full_name'];
          },
        ),
        MenuWithValues(
          labelText: 'Element Name',
          headerLqabel: 'Elements',
          dialogWidth: 600,
          width: 600,
          controller: controller.elementName,
          displayKeys: const ['name'],
          displaySelectedKeys: const ['name'],
          onOpen: () {
            return controller.getAllPayrollElements();
          },
          onDelete: () {
            controller.elementId.value = "";
            controller.elementName.clear();
          },
          onSelected: (value) {
            controller.elementId.value = value['_id'];
            controller.elementName.text = value['name'];
          },
        ),
      ],
    ),
  );
}
