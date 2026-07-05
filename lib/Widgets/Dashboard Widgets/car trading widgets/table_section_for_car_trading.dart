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
          dataRowHeight: 82,
          minWidth: 1450,
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
            DataColumn2(label: SizedBox.shrink(), fixedWidth: 88),
            DataColumn2(label: Text('VEHICLE'), fixedWidth: 360),
            DataColumn2(label: Text('VIN'), fixedWidth: 180),
            DataColumn2(label: Text('BOUGHT BY'), fixedWidth: 180),
            DataColumn2(label: Text('SOLD BY'), fixedWidth: 180),
            DataColumn2(numeric: true, label: Text('PAID')),
            DataColumn2(numeric: true, label: Text('RECEIVED')),
            DataColumn2(numeric: true, label: Text('NET')),
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
      DataCell(_VehicleSummary(trade: tradeData)),
      DataCell(_VinCell(vin: tradeData.vin)),
      DataCell(
        _PartyDateSummary(
          name: tradeData.boughtBy,
          date: textToDate(tradeData.buyDate ?? ''),
          accentColor: Colors.purple,
        ),
      ),
      DataCell(
        _PartyDateSummary(
          name: tradeData.soldBy,
          date: textToDate(tradeData.sellDate ?? ''),
          accentColor: Colors.blue,
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

class _VinCell extends StatelessWidget {
  const _VinCell({required this.vin});

  final String? vin;

  @override
  Widget build(BuildContext context) {
    final value = vin?.trim() ?? '';
    if (value.isEmpty) {
      return Text(
        ' - ',
        style: TextStyle(
          color: Colors.blueGrey.shade300,
          fontWeight: FontWeight.w700,
        ),
      );
    }

    return Tooltip(
      message: value,
      child: Row(
        children: [
          Icon(
            Icons.fingerprint_rounded,
            size: 14,
            color: Colors.blueGrey.shade300,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.blueGrey.shade700,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PartyDateSummary extends StatelessWidget {
  const _PartyDateSummary({
    required this.name,
    required this.date,
    required this.accentColor,
  });

  final String? name;
  final String date;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final normalizedName = name?.trim() ?? '';
    final normalizedDate = date.trim();
    if (normalizedName.isEmpty && normalizedDate.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: 160,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (normalizedName.isNotEmpty)
            Row(
              children: [
                Icon(
                  Icons.person_outline_rounded,
                  size: 14,
                  color: Colors.blueGrey.shade400,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    normalizedName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.blueGrey.shade800,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          if (normalizedName.isNotEmpty && normalizedDate.isNotEmpty)
            const SizedBox(height: 5),
          if (normalizedDate.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: accentColor.withValues(alpha: 0.18)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 11,
                    color: accentColor.withValues(alpha: 0.75),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      normalizedDate,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: accentColor.withValues(alpha: 0.85),
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _VehicleSummary extends StatelessWidget {
  const _VehicleSummary({required this.trade});

  final CarTradeModel trade;

  String _value(String? value) {
    final normalized = value?.trim() ?? '';
    return normalized.isEmpty ? '—' : normalized;
  }

  String _formatMileage(int mileage) {
    return mileage.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
      case 'open':
      case 'active':
        return Colors.green.shade600;
      case 'sold':
      case 'posted':
        return Colors.teal.shade600;
      case 'cancelled':
      case 'inactive':
      case 'returned':
        return Colors.red.shade600;
      case 'draft':
        return Colors.blueGrey.shade600;
      case 'approved':
        return Colors.indigo.shade500;
      default:
        return Colors.orange.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brand = trade.carBrand?.trim() ?? '';
    final model = trade.carModel?.trim() ?? '';
    final year = trade.year?.trim() ?? '';
    final status = trade.status?.trim() ?? '';
    final statusColor = _statusColor(status);

    return SizedBox(
      width: 340,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: brand.isEmpty ? 'Unknown vehicle' : brand,
                        style: TextStyle(color: Colors.blueGrey.shade900),
                      ),
                      if (model.isNotEmpty)
                        TextSpan(
                          text: '  $model',
                          style: TextStyle(color: Colors.blueGrey.shade700),
                        ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                _detailLine(
                  icon: Icons.palette_outlined,
                  firstLabel: 'Exterior',
                  firstValue: _value(trade.colorOut),
                  secondLabel: 'Interior',
                  secondValue: _value(trade.colorIn),
                ),
                const SizedBox(height: 3),
                _detailLine(
                  icon: Icons.settings_outlined,
                  firstLabel: 'Spec',
                  firstValue: _value(trade.specification),
                  secondLabel: 'Engine',
                  secondValue: _value(trade.engineSize),
                ),
              ],
            ),
          ),
          if (year.isNotEmpty ||
              status.isNotEmpty ||
              trade.mileage != null) ...[
            const SizedBox(width: 10),
            SizedBox(
              width: 88,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (year.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blueGrey.shade100),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 10,
                              color: Colors.blueGrey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                year,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.blueGrey.shade700,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (year.isNotEmpty && status.isNotEmpty)
                      const SizedBox(height: 5),
                    if (status.isNotEmpty)
                      _StatusPill(status: status, color: statusColor),
                    if ((year.isNotEmpty || status.isNotEmpty) &&
                        trade.mileage != null)
                      const SizedBox(height: 5),
                    if (trade.mileage != null)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.deepOrange.shade100),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.speed_outlined,
                              size: 11,
                              color: Colors.deepOrange.shade500,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                '${_formatMileage(trade.mileage!)} km',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.deepOrange.shade700,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _detailLine({
    required IconData icon,
    required String firstLabel,
    required String firstValue,
    required String secondLabel,
    required String secondValue,
  }) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Colors.blueGrey.shade300),
        const SizedBox(width: 5),
        Expanded(
          child: Text.rich(
            TextSpan(
              style: TextStyle(color: Colors.grey.shade600, fontSize: 10.5),
              children: [
                TextSpan(
                  text: '$firstLabel: ',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: firstValue),
                TextSpan(text: '  •  $secondLabel: '),
                TextSpan(text: secondValue),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status, required this.color});

  final String status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              status.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget editSection({required CarTradeModel tradeData, required String id}) {
  return GetX<CarTradingDashboardController>(
    builder: (controller) {
      final infosLoadingKey = '$id:infos';
      final itemsLoadingKey = '$id:items';
      final infosLoading =
          controller.buttonLoadingStates[infosLoadingKey] ?? false;
      final itemsLoading =
          controller.buttonLoadingStates[itemsLoadingKey] ?? false;
      final rowIsLoading = infosLoading || itemsLoading;

      Future<void> openScreen(String screen, String loadingKey) async {
        controller.setButtonLoading(loadingKey, true);
        try {
          await controller.loadValues(tradeData);
        } finally {
          controller.setButtonLoading(loadingKey, false);
        }

        await carTradesDialog(
          screen: screen,
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

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TradeActionButton(
            label: 'INFOS',
            color: Colors.blueGrey.shade600,
            isLoading: infosLoading,
            onPressed: rowIsLoading
                ? null
                : () => openScreen('car_trading', infosLoadingKey),
          ),
          const SizedBox(height: 5),
          _TradeActionButton(
            label: 'ITEMS',
            color: Colors.teal.shade600,
            isLoading: itemsLoading,
            onPressed: rowIsLoading
                ? null
                : () => openScreen('items', itemsLoadingKey),
          ),
        ],
      );
    },
  );
}

class _TradeActionButton extends StatelessWidget {
  const _TradeActionButton({
    required this.label,
    required this.color,
    required this.onPressed,
    required this.isLoading,
  });

  final String label;
  final Color color;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      height: 29,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          backgroundColor: color.withValues(alpha: 0.06),
          disabledForegroundColor: color.withValues(alpha: 0.45),
          disabledBackgroundColor: color.withValues(alpha: 0.03),
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          side: BorderSide(color: color.withValues(alpha: 0.35)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: isLoading
            ? SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2, color: color),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.3,
                ),
              ),
      ),
    );
  }
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
