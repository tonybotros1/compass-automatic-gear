import 'dart:math' as math;

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
const _cardBorder = Color(0xFFB8C8CF);
const _text = Color(0xFF26343A);
const _muted = Color(0xFF6F8088);
const _primary = Color.fromARGB(255, 1, 42, 40);
const _orange = Color(0xFFF26D32);
const _red = Color(0xFFED554E);
const _green = Color(0xFF2DA85A);
const _cardsPerPage = 30;
const _paginationGrey = Color(0xFF6B7280);
const _paginationMutedGrey = Color(0xFF94A3B8);
const _paginationLine = Color(0xFFD1D5DB);
const _paginationSurface = Color(0xFFF8FAFC);

const _tableVehicleWidth = 460.0;
const _tableStatusWidth = 100.0;
const _tablePersonWidth = 190.0;
const _tableMoneyWidth = 130.0;
const _tableActionsWidth = 350.0;
const _tableContentWidth = 1680.0;
const _tableHeaderHeight = 42.0;
const _tableRowHeight = 126.0;

Widget tableOfCarTrades({
  required BoxConstraints constraints,
  required BuildContext context,
}) {
  return GetX<CarTradingDashboardController>(
    builder: (controller) {
      final trades = controller.filteredTrades.toList(growable: false);
      final isSearching = controller.searching.value;

      return _CarTradeResultsView(
        trades: trades,
        isSearching: isSearching,
        showTable: controller.showCarTradeTableView.value,
      );
    },
  );
}

class _CarTradeResultsView extends StatefulWidget {
  const _CarTradeResultsView({
    required this.trades,
    required this.isSearching,
    required this.showTable,
  });

  final List<CarTradeModel> trades;
  final bool isSearching;
  final bool showTable;

  @override
  State<_CarTradeResultsView> createState() => _CarTradeResultsViewState();
}

