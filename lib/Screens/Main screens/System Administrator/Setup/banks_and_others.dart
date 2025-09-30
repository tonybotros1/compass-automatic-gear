import 'package:datahubai/Models/banks/banks_model.dart';
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
                        onChanged: (_) {
                          controller.filterBanks();
                        },
                        onPressedForClearSearch: () {
                          controller.search.value.clear();
                          controller.filterBanks();
                        },
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        title: 'Search for bankes',
                        button: newbankesButton(
                          context,
                          constraints,
                          controller,
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<BanksAndOthersController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return Center(child: loadingProcess);
                        }
                        if (controller.allBanks.isEmpty) {
                          return const Center(child: Text('No Element'));
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
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

Widget tableOfScreens({
  required BoxConstraints constraints,
  required BuildContext context,
  required BanksAndOthersController controller,
}) {
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
      const DataColumn(label: Text('')),
      DataColumn(
        label: AutoSizedText(text: 'Account Name', constraints: constraints),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Account Number'),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Currency'),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Country'),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Rate'),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Account Type'),
        onSort: controller.onSort,
      ),

      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Creation Date'),
        onSort: controller.onSort,
      ),
    ],
    rows:
        controller.filteredBanks.isEmpty && controller.search.value.text.isEmpty
        ? controller.allBanks.map<DataRow>((bank) {
            final bankId = bank.id;
            return dataRowForTheTable(
              bank,
              context,
              constraints,
              bankId,
              controller,
            );
          }).toList()
        : controller.filteredBanks.map<DataRow>((bank) {
            final bankId = bank.id;
            return dataRowForTheTable(
              bank,
              context,
              constraints,
              bankId,
              controller,
            );
          }).toList(),
  );
}

DataRow dataRowForTheTable(
  BanksModel bankData,
  context,
  constraints,
  bankId,
  BanksAndOthersController controller,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            deleteSection(controller, bankId, context),
            editSection(context, controller, bankData, constraints, bankId),
          ],
        ),
      ),
      DataCell(Text(bankData.accountName ?? '')),
      DataCell(Text(bankData.accountNumber ?? '')),
      DataCell(Text(bankData.currency ?? '')),
      DataCell(Text(bankData.countryName ?? '')),
      DataCell(Text(bankData.rate.toString())),
      DataCell(Text(bankData.accountTypeName ?? '')),
      DataCell(Text(textToDate(bankData.createdAt))),
    ],
  );
}

IconButton deleteSection(
  BanksAndOthersController controller,
  String bankId,
  BuildContext context,
) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: context,
        content: "The bank will be deleted permanently",
        onPressed: () {
          controller.deleteBank(bankId);
        },
      );
    },
    icon: deleteIcon,
  );
}

IconButton editSection(
  BuildContext context,
  BanksAndOthersController controller,
  BanksModel bankData,
  constraints,
  bankId,
) {
  return IconButton(
    onPressed: () async {
      controller.loadValues(bankData);
      banksDialog(
        constraints: constraints,
        controller: controller,
        canEdit: true,
        onPressed: controller.addingNewValue.value
            ? null
            : () {
                controller.updateBank(bankId);
              },
      );
    },
    icon: editIcon,
  );
}

ElevatedButton newbankesButton(
  BuildContext context,
  BoxConstraints constraints,
  BanksAndOthersController controller,
) {
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
                controller.addNewBank();
              },
      );
    },
    style: newButtonStyle,
    child: const Text('New Bank'),
  );
}
