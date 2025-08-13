import 'package:datahubai/Controllers/Main%20screen%20controllers/receiving_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Models/receiving_items_model.dart';
import '../../../Models/receiving_items_model_for_table.dart';
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
            label: AutoSizedText(constraints: constraints, text: 'Price'),
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
            // final receivingItemsData = invoiceItems.data();
            final invoiceItemsId = invoiceItems.id;
            // final itemsData = controller.getInventeryItemsData(
            //   id: receivingItemsData['code'],
            // );
            // print(itemsData);

            ReceivingItemsModel data = ReceivingItemsModel(
              handling: double.tryParse(controller.handling.value.text) ?? 0,
              shipping: double.tryParse(controller.shipping.value.text) ?? 0,
              other: double.tryParse(controller.other.value.text) ?? 0,
              discount: invoiceItems.discount,
              orginalPrice: invoiceItems.originalPrice,
              quantity: invoiceItems.quantity,
              rate: double.tryParse(controller.rate.value.text) ?? 1,
              totalForAllItems: controller.itemsTotal.value,
              vat: invoiceItems.vat,
              amount: double.tryParse(controller.amount.value.text) ?? 0,
            );
            return dataRowForTheTable(
              data,
              invoiceItems,
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
               DataCell(
                textForDataRowInTable(text:  'Totals',isBold: true),
              ),
              DataCell(
                textForDataRowInTable(
                  text: '${controller.finalItemsTotal.value}', // '${data[0]}',
                  color: Colors.green,
                  isBold: true,
                ),
              ),
              DataCell(
                textForDataRowInTable(
                  text: '${controller.finalItemsVAT.value}', //'${data[1]}',
                  color: Colors.blue,
                  isBold: true,
                ),
              ),
              DataCell(
                textForDataRowInTable(
                  text: '${controller.finalItemsNet.value}', //'${data[2]}',
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
  ItemModel receivingItemsData,
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
      DataCell(
        FutureBuilder<String>(
          future: controller.getInventeryItemsCode(
            id: receivingItemsData.code,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            } else if (snapshot.hasError) {
              return const Text('');
            } else {
              return textForDataRowInTable(text: '${snapshot.data}');
            }
          },
        ),
      ),
      DataCell(
        FutureBuilder<String>(
          future: controller.getInventeryItemsName(
            id: receivingItemsData.code,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...');
            } else if (snapshot.hasError) {
              return const Text('');
            } else {
              return textForDataRowInTable(text: '${snapshot.data}');
            }
          },
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: '${data.quantity}',
          color: Colors.deepOrangeAccent,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: '${data.orginalPrice}',
          color: Colors.deepPurpleAccent,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: '${data.discount}',
          color: Colors.redAccent,
          isBold: true,
        ),
      ),
      DataCell(textForDataRowInTable(text: '${data.addCost}')),
      DataCell(textForDataRowInTable(text: '${data.addDisc}')),
      DataCell(textForDataRowInTable(text: '${data.localPrice}')),
      DataCell(textForDataRowInTable(text: '${data.total}')),
      DataCell(
        textForDataRowInTable(
          text: '${data.vat}',
          color: Colors.blueGrey,
          isBold: true,
        ),
      ),
      DataCell(textForDataRowInTable(text: '${data.net}')),
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
      if (controller.status.value == 'New') {
        alertDialog(
          context: context,

          content: 'This will be deleted permanently',
          onPressed: () {
            controller.deleteItem(
              controller.curreentReceivingId.value != ''
                  ? controller.curreentReceivingId.value
                  : id,
              invoiceItemsId,
            );
          },
        );
      } else {
        showSnackBar('Alert', 'Only New Jobs Allowed');
      }
    },
    icon: const Icon(Icons.delete, color: Colors.red),
  );
}

Widget editSection(
  String id,
  ReceivingController controller,
  ItemModel receivingItemsData,
  context,
  constraints,
  String itemsId,
) {
  return IconButton(
    onPressed: () async {
      if (controller.status.value == 'New') {
        controller.getInventeryItemsCode(id: receivingItemsData.code).then((
          value,
        ) {
          controller.itemCode.value.text = value;
        });
        controller.getInventeryItemsName(id: receivingItemsData.code).then((
          value,
        ) {
          controller.itemName.value.text = value;
        });
        controller.quantity.value.text = receivingItemsData.quantity
            .toString();
        controller.orginalPrice.value.text = receivingItemsData.originalPrice
            .toString();
        controller.discount.value.text = receivingItemsData.discount
            .toString();
        controller.vat.value.text = receivingItemsData.vat.toString();
        itemsDialog(
          id: id,
          controller: controller,
          constraints: constraints,
          onPressed: controller.addingNewItemsValue.value
              ? null
              : () {
                  controller.editItem(
                    controller.curreentReceivingId.value != ''
                        ? controller.curreentReceivingId.value
                        : id,
                    itemsId,
                    // mode: 'edit',
                  );
                },
        );
      } else {
        showSnackBar('Alert', 'Only New Jobs Allowed');
      }
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
                    await controller.addNewItem(
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
