import 'package:data_table_2/data_table_2.dart';
import 'package:datahubai/Controllers/Main%20screen%20controllers/employees_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Models/employees/employee_loan_and_advances_model.dart';
import '../../../../consts.dart';
import '../../auto_size_box.dart';
import 'loan_and_advances_dialog.dart';

Widget loanAndAdvancesSection(
  BoxConstraints constraints,
  BuildContext context, {
  double height = 410,
}) {
  return Container(
    decoration: containerDecor,
    height: height,
    child: GetX<EmployeesController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: newElementButton(controller: controller, context: context),
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
    // width: constraints.maxWidth - 17,
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
          label: AutoSizedText(constraints: constraints, text: 'Amount'),
          size: ColumnSize.M,
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(
            constraints: constraints,
            text: 'Monthly Installment',
          ),
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(
            constraints: constraints,
            text: 'Deduction Date',
          ),
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(constraints: constraints, text: 'Paid to Date'),
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(
            constraints: constraints,
            text: 'Remaining Amount',
          ),
        ),
        DataColumn2(
          size: ColumnSize.M,
          label: AutoSizedText(constraints: constraints, text: 'Type'),
        ),
        DataColumn2(
          size: ColumnSize.L,
          label: AutoSizedText(constraints: constraints, text: 'Note'),
        ),
      ],
      rows: controller.loanAndAdvancesList.map<DataRow>((invoiceItems) {
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
  EmployeeLoanAndAdvancesModel data,
  BoxConstraints constraints,
  EmployeesController controller,
  BuildContext context,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            removePayrollButton(
              controller: controller,
              id: data.id ?? '',
              context: context,
            ),
            updatePayrollButton(
              controller: controller,
              data: data,
              id: data.id ?? '',
              context: context,
            ),
          ],
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.totalAmount?.toString() ?? '',
          formatDouble: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.monthlyInstallment?.toString() ?? '',
          formatDouble: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: textToDate(data.deductionDate),
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.paidToDate?.toString() ?? '',
          formatDouble: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.remainingAmount?.toString() ?? '',
          formatDouble: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.type?.toString() ?? '',
          formatDouble: false,
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.note ?? '',
          maxWidth: null,
          formatDouble: false,
        ),
      ),
    ],
  );
}

ElevatedButton newElementButton({
  required EmployeesController controller,
  required BuildContext context,
}) {
  return ElevatedButton(
    onPressed: () {
      if (controller.currentEmployeeId.value.isEmpty) {
        alertMessage(context: Get.context!, content: "Please save doc first");
        return;
      }
      controller.loanAndAdvancesTotalAmount.clear();
      controller.loanAndAdvancesTypeId.value = '';
      controller.loanAndAdvancesMonthlyInstallment.clear();
      controller.loanAndAdvancesDeductionDate.clear();
      controller.loanAndAdvancesNote.clear();
      controller.loanAndAdvancesType.clear();
      loanAndAdvancesDialog(
        controller: controller,
        canEdit: true,
        onPressed: controller.addingNewEmployeePayrollValue.isTrue
            ? null
            : () {
                // controller.addNewEmployeePayroll();
              },
        context: context,
      );
    },
    style: newButtonStyle,
    child: const Text('New', style: TextStyle(fontWeight: FontWeight.bold)),
  );
}

IconButton removePayrollButton({
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
          // controller.deleteEmployeePayroll(id);
        },
      );
    },
    icon: deleteIcon,
  );
}

IconButton updatePayrollButton({
  required EmployeeLoanAndAdvancesModel data,
  required EmployeesController controller,
  required String id,
  required BuildContext context,
}) {
  return IconButton(
    onPressed: () {
      controller.loanAndAdvancesTotalAmount.text =
          data.totalAmount?.toString() ?? '';
      controller.loanAndAdvancesTypeId.value = data.typeId ?? '';
      controller.loanAndAdvancesMonthlyInstallment.text =
          data.monthlyInstallment?.toString() ?? '';
      controller.loanAndAdvancesDeductionDate.text = textToDate(
        data.deductionDate,
      );
      controller.loanAndAdvancesNote.text = data.note ?? '';
      controller.loanAndAdvancesType.text = data.type ?? '';
      loanAndAdvancesDialog(
        controller: controller,
        canEdit: true,
        onPressed: controller.addingNewEmployeePayrollValue.isTrue
            ? null
            : () {
                // controller.updateEmployeePayroll(id);
              },
        context: context,
      );
    },
    icon: editIcon,
  );
}
