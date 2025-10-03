import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../Models/car trading/car_trade_model.dart';
import '../../../consts.dart';
import '../../main screen widgets/auto_size_box.dart';
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
          headingTextStyle: fontStyleForTableHeader,
          dataTextStyle: regTextStyle,
        ),
        child: PaginatedDataTable(
          controller: controller.scrollControllerForTable,
          headingRowHeight: 45,
          showEmptyRows: false,
          showFirstLastButtons: true,
          rowsPerPage: controller.pagesPerPage.value,
          showCheckboxColumn: false,
          horizontalMargin: horizontalMarginForTable,
          dataRowMaxHeight: 40,
          dataRowMinHeight: 30,
          columnSpacing: 5,
          headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
          columns: [
            const DataColumn(label: Text('')),
            DataColumn(
              label: AutoSizedText(text: 'Brand', constraints: constraints),
            ),
            DataColumn(
              label: AutoSizedText(text: 'Model', constraints: constraints),
            ),
            DataColumn(
              label: AutoSizedText(text: 'Year', constraints: constraints),
            ),
            DataColumn(
              label: AutoSizedText(text: 'Status', constraints: constraints),
            ),
            DataColumn(
              label: AutoSizedText(text: 'Color in', constraints: constraints),
            ),
            DataColumn(
              label: AutoSizedText(text: 'Color out', constraints: constraints),
            ),
            DataColumn(
              label: AutoSizedText(
                text: 'Specification',
                constraints: constraints,
              ),
            ),
            DataColumn(
              label: AutoSizedText(
                text: 'Engine Size',
                constraints: constraints,
              ),
            ),
            DataColumn(
              label: AutoSizedText(text: 'Mileage', constraints: constraints),
            ),
            DataColumn(
              label: AutoSizedText(
                text: 'Bought From',
                constraints: constraints,
              ),
            ),
            DataColumn(
              label: AutoSizedText(text: 'Sold To', constraints: constraints),
            ),
            DataColumn(
              label: AutoSizedText(constraints: constraints, text: 'Buy Date'),
            ),
            DataColumn(
              label: AutoSizedText(constraints: constraints, text: 'Sell Date'),
            ),
            DataColumn(
              numeric: true,
              label: AutoSizedText(constraints: constraints, text: 'Paid'),
            ),
            DataColumn(
              numeric: true,
              label: AutoSizedText(constraints: constraints, text: 'Received'),
            ),
            DataColumn(
              numeric: true,
              label: AutoSizedText(constraints: constraints, text: 'Net'),
            ),
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
  index,
) {
  final isEvenRow = index % 2 == 0;
  return DataRow(
    color: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.grey.shade400;
      }
      return isEvenRow ? Colors.grey.shade200 : Colors.white;
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
      DataCell(statusBox(tradeData.status.toString())),
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
