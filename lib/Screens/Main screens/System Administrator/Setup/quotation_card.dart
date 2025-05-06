import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/quotation_card_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/quotation_card_widgets/add_new_quotation_card_or_edit.dart';
import '../../../../Widgets/main screen widgets/quotation_card_widgets/quotation_card_buttons.dart';
import '../../../../consts.dart';

class QuotationCard extends StatelessWidget {
  QuotationCard({super.key});
  final QuotationCardController quotationCardController =
      Get.put(QuotationCardController());

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          GetX<QuotationCardController>(
                            init: QuotationCardController(),
                            builder: (controller) {
                              return searchBar(
                                search: controller.search,
                                constraints: constraints,
                                context: context,
                                title: 'Search for quotation cards',
                                button: newQuotationCardButton(
                                    context, constraints, controller),
                              );
                            },
                          ),
                          Expanded(
                            child: GetX<QuotationCardController>(
                              builder: (controller) {
                                if (controller.isScreenLoding.value) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (controller.allQuotationCards.isEmpty) {
                                  return const Center(
                                    child: Text('No Elements'),
                                  );
                                }
                                return SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: SizedBox(
                                    width: constraints.maxWidth,
                                    child: tableOfScreens(
                                        constraints: constraints,
                                        context: context,
                                        controller: controller,
                                        data: controller.filteredQuotationCards
                                                    .isEmpty &&
                                                controller
                                                    .search.value.text.isEmpty
                                            ? controller.allQuotationCards
                                            : controller
                                                .filteredQuotationCards),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
  required RxList<DocumentSnapshot> data,
  // required ScrollController scrollController,
}) {
  final dataSource = CardDataSource(
    cards: data,
    context: context,
    constraints: constraints,
    controller: controller,
  );
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
    child: PaginatedDataTable(
      rowsPerPage: controller.pagesPerPage.value,
      availableRowsPerPage: const [5, 10, 17, 25],
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
        DataColumn(label: SizedBox()),
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
              AutoSizedText(text: 'Code', constraints: constraints),
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
              AutoSizedText(text: 'City', constraints: constraints),
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
          headingRowAlignment: MainAxisAlignment.end,
          label: Column(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(),
              AutoSizedText(text: 'Total Job', constraints: constraints),
            ],
          ),
          // onSort: controller.onSort,
        ),
        DataColumn(
          headingRowAlignment: MainAxisAlignment.end,

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
          headingRowAlignment: MainAxisAlignment.end,

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
      source: dataSource,
    ),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> cardData, context, constraints,
    cardId, QuotationCardController controller, int index) {
  final isEvenRow = index % 2 == 0;
  return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.grey.shade400;
        }
        return isEvenRow ? Colors.grey.shade200 : Colors.white;
      }),
      cells: [
        DataCell(Row(
          children: [
            editSection(context, controller, cardData, constraints, cardId)
          ],
        )),
        DataCell(
            textForDataRowInTable(text: '${cardData['quotation_number']}')),
        DataCell(textForDataRowInTable(
            text: cardData['quotation_number'] != ''
                ? '${cardData['quotation_date']}'
                : '')),
        DataCell(cardData['quotation_status'] != ''
            ? statusBox('${cardData['quotation_status']}',
                hieght: 35, padding: EdgeInsets.symmetric(horizontal: 5))
            : const SizedBox()),
        DataCell(textForDataRowInTable(
            text: controller.getdataName(
                cardData['car_brand'], controller.allBrands))),
        DataCell(
          FutureBuilder<String>(
            future: controller.getModelName(
                cardData['car_brand'], cardData['car_model']),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              } else if (snapshot.hasError) {
                return const Text('Error');
              } else {
                return textForDataRowInTable(
                  text: '${snapshot.data}',
                );
              }
            },
          ),
        ),
        DataCell(Text(
          controller.getdataName(cardData['color'], controller.allColors),
        )),
        DataCell(SelectableText(
          cardData['plate_number'],
          maxLines: 1,
        )),
        DataCell(SelectableText(
          cardData['plate_code'],
          maxLines: 1,
        )),
        DataCell(
          FutureBuilder<String>(
            future:
                controller.getCityName(cardData['country'], cardData['city']),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              } else if (snapshot.hasError) {
                return const Text('Error');
              } else {
                return textForDataRowInTable(
                  text: '${snapshot.data}',
                );
              }
            },
          ),
        ),
        DataCell(
          textForDataRowInTable(
            maxWidth: null,
            text: controller.getdataName(
                cardData['customer'], controller.allCustomers,
                title: 'entity_name'),
          ),
        ),
        DataCell(SelectableText(
          cardData['vehicle_identification_number'],
          maxLines: 1,
        )),
        DataCell(
          Align(
            alignment: Alignment.centerRight,
            child: StreamBuilder<double>(
              stream: controller.calculateAllTotals(cardId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading...');
                } else if (snapshot.hasError) {
                  return const Text('Error');
                } else {
                  return textForDataRowInTable(
                    color: Colors.green,
                    isBold: true,
                    text: '${snapshot.data}',
                  );
                }
              },
            ),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerRight,
            child: StreamBuilder<double>(
              stream: controller.calculateAllVATs(cardId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading...');
                } else if (snapshot.hasError) {
                  return const Text('Error');
                } else {
                  return textForDataRowInTable(
                    color: Colors.red,
                    isBold: true,
                    text: '${snapshot.data}',
                  );
                }
              },
            ),
          ),
        ),
        DataCell(
          Align(
            alignment: Alignment.centerRight,
            child: StreamBuilder<double>(
              stream: controller.calculateAllNETs(cardId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading...');
                } else if (snapshot.hasError) {
                  return const Text('Error');
                } else {
                  return textForDataRowInTable(
                    color: Colors.blueGrey,
                    isBold: true,
                    text: '${snapshot.data}',
                  );
                }
              },
            ),
          ),
        ),
      ]);
}

