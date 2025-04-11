import 'package:datahubai/Controllers/Main%20screen%20controllers/cash_management_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Models/tabel_cell_model.dart';
import '../../../Models/tabel_row_model.dart';
import '../../../consts.dart';
import '../../drop_down_menu3.dart';
import '../../my_text_field.dart';
import '../../tabel_widgets/build_tabel.dart';

Widget receiptHeader(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    child: GetX<CashManagementController>(builder: (controller) {
      bool isCustomerLoading = controller.allCustomers.isEmpty;
      return Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: myTextFormFieldWithBorder(
                  controller: controller.receiptCounter.value,
                  labelText: 'Receipt Number',
                ),
              ),
              Expanded(
                child: myTextFormFieldWithBorder(
                  controller: controller.receiptDate.value,
                  suffixIcon: IconButton(
                      onPressed: () {
                        controller.selectDateContext(
                            context, controller.receiptDate.value);
                      },
                      icon: const Icon(Icons.date_range)),
                  isDate: true,
                  labelText: 'Receipt Date',
                ),
              ),
              Spacer(),
              ElevatedButton(
                  style: historyButtonStyle,
                  onPressed: controller.customerNameId.isEmpty
                      ? () {
                          showSnackBar('Alert', 'Please Select customer First');
                        }
                      : () {
                          if (controller.availableReceipts.isEmpty) {
                            controller.getCustomerInvoices(
                                controller.customerNameId.value);
                          }
                          Get.dialog(
                              barrierDismissible: false,
                              Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                child: LayoutBuilder(
                                    builder: (context, constraints) {
                                  return Column(
                                    children: [
                                      Container(
                                        width: constraints.maxWidth / 1.1,
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              topRight: Radius.circular(5)),
                                          color: mainColor,
                                        ),
                                        child: Row(
                                          spacing: 10,
                                          children: [
                                            Text(
                                              '💸 Invoices',
                                              style:
                                                  fontStyleForScreenNameUsedInButtons,
                                            ),
                                            const Spacer(),
                                            ElevatedButton(
                                                style: new2ButtonStyle,
                                                onPressed: () {
                                                  controller
                                                      .addSelectedReceipts();
                                                },
                                                child: Text('Add')),
                                            closeButton,
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width: constraints.maxWidth / 1.1,
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: GetX<
                                                      CashManagementController>(
                                                  builder: (controller) {
                                                return controller
                                                        .loadingInvoices.isFalse
                                                    ? Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8),
                                                            child:
                                                                buildCustomTableHeader(
                                                              prefix:
                                                                  CupertinoCheckbox(
                                                                      value: controller
                                                                          .isAllJobReceiptsSelected
                                                                          .value,
                                                                      onChanged:
                                                                          (value) {
                                                                        controller
                                                                            .selectAllJobReceipts(value!);
                                                                      }),
                                                              cellConfigs: [
                                                                TableCellConfig(
                                                                    label:
                                                                        'Invoice Number'),
                                                                TableCellConfig(
                                                                    label:
                                                                        'Invoice Date'),
                                                                TableCellConfig(
                                                                    label:
                                                                        'Invoice NET'),
                                                                TableCellConfig(
                                                                    label:
                                                                        'Invoice Amount'),
                                                                TableCellConfig(
                                                                    label:
                                                                        'Outsanding Amount'),
                                                                TableCellConfig(
                                                                    label:
                                                                        'Note',
                                                                    flex: 5),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                              width: double
                                                                  .infinity,
                                                              height: null,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8),
                                                              constraints:
                                                                  BoxConstraints(
                                                                minHeight: 100,
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: Border.all(
                                                                    color:
                                                                        secColor,
                                                                    width: 2),
                                                                // color: Color.fromARGB(255, 202, 204, 202),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              child:
                                                                  SingleChildScrollView(
                                                                child: Column(
                                                                  children: controller
                                                                      .availableReceipts
                                                                      .where((availableReceipt) => !controller.selectedAvailableReceipts.any((selected) =>
                                                                          selected[
                                                                              'invoice_number'] ==
                                                                          availableReceipt[
                                                                              'invoice_number']))
                                                                      .toList()
                                                                      .asMap()
                                                                      .entries
                                                                      .map(
                                                                          (entry) {
                                                                    final receipt =
                                                                        entry
                                                                            .value;
                                                                    // find the original index in availableReceipts
                                                                    final originalIndex = controller
                                                                        .availableReceipts
                                                                        .indexWhere((r) =>
                                                                            r['invoice_number'] ==
                                                                            receipt['invoice_number']);
                                                                    return buildCustomRow(
                                                                      prefix: GetBuilder<
                                                                              CashManagementController>(
                                                                          builder:
                                                                              (controller) {
                                                                        return CupertinoCheckbox(
                                                                          value:
                                                                              receipt['is_selected'],
                                                                          onChanged:
                                                                              (value) {
                                                                            controller.selectJobReceipt(originalIndex,
                                                                                value!);
                                                                          },
                                                                        );
                                                                      }),
                                                                      cellConfigs: [
                                                                        RowCellConfig(
                                                                          initialValue:
                                                                              receipt['invoice_number'],
                                                                          flex:
                                                                              1,
                                                                          isEnabled:
                                                                              false,
                                                                        ),
                                                                        RowCellConfig(
                                                                          initialValue:
                                                                              textToDate(receipt['invoice_date']),
                                                                          flex:
                                                                              1,
                                                                          isEnabled:
                                                                              false,
                                                                        ),
                                                                        RowCellConfig(
                                                                          initialValue:
                                                                              receipt['invoice_amount'].toString(),
                                                                          flex:
                                                                              1,
                                                                          isEnabled:
                                                                              false,
                                                                        ),
                                                                        RowCellConfig(
                                                                          initialValue:
                                                                              receipt['receipt_amount'].toString(),
                                                                          flex:
                                                                              1,
                                                                          isEnabled:
                                                                              false,
                                                                        ),
                                                                        RowCellConfig(
                                                                          initialValue:
                                                                              receipt['outstanding_amount'].toString(),
                                                                          flex:
                                                                              1,
                                                                          isEnabled:
                                                                              false,
                                                                        ),
                                                                        RowCellConfig(
                                                                          initialValue:
                                                                              receipt['notes'],
                                                                          flex:
                                                                              5,
                                                                          isEnabled:
                                                                              false,
                                                                        ),
                                                                      ],
                                                                    );
                                                                  }).toList(),
                                                                ),
                                                              ))
                                                        ],
                                                      )
                                                    : Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                              })),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ));
                        },
                  child: Text('Customer Invoices'))
            ],
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                flex: 4,
                child: CustomDropdown(
                  textcontroller: controller.customerName.text,
                  showedSelectedName: 'entity_name',
                  hintText: 'Customer Name',
                  items: isCustomerLoading ? {} : controller.allCustomers,
                  itemBuilder: (context, key, value) {
                    return ListTile(
                      title: Text(value['entity_name']),
                    );
                  },
                  onChanged: (key, value) {
                    controller.customerName.text = value['entity_name'];
                    controller.customerNameId.value = key;
                    controller.availableReceipts.clear();
                    controller.selectedAvailableReceipts.clear();
                  },
                ),
              ),
              Expanded(child: SizedBox()),
            ],
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                flex: 4,
                child: myTextFormFieldWithBorder(
                  controller: controller.note,
                  labelText: 'Notes',
                  maxLines: 4,
                ),
              ),
              Expanded(child: SizedBox())
            ],
          ),
        ],
      );
    }),
  );
}
