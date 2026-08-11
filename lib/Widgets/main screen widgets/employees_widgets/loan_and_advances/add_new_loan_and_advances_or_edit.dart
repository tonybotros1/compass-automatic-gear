import 'package:flutter/material.dart';
import '../../../../Controllers/Main screen controllers/employees_controller.dart';
import '../../../../consts.dart';
import '../../../form_focus_traversal.dart';
import '../../../menu_dialog.dart';
import '../../../my_text_field.dart';

Widget addNewLoanAndAdvancesOrEdit({
  required EmployeesController controller,
  required BuildContext context,
}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        MenuWithValues(
          labelText: 'Type',
          headerLqabel: 'Type',
          dialogWidth: 600,
          controller: controller.loanAndAdvancesType,
          displayKeys: const ['name'],
          displaySelectedKeys: const ['name'],
          onDelete: () {
            controller.loanAndAdvancesType.clear();
            controller.loanAndAdvancesTypeId.value = '';
          },
          onSelected: (value) {
            controller.loanAndAdvancesType.text = value['name'];
            controller.loanAndAdvancesTypeId.value = value['_id'];
          },
          onOpen: () {
            return controller.getAllLoanAndAdvancesTypes();
          },
        ).withFormFocusOrder(1),
        myTextFormFieldWithBorder(
          width: 200,
          obscureText: false,
          controller: controller.loanAndAdvancesTotalAmount,
          labelText: 'Total Amount',
          isDouble: true,
        ).withFormFocusOrder(2),
        myTextFormFieldWithBorder(
          width: 200,
          obscureText: false,
          controller: controller.loanAndAdvancesMonthlyInstallment,
          labelText: 'Monthly Installment',
          isDouble: true,
        ).withFormFocusOrder(3),
        myTextFormFieldWithBorder(
          labelText: 'Deduction Date',
          isDate: true,
          controller: controller.loanAndAdvancesDeductionDate,
          width: 200,
          suffixIcon: IconButton(
            onPressed: () async {
              selectDateContext(
                context,
                controller.loanAndAdvancesDeductionDate,
              );
            },
            icon: const Icon(Icons.date_range),
          ),
          onFieldSubmitted: (_) async {
            normalizeDate(
              controller.loanAndAdvancesDeductionDate.text,
              controller.loanAndAdvancesDeductionDate,
            );
          },
          onTapOutside: (_) {
            normalizeDate(
              controller.loanAndAdvancesDeductionDate.text,
              controller.loanAndAdvancesDeductionDate,
            );
          },
        ).withFormFocusOrder(4),

        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.loanAndAdvancesNote,
          labelText: 'Note',
        ).withFormFocusOrder(5),
      ],
    ),
  ).withFormFocusTraversal();
}
