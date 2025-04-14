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
                      lable: Text(
                    'Car Information',
                    style: fontStyle1,
                  )),
                  carInformation(context: context),
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
                            itemDialog(
                                controller: controller,
                                canEdit: true,
                                onPressed: () {
                                  if (!controller.formKeyForAddingNewItemvalue
                                      .currentState!
                                      .validate()) {
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
              hasScrollBody: false,
              child: Container(
                // padding: const EdgeInsets.all(5),
                decoration: containerDecor,
                child: Column(
                  children: [
                    buildCustomTableHeader(
                      cellConfigs: [
                        TableCellConfig(label: 'Date'),
                        TableCellConfig(label: 'Item'),
                        TableCellConfig(label: 'Pay'),
                        TableCellConfig(label: 'Receive'),
                        TableCellConfig(label: 'Comments', flex: 5),
                      ],
                    ),
                    GetX<CarTradingController>(builder: (controller) {
                      return SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                              controller.addedItems.length,
                              (i) => buildCustomRow(cellConfigs: [
                                    RowCellConfig(
                                        initialValue: controller.addedItems[i]
                                            ['date']),
                                    RowCellConfig(
                                        initialValue: controller.addedItems[i]
                                            ['item_name']),
                                    RowCellConfig(
                                        initialValue: controller.addedItems[i]
                                            ['pay']),
                                    RowCellConfig(
                                        initialValue: controller.addedItems[i]
                                            ['receive']),
                                    RowCellConfig(
                                        initialValue: controller.addedItems[i]
                                            ['comment'],
                                        flex: 5),
                                  ])),
                        ),
                      );
                    })
                  ],
                ),
              ),
            )
          ],
        ),
      )
    ],
  );
}
