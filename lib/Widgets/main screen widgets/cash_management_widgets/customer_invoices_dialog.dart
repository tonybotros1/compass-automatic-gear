import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/cash_management_controller.dart';
import '../../../Models/tabel_cell_model.dart';
import '../../../Models/tabel_row_model.dart';
import '../../../consts.dart';
import '../../tabel_widgets/build_tabel.dart';

Widget customerInvoicesDialog(BoxConstraints constraints) {
  return SizedBox(
    width: constraints.maxWidth / 1.1,
    child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GetX<CashManagementController>(builder: (controller) {
          return controller.loadingInvoices.isFalse
              ? CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: buildCustomTableHeader(
                          prefix: CupertinoCheckbox(
                              value: controller.isAllJobReceiptsSelected.value,
                              onChanged: controller.availableReceipts.isEmpty
                                  ? null
                                  : (value) {
                                      controller.selectAllJobReceipts(value!);
                                    }),
                          cellConfigs: [
                            TableCellConfig(label: 'Invoice Number'),
                            TableCellConfig(label: 'Invoice Date'),
                            TableCellConfig(label: 'Invoice Amount'),
                            TableCellConfig(label: 'Outsanding Amount'),
                            TableCellConfig(label: 'Note', flex: 5),
                          ],
                        ),
                      ),
                    ),
                    SliverFillRemaining(
                      child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(8),
                          constraints: BoxConstraints(
                            minHeight: 100,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: secColor, width: 2),
                            // color: Color.fromARGB(255, 202, 204, 202),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: controller.availableReceipts
                                  .where((availableReceipt) => !controller
                                      .selectedAvailableReceipts
                                      .any((selected) =>
                                          selected['invoice_number'] ==
                                          availableReceipt['invoice_number']))
                                  .toList()
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                final receipt = entry.value;
                                // find the original index in availableReceipts
                                final originalIndex = controller
                                    .availableReceipts
                                    .indexWhere((r) =>
                                        r['invoice_number'] ==
                                        receipt['invoice_number']);
                                return buildCustomRow(
                                  prefix: GetBuilder<CashManagementController>(
                                      builder: (controller) {
                                    return CupertinoCheckbox(
                                      value: receipt['is_selected'],
                                      onChanged: (value) {
                                        controller.selectJobReceipt(
                                            originalIndex, value!);
                                      },
                                    );
                                  }),
                                  cellConfigs: [
                                    RowCellConfig(
                                      initialValue: receipt['invoice_number'],
                                      flex: 1,
                                      isEnabled: false,
                                    ),
                                    RowCellConfig(
                                      initialValue:
                                          textToDate(receipt['invoice_date']),
                                      flex: 1,
                                      isEnabled: false,
                                    ),
                                    RowCellConfig(
                                      initialValue:
                                          receipt['invoice_amount'].toString(),
                                      flex: 1,
                                      isEnabled: false,
                                    ),
                                    RowCellConfig(
                                      initialValue:
                                          receipt['outstanding_amount']
                                              .toString(),
                                      flex: 1,
                                      isEnabled: false,
                                    ),
                                    RowCellConfig(
                                      initialValue: receipt['notes'],
                                      flex: 5,
                                      isEnabled: false,
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          )),
                    )
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                );
        })),
  );
}