Widget editSection(context, QuotationCardController controller,
    Map<String, dynamic> cardData, constraints, cardId) {
  return GetX<QuotationCardController>(builder: (controller) {
    bool isLoading = controller.buttonLoadingStates[cardId] ?? false;

    return IconButton(
        tooltip: 'Edit',
        onPressed:
            controller.buttonLoadingStates[cardId] == null || isLoading == false
                ? () async {
                    controller.setButtonLoading(cardId, true);

                    controller.getAllInvoiceItems(cardId);
                    controller.currentCountryVAT.value = controller.getdataName(
                        controller.companyDetails['contact_details']['country'],
                        controller.allCountries,
                        title: 'vat');
                    await controller.loadValues(cardData);
                    editQuotationCardDialog(controller, cardData, cardId);
                    controller.setButtonLoading(cardId, false);
                  }
                : null,
        icon: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.blue,
                  strokeWidth: 2,
                ),
              )
            : const Icon(
                Icons.edit_note_rounded,
                color: Colors.blue,
              ));
  });
}

ElevatedButton historySection(
    QuotationCardController controller, Map<String, dynamic> cardData) {
  return ElevatedButton(
      style: historyButtonStyle,
      onPressed: () async {
        // controller.selectForHistory(cardData['vehicle_identification_number']);
      },
      child: const Text('History'));
}

