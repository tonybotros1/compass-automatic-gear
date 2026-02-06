import 'package:data_table_2/data_table_2.dart';
import 'package:datahubai/Controllers/Main%20screen%20controllers/cahs_management_base_controller.dart';
import 'package:datahubai/Models/ar%20receipts%20and%20ap%20payments/base_model_for_receipts_and_payments.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../auto_size_box.dart';

Widget availableInvoicesDialog<T extends CashManagementBaseController>(
  BoxConstraints constraints,
  BuildContext context,
  bool isPayment,
  T controller,
) {
  return SizedBox(
    width: constraints.maxWidth / 1.1,
    child: GetX<T>(
      builder: (controller) {
        if (isPayment) {
          if (controller.loadingInvoices.isTrue &&
              controller.availablePayments.isEmpty) {
            return Center(child: loadingProcess);
          }
        } else {
          if (controller.loadingInvoices.isTrue &&
              controller.availableReceipts.isEmpty) {
            return Center(child: loadingProcess);
          }
        }
        return tableOfScreens(
          constraints: constraints,
          context: context,
          controller: controller,
          isPayment: isPayment,
        );
      },
    ),
  );
}

Widget tableOfScreens<T extends CashManagementBaseController>({
  required BoxConstraints constraints,
  required BuildContext context,
  required T controller,
  required bool isPayment,
}) {
  return DataTable2(
    lmRatio: 4,
    checkboxHorizontalMargin: 2,
    showCheckboxColumn: true,
    columnSpacing: 5,
    horizontalMargin: horizontalMarginForTable,
    showBottomBorder: true,
    onSelectAll: (allSelected) {
      if (allSelected != null) {
        isPayment
            ? controller.selectAllPayments(allSelected)
            : controller.selectAllJobReceipts(allSelected);
      }
    },

    columns: [
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Invoice Number'),
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Invoice Date'),
      ),
      DataColumn2(
        size: ColumnSize.L,
        label: AutoSizedText(constraints: constraints, text: 'Note'),
      ),

      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Invoice Amount'),
        numeric: true,
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(
          constraints: constraints,
          text: 'Outstanding Amount',
        ),
        numeric: true,
      ),
    ],

    rows: isPayment
        ? controller.availablePayments
              .where(
                (r) => !controller.selectedAvailablePayments.any(
                  (sel) =>
                      (sel.apInvoiceId == r.apInvoiceId) &&
                      (sel.isDeleted != true),
                ),
              )
              .map((entry) {
                final originalIndex = controller.availablePayments.indexWhere(
                  (r) => r.apInvoiceId == entry.apInvoiceId,
                );
                return dataRowForTheTable(
                  entry,
                  context,
                  constraints,
                  controller,
                  originalIndex,
                  isPayment,
                );
              })
              .toList()
        : controller.availableReceipts
              .where(
                (r) => !controller.selectedAvailableReceipts.any(
                  (sel) => (sel.jobId == r.jobId) && (sel.isDeleted != true),
                ),
              )
              .map((entry) {
                final originalIndex = controller.availableReceipts.indexWhere(
                  (r) => r.jobId == entry.jobId,
                );
                return dataRowForTheTable(
                  entry,
                  context,
                  constraints,
                  controller,
                  originalIndex,
                  isPayment,
                );
              })
              .toList(),
  );
}

DataRow dataRowForTheTable<
  T extends CashManagementBaseController,
  D extends BaseModelForReceiptsAndPayments
>(
  D receiptData,
  BuildContext context,
  BoxConstraints constraints,
  T controller,
  int index,
  bool isPayment,
) {
  final isSelected = receiptData.isSelected;

  return DataRow(
    color: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.yellow;
      }
      return index % 2 != 0 ? coolColor : Colors.white;
    }),
    // each row reflects its own selection flag
    selected: isSelected,
    onSelectChanged: (value) {
      if (value != null) {
        isPayment
            ? controller.selectPayment(receiptData.apInvoiceId, value)
            : controller.selectJobReceipt(receiptData.jobId, value);
      }
    },
    cells: [
      DataCell(Text(receiptData.invoiceNumber)),
      DataCell(Text(textToDate(receiptData.invoiceDate))),
      DataCell(Text(receiptData.notes)),
      DataCell(
        Align(
          alignment: Alignment.centerRight,
          child: textForDataRowInTable(
            text: receiptData.invoiceAmount.toString(),
          ),
        ),
      ),
      DataCell(
        Align(
          alignment: Alignment.centerRight,
          child: textForDataRowInTable(
            text: receiptData.outstandingAmount.toString(),
          ),
        ),
      ),
    ],
  );
}