class _CarTradeResultsViewState extends State<_CarTradeResultsView> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();
  int _currentPage = 0;
  late String _lastTradesSignature;

  @override
  void initState() {
    super.initState();
    _lastTradesSignature = _tradesSignature(widget.trades);
  }

  @override
  void didUpdateWidget(covariant _CarTradeResultsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final signature = _tradesSignature(widget.trades);

    if (signature != _lastTradesSignature) {
      _currentPage = 0;
      _lastTradesSignature = signature;
      _scrollToTop();
      return;
    }

    if (oldWidget.showTable != widget.showTable) {
      _jumpToTopNow();
      _jumpHorizontalToStart();
    }

    final pageCount = _pageCount(widget.trades.length);
    if (_currentPage >= pageCount) {
      _currentPage = pageCount - 1;
      _scrollToTop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSearching && widget.trades.isEmpty) {
      return const ColoredBox(
        color: _pageBackground,
        child: Center(
          child: CircularProgressIndicator(color: _primary, strokeWidth: 2.5),
        ),
      );
    }

    if (widget.trades.isEmpty) {
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
          final pageCount = _pageCount(widget.trades.length);
          final currentPage = _currentPage.clamp(0, pageCount - 1).toInt();
          final startIndex = currentPage * _cardsPerPage;
          final endIndex = math.min(
            startIndex + _cardsPerPage,
            widget.trades.length,
          );
          final pageTrades = widget.trades.sublist(startIndex, endIndex);

          return Column(
            children: [
              _CarTradePaginationBar(
                start: startIndex + 1,
                end: endIndex,
                total: widget.trades.length,
                currentPage: currentPage,
                pageCount: pageCount,
                onFirst: currentPage == 0 ? null : () => _goToPage(0),
                onPrevious: currentPage == 0
                    ? null
                    : () => _goToPage(currentPage - 1),
                onNext: currentPage >= pageCount - 1
                    ? null
                    : () => _goToPage(currentPage + 1),
                onLast: currentPage >= pageCount - 1
                    ? null
                    : () => _goToPage(pageCount - 1),
              ),
              Expanded(
                child: Obx(() {
                  final isFinancialsHidden =
                      Get.find<CarTradingDashboardController>()
                          .hideCarTradeFinancialValues
                          .value;

                  if (widget.showTable) {
                    return _CarTradeTableView(
                      trades: pageTrades,
                      isFinancialsHidden: isFinancialsHidden,
                      verticalController: _scrollController,
                      horizontalController: _horizontalScrollController,
                    );
                  }

                  return Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    interactive: true,
                    radius: const Radius.circular(99),
                    thickness: 5,
                    child: GridView.builder(
                      controller: _scrollController,
                      scrollCacheExtent: const ScrollCacheExtent.pixels(900),
                      addAutomaticKeepAlives: false,
                      addSemanticIndexes: false,
                      addRepaintBoundaries: true,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      padding: const EdgeInsets.only(top: 5),
                      itemCount: pageTrades.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columnCount,
                        mainAxisExtent: 382,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        final trade = pageTrades[index];
                        return _CarTradeCard(
                          key: ValueKey(
                            trade.id ?? 'trade-${startIndex + index}',
                          ),
                          trade: trade,
                          isFinancialsHidden: isFinancialsHidden,
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }

  int _pageCount(int total) => math.max(1, (total / _cardsPerPage).ceil());

  String _tradesSignature(List<CarTradeModel> trades) {
    if (trades.isEmpty) return 'empty';
    return '${trades.length}:${trades.first.id}:${trades.last.id}';
  }

  void _goToPage(int page) {
    final pageCount = _pageCount(widget.trades.length);
    final nextPage = page.clamp(0, pageCount - 1).toInt();
    if (nextPage == _currentPage) return;

    _jumpToTopNow();
    setState(() {
      _currentPage = nextPage;
    });
  }

  void _jumpToTopNow() {
    if (!_scrollController.hasClients) return;
    _scrollController.jumpTo(_scrollController.position.minScrollExtent);
  }

  void _jumpHorizontalToStart() {
    if (!_horizontalScrollController.hasClients) return;
    _horizontalScrollController.jumpTo(
      _horizontalScrollController.position.minScrollExtent,
    );
  }

  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }
}

class _CarTradePaginationBar extends StatelessWidget {
  const _CarTradePaginationBar({
    required this.start,
    required this.end,
    required this.total,
    required this.currentPage,
    required this.pageCount,
    required this.onFirst,
    required this.onPrevious,
    required this.onNext,
    required this.onLast,
  });

  final int start;
  final int end;
  final int total;
  final int currentPage;
  final int pageCount;
  final VoidCallback? onFirst;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onLast;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 650;
        final info = _PaginationInfo(
          start: start,
          end: end,
          total: total,
          currentPage: currentPage,
          pageCount: pageCount,
        );
        final controls = _PaginationControls(
          onFirst: onFirst,
          onPrevious: onPrevious,
          onNext: onNext,
          onLast: onLast,
        );

        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: isCompact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    info,
                    const SizedBox(height: 7),
                    Align(alignment: Alignment.centerRight, child: controls),
                  ],
                )
              : Row(children: [info, const Spacer(), controls]),
        );
      },
    );
  }
}

class _PaginationInfo extends StatelessWidget {
  const _PaginationInfo({
    required this.start,
    required this.end,
    required this.total,
    required this.currentPage,
    required this.pageCount,
  });

  final int start;
  final int end;
  final int total;
  final int currentPage;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _PaginationPill(
          icon: Icons.directions_car_outlined,
          text: 'Showing $start-$end of $total cars',
        ),
        _PaginationPill(
          icon: Icons.layers_outlined,
          text: 'Page ${currentPage + 1} of $pageCount',
        ),
      ],
    );
  }
}

