import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/payroll_controller.dart';
import '../../../../Models/payroll/payroll_model.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/payroll_widgets/payroll_dialog.dart';
import '../../../../consts.dart';

class Payroll extends StatelessWidget {
  const Payroll({super.key});

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
                GetX<PayrollController>(
                  init: PayrollController(),
                  builder: (controller) {
                    return Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: [
                        newPayrollButton(context, constraints, controller),

                        ElevatedButton(
                          style: findButtonStyle,
                          onPressed: controller.isScreenLoding.isFalse
                              ? () async {
                                  controller.getAllPayrolls();
                                }
                              : null,
                          child: controller.isScreenLoding.isFalse
                              ? Text('Find', style: fontStyleForElevatedButtons)
                              : loadingProcess,
                        ),
                      ],
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
                    child: GetX<PayrollController>(
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
  required PayrollController controller,
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
        size: ColumnSize.S,
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Notes'),
      ),

      DataColumn2(
        size: ColumnSize.L,
        label: AutoSizedText(constraints: constraints, text: 'Notes'),
      ),
    ],
    source: CardDataSourceForEmployees(
      cards: controller.allPayrolls.isEmpty ? [] : controller.allPayrolls,
      context: context,
      constraints: constraints,
      controller: controller,
    ),
  );
}

DataRow dataRowForTheTable(
  PayrollModel data,
  BuildContext context,
  BoxConstraints constraints,
  String employeeId,
  PayrollController controller,
  int index,
) {
  return DataRow(
    cells: [
      DataCell(editSection(controller, data, constraints, employeeId)),
      DataCell(
        textForDataRowInTable(
          text: data.name ?? '',
          color: Colors.blueGrey,
          isBold: true,
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.paymentType ?? '',
          isBold: true,
          maxWidth: null,
        ),
      ),
      DataCell(textForDataRowInTable(text: data.notes ?? '', maxWidth: null)),
    ],
  );
}

IconButton editSection(
  PayrollController controller,
  PayrollModel data,
  BoxConstraints constraints,
  String id,
) {
  return IconButton(
    onPressed: () async {
      controller.currentPayrollId.value = id;
      await controller.getCurrentPayrollDetails(id);
      payrollDialog(
        onPressedForDelete: () {
          alertDialog(
            context: Get.context!,
            content: "Are you sure you want to delete this payroll?",
            onPressed: () {
              controller.deletePayroll(id);
            },
          );
        },
        context: Get.context!,
        constraints: constraints,
        controller: controller,
        onPressed: controller.addingNewValue.value
            ? null
            : () {
                controller.addNewPayroll();
              },
      );
    },
    icon: editIcon,
  );
}

ElevatedButton newPayrollButton(
  BuildContext context,
  BoxConstraints constraints,
  PayrollController controller,
) {
  return ElevatedButton(
    onPressed: () {
      controller.name.clear();
      controller.notes.clear();
      controller.paymentType.clear();
      controller.allPeriodDetails.clear();
      controller.currentPayrollId.value = '';
      controller.paymentTypeId.value = '';
      payrollDialog(
        onPressedForDelete: null,
        context: context,
        constraints: constraints,
        controller: controller,
        onPressed: controller.addingNewValue.value
            ? null
            : () {
                controller.addNewPayroll();
              },
      );
    },
    style: newButtonStyle,
    child: const Text("New Payroll"),
  );
}

class CardDataSourceForEmployees extends DataTableSource {
  final List<PayrollModel> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final PayrollController controller;

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
