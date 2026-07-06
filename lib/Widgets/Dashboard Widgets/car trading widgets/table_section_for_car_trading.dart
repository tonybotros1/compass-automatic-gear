import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollCacheExtent;
import 'package:get/get.dart';

import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../Models/car trading/car_trade_model.dart';
import '../../../consts.dart';
import 'car_trade_dialog.dart';

const _pageBackground = Colors.white;
const _surface = Colors.white;
const _line = Color(0xFFDCE6E8);
const _text = Color(0xFF26343A);
const _muted = Color(0xFF6F8088);
const _primary = Color.fromARGB(255, 1, 42, 40);
const _orange = Color(0xFFF26D32);
const _red = Color(0xFFED554E);
const _green = Color(0xFF2DA85A);

Widget tableOfCarTrades({
  required BoxConstraints constraints,
  required BuildContext context,
}) {
  return GetX<CarTradingDashboardController>(
    builder: (controller) {
      final trades = controller.filteredTrades.toList(growable: false);
      final isSearching = controller.searching.value;

      return _CarTradeCardsView(trades: trades, isSearching: isSearching);
    },
  );
}

class _CarTradeCardsView extends StatelessWidget {
  const _CarTradeCardsView({required this.trades, required this.isSearching});

  final List<CarTradeModel> trades;
  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    if (isSearching && trades.isEmpty) {
      return const ColoredBox(
        color: _pageBackground,
        child: Center(
          child: CircularProgressIndicator(color: _primary, strokeWidth: 2.5),
        ),
      );
    }

    if (trades.isEmpty) {
      return const ColoredBox(
        color: _pageBackground,
        child: _EmptyTradesState(),
      );
    }

    return ColoredBox(
      color: _pageBackground,
      child: LayoutBuilder(
        builder: (context, gridConstraints) {
          final horizontalPadding = gridConstraints.maxWidth < 600 ? 8.0 : 12.0;
          final availableWidth =
              gridConstraints.maxWidth - (horizontalPadding * 2);
          final naturalColumnCount = (availableWidth / 460).ceil();
          final columnCount = gridConstraints.maxWidth < 600
              ? 1
              : naturalColumnCount > 1
              ? naturalColumnCount - 1
              : 1;

          return GridView.builder(
            key: const PageStorageKey<String>('car-trade-cards'),
            scrollCacheExtent: const ScrollCacheExtent.pixels(160),
            addAutomaticKeepAlives: false,
            addSemanticIndexes: false,
            addRepaintBoundaries: true,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              10,
              horizontalPadding,
              10,
            ),
            itemCount: trades.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount,
              mainAxisExtent: 380,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final trade = trades[index];
              return _CarTradeCard(
                key: ValueKey(trade.id ?? 'trade-$index'),
                trade: trade,
              );
            },
          );
        },
      ),
    );
  }
}

class _CarTradeCard extends StatelessWidget {
  const _CarTradeCard({super.key, required this.trade});

  final CarTradeModel trade;

  String _display(String? value) {
    final normalized = value?.trim() ?? '';
    return normalized.isEmpty ? '—' : normalized;
  }

  String _mileage(int? value) {
    if (value == null) return '';
    return '${qtyFormat.format(value)} km';
  }

