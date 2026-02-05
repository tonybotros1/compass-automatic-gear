import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../Models/car trading/car_trade_model.dart';
import '../../../consts.dart';
import 'car_trade_dialog.dart';

Widget tableOfCarTrades({
  required BoxConstraints constraints,
  required BuildContext context,
}) {
  return GetX<CarTradingDashboardController>(
    builder: (controller) {
      bool istradingLoading = controller.filteredTrades.isEmpty;
      return DataTableTheme(
        data: DataTableThemeData(
          dataRowColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.grey.shade400;
            }
            return Colors.white;
          }),
          headingTextStyle: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          dataTextStyle: TextStyle(
            color: Colors.grey.shade800,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        child: PaginatedDataTable2(
          border: TableBorder.symmetric(
            inside: BorderSide(color: Colors.grey.shade200, width: 0.5),
          ),
          // controller: controller.scrollControllerForTable,
          headingRowHeight: 45,
          // showEmptyRows: true,
          autoRowsToHeight: true,
          dividerThickness: .3,
          showFirstLastButtons: true,
          rowsPerPage: controller.numberOfCars.value <= 8
              ? 8
              : controller.numberOfCars.value >= 30
              ? 30
              : controller.numberOfCars.value,
          showCheckboxColumn: false,
          horizontalMargin: horizontalMarginForTable,
          // dataRowMaxHeight: 40,
          // dataRowMinHeight: 30,
          columnSpacing: 5,
          // headingRowColor: const WidgetStatePropertyAll(Color(0xffF4F5F8)),
          columns: const [
            DataColumn(label: Text('')),
            DataColumn(label: Text('Brand')),
            DataColumn(label: Text('Model')),
            DataColumn(label: Text('Year')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Color in')),
            DataColumn(label: Text('Color out')),
            DataColumn(label: Text('Specification')),
            DataColumn(label: Text('Engine Size')),
            DataColumn(label: Text('Mileage')),
            DataColumn(label: Text('Bought From')),
            DataColumn(label: Text('Sold To')),
            DataColumn(label: Text('Buy Date')),
            DataColumn(label: Text('Sell Date')),
            DataColumn(numeric: true, label: Text('Paid')),
            DataColumn(numeric: true, label: Text('Received')),
            DataColumn(numeric: true, label: Text('Net')),
          ],
          source: TradeDataSource(
            trades: istradingLoading ? [] : controller.filteredTrades,
            context: context,
            constraints: constraints,
            controller: controller,
          ),
        ),
      );
    },
  );
}

DataRow dataRowForTheTable(
  CarTradeModel tradeData,
  BuildContext context,
  BoxConstraints constraints,
  String tradeId,
  CarTradingDashboardController controller,
  int index,
) {
  final isEvenRow = index % 2 == 0;
  return DataRow(
    color: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.grey.shade400;
      }
      return isEvenRow ? Colors.white : Colors.grey.shade100;
    }),
    cells: [
      DataCell(editSection(tradeData: tradeData, id: tradeId)),
      DataCell(
        textForDataRowInTable(
          formatDouble: false,
          text: tradeData.carBrand.toString(),
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: tradeData.carModel.toString(),
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: tradeData.year.toString(),
          formatDouble: false,
          color: Colors.teal,
          isBold: true,
        ),
      ),
      DataCell(statusBox(tradeData.status.toString(), width: 100, hieght: 35)),
      DataCell(
        textForDataRowInTable(
          text: tradeData.colorIn.toString(),
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: tradeData.colorOut.toString(),
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: tradeData.specification.toString(),
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: tradeData.engineSize.toString(),
          formatDouble: false,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: tradeData.mileage.toString(),
          formatDouble: false,
          color: Colors.deepOrange,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: tradeData.boughtFrom.toString(),
          formatDouble: false,
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: tradeData.soldTo.toString(),
          formatDouble: false,
          maxWidth: null,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: textToDate(tradeData.buyDate ?? ''),
          formatDouble: false,
          color: Colors.purple,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: textToDate(tradeData.sellDate ?? ''),
          formatDouble: false,
          color: Colors.blue,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: tradeData.totalPay.toString(),
          color: Colors.red,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: tradeData.totalReceive.toString(),
          color: Colors.green,
          isBold: true,
        ),
      ),
      DataCell(
        textForDataRowInTable(
          text: tradeData.net.toString(),
          color: Colors.blueGrey,
          isBold: true,
        ),
      ),
    ],
  );
}

Widget editSection({required CarTradeModel tradeData, required String id}) {
  return GetX<CarTradingDashboardController>(
    builder: (controller) {
      final isLoading = controller.buttonLoadingStates[id] ?? false;

      return IconButton(
        onPressed: isLoading == false
            ? () async {
                controller.setButtonLoading(id, true);
                await controller.loadValues(tradeData);
                controller.setButtonLoading(id, false);
                carTradesDialog(
                  tradeID: tradeData.id ?? '',
                  controller: controller,
                  canEdit: true,
                  onPressed: controller.addingNewValue.value
                      ? null
                      : () async {
                          controller.addNewTrade();
                        },
                );
              }
            : null,
        icon: isLoading == false ? editIcon : loadingProcess,
      );
    },
  );
}

class TradeDataSource extends DataTableSource {
  final List<CarTradeModel> trades;
  final BuildContext context;
  final BoxConstraints constraints;
  final CarTradingDashboardController controller;

  TradeDataSource({
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
