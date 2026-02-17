import 'package:datahubai/Controllers/Main%20screen%20controllers/ap_invoices_controller.dart';
import 'package:datahubai/Models/job%20cards/job_card_model.dart';
import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../menu_dialog.dart';
import '../auto_size_box.dart';

Widget addNewinvoiceForApInvoicesOrEdit({
  required ApInvoicesController controller,
  required BuildContext context,
  required BoxConstraints constraints,
}) {
  return SingleChildScrollView(
    child: SizedBox(
      child: FocusTraversalGroup(
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<ApInvoicesController>(
              builder: (controller) {
                return MenuWithValues(
                  labelText: 'Transaction Type',
                  headerLqabel: 'Transaction Types',
                  dialogWidth: constraints.maxWidth / 3,
                  width: double.infinity,
                  controller: controller.transactionType,
                  displayKeys: const ['type'],
                  displaySelectedKeys: const ['type'],
                  onOpen: () {
                    return controller.getTransactionTypes();
                  },
                  onDelete: () {
                    controller.transactionType.clear();
                    controller.transactionTypeId.value = '';
                  },
                  onSelected: (value) {
                    controller.transactionType.text = value['type'];
                    controller.transactionTypeId.value = value['_id'];
                  },
                );
                // CustomDropdown(
                //   width: double.infinity,
                //   focusNode: controller.focusNode1,
                //   nextFocusNode: controller.focusNode2,
                //   showedSelectedName: 'type',
                //   textcontroller: controller.transactionType.text,
                //   hintText: 'Transaction Type',
                //   onChanged: (key, value) {
                // controller.transactionType.text = value['type'];
                // controller.transactionTypeId.value = key;
                //   },
                //   onDelete: () {
                // controller.transactionType.clear();
                // controller.transactionTypeId.value = '';
                //   },
                //   onOpen: () {
                //     return controller.getTransactionTypes();
                //   },
                // );
              },
            ),
            Row(
              spacing: 10,
              children: [
                myTextFormFieldWithBorder(
                  width: 150,
                  isDouble: true,
                  focusNode: controller.focusNode2,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(controller.focusNode3);
                  },
                  textInputAction: TextInputAction.next,
                  labelText: 'Amount',
                  controller: controller.amount,
                ),
                myTextFormFieldWithBorder(
                  width: 150,
                  focusNode: controller.focusNode3,
                  isDouble: true,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(controller.focusNode4);
                  },
                  textInputAction: TextInputAction.next,
                  labelText: 'VAT',
                  controller: controller.vat,
                ),
              ],
            ),
            myTextFormFieldWithBorder(
              width: 150,
              labelText: 'Received Number',
              controller: controller.receivedNumber,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                myTextFormFieldWithBorder(
                  width: 150,
                  focusNode: controller.focusNode7,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(controller.focusNode8);
                  },
                  labelText: 'Job Number',
                  controller: controller.jobNumber,
                  isEnabled: false,
                ),
                IconButton(
                  focusNode: FocusNode(skipTraversal: true),
                  onPressed: () {
                    controller.searchForJobCards.clear();
                    // controller.getAllJobCards();
                    jobDialog(constraints, context);
                  },
                  icon: Icon(Icons.more_vert_rounded, color: mainColor),
                ),
              ],
            ),
            myTextFormFieldWithBorder(
              focusNode: controller.focusNode8,
              maxLines: 6,
              labelText: 'Note',
              controller: controller.invoiceNote,
            ),
          ],
        ),
      ),
    ),
  );
}

