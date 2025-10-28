import 'package:datahubai/Controllers/Main%20screen%20controllers/cahs_management_base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Models/ar receipts and ap payments/customer_invoices_model.dart';
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
    child: Padding(
      padding: const EdgeInsets.all(8.0),
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
    ),
  );
}

Widget tableOfScreens<T extends CashManagementBaseController>({
  required BoxConstraints constraints,
  required BuildContext context,
  required T controller,
  required bool isPayment,
}) {
  return DataTable(
    checkboxHorizontalMargin: 2,
    showCheckboxColumn: true,
    dataRowMaxHeight: 40,
    dataRowMinHeight: 30,
    columnSpacing: 5,
    horizontalMargin: horizontalMarginForTable,
    showBottomBorder: true,
    dataTextStyle: regTextStyle,
    headingTextStyle: fontStyleForTableHeader,

    headingRowColor: WidgetStateProperty.all(Colors.grey[300]),

    onSelectAll: (allSelected) {
      if (allSelected != null) {
        isPayment
            ? controller.selectAllPayments(allSelected)
            : controller.selectAllJobReceipts(allSelected);
      }
    },

    columns: [
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Invoice Number'),
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Note'),
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Invoice Date'),
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Invoice Amount'),
        numeric: true,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Outstanding Amount',
        ),
        numeric: true,
      ),
    ],

    rows:
        //  isPayment
        //     ? controller.availablePayments
        //           // filter out already‐selected receipts
        //           .where(
        //             (r) => !controller.selectedAvailablePayments.any(
        //               (sel) => sel['reference_number'] == r['reference_number'],
        //             ),
        //           )
        //           .toList()
        //           // re‐index the filtered list
        //           .asMap()
        //           .entries
        //           .map((entry) {
        //             // cast each entry to Map<String,dynamic>
        //             final receipt = Map<String, dynamic>.from(entry.value);
        //             final originalIndex = controller.availablePayments.indexWhere(
        //               (r) => r['reference_number'] == receipt['reference_number'],
        //             );
        //             return dataRowForTheTable(
        //               receipt,
        //               context,
        //               constraints,
        //               controller,
        //               originalIndex,
        //               isPayment,
        //             );
        //           })
        //           .toList()
        //     :
        controller.availableReceipts
            // .where((r) => r.isDeleted != true)
            .where(
              (r) => !controller.selectedAvailableReceipts.any(
                (sel) => (sel.jobId == r.jobId) && (sel.isDeleted != true) ,
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

DataRow dataRowForTheTable<T extends CashManagementBaseController>(
  CustomerInvoicesModel receiptData,
  BuildContext context,
  BoxConstraints constraints,
  T controller,
  int index,
  bool isPayment,
) {
  final isSelected = receiptData.isSelected;

  return DataRow(
    // each row reflects its own selection flag
    selected: isSelected,
    onSelectChanged: (value) {
      if (value != null) {
        isPayment
            ? controller.selectPayment(index, value)
            : controller.selectJobReceipt(receiptData.jobId, value);
      }
    },
    cells: [
      DataCell(Text(receiptData.invoiceNumber)),
      DataCell(Text(receiptData.notes)),
      DataCell(Text(textToDate(receiptData.invoiceDate))),
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
