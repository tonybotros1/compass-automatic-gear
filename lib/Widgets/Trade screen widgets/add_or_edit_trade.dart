import 'package:datahubai/Models/tabel_row_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import '../../Controllers/Trading Controllers/car_trading_controller.dart';
import '../../Models/tabel_cell_model.dart';
import '../../consts.dart';
import '../tabel_widgets/build_tabel.dart';
import 'car_information_section.dart';
import 'item_dialog.dart';

Widget addNewTradeOrEdit({
  required BuildContext context,
  required CarTradingController controller,
  required bool canEdit,
  required BoxConstraints constraints,
}) {
  return Column(
    children: [
      Expanded(
        child: CustomScrollView(
          physics: NeverScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  labelContainer(
                      lable: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Car Information',
                        style: fontStyle1,
                      ),
                      ElevatedButton(
                          style: new2ButtonStyle,
                          onPressed: () {
                            controller.changeStatus(
                                controller.currentTradId.value, 'New');
                            controller.status.value = 'New';
                          },
                          child: Text(
                            'Change Status To New',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ))
                    ],
                  )),
                  carInformation(context: context, constraints: constraints),
                  const SizedBox(
                    height: 10,
                  ),
                  labelContainer(
                      lable: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Items',
                        style: fontStyle1,
                      ),
                      ElevatedButton(
                          style: new2ButtonStyle,
                          onPressed: () {
                            controller.item.clear();
                            controller.itemId.value = '';
                            controller.pay.text = '0';
                            controller.receive.text = '0';
                            controller.comments.value.text = '';
                            itemDialog(
                                controller: controller,
                                canEdit: true,
                                onPressed: () {
                                  if (controller.item.value.text.isEmpty ||
                                      controller.pay.value.text.isEmpty ||
                                      controller.receive.value.text.isEmpty ||
                                      controller.comments.value.text.isEmpty) {
                                    showSnackBar(
                                        'Alert', 'Please fill all fields');
                                  } else {
                                    controller.addNewItem();
                                  }
                                });
                          },
                          child: Text(
                            'Add Item',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                    ],
                  )),
                ],
              ),
            ),
            SliverFillRemaining(
              // Tell the sliver that its child DOES provide its own scrolling.
              hasScrollBody: true,
              child: Container(
                decoration: containerDecor,
                child: Column(
                  // spacing: 10,
                  children: [
                    SizedBox(
                      height: 1,
                    ),
                    buildCustomTableHeader(
                      suffix: TextButton(onPressed: () {}, child: SizedBox()),
                      cellConfigs: [
                        TableCellConfig(label: 'Date'),
                        TableCellConfig(label: 'Item'),
                        TableCellConfig(label: 'Paid'),
                        TableCellConfig(label: 'Received'),
                        TableCellConfig(label: 'Comments', flex: 5),
                      ],
                    ),
                    Expanded(
                      child: GetX<CarTradingController>(
                        builder: (controller) {
                          return Scrollbar(
                            thumbVisibility: true,
                            controller: controller.scrollController,
                            child: SingleChildScrollView(
                              controller: controller.scrollController,
                              child: Column(
                                children: List.generate(
                                  controller.addedItems.length,
                                  (i) => Column(
                                    children: [
                                      KeyedSubtree(
                                        key: ValueKey(controller.addedItems[i]),
                                        child: buildCustomRow(
                                          suffix: TextButton(
                                              onPressed: () {
                                                controller.addedItems
                                                    .removeAt(i);
                                                controller.calculateTotals();
                                              },
                                              child: Text('Delete')),
                                          cellConfigs: [
                                            RowCellConfig(
                                                initialValue: controller
                                                    .addedItems[i]['date']),
                                            RowCellConfig(
                                              initialValue:
                                                  controller.getdataName(
                                                controller.addedItems[i]
                                                    ['item'],
                                                controller.allItems,
                                              ),
                                            ),
                                            RowCellConfig(
                                                initialValue: controller
                                                    .addedItems[i]['pay'],
                                                tabelCellAlign: TextAlign.end),
                                            RowCellConfig(
                                                initialValue: controller
                                                    .addedItems[i]['receive'],
                                                tabelCellAlign: TextAlign.end),
                                            RowCellConfig(
                                              initialValue: controller
                                                  .addedItems[i]['comment'],
                                              flex: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.black,
                                        thickness: 0.5,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: GetX<CarTradingController>(builder: (controller) {
          return buildCustomTableFooter(
            suffix: TextButton(onPressed: () {}, child: SizedBox()),
            cellConfigs: [
              TableCellConfig(label: ''),
              TableCellConfig(
                  label: 'Totals', textAlignment: Alignment.centerRight),
              TableCellConfig(
                  label: '${controller.totalPays.value}',
                  hasBorder: true,
                  textAlignment: Alignment.centerRight),
              TableCellConfig(
                  label: '${controller.totalReceives}',
                  hasBorder: true,
                  textAlignment: Alignment.centerRight),
              TableCellConfig(label: '', flex: 5),
            ],
          );
        }),
      ),
      GetX<CarTradingController>(builder: (controller) {
        return buildCustomTableFooter(
          suffix: TextButton(onPressed: () {}, child: SizedBox()),
          cellConfigs: [
            TableCellConfig(label: ''),
            TableCellConfig(label: 'NET', textAlignment: Alignment.centerRight),
            TableCellConfig(
                label: '${controller.totalNETs.value}',
                hasBorder: true,
                textAlignment: Alignment.centerRight),
            TableCellConfig(
              label: '',
            ),
            TableCellConfig(label: '', flex: 5),
          ],
        );
      }),
    ],
  );
}
