import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/cash_management_controller.dart';
import '../../../Models/tabel_cell_model.dart';
import '../../../Models/tabel_row_model.dart';
import '../../tabel_widgets/build_tabel.dart';
import 'account_informations_section.dart';
import 'receipt_headers_sectiob.dart';

Widget addNewReceiptOrEdit({
  required BuildContext context,
  required CashManagementController controller,
  required bool canEdit,
}) {
  return Form(
    key: controller.formKeyForAddingNewvalue,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              physics: NeverScrollableScrollPhysics(),
              slivers: [
                // Sliver for the upper portion of your form
                SliverToBoxAdapter(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            labelContainer(
                                lable: Text(
                              'Receipt Header',
                              style: fontStyle1,
                            )),
                            receiptHeader(context),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          children: [
                            labelContainer(
                                lable: Text(
                              'Account Informations',
                              style: fontStyle1,
                            )),
                            accountInformations(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Divider
                SliverToBoxAdapter(
                  child: Divider(color: Colors.black),
                ),
                // Container that fills the remaining space
                SliverToBoxAdapter(
                  child: buildCustomTableHeader(
                    suffix: TextButton(onPressed: null, child: SizedBox()),
                    cellConfigs: [
                      TableCellConfig(label: 'Invoice Number'),
                      TableCellConfig(label: 'Invoice Date'),
                      TableCellConfig(label: 'Invoice NET'),
                      TableCellConfig(label: 'Invoice Amount'),
                      TableCellConfig(label: 'Outsanding Amount'),
                      TableCellConfig(label: 'Note', flex: 5),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: true,
                  child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: secColor, width: 2),
                        // color: Color.fromARGB(255, 202, 204, 202),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: SingleChildScrollView(
                        child: GetBuilder<CashManagementController>(
                          builder: (controller) {
                            return controller
                                    .selectedAvailableReceipts.isNotEmpty
                                ? Column(
                                    spacing: 2,
                                    children: List.generate(
                                      controller
                                          .selectedAvailableReceipts.length,
                                      (i) {
                                        final receipt = controller
                                            .selectedAvailableReceipts[i];
                                        return KeyedSubtree(
                                          key: ValueKey(receipt[
                                              'invoice_number']), // Use a unique identifier
                                          child: buildCustomRow(
                                            suffix: TextButton(
                                              onPressed: () {
                                                controller
                                                    .removeSelectedReceipt(i);
                                              },
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                    color: mainColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            cellConfigs: [
                                              RowCellConfig(
                                                initialValue:
                                                    receipt['invoice_number'],
                                                flex: 1,
                                                isEnabled: false,
                                              ),
                                              RowCellConfig(
                                                initialValue: textToDate(
                                                    receipt['invoice_date']),
                                                flex: 1,
                                                isEnabled: false,
                                              ),
                                              RowCellConfig(
                                                initialValue:
                                                    receipt['invoice_amount'],
                                                flex: 1,
                                                isEnabled: false,
                                              ),
                                              RowCellConfig(
                                                initialValue:
                                                    receipt['receipt_amount']
                                                        .toString(),
                                                flex: 1,
                                                isEnabled: true,
                                                onChanged: (value) {
                                                  receipt['receipt_amount'] =
                                                      value;
                                                },
                                              ),
                                              RowCellConfig(
                                                initialValue: receipt[
                                                        'outstanding_amount']
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
                                          ),
                                        );
                                      },
                                    ))
                                : SizedBox();
                          },
                        ),
                      )),
                ),
              ],
            ),
          ),
          SizedBox(height: 2),
          GetX<CashManagementController>(builder: (controller) {
            return buildCustomTableFooter(
              suffix: TextButton(onPressed: null, child: SizedBox()),
              cellConfigs: [
                TableCellConfig(label: ''),
                TableCellConfig(label: ''),
                TableCellConfig(label: 'Totals'),
                TableCellConfig(
                    label:
                        '${controller.calculatedAmountForAllSelectedReceipts.value}',
                    hasBorder: true),
                TableCellConfig(
                    label:
                        '${controller.calculatedOutstandingForAllSelectedReceipts.value}',
                    hasBorder: true),
                TableCellConfig(label: '', flex: 5),
              ],
            );
          })
        ],
      ),
    ),
  );
}
