import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/payroll_runs_controller.dart';
import '../../../../Models/payroll runs/payroll_runs_model.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/payroll_runs_widgets/payroll_runs_dialog.dart';
import '../../../../consts.dart';

class PayrollRuns extends StatelessWidget {
  const PayrollRuns({super.key});

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
                GetX<PayrollRunsController>(
                  init: PayrollRunsController(),
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
                                  // controller.getAllPayrolls();
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
                    child: GetX<PayrollRunsController>(
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
  required PayrollRunsController controller,
}) {
  return PaginatedDataTable2(
    horizontalMargin: horizontalMarginForTable,
    columnSpacing: 5,
    autoRowsToHeight: true,
    renderEmptyRowsInTheEnd: true,
    columns: [
      DataColumn2(
        label: AutoSizedText(text: 'Run Number', constraints: constraints),
        size: ColumnSize.M,
      ),
      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Payroll Name'),
      ),

      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Period Name'),
      ),

      DataColumn2(
        size: ColumnSize.L,
        label: AutoSizedText(constraints: constraints, text: 'Description'),
      ),

      DataColumn2(
        size: ColumnSize.M,
        label: AutoSizedText(constraints: constraints, text: 'Payment Number'),
      ),
    ],
    source: CardDataSourceForEmployees(
      cards: controller.allPayrollRuns.isEmpty ? [] : controller.allPayrollRuns,
      context: context,
      constraints: constraints,
      controller: controller,
    ),
  );
}

DataRow dataRowForTheTable(
  PayrollRunsModel data,
  BuildContext context,
  BoxConstraints constraints,
  String employeeId,
  PayrollRunsController controller,
  int index,
) {
  return DataRow(
    cells: [
      DataCell(
        textForDataRowInTable(
          text: data.runNumber ?? '',
          color: Colors.blueGrey,
          isBold: true,
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.payrollName ?? '',
          isBold: true,
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.periodName ?? '',
          isBold: true,
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.description ?? '',
          isBold: true,
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.paymentNumber ?? '',
          maxWidth: null,
          color: Colors.red,
        ),
      ),
    ],
  );
}

ElevatedButton newPayrollButton(
  BuildContext context,
  BoxConstraints constraints,
  PayrollRunsController controller,
) {
  return ElevatedButton(
    onPressed: () {
      payrollRunsDialog(
        onPressedForDelete: null,
        context: context,
        constraints: constraints,
        controller: controller,
        onPressed: controller.addingNewValue.value
            ? null
            : () {
                controller.payrollRun();
              },
      );
    },
    style: newButtonStyle,
    child: const Text("New Payroll"),
  );
}

class CardDataSourceForEmployees extends DataTableSource {
  final List<PayrollRunsModel> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final PayrollRunsController controller;

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
