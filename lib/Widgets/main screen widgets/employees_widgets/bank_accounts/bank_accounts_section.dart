import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/employees_controller.dart';
import '../../../../Models/employees/employee_account_banks_model.dart';
import '../../../../consts.dart';
import '../../auto_size_box.dart';
import 'bank_accounts_dialog.dart';

Widget bankAccountsSection({
  required BoxConstraints constraints,
  required BuildContext context,
}) {
  return Container(
    decoration: containerDecor,
    child: GetX<EmployeesController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: newBankAccountButton(controller: controller),
            ),
            Expanded(
              child: tableOfScreens(
                constraints: constraints,
                controller: controller,
                context: context,
              ),
            ),
          ],
        );
      },
    ),
  );
}

Widget tableOfScreens({
  required BoxConstraints constraints,
  required EmployeesController controller,
  required BuildContext context,
}) {
  return SizedBox(
    child: DataTable2(
      columnSpacing: 5,
      horizontalMargin: horizontalMarginForTable,
      showBottomBorder: true,
      sortColumnIndex: controller.sortColumnIndex.value,
      sortAscending: controller.isAscending.value,
      lmRatio: 2,
      columns: [
        const DataColumn2(label: SizedBox(), size: ColumnSize.S),
        DataColumn2(
          label: AutoSizedText(constraints: constraints, text: 'Name'),
          size: ColumnSize.M,
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(constraints: constraints, text: 'Acc. Number'),
        ),
        DataColumn2(
          size: ColumnSize.L,
          label: AutoSizedText(constraints: constraints, text: 'IBAN'),
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(constraints: constraints, text: 'SWIFT CODE'),
        ),
      ],
      rows: controller.bankAccountsList.map<DataRow>((invoiceItems) {
        return dataRowForTheTable(
          invoiceItems,
          constraints,
          controller,
          context,
        );
      }).toList(),
    ),
  );
}

DataRow dataRowForTheTable(
  EmployeeAccountBanksModel data,
  BoxConstraints constraints,
  EmployeesController controller,
  BuildContext context,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            removeBankAccountButton(
              controller: controller,
              id: data.id ?? '',
              context: context,
            ),
            updateBankAccountButton(
              controller: controller,
              data: data,
              id: data.id ?? '',
            ),
          ],
        ),
      ),
      DataCell(
        textForDataRowInTable(text: data.bankName ?? '', formatDouble: false),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.accountNumber ?? '',
          maxWidth: null,
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.iban ?? '',
          maxWidth: null,
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.swiftCode ?? '',
          maxWidth: null,
          formatDouble: false,
        ),
      ),
    ],
  );
}

ElevatedButton newBankAccountButton({required EmployeesController controller}) {
  return ElevatedButton(
    onPressed: () {
      controller.employeeBankName.clear();
      controller.employeeBankNameId.value = '';
      controller.employeeAccountNumber.clear();
      controller.employeeIBAN.clear();
      controller.employeeSWIFTCode.clear();
      bankAccountsDialog(
        controller: controller,
        canEdit: true,
        onPressed: () {
          controller.addNewEmployeeBankAccount();
        },
      );
    },
    style: newButtonStyle,
    child: const Text('New', style: TextStyle(fontWeight: FontWeight.bold)),
  );
}

IconButton removeBankAccountButton({
  required EmployeesController controller,
  required String id,
  required BuildContext context,
}) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: context,
        content: "Are you sure you want to delete this document?",
        onPressed: () {
          Get.back();
          controller.deleteBankAccount(id);
        },
      );
    },
    icon: deleteIcon,
  );
}

IconButton updateBankAccountButton({
  required EmployeeAccountBanksModel data,
  required EmployeesController controller,
  required String id,
}) {
  return IconButton(
    onPressed: () {
      controller.employeeBankName.text = data.bankName ?? '';
      controller.employeeBankNameId.value = data.bankNameId ?? '';
      controller.employeeAccountNumber.text = data.accountNumber ?? '';
      controller.employeeIBAN.text = data.iban ?? '';
      controller.employeeSWIFTCode.text = data.swiftCode ?? '';
      bankAccountsDialog(
        controller: controller,
        canEdit: true,
        onPressed: () {
          controller.updateEmployeeBankAccount(id);
        },
      );
    },
    icon: editIcon,
  );
}