  String _money(double? value) => priceFormat.format(value ?? 0);

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
      case 'open':
      case 'active':
        return _green;
      case 'sold':
      case 'posted':
        return _primary;
      case 'cancelled':
      case 'inactive':
      case 'returned':
        return _red;
      case 'approved':
        return const Color(0xFF5667B3);
      case 'draft':
        return const Color(0xFF70828B);
      default:
        return const Color(0xFFB87524);
    }
  }

  @override
  Widget build(BuildContext context) {
    final brand = trade.carBrand?.trim() ?? '';
    final model = trade.carModel?.trim() ?? '';
    final vehicleName = [
      brand,
      model,
    ].where((value) => value.isNotEmpty).join(' ');
    final details = [
      _display(trade.colorOut),
      _display(trade.colorIn),
      _display(trade.specification),
      _display(trade.engineSize),
    ].join('  ·  ');
    final status = trade.status?.trim() ?? '';
    final year = trade.year?.trim() ?? '';
    final vin = trade.vin?.trim() ?? '';
    final statusColor = _statusColor(status);

    return Container(
      decoration: BoxDecoration(
        color: _surface,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicleName.isEmpty ? 'Unknown vehicle' : vehicleName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _text,
                            fontSize: 17,
                            height: 1.25,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          details,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _muted,
                            fontSize: 12.5,
                            height: 1.45,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (year.isNotEmpty || trade.mileage != null) ...[
                          const SizedBox(height: 9),
                          Wrap(
                            spacing: 7,
                            runSpacing: 6,
                            children: [
                              if (year.isNotEmpty)
                                _InlineVehicleMetric(
                                  label: year,
                                  icon: Icons.calendar_today_outlined,
                                  color: const Color(0xFF2F7EA1),
                                ),
                              if (trade.mileage != null)
                                _InlineVehicleMetric(
                                  label: _mileage(trade.mileage),
                                  icon: Icons.speed_outlined,
                                  color: _orange,
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (status.isNotEmpty) ...[
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 86,
                      child: _CardTag(
                        label: status,
                        color: statusColor,
                        background: statusColor.withValues(alpha: 0.10),
                        border: statusColor.withValues(alpha: 0.35),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: _line),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: _PersonSummary(
                    label: 'Bought By',
                    name: trade.boughtBy,
                    date: textToDate(trade.buyDate),
                    dateColor: const Color(0xFFAD47C2),
                    dateBackground: const Color(0xFFF6E9FF),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _PersonSummary(
                    label: 'Sold By',
                    name: trade.soldBy,
                    date: textToDate(trade.sellDate),
                    dateColor: const Color(0xFF1682C2),
                    dateBackground: const Color(0xFFE8F5FF),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: _line),
          Obx(() {
            final isHidden = Get.find<CarTradingDashboardController>()
                .hideCarTradeFinancialValues
                .value;

            return SizedBox(
              height: 55,
              child: Row(
                children: [
                  Expanded(
                    child: _MoneyCell(
                      label: 'Paid',
                      value: _money(trade.totalPay),
                      color: _red,
                      isHidden: isHidden,
                    ),
                  ),
                  const VerticalDivider(width: 1, thickness: 1, color: _line),
                  Expanded(
                    child: _MoneyCell(
                      label: 'Received',
                      value: _money(trade.totalReceive),
                      color: _green,
                      isHidden: isHidden,
                    ),
                  ),
                  const VerticalDivider(width: 1, thickness: 1, color: _line),
                  Expanded(
                    child: _MoneyCell(
                      label: 'Net',
                      value: _money(trade.net),
                      color: trade.net != null && trade.net! < 0
                          ? const Color(0xFF657F91)
                          : const Color(0xFF638095),
                      isHidden: isHidden,
                    ),
                  ),
                ],
              ),
            );
          }),
          const Divider(height: 1, thickness: 1, color: _line),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            child: Row(
              children: [
                editSection(tradeData: trade, id: trade.id?.toString() ?? ''),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    vin.isEmpty ? '-' : vin,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: Color(0xFF73858D),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.25,
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

class _InlineVehicleMetric extends StatelessWidget {
  const _InlineVehicleMetric({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: color),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 17,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }
}

class _CardTag extends StatelessWidget {
  const _CardTag({
    required this.label,
    required this.color,
    required this.background,
    required this.border,
  });

  final String label;
  final Color color;
  final Color background;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 10.5,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.25,
        ),
      ),
    );
  }
}

class _PersonSummary extends StatelessWidget {
  const _PersonSummary({
    required this.label,
    required this.name,
    required this.date,
    required this.dateColor,
    required this.dateBackground,
  });

  final String label;
  final String? name;
  final String date;
  final Color dateColor;
  final Color dateBackground;

  @override
  Widget build(BuildContext context) {
    final normalizedName = name?.trim() ?? '';
    final normalizedDate = date.trim();

    return Container(
      height: 78,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFB),
        border: Border.all(color: const Color(0xFFE7EEEE)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            maxLines: 1,
            style: const TextStyle(
              color: Color(0xFF7A8990),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.55,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            normalizedName.isEmpty ? '—' : normalizedName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF33444C),
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          if (normalizedDate.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: dateBackground,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                normalizedDate,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: dateColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MoneyCell extends StatelessWidget {
  const _MoneyCell({
    required this.label,
    required this.value,
    required this.color,
    required this.isHidden,
  });

  final String label;
  final String value;
  final Color color;
  final bool isHidden;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFFBFCFC),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              maxLines: 1,
              style: const TextStyle(
                color: Color(0xFF75848A),
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.45,
              ),
            ),
            const SizedBox(height: 3),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: isHidden
                    ? _BlurredFinancialValue(color: color)
                    : FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          value,
                          style: TextStyle(
                            color: color,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlurredFinancialValue extends StatelessWidget {
  const _BlurredFinancialValue({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: SizedBox(
          width: 88,
          height: 20,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              ImageFiltered(
                imageFilter: ui.ImageFilter.blur(sigmaX: 4.5, sigmaY: 4.5),
                child: Text(
                  '88,888.88',
                  style: TextStyle(
                    color: color.withValues(alpha: 0.72),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.12),
                        color.withValues(alpha: 0.07),
                        Colors.white.withValues(alpha: 0.20),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 4,
                child: Icon(
                  Icons.lock_outline_rounded,
                  size: 10,
                  color: color.withValues(alpha: 0.70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyTradesState extends StatelessWidget {
  const _EmptyTradesState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: _primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.directions_car_outlined,
                color: _primary,
                size: 27,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'No vehicles found',
              style: TextStyle(
                color: _text,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Try changing the filters or clearing the search.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _muted,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
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

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TradeActionButton(
            label: 'INFOS',
            color: const Color(0xFF456B79),
            isLoading: infosLoading,
            onPressed: rowIsLoading
                ? null
                : () => openScreen('car_trading', infosLoadingKey),
          ),
          const SizedBox(width: 6),
          _TradeActionButton(
            label: 'ITEMS',
            color: _primary,
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
      width: 62,
      height: 29,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          backgroundColor: color.withValues(alpha: 0.035),
          disabledForegroundColor: color.withValues(alpha: 0.42),
          disabledBackgroundColor: color.withValues(alpha: 0.02),
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          side: BorderSide(color: color.withValues(alpha: 0.38)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: isLoading
            ? SizedBox(
                width: 13,
                height: 13,
                child: CircularProgressIndicator(strokeWidth: 2, color: color),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.2,
                ),
              ),
      ),
    );
  }
}