Future<dynamic> editQuotationCardDialog(QuotationCardController controller,
    Map<String, dynamic> cardData, quotationId) {
  return Get.dialog(
      barrierDismissible: false,
      Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          insetPadding: const EdgeInsets.all(8),
          child: LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    color: mainColor,
                  ),
                  padding: const EdgeInsets.all(16),
                  width: constraints.maxWidth,
                  child: Row(
                    spacing: 3,
                    children: [
                      Text(
                        '${controller.getScreenName()}',
                        style: fontStyleForScreenNameUsedInButtons,
                      ),
                      GetX<QuotationCardController>(builder: (controller) {
                        if (controller.quotationStatus.value.isNotEmpty) {
                          return statusBox(
                            controller.quotationStatus.value,
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                      const Spacer(),
                      creatJobButton(),
                      internalNotesButton(controller, constraints, quotationId),
                      copyQuotationButton(quotationId),
                      const Spacer(),
                      saveQuotationButton(
                          () => controller.editQuotationCard(quotationId)),
                      const Spacer(),
                      changeStatusToPostedButton(quotationId),
                      changeStatusToCanceledButton(quotationId),
                      deleteButton(controller, context, quotationId),
                      closeIcon()
                    ],
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
          })));
}

ElevatedButton newQuotationCardButton(BuildContext context,
    BoxConstraints constraints, QuotationCardController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.quotationDate.value.text = textToDate(DateTime.now());
      controller.currentCountryVAT.value = controller.getdataName(
          controller.companyDetails['contact_details']['country'],
          controller.allCountries,
          title: 'vat');
      controller.country.text = controller.getdataName(
          controller.companyDetails['contact_details']['country'],
          controller.allCountries);
      controller.countryId.value =
          controller.companyDetails['contact_details']['country'];
      controller.getCitiesByCountryID(
          controller.companyDetails['contact_details']['country']);
      controller.mileageIn.value.text = '0';
      controller.mileageOut.value.text = '0';
      controller.inOutDiff.value.text = '0';
      controller.customerCreditNumber.text = '0';
      controller.customerOutstanding.text = '0';
      controller.isCashSelected.value = true;
      controller.payType.value = 'Cash';
      var entry = controller.allCurrencies.entries.firstWhere(
          (entry) =>
              entry.value['country_id'] ==
              controller.companyDetails['contact_details']['country'],
          orElse: () => const MapEntry('', {}));
      controller.customerCurrencyId.value = entry.key ?? '';
      controller.customerCurrencyRate.text =
          (entry.value['rate'] ?? '1').toString();
      controller.customerCurrency.text = controller.getdataName(
          controller.companyDetails['contact_details']['country'],
          controller.allCountries,
          title: 'currency_code');
      controller.clearValues();
      Get.dialog(
          barrierDismissible: false,
          Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              insetPadding: const EdgeInsets.all(8),
              child: LayoutBuilder(builder: (context, constraints) {
                return Column(children: [
                  GetX<QuotationCardController>(builder: (controller) {
                    return Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                          color: mainColor,
                        ),
                        padding: const EdgeInsets.all(16),
                        width: constraints.maxWidth,
                        child: Row(spacing: 3, children: [
                          Text(
                            '${controller.getScreenName()}',
                            style: fontStyleForScreenNameUsedInButtons,
                          ),
                          controller.quotationStatus.value.isNotEmpty
                              ? statusBox(
                                  controller.quotationStatus.value,
                                )
                              : SizedBox(),
                          const Spacer(),
                          creatJobButton(),
                          internalNotesButton(controller, constraints,
                              controller.curreentQuotationCardId.value),
                          const Spacer(),
                          saveQuotationButton(
                              () => controller.addNewQuotationCard()),
                          const Spacer(),
                          changeStatusToPostedButton(
                              controller.curreentQuotationCardId.value),
                          changeStatusToCanceledButton(
                              controller.curreentQuotationCardId.value),
                          closeIcon()
                        ]));
                  }),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: addNewQuotationCardOrEdit(
                      quotaionId: controller.curreentQuotationCardId.value,
                      controller: controller,
                      constraints: constraints,
                      context: context,
                    ),
                  ))
                ]);
              })));
    },
    style: newButtonStyle,
    child: const Text('New Card'),
  );
}

class CardDataSource extends DataTableSource {
  final List<DocumentSnapshot> cards;
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

    final trade = cards[index];
    final cardData = trade.data() as Map<String, dynamic>;
    final cardId = trade.id;

    return dataRowForTheTable(
      cardData,
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
  int get selectedRowCount =>
      0; //controller.selectedcardId.value!.isEmpty ? 0 : 1;
}
