import 'package:datahubai/Controllers/Main%20screen%20controllers/cash_management_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../consts.dart';
import '../../decimal_text_field.dart';
import '../../max_value_for_text_field.dart';
import '../auto_size_box.dart';

Widget invoicesTable({
  required BuildContext context,
  required BoxConstraints constraints,
  required bool isPayment,
  required RxList list,
}) {
  return GetX<CashManagementController>(
    builder: (controller) {
      return SizedBox(
        height: list.isEmpty ? 100 : null,
        child: tableOfScreens(
            constraints: constraints,
            context: context,
            controller: controller,
            isPayment: isPayment,
            list: list),
      );
    },
  );
}

Widget tableOfScreens({
  required constraints,
  required context,
  required CashManagementController controller,
  required bool isPayment,
  required RxList list,
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
        label: AutoSizedText(
          constraints: constraints,
          text: '',
        ),
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Invoice Number',
        ),
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Note',
        ),
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.end,
        label: AutoSizedText(
          constraints: constraints,
          text: 'Invoice Amount',
        ),
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.end,
        label: AutoSizedText(
          constraints: constraints,
          text: 'Outsanding',
        ),
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.end,
        label: AutoSizedText(
          constraints: constraints,
          text: isPayment ? 'Amount Paid' : 'Amount Received',
        ),
      ),
    ],
    rows: isPayment
        ? list
            // cast each LinkedMap to a Map<String, dynamic>
            .map((entry) => Map<String, dynamic>.from(entry))
            .toList()
            .asMap()
            .entries
            .map((e) {
            final receipt = e.value;
            // If you need the original index in the full list you can look it up,
            // otherwise just pass `e.key` as the index in this filtered list:
            final originalIndex = list.indexWhere(
                (r) => r['reference_number'] == receipt['reference_number']);
            final invoice = receipt['reference_number'] as String;
            return dataRowForTheTable(receipt, context, constraints, controller,
                originalIndex, invoice, isPayment);
          }).toList()
        : list
            // cast each LinkedMap to a Map<String, dynamic>
            .map((entry) => Map<String, dynamic>.from(entry))
            .toList()
            .asMap()
            .entries
            .map((e) {
            final receipt = e.value;
            // If you need the original index in the full list you can look it up,
            // otherwise just pass `e.key` as the index in this filtered list:
            final originalIndex = list.indexWhere(
                (r) => r['invoice_number'] == receipt['invoice_number']);
            final invoice = receipt['invoice_number'] as String;
            return dataRowForTheTable(receipt, context, constraints, controller,
                originalIndex, invoice, isPayment);
          }).toList(),
  );
}

DataRow dataRowForTheTable(
  Map<String, dynamic> receiptData,
  context,
  constraints,
  CashManagementController controller,
  int index,
  String invoiceNumber,
  bool isPayment,
) {
  return DataRow(cells: [
    DataCell(Row(
      children: [
        deleteSection(context, controller, invoiceNumber, isPayment),
      ],
    )),
    DataCell(Text(receiptData['invoice_number'] ?? '')),
    DataCell(Text(receiptData['notes'])),
    DataCell(Align(
        alignment: Alignment.centerRight,
        child:
            textForDataRowInTable(text: receiptData['invoice_amount'] ?? ''))),
    DataCell(Align(
        alignment: Alignment.centerRight,
        child: textForDataRowInTable(text: receiptData['outstanding_amount']))),
    DataCell(
      controller.editingIndex.value == index
          ? SizedBox(
              width: double.infinity,
              child: TextField(
                inputFormatters: [
                  DecimalTextInputFormatter(),
                  MaxValueInputFormatter(
                      double.parse(receiptData['invoice_amount'] ?? 0.0))
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
                    text: isPayment
                        ? receiptData['payment_amount']
                        : receiptData['receipt_amount']?.toString()),
                keyboardType: TextInputType.number,
                onSubmitted: (value) {
                  final submittedValue = value.trim().isEmpty ? '0.0' : value;
                  isPayment
                      ? controller.finishEditingForPayments(
                          submittedValue, index)
                      : controller.finishEditingForReceipts(
                          submittedValue, index);
                },
                onTapOutside: (_) {
                  // revert back to the original value by cancelling the edit
                  controller.editingIndex.value = -1;
                },
              ),
            )
          : InkWell(
              onTap: () => controller.startEditing(index),
              child: Align(
                alignment: Alignment.centerRight,
                child: textForDataRowInTable(
                    isSelectable: false,
                    text: isPayment
                        ? receiptData['payment_amount']?.toString() ?? ''
                        : receiptData['receipt_amount']?.toString() ?? ''),
              ),
            ),
    ),
  ]);
}

Widget deleteSection(context, CashManagementController controller,
    String invoiceNumber, bool isPayment) {
  return IconButton(
      onPressed: () {
        isPayment
            ? controller.removeSelectedPayment(invoiceNumber)
            : controller.removeSelectedReceipt(invoiceNumber);
      },
      icon: const Icon(
        Icons.delete,
        color: Colors.red,
      ));
}
