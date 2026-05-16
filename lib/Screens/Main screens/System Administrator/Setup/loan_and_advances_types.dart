import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/loan_and_advances_types_controller.dart';
import '../../../../Models/leave types/leave_types_model.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/loan_and_advances_types_widgets/loan_and_advances_types_dialog.dart';
import '../../../../Widgets/menu_dialog.dart';
import '../../../../Widgets/my_text_field.dart';
import '../../../../consts.dart';

class LoanAndAdvancesTypes extends StatelessWidget {
  const LoanAndAdvancesTypes({super.key});

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
                GetBuilder<LoanAndAdvancesTypesController>(
                  init: LoanAndAdvancesTypesController(),
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
                                myTextFormFieldWithBorder(
                                  width: 250,
                                  labelText: 'Code',
                                  controller: controller.codeFilter,
                                ),
                                MenuWithValues(
                                  labelText: 'Based Element',
                                  headerLqabel: 'Based Elements',
                                  dialogWidth: 600,
                                  width: 300,
                                  controller: controller.basedElementFilter,
                                  displayKeys: const ['name'],
                                  displaySelectedKeys: const ['name'],
                                  onOpen: () {
                                    return controller.getAllPayrollElements();
                                  },
                                  onDelete: () {
                                    controller.basedElementFilterId.value = "";
                                    controller.basedElementFilter.clear();
                                  },
                                  onSelected: (value) {
                                    controller.basedElementFilterId.value =
                                        value['_id']?.toString() ?? '';
                                    controller.basedElementFilter.text =
                                        value['name']?.toString() ?? '';
                                  },
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
                GetX<LoanAndAdvancesTypesController>(
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
                            newEmployeeButton(context, constraints, controller),

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
                    child: GetX<LoanAndAdvancesTypesController>(
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
  required LoanAndAdvancesTypesController controller,
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
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Code'),
      ),

      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Based Element'),
      ),
    ],
    source: CardDataSourceForEmployees(
      cards: controller.allLeaveTypes.isEmpty ? [] : controller.allLeaveTypes,
      context: context,
      constraints: constraints,
      controller: controller,
    ),
  );
}

DataRow dataRowForTheTable(
  LeaveTypesModel data,
  BuildContext context,
  BoxConstraints constraints,
  String employeeId,
  LoanAndAdvancesTypesController controller,
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
            editSection(context, controller, data, constraints, employeeId),
          ],
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.name ?? '',
          color: Colors.blueGrey,
          isBold: true,
          maxWidth: null,
        ),
      ),
      DataCell(textForDataRowInTable(text: data.code ?? '', maxWidth: null)),
      DataCell(
        textForDataRowInTable(text: data.basedElement ?? '', maxWidth: null),
      ),
    ],
  );
}

IconButton deleteSection(
  LoanAndAdvancesTypesController controller,
  String id,
  BuildContext context,
) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: context,
        content: "The type will be deleted permanently",
        onPressed: () async {
          final deleted = await controller.deleteLeaveType(id);
          Get.back();
          if (!deleted) {
            alertMessage(
              context: Get.context!,
              content: 'Could not delete this type',
            );
          }
        },
      );
    },
    icon: deleteIcon,
  );
}

IconButton editSection(
  BuildContext context,
  LoanAndAdvancesTypesController controller,
  LeaveTypesModel data,
  BoxConstraints constraints,
  String id,
) {
  return IconButton(
    onPressed: () async {
      controller.clearValues();
      controller.name.text = data.name ?? '';
      controller.code.text = data.code ?? '';
      controller.basedElement.text = data.basedElement ?? '';
      controller.basedElementId.value = data.basedElementId ?? '';
      loanAndAdvancesTypesDialog(
        constraints: constraints,
        controller: controller,
        onPressed: controller.addingNewValue.value
            ? null
            : () {
                controller.editLeaveType(id);
              },
      );
    },
    icon: editIcon,
  );
}

ElevatedButton newEmployeeButton(
  BuildContext context,
  BoxConstraints constraints,
  LoanAndAdvancesTypesController controller,
) {
  return ElevatedButton(
    onPressed: () {
      controller.clearValues();
      loanAndAdvancesTypesDialog(
        constraints: constraints,
        controller: controller,
        onPressed: controller.addingNewValue.value
            ? null
            : () {
                controller.addNewLeaveType();
              },
      );
    },
    style: newButtonStyle,
    child: const Text("New Type"),
  );
}

class CardDataSourceForEmployees extends DataTableSource {
  final List<LeaveTypesModel> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final LoanAndAdvancesTypesController controller;

  CardDataSourceForEmployees({
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
