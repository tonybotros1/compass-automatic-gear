import 'package:datahubai/Controllers/Main%20screen%20controllers/receiving_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Models/receiving/receiving_items_model.dart';
import '../../../consts.dart';
import '../auto_size_box.dart';
import 'items_dialog.dart';

Widget itemsSection({
  required BuildContext context,
  required BoxConstraints constraints,
}) {
  return Container(
    decoration: containerDecor,
    child: GetX<ReceivingController>(
      builder: (controller) {
        if (controller.loadingItems.value &&
            controller.allReceivingItems.isEmpty) {
          return Center(child: loadingProcess);
        }

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: tableOfScreens(
            constraints: constraints,
            context: context,
            controller: controller,
          ),
        );
      },
    ),
  );
}

Widget tableOfScreens({
  required BoxConstraints constraints,
  required BuildContext context,
  required ReceivingController controller,
}) {
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
            columnWidth: const IntrinsicColumnWidth(flex: 1.5),
            label: AutoSizedText(constraints: constraints, text: 'Item Code'),
          ),
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 2),

            label: AutoSizedText(constraints: constraints, text: 'Item Name'),
          ),
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 1),

            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'Quantity'),
          ),
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 1),

            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'Price'),
          ),
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 1),
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'Discount'),
          ),
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 1),
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'Add. Cost'),
          ),

          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 1),
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'Add. Disc.'),
          ),
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 1),
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'Local Price'),
          ),
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 1),
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'Total'),
          ),
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 1),
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'VAT'),
          ),
          DataColumn(
            columnWidth: const IntrinsicColumnWidth(flex: 1),
            numeric: true,
            label: AutoSizedText(constraints: constraints, text: 'NET'),
          ),
        ],
        rows: [
          ...controller.allReceivingItems
              .where((item) => item.isDeleted != true)
              .map<DataRow>((invoiceItems) {
                final invoiceItemsId =
                    invoiceItems.id ?? invoiceItems.uuid ?? '';

                return dataRowForTheTable(
                  invoiceItems,
                  context,
                  constraints,
                  invoiceItemsId,
                  controller,
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
              DataCell(textForDataRowInTable(text: 'Totals', isBold: true)),
              DataCell(
                textForDataRowInTable(
                  text: '${controller.finalItemsTotal.value}',
                  color: Colors.green,
                  isBold: true,
                ),
              ),
              DataCell(
                textForDataRowInTable(
                  text: '${controller.finalItemsVAT.value}',
                  color: Colors.blue,
                  isBold: true,
                ),
              ),
              DataCell(
                textForDataRowInTable(
                  text: '${controller.finalItemsNet.value}',
                  color: Colors.red,
                  isBold: true,
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
  ReceivingItemsModel data,
  BuildContext context,
  BoxConstraints constraints,
  String invoiceItemsId,
  ReceivingController controller,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            deleteSection(context, controller, invoiceItemsId),
            editSection(controller, context, constraints, data, invoiceItemsId),
          ],
        ),
      ),
      DataCell(textForDataRowInTable(text: data.itemCode ?? '')),
      DataCell(textForDataRowInTable(text: data.itemName ?? '')),

      DataCell(
        textForDataRowInTable(
          text: '${data.quantity ?? ''}',
          color: Colors.deepOrangeAccent,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: '${data.originalPrice ?? ''}',
          color: Colors.deepPurpleAccent,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: '${data.discount ?? ''}',
          color: Colors.redAccent,
          isBold: true,
        ),
      ),
      DataCell(textForDataRowInTable(text: '${data.addCost ?? ""}')),
      DataCell(textForDataRowInTable(text: '${data.addDisc ?? ''}')),
      DataCell(textForDataRowInTable(text: '${data.localPrice ?? ''}')),
      DataCell(textForDataRowInTable(text: '${data.total ?? ''}')),
      DataCell(
        textForDataRowInTable(
          text: '${data.vat}',
          color: Colors.blueGrey,
          isBold: true,
        ),
      ),
      DataCell(textForDataRowInTable(text: '${data.net ?? ''}')),
    ],
  );
}

Widget deleteSection(
  BuildContext context,
  ReceivingController controller,
  String invoiceItemsId,
) {
  return IconButton(
    onPressed: () {
      if (controller.status.value == 'New' || controller.status.isEmpty) {
        alertDialog(
          context: context,

          content: 'This will be deleted permanently',
          onPressed: () {
            controller.deleteItem(invoiceItemsId);
          },
        );
      } else {
        showSnackBar('Alert', 'Only New Receiving Allowed');
      }
    },
    icon: const Icon(Icons.delete, color: Colors.red),
  );
}

Widget editSection(
  ReceivingController controller,
  BuildContext context,
  BoxConstraints constraints,
  ReceivingItemsModel data,
  String invoiceItemsId,
) {
  return IconButton(
    onPressed: () async {
      if (controller.curreentReceivingId.value.isNotEmpty) {
        Map recStatus = await controller.getCurrentReceivingStatus(
          controller.curreentReceivingId.value,
        );

        String status1 = recStatus['status'];
        if (status1 != 'New') {
          showSnackBar('Alert', 'Only New Receiving Docs Allowd');
          return;
        }
      }
      controller.itemCode.value.text = data.itemCode ?? '';
      controller.itemName.value.text = data.itemName ?? '';
      controller.selectedInventeryItemID.value = data.inventoryItemId ?? '';
      controller.quantity.value.text = data.quantity.toString();
      controller.orginalPrice.value.text = data.originalPrice.toString();
      controller.discount.value.text = data.discount.toString();
      controller.vat.value.text = data.vat.toString();
      itemsDialog(
        controller: controller,
        constraints: constraints,
        onPressed: () {
          controller.editItem(invoiceItemsId);
        },
      );
    },
    icon: const Icon(Icons.edit_note_rounded, color: Colors.blue),
  );
}

ElevatedButton newItemButton(
  BuildContext context,
  BoxConstraints constraints,
  ReceivingController controller,
) {
  return ElevatedButton(
    onPressed: () async {
      if (controller.curreentReceivingId.value.isNotEmpty) {
        Map recStatus = await controller.getCurrentReceivingStatus(
          controller.curreentReceivingId.value,
        );

        String status1 = recStatus['status'];
        if (status1 != 'New') {
          showSnackBar('Alert', 'Only New Receiving Docs Allowd');
          return;
        }
      }
      controller.clearItemsValues();
      itemsDialog(
        controller: controller,
        constraints: constraints,
        onPressed: () {
          controller.addNewItem();
        },
      );
    },
    style: new2ButtonStyle,
    child: const Text('New item'),
  );
}
