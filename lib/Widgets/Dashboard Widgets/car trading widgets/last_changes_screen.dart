import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../Models/car trading/last_changes_model.dart';
import '../../my_text_field.dart';

Widget lastChangesScreen({
  required BoxConstraints constraints,
  required BuildContext context,
}) {
  return GetBuilder<CarTradingDashboardController>(
    builder: (controller) {
      return FocusTraversalGroup(
        policy: WidgetOrderTraversalPolicy(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  spacing: 10,
                  children: [
                    myTextFormFieldWithBorder(
                      width: 120,
                      controller: controller.fromDateForChanges.value,
                      labelText: 'From Date',
                      onFieldSubmitted: (_) async {
                        normalizeDate(
                          controller.fromDateForChanges.value.text,
                          controller.fromDateForChanges.value,
                        );
                      },
                      onTapOutside: (_) {
                        normalizeDate(
                          controller.fromDateForChanges.value.text,
                          controller.fromDateForChanges.value,
                        );
                      },
                    ),
                    myTextFormFieldWithBorder(
                      width: 120,
                      controller: controller.toDateForChanges.value,
                      labelText: 'To Date',
                      onFieldSubmitted: (_) async {
                        normalizeDate(
                          controller.toDateForChanges.value.text,
                          controller.toDateForChanges.value,
                        );
                      },
                      onTapOutside: (_) {
                        normalizeDate(
                          controller.toDateForChanges.value.text,
                          controller.toDateForChanges.value,
                        );
                      },
                    ),
                    CustomSlidingSegmentedControl<int>(
                      height: 30,
                      initialValue: 1,
                      children: const {
                        1: Text('TODAY'),
                        2: Text('THIS MONTH'),
                        3: Text('THIS YEAR'),
                      },
                      decoration: BoxDecoration(
                        color: CupertinoColors.lightBackgroundGray,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      thumbDecoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(1),
                            blurRadius: 4.0,
                            spreadRadius: 1.0,
                            offset: const Offset(0.0, 2.0),
                          ),
                        ],
                      ),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInToLinear,
                      onValueChanged: (v) {
                        controller.onChooseForDatePickerForChanges(v);
                      },
                    ),
                    myTextFormFieldWithBorder(
                      width: 120,
                      controller: controller.minAmount.value,
                      labelText: 'Min Amount',
                    ),
                    myTextFormFieldWithBorder(
                      width: 120,
                      controller: controller.maxAmount.value,
                      labelText: 'Max Amount',
                    ),
                    const Spacer(),
                    GetX<CarTradingDashboardController>(
                      builder: (controller) {
                        return ElevatedButton(
                          style: findButtonStyle,
                          onPressed: controller.changesSearching.isFalse
                              ? () {
                                  controller.filterLastChangesSearch();
                                }
                              : null,
                          child: controller.changesSearching.isFalse
                              ? Text('Find', style: fontStyleForElevatedButtons)
                              : loadingProcess,
                        );
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: GetX<CarTradingDashboardController>(
                  builder: (controller) {
                    return PaginatedDataTable(
                      showCheckboxColumn: false,
                      rowsPerPage: 20,
                      columns: const [
                        DataColumn(label: Text('Change Date')),
                        DataColumn(label: Text('Type')),
                        DataColumn(label: Text('Brand')),
                        DataColumn(label: Text('Model')),
                        DataColumn(label: Text('Year')),
                        DataColumn(label: Text('Account')),
                        DataColumn(label: Text('Item')),
                        DataColumn(label: Text('Description')),
                        DataColumn(label: Text('Paid'), numeric: true),
                        DataColumn(label: Text('Received'), numeric: true),
                      ],
                      source: LastChangesTradeDataSource(
                        trades: controller.lastChanges.isEmpty
                            ? []
                            : controller.lastChanges,
                        context: context,
                        constraints: constraints,
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
  );
}

DataRow dataRowForTheTable(
  LastCarTradingChangesModel data,
  BuildContext context,
  BoxConstraints constraints,
  String tradeId,
  CarTradingDashboardController controller,
  int index,
) {
  // final isEvenRow = index % 2 == 0;
  final bool isSelected = controller.selectedRowIndex.value == index;

  return DataRow(
    selected: isSelected,
    onSelectChanged: (selected) {
      controller.selectRow(index);
    },
    color: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.grey.shade300;
      }
      return index.isEven ? Colors.grey.shade50 : Colors.white;
    }),
    cells: [
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          text: textToDate(data.updatedAt),
          color: Colors.blueGrey,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          text: data.type?.toString().toUpperCase() ?? '',
          color: data.type == 'car' ? Colors.red : Colors.purple,
        ),
      ),
      DataCell(
        textForDataRowInTable(formatDouble: false, text: data.brandName ?? ''),
      ),
      DataCell(
        textForDataRowInTable(text: data.modelName ?? '', formatDouble: false),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.year ?? '',
          formatDouble: false,
          color: Colors.teal,
          isBold: true,
        ),
      ),

      DataCell(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(5),
          ),
          child: textForDataRowInTable(
            text: data.accountName ?? '',
            maxWidth: null,
            color: data.accountName?.toLowerCase() == 'cash'
                ? Colors.green
                : Colors.lightBlue,
          ),
        ),
      ),
      DataCell(
        textForDataRowInTable(text: data.itemName ?? '', maxWidth: null),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.description == '' ? '-' : data.description ?? '',
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.pay.toString(),
          formatDouble: true,
          color: Colors.red,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: data.receive.toString(),
          formatDouble: true,
          color: Colors.green,
        ),
      ),
    ],
  );
}

class LastChangesTradeDataSource extends DataTableSource {
  final List<LastCarTradingChangesModel> trades;
  final BuildContext context;
  final BoxConstraints constraints;
  final CarTradingDashboardController controller;

  LastChangesTradeDataSource({
    required this.trades,
    required this.context,
    required this.constraints,
    required this.controller,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= trades.length) return null;

    final trade = trades[index];
    final tradeId = trade.id.toString();

    return dataRowForTheTable(
      trade,
      context,
      constraints,
      tradeId,
      controller,
      index,
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => trades.length;

  @override
  int get selectedRowCount => 0;
}
