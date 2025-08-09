import 'package:datahubai/Controllers/Main%20screen%20controllers/receiving_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../consts.dart';
import '../auto_size_box.dart';
import 'items_dialog.dart';

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
            final receivingItemsData = invoiceItems.data();
            final invoiceItemsId = invoiceItems.id;
            final itemsData = controller.getInventeryItemsData(
              id: receivingItemsData['code'],
            );
            print(itemsData);
            return dataRowForTheTable(
              receivingItemsData,
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
  Map<String, dynamic> receivingItemsData,
  context,
  constraints,
  String invoiceItemsId,
  ReceivingController controller,
  String id,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            deleteSection(id, context, controller, invoiceItemsId),
            editSection(
              id,
              controller,
              receivingItemsData,
              context,
              constraints,
              invoiceItemsId,
            ),
          ],
        ),
      ),
      DataCell(textForDataRowInTable(text: '')),
      DataCell(
        textForDataRowInTable(
          text: '${receivingItemsData['line_number'] ?? ''}',
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: '${receivingItemsData['line_number'] ?? ''}',
        ),
      ),
      DataCell(textForDataRowInTable(text: '', maxWidth: null)),
      DataCell(
        textForDataRowInTable(text: '${receivingItemsData['quantity']}'),
      ),
      DataCell(textForDataRowInTable(text: '${receivingItemsData['price']}')),
      DataCell(textForDataRowInTable(text: '${receivingItemsData['amount']}')),
      DataCell(
        textForDataRowInTable(text: '${receivingItemsData['discount']}'),
      ),
      DataCell(textForDataRowInTable(text: '${receivingItemsData['total']}')),
      DataCell(textForDataRowInTable(text: '${receivingItemsData['vat']}')),
      DataCell(textForDataRowInTable(text: '${receivingItemsData['net']}')),
    ],
  );
}

Widget deleteSection(
  String id,
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
      //             : id,
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
  String id,
  ReceivingController controller,
  Map<String, dynamic> receivingItemsData,
  context,
  constraints,
  String invoiceItemsId,
) {
  return IconButton(
    onPressed: () {
      // if (controller.jobStatus1.value == 'New') {
      //   controller.invoiceItemNameId.value = receivingItemsData['name'];
      //   controller.invoiceItemName.text = controller.getdataName(
      //     receivingItemsData['name'],
      //     controller.allInvoiceItemsFromCollection,
      //   );
      //   controller.lineNumber.text = (receivingItemsData['line_number'] ?? '')
      //       .toString();
      //   controller.description.text = receivingItemsData['description'];
      //   controller.quantity.text = receivingItemsData['quantity'];
      //   controller.price.text = receivingItemsData['price'];
      //   controller.amount.text = receivingItemsData['amount'];
      //   controller.discount.text = receivingItemsData['discount'];
      //   controller.total.text = receivingItemsData['total'];
      //   controller.vat.text = receivingItemsData['vat'];
      //   controller.net.text = receivingItemsData['net'];
      //   invoiceItemsForJobDialog(
      //     id: id,
      //     controller: controller,
      //     constraints: constraints,
      //     onPressed: controller.addingNewinvoiceItemsValue.value
      //         ? null
      //         : () {
      //             controller.editInvoiceItem(
      //               controller.curreentJobCardId.value != ''
      //                   ? controller.curreentJobCardId.value
      //                   : id,
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

ElevatedButton newItemButton(
  BuildContext context,
  BoxConstraints constraints,
  ReceivingController controller,
  String id,
) {
  return ElevatedButton(
    onPressed: () {
      if (controller.canAddItems.isTrue) {
        if (controller.status.value == 'New') {
          controller.clearItemsValues();

          itemsDialog(
            id: id,
            controller: controller,
            constraints: constraints,
            onPressed: controller.addingNewItemsValue.isTrue
                ? null
                : () async {
                    controller.addNewItem(
                      id != '' ? id : controller.curreentReceivingId.value,
                    );
                  },
          );
        } else {
          showSnackBar('Alert', 'Only New Docs Allowed');
        }
      } else {
        showSnackBar('Alert', 'Please Save Docs First');
      }
    },
    style: new2ButtonStyle,
    child: const Text('New item'),
  );
}
