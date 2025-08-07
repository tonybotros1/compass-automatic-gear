import 'package:datahubai/Controllers/Main%20screen%20controllers/receiving_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../auto_size_box.dart';

Widget itemsSection({
  required BuildContext context,
  required BoxConstraints constraints,
  required String id,
}) {
  return Container(
    decoration: containerDecor,
    child: GetX<ReceivingController>(
      builder: (controller) {
        if (controller.loadingItems.value && controller.allItems.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: tableOfScreens(
            constraints: constraints,
            context: context,
            controller: controller,
            id: id,
          ),
        );
      },
    ),
  );
}

Widget tableOfScreens({
  required constraints,
  required context,
  required ReceivingController controller,
  required String id,
}) {
  // List data = controller.calculateTotals();

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: SizedBox(
      width: constraints.maxWidth - 17,
      child: DataTable(
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
            columnWidth: IntrinsicColumnWidth(flex: 1.5),
            label: AutoSizedText(constraints: constraints, text: 'Item Code'),
          ),
          DataColumn(
            columnWidth: IntrinsicColumnWidth(flex: 2),

            label: AutoSizedText(constraints: constraints, text: 'Item Name'),
          ),
          DataColumn(
            columnWidth: IntrinsicColumnWidth(flex: 1),

            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'Quantity'),
          ),
          DataColumn(
            columnWidth: IntrinsicColumnWidth(flex: 1),

            numeric: true,
            label: AutoSizedText(
              constraints: constraints,
              text: 'Orginal Price',
            ),
          ),
          DataColumn(
            columnWidth: IntrinsicColumnWidth(flex: 1),
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'Discount'),
          ),
          DataColumn(
            columnWidth: IntrinsicColumnWidth(flex: 1),
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'Add. Cost'),
          ),

          DataColumn(
            columnWidth: IntrinsicColumnWidth(flex: 1),
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'Add. Disc.'),
          ),
          DataColumn(
            columnWidth: IntrinsicColumnWidth(flex: 1),
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'Local Price'),
          ),
          DataColumn(
            columnWidth: IntrinsicColumnWidth(flex: 1),
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'Total'),
          ),
          DataColumn(
            columnWidth: IntrinsicColumnWidth(flex: 1),
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'VAT'),
          ),
          DataColumn(
            columnWidth: IntrinsicColumnWidth(flex: 1),
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'NET'),
          ),
        ],
        rows: [
          ...controller.allItems.map<DataRow>((invoiceItems) {
            final invoiceItemsData = invoiceItems.data();
            final invoiceItemsId = invoiceItems.id;
            return dataRowForTheTable(
              invoiceItemsData,
              context,
              constraints,
              invoiceItemsId,
              controller,
              id,
            );
          }),
          DataRow(
            selected: true,
            cells: [
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(
                Align(alignment: Alignment.centerRight, child: Text('Totals')),
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerRight,
                  child: textForDataRowInTable(
                    text: '', // '${data[0]}',
                    color: Colors.blue,
                  ),
                ),
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerRight,
                  child: textForDataRowInTable(
                    text: '', //'${data[1]}',
                    color: Colors.green,
                  ),
                ),
              ),
              DataCell(
                Align(
                  alignment: Alignment.centerRight,
                  child: textForDataRowInTable(
                    text: '', //'${data[2]}',
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

DataRow dataRowForTheTable(
  Map<String, dynamic> invoiceItemsData,
  context,
  constraints,
  String invoiceItemsId,
  ReceivingController controller,
  String jobId,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            deleteSection(jobId, context, controller, invoiceItemsId),
            editSection(
              jobId,
              controller,
              invoiceItemsData,
              context,
              constraints,
              invoiceItemsId,
            ),
          ],
        ),
      ),
      DataCell(Text('${invoiceItemsData['line_number'] ?? ''}')),
      DataCell(Text('${invoiceItemsData['line_number'] ?? ''}')),
      DataCell(Text('${invoiceItemsData['line_number'] ?? ''}')),
      DataCell(textForDataRowInTable(text: '', maxWidth: null)),
      DataCell(textForDataRowInTable(text: '${invoiceItemsData['quantity']}')),
      DataCell(textForDataRowInTable(text: '${invoiceItemsData['price']}')),
      DataCell(textForDataRowInTable(text: '${invoiceItemsData['amount']}')),
      DataCell(textForDataRowInTable(text: '${invoiceItemsData['discount']}')),
      DataCell(textForDataRowInTable(text: '${invoiceItemsData['total']}')),
      DataCell(textForDataRowInTable(text: '${invoiceItemsData['vat']}')),
      DataCell(textForDataRowInTable(text: '${invoiceItemsData['net']}')),
    ],
  );
}