Future<dynamic> jobDialog(BoxConstraints constraints, BuildContext context) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SizedBox(
        width: constraints.maxWidth,
        height: 700,
        child: Column(
          children: [
            // Header
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                color: mainColor,
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    '💳 Job Cards',
                    style: fontStyleForScreenNameUsedInButtons,
                  ),
                  const Spacer(),
                  closeIcon(),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              child: GetX<ApInvoicesController>(
                builder: (controller) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            spacing: 10,
                            children: [
                              myTextFormFieldWithBorder(
                                width: 120,
                                labelText: 'Job No.',
                                controller: controller.jobNumberFilter,
                              ),
                              CustomDropdown(
                                width: 170,
                                showedSelectedName: 'name',
                                textcontroller:
                                    controller.carBrandIdFilterName.text,
                                hintText: 'Car Brand',
                                onChanged: (key, value) async {
                                  controller.carBrandIdFilter.value = key;
                                  controller.carBrandIdFilterName.text =
                                      value['name'];
                                  controller.carModelIdFilter.value = '';
                                  controller.carModelIdFilterName.text = '';
                                },
                                onDelete: () {
                                  controller.carBrandIdFilter.value = "";
                                  controller.carBrandIdFilterName.clear();
                                  controller.carModelIdFilter.value = '';
                                  controller.carModelIdFilterName.text = '';
                                },
                                onOpen: () {
                                  return controller.getCarBrands();
                                },
                              ),
                              CustomDropdown(
                                width: 170,
                                showedSelectedName: 'name',
                                textcontroller:
                                    controller.carModelIdFilterName.value.text,
                                hintText: 'Car Model',
                                onChanged: (key, value) async {
                                  controller.carModelIdFilter.value = key;
                                  controller.carModelIdFilterName.text =
                                      value['name'];
                                },
                                onDelete: () {
                                  controller.carModelIdFilter.value = "";
                                  controller.carModelIdFilterName.clear();
                                },
                                onOpen: () {
                                  return controller.getModelsByCarBrand(
                                    controller.carBrandIdFilter.value,
                                  );
                                },
                              ),
                              myTextFormFieldWithBorder(
                                width: 90,
                                labelText: 'Plate NO.',
                                controller: controller.plateNumberFilter,
                              ),
                              myTextFormFieldWithBorder(
                                width: 170,
                                labelText: 'VIN',
                                controller: controller.vinFilter,
                              ),
                              CustomDropdown(
                                width: 300,
                                textcontroller: controller
                                    .customerNameIdFilterName
                                    .value
                                    .text,
                                showedSelectedName: 'entity_name',
                                hintText: 'Customer Name',
                                onChanged: (key, value) async {
                                  controller.customerNameIdFilterName.text =
                                      value['entity_name'];
                                  controller.customerNameIdFilter.value = key;
                                },
                                onDelete: () {
                                  controller.customerNameIdFilterName.clear();
                                  controller.customerNameIdFilter.value = "";
                                },
                                onOpen: () {
                                  return controller.getAllCustomers();
                                },
                              ),
                            ],
                          ),
                          ElevatedButton(
                            style: findButtonStyle,
                            onPressed: controller.loadingJobCards.isFalse
                                ? () async {
                                    controller.filterSearchForJobCards();
                                  }
                                : null,
                            child: controller.loadingJobCards.isFalse
                                ? Text(
                                    'Find',
                                    style: fontStyleForElevatedButtons,
                                  )
                                : loadingProcess,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                            topLeft: Radius.circular(2),
                            topRight: Radius.circular(2),
                          ),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth,
                            ),
                            child: PaginatedDataTable(
                              showCheckboxColumn: false,
                              horizontalMargin: horizontalMarginForTable,
                              dataRowMaxHeight: 40,
                              dataRowMinHeight: 30,
                              columnSpacing: 5,
                              columns: [
                                DataColumn(
                                  label: AutoSizedText(
                                    constraints: constraints,
                                    text: 'Job Number',
                                  ),
                                ),
                                DataColumn(
                                  label: AutoSizedText(
                                    constraints: constraints,
                                    text: 'Car Brand',
                                  ),
                                ),
                                DataColumn(
                                  label: AutoSizedText(
                                    constraints: constraints,
                                    text: 'Car Model',
                                  ),
                                ),
                                DataColumn(
                                  label: AutoSizedText(
                                    constraints: constraints,
                                    text: 'Plate Number',
                                  ),
                                ),
                                DataColumn(
                                  label: AutoSizedText(
                                    constraints: constraints,
                                    text: 'VIN',
                                  ),
                                ),
                                DataColumn(
                                  label: AutoSizedText(
                                    constraints: constraints,
                                    text: 'Customer',
                                  ),
                                ),
                              ],
                              source: CardDataSource(
                                cards: controller.allJobCards.isEmpty
                                    ? []
                                    : controller.allJobCards,
                                context: context,
                                constraints: constraints,
                                controller: controller,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

DataRow dataRowForTheTable(
  JobCardModel jobData,
  context,
  constraints,
  jobId,
  ApInvoicesController controller,
  int index,
) {
  return DataRow(
    onSelectChanged: (_) {
      Get.back();
      controller.jobNumber.text = jobData.jobNumber ?? '';
      controller.jobNumberId.text = jobData.id ?? '';
    },
    color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
      return index % 2 == 0 ? Colors.grey[200] : Colors.white;
    }),
    cells: [
      DataCell(
        textForDataRowInTable(
          text: jobData.jobNumber ?? '',
          color: Colors.green,
          formatDouble: false,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: jobData.carBrandName ?? '',
          formatDouble: false,
          color: Colors.blueGrey,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: jobData.carModelName ?? '',
          formatDouble: false,
          color: Colors.blueGrey,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: jobData.plateNumber ?? '',
          formatDouble: false,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: jobData.vehicleIdentificationNumber ?? '',
          formatDouble: false,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: jobData.customerName ?? '',
          maxWidth: null,
          formatDouble: false,
          color: Colors.teal,
          isBold: true,
        ),
      ),
    ],
  );
}

class CardDataSource extends DataTableSource {
  final List<JobCardModel> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final ApInvoicesController controller;

  CardDataSource({
    required this.cards,
    required this.context,
    required this.constraints,
    required this.controller,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= cards.length) return null;

    final jobCard = cards[index];
    final cardId = jobCard.id ?? '';

    return dataRowForTheTable(
      jobCard,
      context,
      constraints,
      cardId,
      controller,
      index,
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => cards.length;

  @override
  int get selectedRowCount => 0;
}
