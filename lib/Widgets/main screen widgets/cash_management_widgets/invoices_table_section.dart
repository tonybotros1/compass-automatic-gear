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
}) {
  return GetX<CashManagementController>(
    builder: (controller) {
      return SizedBox(
        height: controller.selectedAvailableReceipts.isEmpty ? 100 : null,
        child: tableOfScreens(
          constraints: constraints,
          context: context,
          controller: controller,
        ),
      );
    },
  );
}

Widget tableOfScreens({
  required constraints,
  required context,
  required CashManagementController controller,
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
          text: 'Amount Received',
        ),
      ),
    ],
    rows: controller.selectedAvailableReceipts
        // cast each LinkedMap to a Map<String, dynamic>
        .map((entry) => Map<String, dynamic>.from(entry))
        .toList()
        .asMap()
        .entries
        .map((e) {
      final receipt = e.value;
      // If you need the original index in the full list you can look it up,
      // otherwise just pass `e.key` as the index in this filtered list:
      final originalIndex = controller.selectedAvailableReceipts
          .indexWhere((r) => r['invoice_number'] == receipt['invoice_number']);
      final invoice = receipt['invoice_number'] as String;
      return dataRowForTheTable(
          receipt, context, constraints, controller, originalIndex, invoice);
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
) {
  return DataRow(cells: [
    DataCell(Row(
      children: [
        deleteSection(context, controller, invoiceNumber),
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
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
                autofocus: true,
                controller: TextEditingController(
                    text: receiptData['receipt_amount']?.toString()),
                keyboardType: TextInputType.number,
                onSubmitted: (value) {
                  final submittedValue = value.trim().isEmpty ? '0.0' : value;
                  controller.finishEditing(submittedValue, index);
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
                   text:   receiptData['receipt_amount']?.toString() ?? ''),
              ),
            ),
    ),
  ]);
}

Widget deleteSection(
    context, CashManagementController controller, String invoiceNumber) {
  return IconButton(
      onPressed: () {
        controller.removeSelectedReceipt(invoiceNumber);
      },
      icon: const Icon(
        Icons.delete,
        color: Colors.red,
      ));
}
