import 'package:datahubai/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/cash_management_controller.dart';
import '../../../Models/tabel_cell_model.dart';
import '../../../Models/tabel_row_model.dart';
import '../../drop_down_menu3.dart';
import '../../my_text_field.dart';
import '../../tabel_widgets/build_tabel.dart';

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
                        child: GetX<CashManagementController>(
                            builder: (controller) {
                          bool isCustomerLoading =
                              controller.allCustomers.isEmpty;
                          return Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                spacing: 10,
                                children: [
                                  Expanded(
                                    child: myTextFormFieldWithBorder(
                                      labelText: 'Receipt Number',
                                    ),
                                  ),
                                  Expanded(
                                    child: myTextFormFieldWithBorder(
                                      controller: controller.receiptDate.value,
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            controller.selectDateContext(
                                                context,
                                                controller.receiptDate.value);
                                          },
                                          icon: const Icon(Icons.date_range)),
                                      isDate: true,
                                      labelText: 'Receipt Date',
                                    ),
                                  ),
                                  Expanded(flex: 2, child: SizedBox())
                                ],
                              ),
                              Row(
                                spacing: 10,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: CustomDropdown(
                                      textcontroller:
                                          controller.customerName.text,
                                      showedSelectedName: 'entity_name',
                                      hintText: 'Customer Name',
                                      items: isCustomerLoading
                                          ? {}
                                          : controller.allCustomers,
                                      itemBuilder: (context, key, value) {
                                        return ListTile(
                                          title: Text(value['entity_name']),
                                        );
                                      },
                                      onChanged: (key, value) {
                                        controller.customerName.text =
                                            value['entity_name'];
                                        controller.customerNameId.value = key;
                                        controller.availableReceipts.clear();
                                        controller.selectedAvailableReceipts
                                            .clear();
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: myTextFormFieldWithBorder(
                                      isEnabled: false,
                                      labelText: 'Outstanding',
                                    ),
                                  ),
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
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: GetX<CashManagementController>(
                            builder: (controller) {
                          bool isReceiptTypesLoading =
                              controller.allReceiptTypes.isEmpty;
                          return Column(
                            spacing: 10,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomDropdown(
                                      textcontroller:
                                          controller.receiptType.text,
                                      showedSelectedName: 'name',
                                      hintText: 'Receipt Type',
                                      items: isReceiptTypesLoading
                                          ? {}
                                          : controller.allReceiptTypes,
                                      itemBuilder: (context, key, value) {
                                        return ListTile(
                                          title: Text(value['name']),
                                        );
                                      },
                                      onChanged: (key, value) {
                                        controller.receiptTypeId.value = key;
                                        controller.receiptType.text =
                                            value['name'];
                                        if (value['name'] == 'Cheque') {
                                          controller.isChequeSelected.value =
                                              true;
                                        } else {
                                          controller.isChequeSelected.value =
                                              false;
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 2,
                                    child: const SizedBox(),
                                  ),
                                ],
                              ),
                              // const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: myTextFormFieldWithBorder(
                                      isEnabled:
                                          controller.isChequeSelected.isTrue,
                                      labelText: 'Cheque Number',
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: myTextFormFieldWithBorder(
                                      isEnabled:
                                          controller.isChequeSelected.isTrue,
                                      labelText: 'Bank Name',
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: myTextFormFieldWithBorder(
                                      isEnabled:
                                          controller.isChequeSelected.isTrue,
                                      labelText: 'Cheque Date',
                                      isDate: true,
                                    ),
                                  ),
                                ],
                              ),
                              // const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomDropdown(
                                      hintText: 'Account',
                                      items: {},
                                      itemBuilder: (context, key, value) {
                                        return ListTile();
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: myTextFormFieldWithBorder(
                                      labelText: 'Currency',
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: myTextFormFieldWithBorder(
                                      labelText: 'Rate',
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                      style: historyButtonStyle,
                                      onPressed:
                                          controller.customerNameId.isEmpty
                                              ? () {
                                                  showSnackBar('Alert',
                                                      'Please Select customer First');
                                                }
                                              : () {
                                                  if (controller
                                                      .availableReceipts
                                                      .isEmpty)
                                                    controller
                                                        .getCustomerInvoices(
                                                            controller
                                                                .customerNameId
                                                                .value);
                                                  Get.dialog(
                                                      barrierDismissible: false,
                                                      Dialog(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                        child: LayoutBuilder(
                                                            builder: (context,
                                                                constraints) {
                                                          return Column(
                                                            children: [
                                                              Container(
                                                                width: constraints
                                                                        .maxWidth /
                                                                    1.1,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        16),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius: const BorderRadius
                                                                      .only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              5),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              5)),
                                                                  color:
                                                                      mainColor,
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
                                                                        style:
                                                                            new2ButtonStyle,
                                                                        onPressed:
                                                                            () {
                                                                          controller
                                                                              .addSelectedReceipts();
                                                                        },
                                                                        child: Text(
                                                                            'Add')),
                                                                    closeButton,
                                                                  ],
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  width: constraints
                                                                          .maxWidth /
                                                                      1.1,
                                                                  child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: GetX<CashManagementController>(builder: (controller) {
                                                                        return controller.loadingInvoices.isFalse
                                                                            ? Column(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                                                                    child: buildCustomTableHeader(
                                                                                      prefix: CupertinoCheckbox(
                                                                                          value: controller.isAllJobReceiptsSelected.value,
                                                                                          onChanged: (value) {
                                                                                            controller.selectAllJobReceipts(value!);
                                                                                          }),
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
                                                                                  Container(
                                                                                    width: double.infinity,
                                                                                    height: controller.availableReceipts.isEmpty ? 100 : null,
                                                                                    padding: EdgeInsets.all(8),
                                                                                    decoration: BoxDecoration(
                                                                                      border: Border.all(color: secColor, width: 2),
                                                                                      // color: Color.fromARGB(255, 202, 204, 202),
                                                                                      borderRadius: BorderRadius.circular(5),
                                                                                    ),
                                                                                    child: SingleChildScrollView(
                                                                                        child: Column(
                                                                                      children: List.generate(
                                                                                          controller.availableReceipts.length,
                                                                                          (i) => buildCustomRow(
                                                                                                prefix: GetBuilder<CashManagementController>(builder: (controller) {
                                                                                                  return CupertinoCheckbox(
                                                                                                      value: controller.availableReceipts[i]['is_selected'],
                                                                                                      onChanged: (value) {
                                                                                                        controller.selectJobReceipt(i, value!);
                                                                                                      });
                                                                                                }),
                                                                                                cellConfigs: [
                                                                                                  RowCellConfig(initialValue: controller.availableReceipts[i]['invoice_number'], flex: 1, isEnabled: false),
                                                                                                  RowCellConfig(initialValue: textToDate(controller.availableReceipts[i]['invoice_date']), flex: 1, isEnabled: false),
                                                                                                  RowCellConfig(initialValue: controller.availableReceipts[i]['invoice_amount'].toString(), flex: 1, isEnabled: false),
                                                                                                  RowCellConfig(initialValue: controller.availableReceipts[i]['receipt_amount'].toString(), flex: 1, isEnabled: false),
                                                                                                  RowCellConfig(initialValue: controller.availableReceipts[i]['outstanding_amount'].toString(), flex: 1, isEnabled: false),
                                                                                                  RowCellConfig(initialValue: controller.availableReceipts[i]['notes'], flex: 5, isEnabled: false),
                                                                                                ],
                                                                                              )),
                                                                                    )),
                                                                                  )
                                                                                ],
                                                                              )
                                                                            : Center(
                                                                                child: CircularProgressIndicator(),
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
                              )
                            ],
                          );
                        }),
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
                        child: GetX<CashManagementController>(
                          builder: (controller) {
                            return controller
                                    .selectedAvailableReceipts.isNotEmpty
                                ? Column(
                                    spacing: 2,
                                    children: List.generate(
                                      controller
                                          .selectedAvailableReceipts.length,
                                      (i) => buildCustomRow(
                                        cellConfigs: [
                                          RowCellConfig(
                                            initialValue:
                                                controller.selectedAvailableReceipts[i]
                                                    ['invoice_number'],
                                            flex: 1,
                                            isEnabled: false,
                                          ),
                                          RowCellConfig(
                                              initialValue: textToDate(
                                                  controller
                                                          .selectedAvailableReceipts[i]
                                                      ['invoice_date']),
                                              flex: 1,
                                              isEnabled: false),
                                          RowCellConfig(
                                            initialValue:
                                                controller.selectedAvailableReceipts[i]
                                                    ['invoice_amount'],
                                            flex: 1,
                                            isEnabled: false,
                                          ),
                                          RowCellConfig(
                                              initialValue: controller
                                                  .selectedAvailableReceipts[i]
                                                      ['receipt_amount']
                                                  .toString(),
                                              flex: 1,
                                              isEnabled: true,
                                              onChanged: (value) {
                                                controller.selectedAvailableReceipts[i]
                                                    ['receipt_amount'] = value;
                                              }),
                                          RowCellConfig(
                                            initialValue: controller
                                                .selectedAvailableReceipts[i]
                                                    ['outstanding_amount']
                                                .toString(),
                                            flex: 1,
                                            isEnabled: false,
                                          ),
                                          RowCellConfig(
                                            initialValue: controller
                                                .selectedAvailableReceipts[i]['notes'],
                                            flex: 5,
                                            isEnabled: false,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
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
              cellConfigs: [
                TableCellConfig(label: ''),
                TableCellConfig(label: ''),
                TableCellConfig(label: 'Total'),
                TableCellConfig(
                    label:
                        '${controller.calculatedAmountForAllSelectedReceipts.value}',
                    hasBorder: true),
                TableCellConfig(label: ''),
                TableCellConfig(label: '', flex: 5),
              ],
            );
          })
        ],
      ),
    ),
  );
}

Widget tableFooter() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Row(
      spacing: 2,
      children: [
        SizedBox(width: 15, height: 30),
        tabelCell(label: ''),
        tabelCell(label: ''),
        tabelCell(label: 'Total', hasBorder: true),
        tabelCell(label: '5000', hasBorder: true),
        tabelCell(label: '', flex: 5),
        TextButton(onPressed: null, child: SizedBox())
      ],
    ),
  );
}

Widget tableHeader() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Row(
      spacing: 2,
      children: [
        SizedBox(width: 15, height: 30),
        tabelCell(label: 'Invoice Number'),
        tabelCell(label: 'Total'),
        tabelCell(label: 'Outstanding'),
        tabelCell(label: 'Amount'),
        tabelCell(label: 'Notes', flex: 5),
        TextButton(onPressed: null, child: SizedBox())
      ],
    ),
  );
}

Expanded tabelCell({
  int flex = 1,
  required String label,
  bool hasBorder = false,
}) {
  return Expanded(
      flex: flex,
      child: Container(
        decoration: hasBorder
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey))
            : null,
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.bottomLeft,
        height: textFieldHeight,
        child: Text(
          overflow: TextOverflow.ellipsis,
          label,
          style: textFieldLabelStyle,
        ),
      ));
}

Row receiptTableRowLine() {
  return Row(
    spacing: 2,
    children: [
      Container(
        height: 30,
        width: 15,
        color: Colors.yellow,
      ),
      Expanded(
          child: myTextFormFieldWithBorder(
              isEnabled: false,
              controller: null,
              initialValue: 'Tony',
              onChanged: (value) {
                print(value);
              })),
      Expanded(
          child: myTextFormFieldWithBorder(
              isEnabled: false,
              controller: null,
              initialValue: 'Tony',
              onChanged: (value) {
                print(value);
              })),
      Expanded(
          child: myTextFormFieldWithBorder(
              isEnabled: false,
              controller: null,
              initialValue: 'Tony',
              onChanged: (value) {
                print(value);
              })),
      Expanded(
          child: myTextFormFieldWithBorder(
              controller: null,
              initialValue: 'Tony',
              onChanged: (value) {
                print(value);
              })),
      Expanded(
          flex: 5,
          child: myTextFormFieldWithBorder(
              isEnabled: false,
              controller: null,
              initialValue: 'Tony',
              onChanged: (value) {
                print(value);
              })),
      TextButton(onPressed: () {}, child: Text('Delete'))
    ],
  );
}