Widget deleteSection(
  String jobId,
  context,
  ReceivingController controller,
  invoiceItemsId,
) {
  return IconButton(
    onPressed: () {
      // if (controller.jobStatus1.value == 'New') {
      //   alertDialog(
      //     context: context,
      //     controller: controller,
      //     content: 'This will be deleted permanently',
      //     onPressed: () {
      //       controller.deleteInvoiceItem(
      //         controller.curreentJobCardId.value != ''
      //             ? controller.curreentJobCardId.value
      //             : jobId,
      //         invoiceItemsId,
      //       );
      //     },
      //   );
      // } else {
      //   showSnackBar('Alert', 'Only New Jobs Allowed');
      // }
    },
    icon: const Icon(Icons.delete, color: Colors.red),
  );
}

Widget editSection(
  String jobId,
  ReceivingController controller,
  Map<String, dynamic> invoiceItemsData,
  context,
  constraints,
  String invoiceItemsId,
) {
  return IconButton(
    onPressed: () {
      // if (controller.jobStatus1.value == 'New') {
      //   controller.invoiceItemNameId.value = invoiceItemsData['name'];
      //   controller.invoiceItemName.text = controller.getdataName(
      //     invoiceItemsData['name'],
      //     controller.allInvoiceItemsFromCollection,
      //   );
      //   controller.lineNumber.text = (invoiceItemsData['line_number'] ?? '')
      //       .toString();
      //   controller.description.text = invoiceItemsData['description'];
      //   controller.quantity.text = invoiceItemsData['quantity'];
      //   controller.price.text = invoiceItemsData['price'];
      //   controller.amount.text = invoiceItemsData['amount'];
      //   controller.discount.text = invoiceItemsData['discount'];
      //   controller.total.text = invoiceItemsData['total'];
      //   controller.vat.text = invoiceItemsData['vat'];
      //   controller.net.text = invoiceItemsData['net'];
      //   invoiceItemsForJobDialog(
      //     jobId: jobId,
      //     controller: controller,
      //     constraints: constraints,
      //     onPressed: controller.addingNewinvoiceItemsValue.value
      //         ? null
      //         : () {
      //             controller.editInvoiceItem(
      //               controller.curreentJobCardId.value != ''
      //                   ? controller.curreentJobCardId.value
      //                   : jobId,
      //               invoiceItemsId,
      //             );
      //           },
      //   );
      // } else {
      //   showSnackBar('Alert', 'Only New Jobs Allowed');
      // }
    },
    icon: const Icon(Icons.edit_note_rounded, color: Colors.blue),
  );
}

ElevatedButton newinvoiceItemsButton(
  BuildContext context,
  BoxConstraints constraints,
  ReceivingController controller,
  String jobId,
) {
  return ElevatedButton(
    onPressed: () {
      // if (controller.canAddInternalNotesAndInvoiceItems.isTrue) {
      //   if (controller.jobStatus1.value == 'New') {
      //     controller.clearInvoiceItemsVariables();

      //     invoiceItemsForJobDialog(
      //       jobId: jobId,
      //       controller: controller,
      //       constraints: constraints,
      //       onPressed: controller.addingNewinvoiceItemsValue.value
      //           ? null
      //           : () async {
      //               controller.addNewInvoiceItem(
      //                 jobId != '' ? jobId : controller.curreentJobCardId.value,
      //               );
      //             },
      //     );
      //   } else {
      //     showSnackBar('Alert', 'Only New Jobs Allowed');
      //   }
      // } else {
      //   showSnackBar('Alert', 'Please Save Job First');
      // }
    },
    style: new2ButtonStyle,
    child: const Text(
      'New item',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}
