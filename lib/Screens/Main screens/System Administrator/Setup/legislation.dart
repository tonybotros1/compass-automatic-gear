import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/legislation_controller.dart';
import '../../../../Models/legislations model/legislation_model.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/legislation_widgets/legislation_dialog.dart';
import '../../../../Widgets/my_text_field.dart';
import '../../../../consts.dart';

class Legislation extends StatefulWidget {
  const Legislation({super.key});

  @override
  State<Legislation> createState() => _LegislationState();
}

class _LegislationState extends State<Legislation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: screenPadding,
            child: Column(
              children: [
                GetBuilder<LegislationController>(
                  init: LegislationController(),
                  builder: (controller) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth - 28,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: 10,
                          children: [
                            Row(
                              spacing: 10,
                              children: [
                                myTextFormFieldWithBorder(
                                  width: 250,
                                  labelText: 'Name',
                                  controller: controller.nameFilter,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                GetX<LegislationController>(
                  builder: (controller) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth - 28,
                        ),
                        child: Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,

                          children: [
                            newButton(constraints, controller),

                            Row(
                              spacing: 10,
                              children: [
                                ElevatedButton(
                                  style: findButtonStyle,
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
                                    'Clear',
                                    style: fontStyleForElevatedButtons,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GetX<LegislationController>(
                      builder: (controller) {
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
                ),
              ],
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
  required LegislationController controller,
}) {
  return PaginatedDataTable2(
    horizontalMargin: horizontalMarginForTable,
    columnSpacing: 5,
    autoRowsToHeight: true,
    renderEmptyRowsInTheEnd: true,
    columns: [
      const DataColumn2(label: Text(''), size: ColumnSize.S),
      DataColumn2(
        label: AutoSizedText(text: 'Name', constraints: constraints),
        size: ColumnSize.M,
      ),
    ],
    source: CardDataSourceForLegislation(
      cards: controller.allLegislations.isEmpty
          ? []
          : controller.allLegislations,
      context: context,
      constraints: constraints,
      controller: controller,
    ),
  );
}

DataRow dataRowForTheTable(
  LegislationModel data,
  BuildContext context,
  BoxConstraints constraints,
  String employeeId,
  LegislationController controller,
  int index,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            deleteSection(controller, employeeId, context),
            editSection(controller, data, constraints, employeeId),
          ],
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.name ?? '',
          color: Colors.blueGrey,
          isBold: true,
        ),
      ),
    ],
  );
}

ElevatedButton newButton(
  BoxConstraints constraints,
  LegislationController controller,
) {
  return ElevatedButton(
    onPressed: () {
      controller.name.clear();
      controller.name.clear();
      legislationDialog(
        constraints: constraints,
        controller: controller,
        onPressed: controller.addingNewValue.value
            ? null
            : () async {
                await controller.addNewLegislation();
              },
      );
    },
    style: newButtonStyle,
    child: const Text('New Legislation'),
  );
}

IconButton deleteSection(
  LegislationController controller,
  String employeeId,
  BuildContext context,
) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: context,
        content: "The doc will be deleted permanently",
        onPressed: () {
          controller.deletedLegislation(employeeId);
        },
      );
    },
    icon: deleteIcon,
  );
}

IconButton editSection(
  LegislationController controller,
  LegislationModel data,
  BoxConstraints constraints,
  String elementID,
) {
  return IconButton(
    onPressed: () async {
      controller.name.text = data.name ?? '';
      legislationDialog(
        constraints: constraints,
        controller: controller,
        onPressed: controller.addingNewValue.value
            ? null
            : () async {
                await controller.updateLegislation(elementID);
              },
      );
    },
    icon: editIcon,
  );
}

class CardDataSourceForLegislation extends DataTableSource {
  final List<LegislationModel> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final LegislationController controller;

  CardDataSourceForLegislation({
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