class _PaginationPill extends StatelessWidget {
  const _PaginationPill({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: _paginationSurface,
        border: Border.all(color: _paginationLine),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: _paginationGrey),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: _paginationGrey,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaginationControls extends StatelessWidget {
  const _PaginationControls({
    required this.onFirst,
    required this.onPrevious,
    required this.onNext,
    required this.onLast,
  });

  final VoidCallback? onFirst;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _PaginationArrowButton(
          tooltip: 'First page',
          icon: Icons.first_page_rounded,
          onPressed: onFirst,
        ),
        const SizedBox(width: 6),
        _PaginationArrowButton(
          tooltip: 'Previous page',
          icon: Icons.chevron_left_rounded,
          onPressed: onPrevious,
        ),
        const SizedBox(width: 6),
        _PaginationArrowButton(
          tooltip: 'Next page',
          icon: Icons.chevron_right_rounded,
          onPressed: onNext,
        ),
        const SizedBox(width: 6),
        _PaginationArrowButton(
          tooltip: 'Last page',
          icon: Icons.last_page_rounded,
          onPressed: onLast,
        ),
      ],
    );
  }
}

class _PaginationArrowButton extends StatelessWidget {
  const _PaginationArrowButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: SizedBox(
        width: 34,
        height: 30,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: _paginationGrey,
            disabledForegroundColor: _paginationMutedGrey,
            backgroundColor: _paginationSurface,
            disabledBackgroundColor: _paginationSurface,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            side: const BorderSide(color: _paginationLine),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Icon(icon, size: 18),
        ),
      ),
    );
  }
}

class _CarTradeTableView extends StatelessWidget {
  const _CarTradeTableView({
    required this.trades,
    required this.isFinancialsHidden,
    required this.verticalController,
    required this.horizontalController,
  });

  final List<CarTradeModel> trades;
  final bool isFinancialsHidden;
  final ScrollController verticalController;
  final ScrollController horizontalController;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = math.max(_tableContentWidth, constraints.maxWidth);
        final vehicleWidth =
            _tableVehicleWidth + (contentWidth - _tableContentWidth);

