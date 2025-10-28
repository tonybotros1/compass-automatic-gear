import 'package:datahubai/Models/quotation%20cards/quotation_cards_model.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/quotation_card_controller.dart';
import '../../../../Widgets/Dashboard Widgets/trading dashboard widgets/custom_box.dart';
import '../../../../Widgets/drop_down_menu3.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/quotation_card_widgets/add_new_quotation_card_or_edit.dart';
import '../../../../Widgets/main screen widgets/quotation_card_widgets/quotation_card_buttons.dart';
import '../../../../consts.dart';

class QuotationCard extends StatelessWidget {
  const QuotationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: screenPadding,
            child: SizedBox(
              width: constraints.maxWidth,
              child: ListView(
                children: [
                  GetX<QuotationCardController>(
                    init: QuotationCardController(),
                    builder: (controller) {
                      bool isModelLoading = controller.allModels.isEmpty;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 10,
                        children: [
                          Expanded(
                            child: myTextFormFieldWithBorder(
                              labelText: 'Quotation NO.',
                              controller: controller.quotaionNumberFilter.value,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CustomDropdown(
                              showedSelectedName: 'name',
                              textcontroller:
                                  controller.carBrandIdFilterName.value.text,
                              hintText: 'Car Brand',
                              onChanged: (key, value) async {
                                controller.carModel.clear();
                                controller.getModelsByCarBrand(key);
                                controller.carBrandIdFilter.value = key;
                                controller.carBrandIdFilterName.value.text =
                                    value['name'];
                                controller.carModelIdFilter.value = '';
                                controller.carModelIdFilterName.value.text = '';
                              },
                              onDelete: () {
                                controller.carModel.clear();
                                controller.carBrandIdFilter.value = '';
                                controller.carBrandIdFilterName.value.clear();
                                controller.carModelIdFilter.value = '';
                                controller.carModelIdFilterName.value.text = '';
                              },
                              onOpen: () {
                                return controller.getCarBrands();
                              },
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: CustomDropdown(
                              showedSelectedName: 'name',
                              textcontroller:
                                  controller.carModelIdFilterName.value.text,
                              hintText: 'Car Model',
                              items: isModelLoading ? {} : controller.allModels,
                              onChanged: (key, value) async {
                                controller.carModelIdFilter.value = key;
                                controller.carModelIdFilterName.value.text =
                                    value['name'];
                              },
                              onDelete: () {
                                controller.carModelIdFilter.value = '';
                                controller.carModelIdFilterName.value.clear();
                              },
                            ),
                          ),
                          Expanded(
                            child: myTextFormFieldWithBorder(
                              labelText: 'Plate NO.',
                              controller: controller.plateNumberFilter.value,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: myTextFormFieldWithBorder(
                              labelText: 'VIN',
                              controller: controller.vinFilter.value,
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: CustomDropdown(
                              textcontroller: controller
                                  .customerNameIdFilterName
                                  .value
                                  .text,
                              showedSelectedName: 'entity_name',
                              hintText: 'Customer Name',
                              onChanged: (key, value) async {
                                controller.customerNameIdFilterName.value.text =
                                    value['entity_name'];
                                controller.customerNameIdFilter.value = key;
                              },
                              onDelete: () {
                                controller.customerNameIdFilterName.value
                                    .clear();
                                controller.customerNameIdFilter.value = '';
                              },
                              onOpen: () {
                                return controller.getAllCustomers();
                              },
                            ),
                          ),
                          Expanded(
                            child: CustomDropdown(
                              textcontroller:
                                  controller.statusFilter.value.text,
                              showedSelectedName: 'name',
                              hintText: 'Status',
                              items: allStatus,
                              onChanged: (key, value) async {
                                controller.statusFilter.value.text =
                                    value['name'];
                              },onDelete: (){
                                  controller.statusFilter.value.clear();
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  GetX<QuotationCardController>(
                    builder: (controller) {
                      return Row(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          myTextFormFieldWithBorder(
                            width: 150,
                            controller: controller.fromDate.value,
                            labelText: 'From Date',
                            onFieldSubmitted: (_) async {
                              normalizeDate(
                                controller.fromDate.value.text,
                                controller.fromDate.value,
                              );
                            },
                          ),
                          myTextFormFieldWithBorder(
                            width: 150,
                            controller: controller.toDate.value,
                            labelText: 'To Date',
                            onFieldSubmitted: (_) async {
                              normalizeDate(
                                controller.toDate.value.text,
                                controller.toDate.value,
                              );
                            },
                          ),
                          // ElevatedButton(
                          //   style: allButtonStyle,
                          //   onPressed: () {
                          //     controller.clearAllFilters();
                          //     controller.isAllSelected.value = true;
                          //     controller.isTodaySelected.value = false;
                          //     controller.isThisMonthSelected.value =
                          //         false;
                          //     controller.isThisYearSelected.value = false;
                          //     controller.carBrand.clear();
                          //     controller.carModel.clear();
                          //     controller.carBrandId.value = '';
                          //     controller.carModelId.value = '';
                          //     controller.allModels.clear();
                          //     controller.searchEngine({"all": true});
                          //   },
                          //   child: const Text('All'),
                          // ),
                          ElevatedButton(
                            style: todayButtonStyle,
                            onPressed: controller.isTodaySelected.isFalse
                                ? () {
                                    controller.isAllSelected.value = false;
                                    controller.isTodaySelected.value = true;
                                    controller.isThisMonthSelected.value =
                                        false;
                                    controller.isThisYearSelected.value =
                                        false;
                                    controller.isYearSelected.value = false;
                                    controller.isMonthSelected.value =
                                        false;
                                    controller.isDaySelected.value = true;
                                    controller.searchEngine({
                                      "today": true,
                                    });
                                  }
                                : null,
                            child: const Text('Today'),
                          ),
                          ElevatedButton(
                            style: thisMonthButtonStyle,
                            onPressed:
                                controller.isThisMonthSelected.isFalse
                                ? () {
                                    controller.isAllSelected.value = false;
                                    controller.isTodaySelected.value =
                                        false;
                                    controller.isThisMonthSelected.value =
                                        true;
                                    controller.isThisYearSelected.value =
                                        false;
                                    controller.isYearSelected.value = false;
                                    controller.isMonthSelected.value = true;
                                    controller.isDaySelected.value = false;
                                    controller.searchEngine({
                                      "this_month": true,
                                    });
                                  }
                                : null,
                            child: const Text('This Month'),
                          ),
                          ElevatedButton(
                            style: thisYearButtonStyle,
                            onPressed: controller.isThisYearSelected.isFalse
                                ? () {
                                    controller.isTodaySelected.value =
                                        false;
                                    controller.isThisMonthSelected.value =
                                        false;
                                    controller.isThisYearSelected.value =
                                        true;
                                    controller.isYearSelected.value = true;
                                    controller.isMonthSelected.value =
                                        false;
                                    controller.isDaySelected.value = false;
                                    controller.searchEngine({
                                      "this_year": true,
                                    });
                                  }
                                : null,
                            child: const Text('This Year'),
                          ),
                          ElevatedButton(
                            style: saveButtonStyle,
                            onPressed: controller.isScreenLoding.isFalse
                                ? () async {
                                    controller.filterSearch();
                                  }
                                : null,
                            child: controller.isScreenLoding.isFalse
                                ? Text(
                                    'Find',
                                    style: fontStyleForElevatedButtons,
                                  )
                                : loadingProcess,
                          ),
                          ElevatedButton(
                            style: clearVariablesButtonStyle,
                            onPressed: () {
                              controller.clearAllFilters();
                              // controller.update();
                            },
                            child: Text(
                              'Clear Filters',
                              style: fontStyleForElevatedButtons,
                            ),
                          ),
                          const Spacer(),
                          newQuotationCardButton(
                            context,
                            constraints,
                            controller,
                          ),
                        ],
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: GetX<QuotationCardController>(
                      builder: (controller) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          spacing: 10,
                          children: [
                            customBox(
                              title: 'NUMBER OF QUOTATIONS',
                              value: Text(
                                '${controller.numberOfQuotations.value}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: mainColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            customBox(
                              title: 'TOTALS',
                              value: textForDataRowInTable(
                                fontSize: 16,
                                color: Colors.green,
                                isBold: true,
                                text: '${controller.allQuotationsTotals.value}',
                              ),
                            ),
                            customBox(
                              title: 'VATS',
                              value: textForDataRowInTable(
                                fontSize: 16,
                                color: Colors.red,
                                isBold: true,
                                text: '${controller.allQuotationsVATS.value}',
                              ),
                            ),
                            customBox(
                              title: 'NETS',
                              value: textForDataRowInTable(
                                fontSize: 16,
                                color: Colors.blueGrey,
                                isBold: true,
                                text: '${controller.allQuotationsNET.value}',
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        topLeft: Radius.circular(2),
                        topRight: Radius.circular(2),
                      ),
                    ),
                    child: GetX<QuotationCardController>(
                      builder: (controller) {
                        return SizedBox(
                          width: constraints.maxWidth,
                          child: tableOfScreens(
                            scrollController:
                                controller.scrollControllerFotTable1,
                            constraints: constraints,
                            context: context,
                            controller: controller,
                            data: controller.allQuotationCards,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget tableOfScreens({
  required BoxConstraints constraints,
  required BuildContext context,
  required QuotationCardController controller,
  required List<QuotationCardsModel> data,
  required ScrollController scrollController,
}) {
  bool isQuotationsLoading = data.isEmpty;

  return DataTableTheme(
    data: DataTableThemeData(
      headingTextStyle: fontStyleForTableHeader,
      dataTextStyle: regTextStyle,
      dataRowColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.grey.shade300;
        }
        return null;
      }),
    ),
    child: Scrollbar(
      thumbVisibility: true,
      controller: scrollController,
      child: PaginatedDataTable(
        controller: scrollController,
        // rowsPerPage: controller.numberOfQuotations.value +1,
        // availableRowsPerPage: const [1, 10, 17, 25],
        onRowsPerPageChanged: (rows) {
          controller.pagesPerPage.value = rows!;
        },
        showCheckboxColumn: false,
        dataRowMaxHeight: 40,
        dataRowMinHeight: 30,
        headingRowHeight: 70,
        columnSpacing: 15,
        sortColumnIndex: controller.sortColumnIndex.value,
        sortAscending: controller.isAscending.value,
        headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
        columns: [
          const DataColumn(label: SizedBox()),
          DataColumn(
            label: Column(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizedText(text: 'Quotation', constraints: constraints),
                AutoSizedText(text: 'Number', constraints: constraints),
              ],
            ),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: Column(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(),
                // AutoSizedText(text: '', constraints: constraints),
                AutoSizedText(text: 'Date', constraints: constraints),
              ],
            ),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: Column(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(),
                AutoSizedText(text: 'Status', constraints: constraints),
              ],
            ),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: Column(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizedText(text: 'Car', constraints: constraints),
                AutoSizedText(text: 'Brand', constraints: constraints),
              ],
            ),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: Column(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(),
                AutoSizedText(text: 'Model', constraints: constraints),
              ],
            ),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: Column(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(),
                AutoSizedText(text: 'Color', constraints: constraints),
              ],
            ),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: Column(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizedText(text: 'Plate', constraints: constraints),
                AutoSizedText(text: 'Number', constraints: constraints),
              ],
            ),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: Column(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(),
                AutoSizedText(text: 'Customer Name', constraints: constraints),
              ],
            ),
            // onSort: controller.onSort,
          ),
          DataColumn(
            label: Column(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(),
                AutoSizedText(text: 'VIN', constraints: constraints),
              ],
            ),
            // onSort: controller.onSort,
          ),
          DataColumn(
            numeric: true,
            label: Column(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(),
                AutoSizedText(text: 'Totals', constraints: constraints),
              ],
            ),
            // onSort: controller.onSort,
          ),
          DataColumn(
            numeric: true,
            label: Column(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(),
                AutoSizedText(text: 'VAT', constraints: constraints),
              ],
            ),
            // onSort: controller.onSort,
          ),
          DataColumn(
            numeric: true,
            label: Column(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(),
                AutoSizedText(text: 'NET', constraints: constraints),
              ],
            ),
            // onSort: controller.onSort,
          ),
        ],
        source: CardDataSource(
          cards: isQuotationsLoading ? [] : data,
          context: context,
          constraints: constraints,
          controller: controller,
        ),
      ),
    ),
  );
}

DataRow dataRowForTheTable(
  QuotationCardsModel cardData,
  BuildContext context,
  BoxConstraints constraints,
  String cardId,
  QuotationCardController controller,
  int index,
) {
  final isEvenRow = index % 2 == 0;
  return DataRow(
    color: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.grey.shade400;
      }
      return isEvenRow ? Colors.grey.shade200 : Colors.white;
    }),
    cells: [
      DataCell(
        Row(
          children: [
            editSection(context, controller, cardData, constraints, cardId),
          ],
        ),
      ),
      DataCell(textForDataRowInTable(text: cardData.quotationNumber ?? '')),
      DataCell(textForDataRowInTable(text: textToDate(cardData.quotationDate))),
      DataCell(
        cardData.quotationStatus != ''
            ? statusBox(
                '${cardData.quotationStatus}',
                hieght: 35,
                padding: const EdgeInsets.symmetric(horizontal: 5),
              )
            : const SizedBox(),
      ),
      DataCell(textForDataRowInTable(text: cardData.carBrand ?? '')),
      DataCell(textForDataRowInTable(text: cardData.carModel ?? '')),
      DataCell(textForDataRowInTable(text: cardData.color ?? '')),
      DataCell(SelectableText(cardData.plateNumber ?? '', maxLines: 1)),

      DataCell(
        textForDataRowInTable(maxWidth: null, text: cardData.customer ?? ''),
      ),
      DataCell(
        SelectableText(cardData.vehicleIdentificationNumber ?? '', maxLines: 1),
      ),
      DataCell(
        textForDataRowInTable(
          color: Colors.green,
          isBold: true,
          text: '${cardData.totals}',
        ),
      ),
      DataCell(
        textForDataRowInTable(
          color: Colors.red,
          isBold: true,
          text: '${cardData.vat}',
        ),
      ),
      DataCell(
        textForDataRowInTable(
          color: Colors.blueGrey,
          isBold: true,
          text: '${cardData.net}',
        ),
      ),
    ],
  );
}

Widget editSection(
  BuildContext context,
  QuotationCardController controller,
  QuotationCardsModel cardData,
  BoxConstraints constraints,
  String cardId,
) {
  return GetX<QuotationCardController>(
    builder: (controller) {
      bool isLoading = controller.buttonLoadingStates[cardId] ?? false;

      return IconButton(
        tooltip: 'Edit',
        onPressed:
            controller.buttonLoadingStates[cardId] == null || isLoading == false
            ? () async {
                controller.setButtonLoading(cardId, true);
                controller.currentCountryVAT.value =
                    controller.companyDetails.containsKey('country_vat')
                    ? controller.companyDetails['country_vat'].toString()
                    : "";
                await controller.loadValues(cardData);
                editQuotationCardDialog(controller, cardData, cardId);
                controller.setButtonLoading(cardId, false);
              }
            : null,
        icon: isLoading ? loadingProcess : editIcon,
      );
    },
  );
}

ElevatedButton historySection(
  QuotationCardController controller,
  Map<String, dynamic> cardData,
) {
  return ElevatedButton(
    style: historyButtonStyle,
    onPressed: () async {
      // controller.selectForHistory(cardData['vehicle_identification_number']);
    },
    child: const Text('History'),
  );
}

Future<dynamic> editQuotationCardDialog(
  QuotationCardController controller,
  QuotationCardsModel cardData,
  String quotationId, {
  String screenName = '',
  headerColor = '',
}) {
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      insetPadding: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                  color: headerColor == '' ? mainColor : headerColor,
                ),
                padding: const EdgeInsets.all(16),
                width: constraints.maxWidth,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth - 40,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          spacing: 10,
                          children: [
                            Text(
                              screenName == ''
                                  ? controller.getScreenName()
                                  : screenName,
                              style: fontStyleForScreenNameUsedInButtons,
                            ),
                            GetX<QuotationCardController>(
                              builder: (controller) {
                                if (controller
                                    .quotationStatus
                                    .value
                                    .isNotEmpty) {
                                  return statusBox(
                                    controller.quotationStatus.value,
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            ),
                          ],
                        ),
                        Row(
                          spacing: 10,
                          children: [
                            separator(),
                            creatJobButton(quotationId),
                            point(),
                            internalNotesButton(
                              controller,
                              constraints,
                              quotationId,
                            ),
                            separator(),
                            saveQuotationButton(
                              () => controller.addNewQuotationCard(),
                            ),
                            point(),
                            copyQuotationButton(quotationId),
                            point(),
                            deleteButton(controller, context, quotationId),
                            separator(),
                            changeStatusToPostedButton(quotationId),
                            point(),
                            changeStatusToCanceledButton(quotationId),
                            separator(),
                            closeIcon(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: addNewQuotationCardOrEdit(
                    quotaionId: quotationId,
                    controller: controller,
                    constraints: constraints,
                    context: context,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

ElevatedButton newQuotationCardButton(
  BuildContext context,
  BoxConstraints constraints,
  QuotationCardController controller,
) {
  return ElevatedButton(
    onPressed: () {
      controller.clearValues();
      Get.dialog(
        barrierDismissible: false,
        Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          insetPadding: const EdgeInsets.all(8),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  GetX<QuotationCardController>(
                    builder: (controller) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
                          color: mainColor,
                        ),
                        padding: const EdgeInsets.all(16),
                        width: constraints.maxWidth,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth - 40,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  spacing: 10,
                                  children: [
                                    Text(
                                      controller.getScreenName(),
                                      style:
                                          fontStyleForScreenNameUsedInButtons,
                                    ),
                                    controller.quotationStatus.value.isNotEmpty
                                        ? statusBox(
                                            controller.quotationStatus.value,
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                                Row(
                                  spacing: 10,
                                  children: [
                                    separator(),
                                    creatJobButton(
                                      controller.curreentQuotationCardId.value,
                                    ),
                                    point(),
                                    internalNotesButton(
                                      controller,
                                      constraints,
                                      controller.curreentQuotationCardId.value,
                                    ),
                                    separator(),
                                    saveQuotationButton(
                                      () => controller.addNewQuotationCard(),
                                    ),
                                    separator(),
                                    changeStatusToPostedButton(
                                      controller.curreentQuotationCardId.value,
                                    ),
                                    point(),
                                    changeStatusToCanceledButton(
                                      controller.curreentQuotationCardId.value,
                                    ),
                                    separator(),
                                    closeIcon(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: addNewQuotationCardOrEdit(
                        quotaionId: controller.curreentQuotationCardId.value,
                        controller: controller,
                        constraints: constraints,
                        context: context,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
    style: newButtonStyle,
    child: const Text('New Card'),
  );
}

class CardDataSource extends DataTableSource {
  final List<QuotationCardsModel> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final QuotationCardController controller;

  CardDataSource({
    required this.cards,
    required this.context,
    required this.constraints,
    required this.controller,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= cards.length) return null;

    final quotation = cards[index];
    final cardId = quotation.id ?? '';

    return dataRowForTheTable(
      quotation,
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
  int get selectedRowCount => 0; //controller.selectedcardId.value!.isEmpty ? 0 : 1;
}
