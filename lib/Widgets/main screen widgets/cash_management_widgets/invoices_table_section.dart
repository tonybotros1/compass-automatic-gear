import 'package:datahubai/Controllers/Main%20screen%20controllers/cahs_management_base_controller.dart';
import 'package:datahubai/Models/ar%20receipts%20and%20ap%20payments/base_model_for_receipts_and_payments.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../../decimal_text_field.dart';
import '../../max_value_for_text_field.dart';
import '../auto_size_box.dart';

Widget invoicesTable<T extends CashManagementBaseController>({
  required BuildContext context,
  required BoxConstraints constraints,
  required bool isPayment,
  required T controller,
}) {
  return GetX<T>(
    builder: (controller) {
      return tableOfScreens(
        constraints: constraints,
        context: context,
        controller: controller,
        isPayment: isPayment,
      );
    },
  );
}

Widget tableOfScreens<T extends CashManagementBaseController>({
  required BoxConstraints constraints,
  required BuildContext context,
  required T controller,
  required bool isPayment,
}) {
  return DataTable(
    dataRowMaxHeight: 40,
    dataRowMinHeight: 30,
    columnSpacing: 5,
    horizontalMargin: horizontalMarginForTable,
    showBottomBorder: true,
    dataTextStyle: regTextStyle,
    headingTextStyle: fontStyleForTableHeader,
    sortColumnIndex: controller.sortColumnIndex.value,
    sortAscending: controller.isAscending.value,
    headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
    columns: [
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: ''),
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Invoice Number'),
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Note'),
      ),
      DataColumn(
        numeric: true,
        label: AutoSizedText(constraints: constraints, text: 'Invoice Amount'),
      ),
      DataColumn(
        numeric: true,
        label: AutoSizedText(constraints: constraints, text: 'Outsanding'),
      ),
      DataColumn(
        numeric: true,
        label: AutoSizedText(
          constraints: constraints,
          text: isPayment ? 'Amount Paid' : 'Amount Received',
        ),
      ),
    ],
    rows:
        // isPayment
        //     ? controller.selectedAvailablePayments
        //           // cast each LinkedMap to a Map<String, dynamic>
        //           .map((entry) => Map<String, dynamic>.from(entry))
        //           .toList()
        //           .asMap()
        //           .entries
        //           .map((e) {
        //             final receipt = e.value;
        //             // If you need the original index in the full list you can look it up,
        //             // otherwise just pass `e.key` as the index in this filtered list:
        //             final originalIndex = controller.selectedAvailablePayments
        //                 .indexWhere(
        //                   (r) =>
        //                       r['reference_number'] == receipt['reference_number'],
        //                 );
        //             final invoice = receipt['reference_number'] as String;
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
        // :
        controller.selectedAvailableReceipts
            .where((inv) => inv.isDeleted != true)
            .map((receipt) {
              // If you need the original index in the full list you can look it up,
              // otherwise just pass `e.key` as the index in this filtered list:
              final originalIndex = controller.selectedAvailableReceipts
                  .indexWhere((r) => r.jobId == receipt.jobId);
              return dataRowForTheTable(
                receipt,
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
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            deleteSection(context, controller, receiptData.jobId, isPayment),
          ],
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: receiptData.invoiceNumber,
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: receiptData.notes,
          formatDouble: false,
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: receiptData.invoiceAmount.toString(),
          formatDouble: true,
          isBold: true,
          color: Colors.blueGrey,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: receiptData.outstandingAmount.toString(),
          formatDouble: true,
          isBold: true,
          color: Colors.red,
        ),
      ),
      DataCell(
        controller.editingIndex.value == index
            ? SizedBox(
                width: double.infinity,
                child: TextField(
                  inputFormatters: [
                    DecimalTextInputFormatter(),
                    MaxValueInputFormatter(receiptData.invoiceAmount),
                  ],
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                  autofocus: true,
                  controller: TextEditingController(
                    text:
                        // isPayment
                        // ? receiptData['payment_amount']
                        // :
                        receiptData.receiptAmount.toString(),
                  ),
                  keyboardType: TextInputType.number,
                  onSubmitted: (value) {
                    final submittedValue = value.trim().isEmpty ? '0.0' : value;
                    isPayment
                        ? controller.finishEditingForPayments(
                            submittedValue,
                            index,
                          )
                        : controller.finishEditingForReceipts(
                            submittedValue,
                            index,
                          );
                  },
                  onTapOutside: (_) {
                    controller.editingIndex.value = -1;
                  },
                ),
              )
            : InkWell(
                onTap: () => controller.startEditing(index),
                child: SizedBox(
                  height: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: 10,
                    children: [
                      textForDataRowInTable(
                        isSelectable: false,
                        color: Colors.green,
                        isBold: true,
                        maxWidth: null,
                        text:
                            //  isPayment
                            //     ? receiptData['payment_amount']?.toString() ?? ''
                            //     :
                            receiptData.receiptAmount.toString(),
                      ),
                      Icon(Icons.edit_outlined, color: Colors.grey.shade700),
                    ],
                  ),
                ),
              ),
      ),
    ],
  );
}

Widget deleteSection<T extends CashManagementBaseController>(
  BuildContext context,
  T controller,
  String id,
  bool isPayment,
) {
  return IconButton(
    onPressed: () {
      isPayment
          ? controller.removeSelectedPayment(id)
          : controller.removeSelectedReceipt(id);
    },
    icon: const Icon(Icons.delete, color: Colors.red),
  );
}
