import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import '../../../Controllers/Main screen controllers/loan_and_advances_types_controller.dart';
import '../../menu_dialog.dart';

Widget addNewLoanAndAdvancesTypeOrEdit({
  required LoanAndAdvancesTypesController controller,
  required BoxConstraints constraints,
}) {
  return Form(
    key: controller.leaveTypeFormKey,
    child: SingleChildScrollView(
      child: Column(
        spacing: 20,
        children: [
          myTextFormFieldWithBorder(
            labelText: 'Name',
            controller: controller.name,
          ),
          myTextFormFieldWithBorder(
            labelText: 'Code',
            controller: controller.code,
          ),
          MenuWithValues(
            labelText: 'Based Element',
            headerLqabel: 'Based Elements',
            dialogWidth: 600,
            controller: controller.basedElement,
            displayKeys: const ['name'],
            displaySelectedKeys: const ['name'],
            onOpen: () {
              return controller.getAllPayrollElements();
            },
            onDelete: () {
              controller.basedElementId.value = "";
              controller.basedElement.clear();
            },
            onSelected: (value) {
              controller.basedElementId.value = value['_id']?.toString() ?? '';
              controller.basedElement.text = value['name']?.toString() ?? '';
            },
          ),
        ],
      ),
    ),
  );
}