        return Container(
          margin: const EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFD6E1E7)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Scrollbar(
            controller: horizontalController,
            thumbVisibility: true,
            interactive: true,
            radius: const Radius.circular(99),
            thickness: 6,
            scrollbarOrientation: ScrollbarOrientation.bottom,
            notificationPredicate: (notification) =>
                notification.metrics.axis == Axis.horizontal,
            child: SingleChildScrollView(
              controller: horizontalController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: contentWidth,
                height: constraints.maxHeight - 5,
                child: Column(
                  children: [
                    _CarTradeTableHeader(vehicleWidth: vehicleWidth),
                    Expanded(
                      child: Scrollbar(
                        controller: verticalController,
                        thumbVisibility: true,
                        interactive: true,
                        radius: const Radius.circular(99),
                        thickness: 5,
                        notificationPredicate: (notification) =>
                            notification.metrics.axis == Axis.vertical,
                        child: ListView.builder(
                          controller: verticalController,
                          itemExtent: _tableRowHeight,
                          scrollCacheExtent: const ScrollCacheExtent.pixels(
                            700,
                          ),
                          addAutomaticKeepAlives: false,
                          addSemanticIndexes: false,
                          addRepaintBoundaries: true,
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          physics: const ClampingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          itemCount: trades.length,
                          itemBuilder: (context, index) {
                            final trade = trades[index];
                            return _CarTradeTableRow(
                              key: ValueKey(trade.id ?? 'table-row-$index'),
                              trade: trade,
                              index: index,
                              vehicleWidth: vehicleWidth,
                              isFinancialsHidden: isFinancialsHidden,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CarTradeTableHeader extends StatelessWidget {
  const _CarTradeTableHeader({required this.vehicleWidth});

  final double vehicleWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _tableHeaderHeight,
      decoration: const BoxDecoration(
        color: Color(0xFFF3F7F9),
        border: Border(bottom: BorderSide(color: Color(0xFFD6E1E7))),
      ),
      child: Row(
        children: [
          _CarTradeHeaderCell(
            width: vehicleWidth,
            label: 'VEHICLE INFORMATION',
          ),
          const _CarTradeHeaderCell(width: _tableStatusWidth, label: 'STATUS'),
          const _CarTradeHeaderCell(
            width: _tablePersonWidth,
            label: 'BOUGHT BY',
          ),
          const _CarTradeHeaderCell(width: _tablePersonWidth, label: 'SOLD BY'),
          const _CarTradeHeaderCell(
            width: _tableMoneyWidth,
            label: 'PAID',
            alignment: Alignment.centerRight,
          ),
          const _CarTradeHeaderCell(
            width: _tableMoneyWidth,
            label: 'RECEIVED',
            alignment: Alignment.centerRight,
          ),
          const _CarTradeHeaderCell(
            width: _tableMoneyWidth,
            label: 'NET',
            alignment: Alignment.centerRight,
          ),
          const _CarTradeHeaderCell(
            width: _tableActionsWidth,
            label: 'ACTIONS',
          ),
        ],
      ),
    );
  }
}

class _CarTradeHeaderCell extends StatelessWidget {
  const _CarTradeHeaderCell({
    required this.width,
    required this.label,
    this.alignment = Alignment.centerLeft,
  });

  final double width;
  final String label;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: _tableHeaderHeight,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Color(0xFFE0E8EC))),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Color(0xFF647780),
          fontSize: 9.5,
          fontWeight: FontWeight.w900,
          letterSpacing: .45,
        ),
      ),
    );
  }
}

class _CarTradeTableRow extends StatelessWidget {
  const _CarTradeTableRow({
    super.key,
    required this.trade,
    required this.index,
    required this.vehicleWidth,
    required this.isFinancialsHidden,
  });

  final CarTradeModel trade;
  final int index;
  final double vehicleWidth;
  final bool isFinancialsHidden;

  String _display(String? value) {
    final normalized = value?.trim() ?? '';
    return normalized.isEmpty ? '—' : normalized;
  }

  double? _itemAmount(String itemName, {required bool preferReceive}) {
    final items = trade.tradeItems ?? const [];
    var found = false;
    var total = 0.0;
    for (final item in items) {
      if ((item.item?.trim().toUpperCase() ?? '') != itemName) continue;
      found = true;
      final primary = preferReceive ? item.receive : item.pay;
      final fallback = preferReceive ? item.pay : item.receive;
      total += primary != null && primary != 0 ? primary : fallback ?? 0;
    }
    return found ? total : null;
  }

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
    final trim = trade.trim?.trim() ?? '';
    final vehicleName = [
      brand,
      model,
      trim,
    ].where((value) => value.isNotEmpty).join(' ');
    final details = [
      'OUT ${_display(trade.colorOut)}',
      'IN ${_display(trade.colorIn)}',
      _display(trade.specification),
      _display(trade.engineSize),
    ].join('  ·  ');
    final year = trade.year?.trim() ?? '';
    final vin = trade.vin?.trim() ?? '';
    final status = trade.status?.trim() ?? '';
    final statusColor = _statusColor(status);
    final buyPrice = _itemAmount('BUY', preferReceive: false);
    final sellPrice = _itemAmount('SELL', preferReceive: true);

    return Container(
      height: _tableRowHeight,
      decoration: BoxDecoration(
        color: index.isEven ? _surface : const Color(0xFFFBFCFD),
        border: const Border(bottom: BorderSide(color: _line)),
      ),
      child: Row(
        children: [
          _CarTradeTableVehicleCell(
            width: vehicleWidth,
            brandName: brand,
            vehicleName: vehicleName.isEmpty ? 'Unknown vehicle' : vehicleName,
            details: details,
            year: year,
            mileage: '${qtyFormat.format(trade.mileage ?? 0)} km',
            vin: vin.isEmpty ? '-' : vin,
          ),
          SizedBox(
            width: _tableStatusWidth,
            child: Center(
              child: status.isEmpty
                  ? const Text('—', style: TextStyle(color: _muted))
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: _CardTag(
                        label: status,
                        color: statusColor,
                        background: statusColor.withValues(alpha: .10),
                        border: statusColor.withValues(alpha: .35),
                      ),
                    ),
            ),
          ),
          _CarTradeTablePersonCell(
            name: trade.boughtBy,
            date: textToDate(trade.buyDate),
            price: buyPrice,
            color: _red,
            dateColor: const Color(0xFFAD47C2),
            dateBackground: const Color(0xFFF6E9FF),
            isFinancialsHidden: isFinancialsHidden,
          ),
          _CarTradeTablePersonCell(
            name: trade.soldBy,
            date: textToDate(trade.sellDate),
            price: sellPrice,
            color: _green,
            dateColor: const Color(0xFF1682C2),
            dateBackground: const Color(0xFFE8F5FF),
            isFinancialsHidden: isFinancialsHidden,
          ),
          _CarTradeTableMoneyCell(
            value: trade.totalPay,
            color: _red,
            isHidden: isFinancialsHidden,
          ),
          _CarTradeTableMoneyCell(
            value: trade.totalReceive,
            color: _green,
            isHidden: isFinancialsHidden,
          ),
          _CarTradeTableMoneyCell(
            value: trade.net,
            color: trade.net != null && trade.net! < 0
                ? const Color(0xFF657F91)
                : const Color(0xFF638095),
            isHidden: isFinancialsHidden,
          ),
          SizedBox(
            width: _tableActionsWidth,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: KeyedSubtree(
                key: ValueKey('actions-${trade.id ?? index}'),
                child: editSection(
                  tradeData: trade,
                  id: trade.id?.toString() ?? '',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CarTradeTableVehicleCell extends StatelessWidget {
  const _CarTradeTableVehicleCell({
    required this.width,
    required this.brandName,
    required this.vehicleName,
    required this.details,
    required this.year,
    required this.mileage,
    required this.vin,
  });

  final double width;
  final String brandName;
  final String vehicleName;
  final String details;
  final String year;
  final String mileage;
  final String vin;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: Row(
          children: [
            _CarTradeBrandLogo(brandName: brandName, size: 84),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    vehicleName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _text,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    details,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (year.isNotEmpty) ...[
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 13,
                          color: Color(0xFF2F7EA1),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          year,
                          style: const TextStyle(
                            color: Color(0xFF2F7EA1),
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      const Icon(
                        Icons.speed_outlined,
                        size: 14,
                        color: _orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        mileage.toUpperCase(),
                        style: const TextStyle(
                          color: _orange,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'VIN: $vin',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF647780),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CarTradeBrandLogo extends StatelessWidget {
  const _CarTradeBrandLogo({required this.brandName, required this.size});

  final String brandName;
  final double size;

  @override
  Widget build(BuildContext context) {
    final slug = _carTradeBrandSlug(brandName);
    final fallback = _CarTradeLogoFallback(brandName: brandName);

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFF1F7FA)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD4E2E9), width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11172A3A),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color(0x0AFFFFFF),
            blurRadius: 2,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: slug.isEmpty
          ? fallback
          : Image.asset(
              'assets/logos/thumb/$slug.png',
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
              semanticLabel: '$brandName logo',
              errorBuilder: (_, _, _) => fallback,
            ),
    );
  }
}

class _CarTradeLogoFallback extends StatelessWidget {
  const _CarTradeLogoFallback({required this.brandName});

  final String brandName;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _primary.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _carTradeBrandInitials(brandName),
        style: const TextStyle(
          color: _primary,
          fontSize: 16,
          fontWeight: FontWeight.w900,
          letterSpacing: .4,
        ),
      ),
    );
  }
}

String _carTradeBrandInitials(String value) {
  final parts = value
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .take(2)
      .toList();
  if (parts.isEmpty) return '?';
  return parts.map((part) => part.substring(0, 1)).join().toUpperCase();
}

String _carTradeBrandSlug(String brandName) {
  final normalized = brandName
      .toLowerCase()
      .replaceAll('&', ' and ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  const knownSlugs = {
    'mercedes': 'mercedes-benz',
    'mercedes benz': 'mercedes-benz',
    'mercedes-benz': 'mercedes-benz',
    'landrover': 'land-rover',
    'land rover': 'land-rover',
    'range rover': 'land-rover',
    'rolls royce': 'rolls-royce',
    'rolls-royce': 'rolls-royce',
    'alfa romeo': 'alfa-romeo',
    'aston martin': 'aston-martin',
    'volkswagen': 'volkswagen',
    'vw': 'volkswagen',
    'mini cooper': 'mini',
  };

  if (knownSlugs.containsKey(normalized)) {
    return knownSlugs[normalized]!;
  }

  return normalized
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'-+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
}

class _CarTradeTablePersonCell extends StatelessWidget {
  const _CarTradeTablePersonCell({
    required this.name,
    required this.date,
    required this.price,
    required this.color,
    required this.dateColor,
    required this.dateBackground,
    required this.isFinancialsHidden,
  });

  final String? name;
  final String date;
  final double? price;
  final Color color;
  final Color dateColor;
  final Color dateBackground;
  final bool isFinancialsHidden;

  @override
  Widget build(BuildContext context) {
    final normalizedName = name?.trim() ?? '';
    return SizedBox(
      width: _tablePersonWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              normalizedName.isEmpty ? '—' : normalizedName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF33444C),
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            if (date.trim().isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: dateBackground,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  date,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: dateColor,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              )
            else
              const Text('—', style: TextStyle(color: _muted, fontSize: 9)),
            if (price != null) ...[
              const SizedBox(height: 6),
              _PersonPriceLine(
                price: priceFormat.format(price),
                color: color,
                isHidden: isFinancialsHidden,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CarTradeTableMoneyCell extends StatelessWidget {
  const _CarTradeTableMoneyCell({
    required this.value,
    required this.color,
    required this.isHidden,
  });

  final double? value;
  final Color color;
  final bool isHidden;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _tableMoneyWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Align(
          alignment: Alignment.centerRight,
          child: isHidden
              ? _BlurredFinancialValue(
                  color: color,
                  width: 94,
                  height: 20,
                  fontSize: 12,
                  iconSize: 9,
                )
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    priceFormat.format(value ?? 0),
                    maxLines: 1,
                    style: TextStyle(
                      color: color,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class _CarTradeCard extends StatelessWidget {
  const _CarTradeCard({
    super.key,
    required this.trade,
    required this.isFinancialsHidden,
  });

  final CarTradeModel trade;
  final bool isFinancialsHidden;

  String _display(String? value) {
    final normalized = value?.trim() ?? '';
    return normalized.isEmpty ? '—' : normalized;
  }

  String _mileage(int? value) {
    if (value == null) return '';
    return '${qtyFormat.format(value)} km';
  }

  String _money(double? value) => priceFormat.format(value ?? 0);

  double? _itemAmount(String itemName, {required bool preferReceive}) {
    final items = trade.tradeItems ?? const [];
    var found = false;
    var total = 0.0;

    for (final item in items) {
      final normalizedItem = item.item?.trim().toUpperCase() ?? '';
      if (normalizedItem != itemName) continue;

      found = true;
      final primaryAmount = preferReceive ? item.receive : item.pay;
      final fallbackAmount = preferReceive ? item.pay : item.receive;
      total += primaryAmount != null && primaryAmount != 0
          ? primaryAmount
          : fallbackAmount ?? 0;
    }

    return found ? total : null;
  }

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
    final trim = trade.trim?.trim() ?? '';
    final vehicleName = [
      brand,
      model,
      trim,
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
    final buyPrice = _itemAmount('BUY', preferReceive: false);
    final sellPrice = _itemAmount('SELL', preferReceive: true);

    return Container(
      decoration: BoxDecoration(
        color: _surface,
        border: Border.all(color: _cardBorder, width: 1.55),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.028),
            blurRadius: 3,
            offset: const Offset(0, 1.5),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
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
                      const SizedBox(height: 7),
                      _VehicleVinLine(vin: vin.isEmpty ? '-' : vin),
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
          const Divider(height: 1, thickness: 1, color: _line),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _PersonSummary(
                      label: 'Bought By',
                      name: trade.boughtBy,
                      date: textToDate(trade.buyDate),
                      dateColor: const Color(0xFFAD47C2),
                      dateBackground: const Color(0xFFF6E9FF),
                      price: buyPrice == null ? '' : _money(buyPrice),
                      priceColor: _red,
                      isPriceHidden: isFinancialsHidden,
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
                      price: sellPrice == null ? '' : _money(sellPrice),
                      priceColor: _green,
                      isPriceHidden: isFinancialsHidden,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: _line),
          SizedBox(
            height: 55,
            child: Row(
              children: [
                Expanded(
                  child: _MoneyCell(
                    label: 'Paid',
                    value: _money(trade.totalPay),
                    color: _red,
                    isHidden: isFinancialsHidden,
                  ),
                ),
                const VerticalDivider(width: 1, thickness: 1, color: _line),
                Expanded(
                  child: _MoneyCell(
                    label: 'Received',
                    value: _money(trade.totalReceive),
                    color: _green,
                    isHidden: isFinancialsHidden,
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
                    isHidden: isFinancialsHidden,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: _line),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            child: editSection(
              tradeData: trade,
              id: trade.id?.toString() ?? '',
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

class _VehicleVinLine extends StatelessWidget {
  const _VehicleVinLine({required this.vin});

  final String vin;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.confirmation_number_outlined,
          size: 15,
          color: Color(0xFF647780),
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            'VIN: $vin',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF647780),
              fontSize: 12.5,
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
    required this.price,
    required this.priceColor,
    required this.isPriceHidden,
  });

  final String label;
  final String? name;
  final String date;
  final Color dateColor;
  final Color dateBackground;
  final String price;
  final Color priceColor;
  final bool isPriceHidden;

  @override
  Widget build(BuildContext context) {
    final normalizedName = name?.trim() ?? '';
    final normalizedDate = date.trim();

    return Container(
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
          const SizedBox(height: 5),
          if (normalizedDate.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
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
            ),
          if (price.isNotEmpty) ...[
            const SizedBox(height: 5),
            _PersonPriceLine(
              price: price,
              color: priceColor,
              isHidden: isPriceHidden,
            ),
          ],
        ],
      ),
    );
  }
}

class _PersonPriceLine extends StatelessWidget {
  const _PersonPriceLine({
    required this.price,
    required this.color,
    required this.isHidden,
  });

  final String price;
  final Color color;
  final bool isHidden;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 21,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.075),
        border: Border.all(color: color.withValues(alpha: 0.18)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.payments_outlined, size: 13, color: color),
          const SizedBox(width: 5),
          Flexible(
            child: isHidden
                ? _BlurredFinancialValue(
                    color: color,
                    width: 72,
                    height: 17,
                    fontSize: 12,
                    iconSize: 8,
                  )
                : Text(
                    price,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: color,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.1,
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
  const _BlurredFinancialValue({
    required this.color,
    this.width = 88,
    this.height = 20,
    this.fontSize = 14,
    this.iconSize = 10,
  });

  final Color color;
  final double width;
  final double height;
  final double fontSize;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: color.withValues(alpha: 0.08)),
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.09),
              color.withValues(alpha: 0.17),
              Colors.white.withValues(alpha: 0.34),
              color.withValues(alpha: 0.11),
            ],
            stops: const [0, 0.42, 0.64, 1],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  _PrivacyMaskBar(
                    flex: 7,
                    height: fontSize >= 14 ? 6 : 5,
                    color: color,
                  ),
                  const SizedBox(width: 4),
                  _PrivacyMaskBar(
                    flex: 4,
                    height: fontSize >= 14 ? 6 : 5,
                    color: color,
                    opacity: 0.18,
                  ),
                  const SizedBox(width: 4),
                  _PrivacyMaskBar(
                    flex: 5,
                    height: fontSize >= 14 ? 6 : 5,
                    color: color,
                    opacity: 0.14,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            Icon(
              Icons.lock_outline_rounded,
              size: iconSize,
              color: color.withValues(alpha: 0.72),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacyMaskBar extends StatelessWidget {
  const _PrivacyMaskBar({
    required this.flex,
    required this.height,
    required this.color,
    this.opacity = 0.24,
  });

  final int flex;
  final double height;
  final Color color;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: SizedBox(
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(99),
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
  return _TradeActions(tradeData: tradeData, id: id);
}

class _TradeActions extends StatefulWidget {
  const _TradeActions({required this.tradeData, required this.id});

  final CarTradeModel tradeData;
  final String id;

  @override
  State<_TradeActions> createState() => _TradeActionsState();
}

class _TradeActionsState extends State<_TradeActions> {
  late final CarTradingDashboardController _controller;
  String? _loadingKey;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<CarTradingDashboardController>();
  }

  @override
  Widget build(BuildContext context) {
    final infosLoadingKey = '${widget.id}:infos';
    final itemsLoadingKey = '${widget.id}:items';
    final salesAgreementLoadingKey = '${widget.id}:sales-agreement';
    final infosLoading = _loadingKey == infosLoadingKey;
    final itemsLoading = _loadingKey == itemsLoadingKey;
    final salesAgreementLoading = _loadingKey == salesAgreementLoadingKey;
    final rowIsLoading = _loadingKey != null;
    const actionButtonColor = Color(0xFF456B79);

    return Row(
      children: [
        _TradeActionButton(
          label: 'Car Information',
          width: 118,
          color: actionButtonColor,
          isLoading: infosLoading,
          onPressed: rowIsLoading
              ? null
              : () => _openScreen('car_trading', infosLoadingKey),
        ),
        const Spacer(),
        const SizedBox(width: 6),
        _TradeActionButton(
          label: 'ITEMS',
          color: actionButtonColor,
          isLoading: itemsLoading,
          onPressed: rowIsLoading
              ? null
              : () => _openScreen('items', itemsLoadingKey),
        ),
        const SizedBox(width: 6),
        _TradeActionButton(
          label: 'Sales Agreement',
          width: 126,
          color: actionButtonColor,
          isLoading: salesAgreementLoading,
          onPressed: rowIsLoading
              ? null
              : () => _openScreen('sales_agreement', salesAgreementLoadingKey),
        ),
      ],
    );
  }

  Future<void> _openScreen(String screen, String loadingKey) async {
    if (_loadingKey != null) return;

    setState(() {
      _loadingKey = loadingKey;
    });

    try {
      await _controller.loadValues(widget.tradeData);
    } finally {
      if (mounted) {
        setState(() {
          _loadingKey = null;
        });
      }
    }

    if (!mounted) return;

    await carTradesDialog(
      screen: screen,
      tradeID: widget.tradeData.id ?? '',
      controller: _controller,
      canEdit: true,
      onPressed: _controller.addingNewValue.value
          ? null
          : () async {
              _controller.addNewTrade();
            },
    );
  }
}

class _TradeActionButton extends StatelessWidget {
  const _TradeActionButton({
    required this.label,
    required this.color,
    required this.onPressed,
    required this.isLoading,
    this.width = 62,
  });

  final String label;
  final Color color;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
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
