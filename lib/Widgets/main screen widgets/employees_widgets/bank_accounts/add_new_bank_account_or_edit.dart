import 'package:flutter/material.dart';
import '../../../../Controllers/Main screen controllers/employees_controller.dart';
import '../../../menu_dialog.dart';
import '../../../my_text_field.dart';

Widget addNewBankAccountOrEdit({
  required EmployeesController controller,
  required bool canEdit,
}) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        MenuWithValues(
          labelText: 'Bank Name',
          headerLqabel: 'Bank Name',
          dialogWidth: 600,
          controller: controller.employeeBankName,
          displayKeys: const ['name'],
          displaySelectedKeys: const ['name'],
          onDelete: () {
            controller.employeeBankName.clear();
            controller.employeeBankNameId.value = '';
          },
          onSelected: (value) {
            controller.employeeBankName.text = value['name'];
            controller.employeeBankNameId.value = value['_id'];
          },
          onOpen: () {
            return controller.getAkkBanksNames();
          },
        ),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.employeeAccountNumber,
          labelText: 'Account Number',
          validate: true,
        ),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.employeeIBAN,
          labelText: 'IBAN',
          validate: true,
        ),
        myTextFormFieldWithBorder(
          obscureText: false,
          controller: controller.employeeSWIFTCode,
          labelText: 'SWIFT Code',
          validate: true,
        ),
      ],
    ),
  );
}
