import 'package:data_table_2/data_table_2.dart';
import 'package:datahubai/Controllers/Main%20screen%20controllers/ap_payment_type_controller.dart';
import 'package:datahubai/Models/ap%20payment%20types/ap_payment_types_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart'
    show searchBar;
import '../../../../Widgets/main screen widgets/ap_payment_type_widgets/ap_payment_dialog.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../consts.dart';

class ApPaymentType extends StatelessWidget {
  const ApPaymentType({super.key});

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
                  GetX<ApPaymentTypeController>(
                    init: ApPaymentTypeController(),
                    builder: (controller) {
                      return searchBar(
                        onChanged: (_) {
                          controller.filterTypes();
                        },
                        onPressedForClearSearch: () {
                          controller.search.value.clear();
                          controller.filterTypes();
                        },
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        title: 'Search for Types',
                        button: newTypeButton(context, constraints, controller),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<ApPaymentTypeController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return Center(child: loadingProcess);
                        }
                        if (controller.allApPaymentTypes.isEmpty) {
                          return const Center(child: Text('No Element'));
                        }
                        return SizedBox(
                          width: constraints.maxWidth,
                          child: tableOfScreens(
                            constraints: constraints,
                            context: context,
                            controller: controller,
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
  required ApPaymentTypeController controller,
}) {
  return PaginatedDataTable2(
    horizontalMargin: horizontalMarginForTable,
    columnSpacing: 5,
    sortColumnIndex: controller.sortColumnIndex.value,
    sortAscending: controller.isAscending.value,
    autoRowsToHeight: true,
    lmRatio: 2,
    columns: [
      const DataColumn2(size: ColumnSize.S, label: Text('')),
      DataColumn2(
        size: ColumnSize.L,
        label: AutoSizedText(text: 'Type', constraints: constraints),
        // onSort: controller.onSort,
      ),
      DataColumn2(
        size: ColumnSize.L,
        label: AutoSizedText(constraints: constraints, text: 'Creation Date'),
        // onSort: controller.onS ort,
      ),
    ],
    source: CardDataSourceForPaymentTypes(
      cards:
          controller.filteredApPaymentTypes.isEmpty &&
              controller.search.value.text.isEmpty
          ? controller.allApPaymentTypes
          : controller.filteredApPaymentTypes,
      context: context,
      constraints: constraints,
      controller: controller,
    ),
  );
}

DataRow dataRowForTheTable(
  APPaymentTypesModel typeData,
  BuildContext context,
  BoxConstraints constraints,
  String typeId,
  ApPaymentTypeController controller,
  int index,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            deleteSection(controller, typeId, context),
            editSection(context, controller, typeData, constraints, typeId),
          ],
        ),
      ),
      DataCell(Text(typeData.type ?? '')),
      DataCell(Text(textToDate(typeData.createdAt))),
    ],
  );
}

IconButton deleteSection(ApPaymentTypeController controller, typeId, context) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: context,
        content: "The type will be deleted permanently",
        onPressed: () {
          controller.deleteType(typeId);
        },
      );
    },
    icon: deleteIcon,
  );
}

IconButton editSection(
  BuildContext context,
  ApPaymentTypeController controller,
  APPaymentTypesModel typeData,
  BoxConstraints constraints,
  String typeId,
) {
  return IconButton(
    onPressed: () async {
      controller.type.text = typeData.type ?? '';
      apPaymentTypeDialog(
        constraints: constraints,
        controller: controller,
        canEdit: true,
        onPressed: controller.addingNewValue.value
            ? null
            : () {
                controller.updateType(typeId);
              },
      );
    },
    icon: editIcon,
  );
}

ElevatedButton newTypeButton(
  BuildContext context,
  BoxConstraints constraints,
  ApPaymentTypeController controller,
) {
  return ElevatedButton(
    onPressed: () {
      controller.type.clear();
      apPaymentTypeDialog(
        constraints: constraints,
        controller: controller,
        canEdit: true,
        onPressed: controller.addingNewValue.value
            ? null
            : () async {
                controller.addNewType();
              },
      );
    },
    style: newButtonStyle,
    child: const Text('New Type'),
  );
}

class CardDataSourceForPaymentTypes extends DataTableSource {
  final List<APPaymentTypesModel> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final ApPaymentTypeController controller;

  CardDataSourceForPaymentTypes({
    required this.cards,
    required this.context,
    required this.constraints,
    required this.controller,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= cards.length) return null;

    final card = cards[index];
    final cardId = card.id ?? '';

    return dataRowForTheTable(
      card,
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
