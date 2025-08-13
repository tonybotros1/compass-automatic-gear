import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/banks_and_others_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/banks_and_others_widgets/banks_widgets.dart';

class BanksAndOthers extends StatelessWidget {
  const BanksAndOthers({super.key});

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
                  GetX<BanksAndOthersController>(
                    init: BanksAndOthersController(),
                    builder: (controller) {
                      return searchBar(
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        // controller: controller,
                        title: 'Search for bankes',
                        button:
                            newbankesButton(context, constraints, controller),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<BanksAndOthersController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.allBanks.isEmpty) {
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
    required BanksAndOthersController controller}) {
  return DataTable(
    horizontalMargin: horizontalMarginForTable,
    dataRowMaxHeight: 40,
    dataRowMinHeight: 30,
    columnSpacing: 5,
    showBottomBorder: true,
    dataTextStyle: regTextStyle,
    headingTextStyle: fontStyleForTableHeader,
    sortColumnIndex: controller.sortColumnIndex.value,
    sortAscending: controller.isAscending.value,
    headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
    columns: [
      DataColumn(
        label: AutoSizedText(
          text: 'Account Name',
          constraints: constraints,
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Account Number',
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Currency',
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Account Type',
        ),
        onSort: controller.onSort,
      ),

      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Creation Date',
        ),
        onSort: controller.onSort,
      ),
      const DataColumn(
        label: Text(''),
      ),
    ],
    rows:
        controller.filteredBanks.isEmpty && controller.search.value.text.isEmpty
            ? controller.allBanks.map<DataRow>((bank) {
                final bankData = bank.data() as Map<String, dynamic>;
                final bankId = bank.id;
                return dataRowForTheTable(
                    bankData, context, constraints, bankId, controller);
              }).toList()
            : controller.filteredBanks.map<DataRow>((bank) {
                final bankData = bank.data() as Map<String, dynamic>;
                final bankId = bank.id;
                return dataRowForTheTable(
                    bankData, context, constraints, bankId, controller);
              }).toList(),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> bankData, context,
    constraints, bankId, BanksAndOthersController controller) {
  return DataRow(cells: [
    DataCell(Text(
      bankData['account_name'] ?? '',
    )),
    DataCell(
      Text(
        bankData['account_number'] ?? 'no name',
      ),
    ),
    DataCell(
      Text(
        controller.currencyNames[bankData['country_id']] ?? 'no name',
      ),
    ),
    DataCell(
      Text(
        controller.getdataName(bankData['account_type'],controller.allAccountTypes),
      ),
    ),
    DataCell(
      Text(
        bankData['added_date'] != null && bankData['added_date'] != ''
            ? textToDate(bankData['added_date']) //
            : 'N/A',
      ),
    ),
    DataCell(Row(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        editSection(context, controller, bankData, constraints, bankId),
        deleteSection(controller, bankId, context),
      ],
    )),
  ]);
}

ElevatedButton deleteSection(
    BanksAndOthersController controller, bankId, context) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        alertDialog(
            context: context,
            content: "The bank will be deleted permanently",
            onPressed: () {
              controller.deleteBank(bankId);
            });
      },
      child: const Text("Delete"));
}

ElevatedButton editSection(context, BanksAndOthersController controller,
    Map<String, dynamic> bankData, constraints, bankId) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () async {
        controller.loadValues(bankData);
        banksDialog(
            constraints: constraints,
            controller: controller,
            canEdit: true,
            onPressed: controller.addingNewValue.value
                ? null
                : () {
                    controller.editBank(bankId);
                  });
      },
      child: const Text('Edit'));
}

ElevatedButton newbankesButton(BuildContext context,
    BoxConstraints constraints, BanksAndOthersController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.clearValues();
      banksDialog(
          constraints: constraints,
          controller: controller,
          canEdit: true,
          onPressed: controller.addingNewValue.value
              ? null
              : () async {
                  await controller.addNewBank();
                });
    },
    style: newButtonStyle,
    child: const Text('New Bank'),
  );
}
