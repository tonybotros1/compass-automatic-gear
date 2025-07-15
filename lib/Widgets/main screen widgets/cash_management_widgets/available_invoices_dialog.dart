import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/cash_management_controller.dart';
import '../../../consts.dart';
import '../auto_size_box.dart';

Widget availableInvoicesDialog(
  BoxConstraints constraints,
  BuildContext context,
  bool isPayment,
  RxList<dynamic> availableList,
  RxList<dynamic> selectedAvailableList,
) {
  return SizedBox(
    width: constraints.maxWidth / 1.1,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: GetX<CashManagementController>(builder: (controller) {
        if (controller.loadingInvoices.isTrue && availableList.isEmpty) {
          return Center(child: loadingProcess);
        }
        return tableOfScreens(
            constraints: constraints,
            context: context,
            controller: controller,
            isPayment: isPayment,
            availableList: availableList,
            selectedAvailableList: selectedAvailableList);
      }),
    ),
  );
}

Widget tableOfScreens({
  required BoxConstraints constraints,
  required BuildContext context,
  required CashManagementController controller,
  required bool isPayment,
  required RxList<dynamic> availableList,
  required RxList<dynamic> selectedAvailableList,
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

    // **NEW**: select/deselect *all* rows
    onSelectAll: (allSelected) {
      if (allSelected != null) {
        isPayment
            ? controller.selectAllPayments(allSelected)
            : controller.selectAllJobReceipts(allSelected);
      }
    },

    columns: [
      DataColumn(
          label:
              AutoSizedText(constraints: constraints, text: 'Invoice Number')),
      DataColumn(label: AutoSizedText(constraints: constraints, text: 'Note')),
      DataColumn(
          label: AutoSizedText(constraints: constraints, text: 'Invoice Date')),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Invoice Amount'),
        numeric: true,
      ),
      DataColumn(
        label:
            AutoSizedText(constraints: constraints, text: 'Outstanding Amount'),
        numeric: true,
      ),
    ],

    rows: availableList
        // filter out already‐selected receipts
        .where((r) => !selectedAvailableList
            .any((sel) => sel['invoice_number'] == r['invoice_number']))
        .toList()
        // re‐index the filtered list
        .asMap()
        .entries
        .map((entry) {
      // cast each entry to Map<String,dynamic>
      final receipt = Map<String, dynamic>.from(entry.value);
      final originalIndex = availableList
          .indexWhere((r) => r['invoice_number'] == receipt['invoice_number']);
      return dataRowForTheTable(
          receipt, context, constraints, controller, originalIndex, isPayment);
    }).toList(),
  );
}

DataRow dataRowForTheTable(
    Map<String, dynamic> receiptData,
    BuildContext context,
    BoxConstraints constraints,
    CashManagementController controller,
    int index,
    bool isPayment) {
  final isSelected = receiptData['is_selected'] as bool? ?? false;

  return DataRow(
    // each row reflects its own selection flag
    selected: isSelected,
    onSelectChanged: (value) {
      if (value != null) {
        isPayment
            ? controller.selectPayment(index, value)
            : controller.selectJobReceipt(index, value);
      }
    },
    cells: [
      DataCell(Text(receiptData['invoice_number'] ?? '')),
      DataCell(Text(receiptData['notes'] ?? '')),
      DataCell(Text(textToDate(receiptData['invoice_date'] ?? ''))),
      DataCell(
        Align(
          alignment: Alignment.centerRight,
          child: textForDataRowInTable(
            text: receiptData['invoice_amount']?.toString() ?? '',
          ),
        ),
      ),
      DataCell(
        Align(
          alignment: Alignment.centerRight,
          child: textForDataRowInTable(
            text: receiptData['outstanding_amount']?.toString() ?? '',
          ),
        ),
      ),
    ],
  );
}


  // controller.loadingInvoices.isFalse
  //             ? CustomScrollView(
  //                 slivers: [
  //                   SliverToBoxAdapter(
  //                     child: Padding(
  //                       padding: const EdgeInsets.symmetric(horizontal: 8),
  //                       child: buildCustomTableHeader(
  //                         prefix: CupertinoCheckbox(
  //                             value: controller.isAllJobReceiptsSelected.value,
  //                             onChanged: controller.availableReceipts.isEmpty
  //                                 ? null
  //                                 : (value) {
  //                                     controller.selectAllJobReceipts(value!);
  //                                   }),
  //                         cellConfigs: [
  //                           TableCellConfig(label: 'Invoice Number'),
  //                           TableCellConfig(label: 'Invoice Date'),
  //                           TableCellConfig(label: 'Invoice Amount'),
  //                           TableCellConfig(label: 'Outsanding Amount'),
  //                           TableCellConfig(label: 'Note', flex: 5),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   SliverFillRemaining(
  //                     child: Container(
  //                         width: double.infinity,
  //                         padding: EdgeInsets.all(8),
  //                         constraints: BoxConstraints(
  //                           minHeight: 100,
  //                         ),
  //                         decoration: BoxDecoration(
  //                           border: Border.all(color: secColor, width: 2),
  //                           // color: Color.fromARGB(255, 202, 204, 202),
  //                           borderRadius: BorderRadius.circular(5),
  //                         ),
  //                         child: SingleChildScrollView(
  //                           child: Column(
  //                             children: controller.availableReceipts
  //                                 .where((availableReceipt) => !controller
  //                                     .selectedAvailableReceipts
  //                                     .any((selected) =>
  //                                         selected['invoice_number'] ==
  //                                         availableReceipt['invoice_number']))
  //                                 .toList()
  //                                 .asMap()
  //                                 .entries
  //                                 .map((entry) {
  //                               final receipt = entry.value;
  //                               // find the original index in availableReceipts
  //                               final originalIndex = controller
  //                                   .availableReceipts
  //                                   .indexWhere((r) =>
  //                                       r['invoice_number'] ==
  //                                       receipt['invoice_number']);
  //                               return buildCustomRow(
  //                                 prefix: GetBuilder<CashManagementController>(
  //                                     builder: (controller) {
  //                                   return CupertinoCheckbox(
  //                                     value: receipt['is_selected'],
  //                                     onChanged: (value) {
  //                                       controller.selectJobReceipt(
  //                                           originalIndex, value!);
  //                                     },
  //                                   );
  //                                 }),
  //                                 cellConfigs: [
  //                                   RowCellConfig(
  //                                     initialValue: receipt['invoice_number'],
  //                                     flex: 1,
  //                                     isEnabled: false,
  //                                   ),
  //                                   RowCellConfig(
  //                                     initialValue:
  //                                         textToDate(receipt['invoice_date']),
  //                                     flex: 1,
  //                                     isEnabled: false,
  //                                   ),
  //                                   RowCellConfig(
  //                                     initialValue:
  //                                         receipt['invoice_amount'].toString(),
  //                                     flex: 1,
  //                                     isEnabled: false,
  //                                   ),
  //                                   RowCellConfig(
  //                                     initialValue:
  //                                         receipt['outstanding_amount']
  //                                             .toString(),
  //                                     flex: 1,
  //                                     isEnabled: false,
  //                                   ),
  //                                   RowCellConfig(
  //                                     initialValue: receipt['notes'],
  //                                     flex: 5,
  //                                     isEnabled: false,
  //                                   ),
  //                                 ],
  //                               );
  //                             }).toList(),
  //                           ),
  //                         )),
  //                   )
  //                 ],
  //               )