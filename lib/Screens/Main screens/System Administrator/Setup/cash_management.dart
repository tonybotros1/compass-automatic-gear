import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/cash_management_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/cash_management_widgets/receipt_dialog.dart';
import '../../../../consts.dart';

class CashManagement extends StatelessWidget {
  const CashManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: screenPadding,
            child: Container(
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  GetX<CashManagementController>(
                    init: CashManagementController(),
                    builder: (controller) {
                      return searchBar(
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        controller: controller,
                        title: 'Search for cashes',
                        button:
                            newReceiptButton(context, constraints, controller),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<CashManagementController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.allCashsManagements.isEmpty) {
                          return const Center(
                            child: Text('No Element'),
                          );
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis
                              .vertical, // Horizontal scrolling for the table
                          child: SizedBox(
                            width: constraints.maxWidth,
                            child: tableOfScreens(
                              constraints: constraints,
                              context: context,
                              controller: controller,
                            ),
                          ),
                        );
                      },
                    ),
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

Widget tableOfScreens(
    {required constraints,
    required context,
    required CashManagementController controller}) {
  return DataTable(
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
        label: AutoSizedText(
          text: 'Code',
          constraints: constraints,
        ),
        // onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Flag',
        ),
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Name',
        ),
        // onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Calling Code',
        ),
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Creation Date',
        ),
        // onSort: controller.onSort,
      ),
      const DataColumn(
          headingRowAlignment: MainAxisAlignment.center, label: Text('')),
    ],
    rows: controller.filteredCashsManagements.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allCashsManagements.map<DataRow>((cashManagement) {
            final cashManagementData =
                cashManagement.data() as Map<String, dynamic>;
            final cashManagementId = cashManagement.id;
            return dataRowForTheTable(cashManagementData, context, constraints,
                cashManagementId, controller);
          }).toList()
        : controller.filteredCashsManagements.map<DataRow>((cashManagement) {
            final cashManagementData =
                cashManagement.data() as Map<String, dynamic>;
            final cashManagementId = cashManagement.id;
            return dataRowForTheTable(cashManagementData, context, constraints,
                cashManagementId, controller);
          }).toList(),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> cashManagementData, context,
    constraints, cashManagementId, CashManagementController controller) {
  return DataRow(cells: [
    DataCell(Text(
      cashManagementData['code'] ?? 'no code',
    )),
    DataCell(
        cashManagementData['flag'] != '' || cashManagementData['flag'] != null
            ? Image.network(
                cashManagementData['flag'],
                width: 40,
              )
            : const Text('no flag')),
    DataCell(
      Text(
        cashManagementData['name'] ?? 'no name',
      ),
    ),
    DataCell(
      Text(
        cashManagementData['calling_code'] ?? 'no calling code',
      ),
    ),
    DataCell(
      Text(
        cashManagementData['added_date'] != null &&
                cashManagementData['added_date'] != ''
            ? textToDate(cashManagementData['added_date']) //
            : 'N/A',
      ),
    ),
    DataCell(Row(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        valSectionInTheTable(controller, cashManagementId, context, constraints,
            cashManagementData),
        editSection(context, controller, cashManagementData, constraints,
            cashManagementId),
        deleteSection(controller, cashManagementId, context),
      ],
    )),
  ]);
}

ElevatedButton valSectionInTheTable(CashManagementController controller,
    cashManagementId, context, BoxConstraints constraints, cashManagementData) {
  return ElevatedButton(
      style: viewButtonStyle,
      onPressed: () {
        // controller.getCitiesValues(cashManagementId);
        // controller.cashManagementIdToWorkWith.value = cashManagementId;
        Get.dialog(
            barrierDismissible: false,
            Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: SizedBox(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        color: mainColor,
                      ),
                      child: Row(
                        children: [
                          Text(
                            '🏙️ Cities',
                            style: fontStyleForScreenNameUsedInButtons,
                          ),
                          const Spacer(),
                          closeButton
                        ],
                      ),
                    ),
                    // Expanded(
                    //     child: Padding(
                    //   padding: const EdgeInsets.all(16),
                    //   child: citiesSection(
                    //     constraints: constraints,
                    //     context: context,
                    //   ),
                    // ))
                  ],
                ),
              ),
            ));
      },
      child: const Text('Cities'));
}

ElevatedButton deleteSection(
    CashManagementController controller, cashManagementId, context) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        alertDialog(
            context: context,
            controller: controller,
            content: "The cashManagement will be deleted permanently",
            onPressed: () {
              // controller.deletecashManagement(cashManagementId);
            });
      },
      child: const Text("Delete"));
}

ElevatedButton editSection(context, CashManagementController controller,
    Map<String, dynamic> cashManagementData, constraints, cashManagementId) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () {
        // controller.cashManagementName.text = cashManagementData['name'];
        // controller.cashManagementCallingCode.text = cashManagementData['calling_code'];
        // controller.cashManagementCode.text = cashManagementData['code'];
        // controller.currencyName.text = cashManagementData['currency_name'];
        // controller.currencyCode.text = cashManagementData['currency_code'];
        // controller.vat.text = cashManagementData['vat'];

        // controller.flagUrl.value = cashManagementData['flag'] ?? '';
        // controller.imageBytes.value = Uint8List(0);
        // controller.flagSelectedError.value = false;
        // countriesDialog(
        //     canEdit: false,
        //     constraints: constraints,
        //     controller: controller,
        //     onPressed: controller.addingNewValue.value
        //         ? null
        //         : () {
        //             controller.editCountries(cashManagementId);
        //           });
      },
      child: const Text('Edit'));
}

ElevatedButton newReceiptButton(BuildContext context,
    BoxConstraints constraints, CashManagementController controller) {
  return ElevatedButton(
    onPressed: () {
      // controller.cashManagementCode.clear();
      // controller.cashManagementName.clear();
      // controller.cashManagementCallingCode.clear();
      // controller.currencyName.clear();
      // controller.currencyCode.clear();
      // controller.vat.clear();
      // controller.imageBytes.value = Uint8List(0);
      // controller.flagUrl.value = '';
      // controller.flagSelectedError.value = false;
      receiptDialog(
        canEdit: true,
        constraints: constraints,
        controller: controller,
        onPressed: null,
        //  controller.addingNewValue.value
        //     ? null
        //     : () async {
        //         if (!controller.formKeyForAddingNewvalue.currentState!
        //             .validate()) {}
        //         if (controller.imageBytes.value.isEmpty) {
        //           controller.flagSelectedError.value = true;
        //         } else {
        //           await controller.addNewcashManagement();
        //         }
        //       }
      );
    },
    style: newButtonStyle,
    child: const Text('New Receipt'),
  );
}
