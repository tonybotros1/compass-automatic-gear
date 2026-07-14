import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollCacheExtent;
import 'package:get/get.dart';

import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../Models/car trading/vehicle_analysis_model.dart'
    as vehicle_analysis_model;
import '../../../consts.dart';

typedef _BrandAnalysis = vehicle_analysis_model.VehicleAnalysisModel;
typedef _CarAnalysis = vehicle_analysis_model.Cars;

const _pageBackground = Colors.white;
const _surface = Colors.white;
const _surfaceSoft = Color(0xFFF8FAFC);
const _surfaceStrong = Color(0xFFEDF2F7);
const _line = Color(0xFFDFE7EF);
const _lineStrong = Color(0xFFCFD9E5);
const _text = Color(0xFF172231);
const _muted = Color(0xFF6C798A);
const _primary = Color(0xFF0C7C86);
const _primaryDark = Color(0xFF075F67);
const _primarySoft = Color(0xFFE7F7F8);
const _green = Color(0xFF2F9E62);
const _red = Color(0xFFD95757);
const _blue = Color(0xFF2F78C4);
const _shadow = Color(0x141B2C45);
const _desktopBreakpoint = 980.0;
const _carsRowsPerPage = 4;

final List<_CarMetricColumn> _carMetricColumns = [
  _CarMetricColumn(label: 'BUY PRICE', value: (car) => car.safeBuyPrice),
  _CarMetricColumn(label: 'SELL PRICE', value: (car) => car.safeSellPrice),
  _CarMetricColumn(
    label: 'BUY / SELL NET',
    value: (car) => car.safeBuySellNet,
    color: (car) => _netColor(car.safeBuySellNet),
  ),
  _CarMetricColumn(label: 'EXPENSES', value: (car) => car.safeExpenses),
  _CarMetricColumn(label: 'REVENUE', value: (car) => car.safeRevenue),
  _CarMetricColumn(
    label: 'EXPENSE / REVENUE NET',
    value: (car) => car.safeExpensesRevenueNet,
    color: (car) => _netColor(car.safeExpensesRevenueNet),
  ),
  _CarMetricColumn(label: 'TOTAL PAID', value: (car) => car.safeTotalPaid),
  _CarMetricColumn(
    label: 'TOTAL RECEIVED',
    value: (car) => car.safeTotalReceived,
  ),
  _CarMetricColumn(
    label: 'TOTAL NET',
    value: (car) => car.safeTotalNet,
    color: (car) => _netColor(car.safeTotalNet),
    strong: true,
  ),
];

class VehicleAnalysis extends StatefulWidget {
  const VehicleAnalysis({super.key});

  @override
  State<VehicleAnalysis> createState() => _VehicleAnalysisState();
}

class _VehicleAnalysisState extends State<VehicleAnalysis>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  String? _expandedBrandKey;
  _VehicleStatusFilter _statusFilter = _VehicleStatusFilter.all;
  DateTime? _lastVehicleAnalysisRequestAt;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return GetX<CarTradingDashboardController>(
      builder: (controller) {
        final needsInitialLoad =
            controller.allVehicleAnalysis.isEmpty &&
            !controller.isVehicleAnalysisLoading.value &&
            _canRequestVehicleAnalysis();
        _loadVehicleAnalysisIfNeeded(controller, needsInitialLoad);

        final analysis = controller.allVehicleAnalysis.toList(growable: false);
        final brands = _buildBrandAnalysis(
          analysis,
          statusFilter: _statusFilter,
        );
        final isSearching =
            controller.isVehicleAnalysisLoading.value || needsInitialLoad;
        final visibleCarCount = brands.fold<int>(
          0,
          (total, brand) => total + brand.safeCarCount,
        );
        const hideFinancials = false;

        if (_expandedBrandKey != null &&
            !brands.any((brand) => brand.key == _expandedBrandKey)) {
          _expandedBrandKey = null;
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < _desktopBreakpoint;

            return Container(
              color: _pageBackground,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _VehicleStatusFilterBar(
                    selectedFilter: _statusFilter,
                    visibleCarCount: visibleCarCount,
                    isRefreshing: controller.isVehicleAnalysisLoading.value,
                    onRefresh: () => _refreshVehicleAnalysis(controller),
                    onChanged: (filter) {
                      if (_statusFilter == filter) return;
                      setState(() {
                        _statusFilter = filter;
                        _expandedBrandKey = null;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: _AnalysisPanel(
                      brands: brands,
                      isSearching: isSearching,
                      isCompact: isCompact,
                      hideFinancials: hideFinancials,
                      expandedBrandKey: _expandedBrandKey,
                      scrollController: _scrollController,
                      canCollapse: _expandedBrandKey != null,
                      onCollapseAll: () {
                        if (_expandedBrandKey == null) return;
                        setState(() => _expandedBrandKey = null);
                      },
                      onToggleBrand: (brand) {
                        setState(() {
                          _expandedBrandKey = _expandedBrandKey == brand.key
                              ? null
                              : brand.key;
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _loadVehicleAnalysisIfNeeded(
    CarTradingDashboardController controller,
    bool shouldLoad,
  ) {
    if (!shouldLoad) return;

    _lastVehicleAnalysisRequestAt = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (controller.allVehicleAnalysis.isNotEmpty ||
          controller.isVehicleAnalysisLoading.value) {
        return;
      }
      controller.getAllVehcileAnalysis();
    });
  }

  bool _canRequestVehicleAnalysis() {
    final lastRequest = _lastVehicleAnalysisRequestAt;
    if (lastRequest == null) return true;
    return DateTime.now().difference(lastRequest) > const Duration(seconds: 5);
  }

  Future<void> _refreshVehicleAnalysis(
    CarTradingDashboardController controller,
  ) async {
    if (controller.isVehicleAnalysisLoading.value) return;
    _lastVehicleAnalysisRequestAt = DateTime.now();
    await controller.getAllVehcileAnalysis();
  }
}

enum _VehicleStatusFilter { all, newCars, sold }

extension _VehicleStatusFilterView on _VehicleStatusFilter {
  String get label {
    switch (this) {
      case _VehicleStatusFilter.all:
        return 'ALL';
      case _VehicleStatusFilter.newCars:
        return 'NEW';
      case _VehicleStatusFilter.sold:
        return 'SOLD';
    }
  }

  IconData get icon {
    switch (this) {
      case _VehicleStatusFilter.all:
        return Icons.all_inclusive_rounded;
      case _VehicleStatusFilter.newCars:
        return Icons.fiber_new_rounded;
      case _VehicleStatusFilter.sold:
        return Icons.sell_outlined;
    }
  }

  bool matches(String status) {
    final normalized = status.trim().toLowerCase();
    switch (this) {
      case _VehicleStatusFilter.all:
        return true;
      case _VehicleStatusFilter.newCars:
        return normalized == 'new';
      case _VehicleStatusFilter.sold:
        return normalized == 'sold';
    }
  }
}

class _VehicleStatusFilterBar extends StatelessWidget {
  const _VehicleStatusFilterBar({
    required this.selectedFilter,
    required this.visibleCarCount,
    required this.isRefreshing,
    required this.onRefresh,
    required this.onChanged,
  });

  final _VehicleStatusFilter selectedFilter;
  final int visibleCarCount;
  final bool isRefreshing;
  final VoidCallback onRefresh;
  final ValueChanged<_VehicleStatusFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 620;
        final filter = _VehicleStatusSegmentedControl(
          selectedFilter: selectedFilter,
          onChanged: onChanged,
        );
        final count = _VehicleStatusCountPill(
          count: visibleCarCount,
          label: selectedFilter.label,
        );
        final refresh = _VehicleRefreshButton(
          isRefreshing: isRefreshing,
          onPressed: onRefresh,
        );

        if (isCompact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              filter,
              const SizedBox(height: 8),
              Row(children: [count, const Spacer(), refresh]),
            ],
          );
        }

        return Row(
          children: [
            filter,
            const Spacer(),
            count,
            const SizedBox(width: 8),
            refresh,
          ],
        );
      },
    );
  }
}

class _VehicleRefreshButton extends StatelessWidget {
  const _VehicleRefreshButton({
    required this.isRefreshing,
    required this.onPressed,
  });

  final bool isRefreshing;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Refresh vehicle analysis',
      child: SizedBox(
        height: 34,
        child: OutlinedButton.icon(
          onPressed: isRefreshing ? null : onPressed,
          icon: SizedBox(
            width: 15,
            height: 15,
            child: isRefreshing
                ? const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _primary,
                  )
                : const Icon(Icons.refresh_rounded, size: 17),
          ),
          label: Text(isRefreshing ? 'REFRESHING' : 'REFRESH'),
          style: OutlinedButton.styleFrom(
            foregroundColor: _primaryDark,
            disabledForegroundColor: _primaryDark,
            backgroundColor: _surface,
            disabledBackgroundColor: _surfaceSoft,
            side: const BorderSide(color: _lineStrong),
            padding: const EdgeInsets.symmetric(horizontal: 11),
            textStyle: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
              letterSpacing: .15,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}

class _VehicleStatusSegmentedControl extends StatelessWidget {
  const _VehicleStatusSegmentedControl({
    required this.selectedFilter,
    required this.onChanged,
  });

  final _VehicleStatusFilter selectedFilter;
  final ValueChanged<_VehicleStatusFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: _surfaceSoft,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _VehicleStatusFilter.values.map((filter) {
          return _VehicleStatusOption(
            filter: filter,
            isSelected: selectedFilter == filter,
            onTap: () => onChanged(filter),
          );
        }).toList(),
      ),
    );
  }
}

class _VehicleStatusOption extends StatelessWidget {
  const _VehicleStatusOption({
    required this.filter,
    required this.isSelected,
    required this.onTap,
  });

  final _VehicleStatusFilter filter;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: isSelected ? _surface : Colors.transparent,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: isSelected ? _lineStrong : Colors.transparent,
        ),
        boxShadow: isSelected
            ? const [
                BoxShadow(color: _shadow, blurRadius: 12, offset: Offset(0, 5)),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  filter.icon,
                  size: 15,
                  color: isSelected ? _primaryDark : _muted,
                ),
                const SizedBox(width: 6),
                Text(
                  filter.label,
                  style: TextStyle(
                    color: isSelected ? _primaryDark : _muted,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VehicleStatusCountPill extends StatelessWidget {
  const _VehicleStatusCountPill({required this.count, required this.label});

  final int count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: _primarySoft,
        border: Border.all(color: _primary.withValues(alpha: 0.16)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.directions_car_outlined,
            size: 15,
            color: _primaryDark,
          ),
          const SizedBox(width: 7),
          Text(
            '$count ${label == 'ALL' ? 'CARS' : '$label CARS'}',
            style: const TextStyle(
              color: _primaryDark,
              fontSize: 11.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.15,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCollapseButton extends StatelessWidget {
  const _HeaderCollapseButton({required this.enabled, required this.onPressed});

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Collapse all',
      child: SizedBox(
        width: 32,
        height: 32,
        child: OutlinedButton(
          onPressed: enabled ? onPressed : null,
          style: OutlinedButton.styleFrom(
            foregroundColor: _muted,
            disabledForegroundColor: _muted.withValues(alpha: 0.38),
            backgroundColor: enabled ? _surface : _surfaceSoft,
            disabledBackgroundColor: _surfaceSoft,
            padding: EdgeInsets.zero,
            minimumSize: const Size(32, 32),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            side: BorderSide(
              color: enabled ? _lineStrong : _line.withValues(alpha: 0.55),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Icon(Icons.unfold_less_rounded, size: 17),
        ),
      ),
    );
  }
}

class _AnalysisPanel extends StatelessWidget {
  const _AnalysisPanel({
    required this.brands,
    required this.isSearching,
    required this.isCompact,
    required this.hideFinancials,
    required this.expandedBrandKey,
    required this.scrollController,
    required this.canCollapse,
    required this.onCollapseAll,
    required this.onToggleBrand,
  });

  final List<_BrandAnalysis> brands;
  final bool isSearching;
  final bool isCompact;
  final bool hideFinancials;
  final String? expandedBrandKey;
  final ScrollController scrollController;
  final bool canCollapse;
  final VoidCallback onCollapseAll;
  final ValueChanged<_BrandAnalysis> onToggleBrand;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: _shadow, blurRadius: 38, offset: Offset(0, 16)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          if (!isCompact)
            _BrandTableHeader(
              canCollapse: canCollapse,
              onCollapseAll: onCollapseAll,
            ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (isSearching && brands.isEmpty) {
      return const _AnalysisLoadingState();
    }

    if (brands.isEmpty) {
      return const _AnalysisEmptyState();
    }

    return Scrollbar(
      controller: scrollController,
      thumbVisibility: !isCompact,
      child: ListView.builder(
        controller: scrollController,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        scrollCacheExtent: const ScrollCacheExtent.pixels(700),
        itemCount: brands.length,
        itemBuilder: (context, index) {
          final brand = brands[index];
          final isOpen = expandedBrandKey == brand.key;

          return RepaintBoundary(
            child: _BrandItem(
              brand: brand,
              rank: brand.isOthers ? null : index + 1,
              isOpen: isOpen,
              isCompact: isCompact,
              hideFinancials: hideFinancials,
              onTap: () => onToggleBrand(brand),
            ),
          );
        },
      ),
    );
  }
}

class _BrandTableHeader extends StatelessWidget {
  const _BrandTableHeader({
    required this.canCollapse,
    required this.onCollapseAll,
  });

  final bool canCollapse;
  final VoidCallback onCollapseAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.symmetric(horizontal: 17),
      decoration: const BoxDecoration(
        color: _surfaceSoft,
        border: Border(bottom: BorderSide(color: _line)),
      ),
      child: _BrandGridRow(
        cells: [
          const Text('BRAND'),
          const Text('COUNT'),
          const Text('BUY PRICE'),
          const Text('SELL PRICE'),
          const Text('BUY / SELL NET'),
          const Text('EXPENSES'),
          const Text('REVENUE'),
          const Text('TOTAL NET'),
          _HeaderCollapseButton(enabled: canCollapse, onPressed: onCollapseAll),
        ],
        isHeader: true,
      ),
    );
  }
}

class _BrandItem extends StatelessWidget {
  const _BrandItem({
    required this.brand,
    required this.rank,
    required this.isOpen,
    required this.isCompact,
    required this.hideFinancials,
    required this.onTap,
  });

  final _BrandAnalysis brand;
  final int? rank;
  final bool isOpen;
  final bool isCompact;
  final bool hideFinancials;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _line)),
      ),
      child: Column(
        children: [
          if (isCompact)
            _CompactBrandRow(
              brand: brand,
              rank: rank,
              isOpen: isOpen,
              hideFinancials: hideFinancials,
              onTap: onTap,
            )
          else
            _DesktopBrandRow(
              brand: brand,
              rank: rank,
              isOpen: isOpen,
              hideFinancials: hideFinancials,
              onTap: onTap,
            ),
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: isOpen
                ? _BrandDetails(
                    brand: brand,
                    isCompact: isCompact,
                    hideFinancials: hideFinancials,
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }
}

class _DesktopBrandRow extends StatelessWidget {
  const _DesktopBrandRow({
    required this.brand,
    required this.rank,
    required this.isOpen,
    required this.hideFinancials,
    required this.onTap,
  });

  final _BrandAnalysis brand;
  final int? rank;
  final bool isOpen;
  final bool hideFinancials;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isOpen ? _primarySoft : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        hoverColor: _surfaceSoft,
        splashColor: _primary.withValues(alpha: 0.08),
        highlightColor: _primary.withValues(alpha: 0.05),
        child: Container(
          constraints: const BoxConstraints(minHeight: 70),
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
          child: _BrandGridRow(
            cells: [
              _BrandIdentity(
                brandName: brand.name,
                rank: rank,
                isOthers: brand.isOthers,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: _CarCountBadge(count: brand.safeCarCount),
              ),
              _MoneyValue(value: brand.safeBuyPrice, hidden: hideFinancials),
              _MoneyValue(value: brand.safeSellPrice, hidden: hideFinancials),
              _MoneyValue(
                value: brand.safeBuySellNet,
                hidden: hideFinancials,
                color: _netColor(brand.safeBuySellNet),
              ),
              _MoneyValue(value: brand.safeExpenses, hidden: hideFinancials),
              _MoneyValue(value: brand.safeRevenue, hidden: hideFinancials),
              _MoneyValue(
                value: brand.safeTotalNet,
                hidden: hideFinancials,
                color: _netColor(brand.safeTotalNet),
                strong: true,
              ),
              _ChevronBox(isOpen: isOpen),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompactBrandRow extends StatelessWidget {
  const _CompactBrandRow({
    required this.brand,
    required this.rank,
    required this.isOpen,
    required this.hideFinancials,
    required this.onTap,
  });

  final _BrandAnalysis brand;
  final int? rank;
  final bool isOpen;
  final bool hideFinancials;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isOpen ? _primarySoft : _surface,
      child: InkWell(
        onTap: onTap,
        splashColor: _primary.withValues(alpha: 0.08),
        highlightColor: _primary.withValues(alpha: 0.05),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _BrandIdentity(
                      brandName: brand.name,
                      rank: rank,
                      isOthers: brand.isOthers,
                    ),
                  ),
                  const SizedBox(width: 12),
                  _CarCountBadge(count: brand.safeCarCount),
                  const SizedBox(width: 8),
                  _ChevronBox(isOpen: isOpen),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _CompactMetricTile(
                      label: 'Buy',
                      value: brand.safeBuyPrice,
                      hidden: hideFinancials,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _CompactMetricTile(
                      label: 'Sell',
                      value: brand.safeSellPrice,
                      hidden: hideFinancials,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _CompactMetricTile(
                      label: 'Net',
                      value: brand.safeTotalNet,
                      color: _netColor(brand.safeTotalNet),
                      hidden: hideFinancials,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandGridRow extends StatelessWidget {
  const _BrandGridRow({required this.cells, this.isHeader = false});

  final List<Widget> cells;
  final bool isHeader;

  static const _flexes = [34, 8, 13, 13, 14, 11, 11, 13, 5];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < cells.length; i++) ...[
          Expanded(
            flex: _flexes[i],
            child: Align(
              alignment: i == 0 ? Alignment.centerLeft : Alignment.centerRight,
              child: DefaultTextStyle.merge(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: _muted,
                  fontSize: isHeader ? 10 : 12,
                  fontWeight: isHeader ? FontWeight.w900 : FontWeight.w800,
                  letterSpacing: isHeader ? 0.5 : 0,
                ),
                child: cells[i],
              ),
            ),
          ),
          if (i != cells.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _BrandIdentity extends StatelessWidget {
  const _BrandIdentity({
    required this.brandName,
    required this.rank,
    required this.isOthers,
  });

  final String brandName;
  final int? rank;
  final bool isOthers;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RankBadge(rank: rank),
        const SizedBox(width: 12),
        _BrandLogo(brandName: brandName, isOthers: isOthers, size: 42),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                brandName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _text,
                  fontSize: 13,
                  height: 1.15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                isOthers
                    ? 'Combined remaining brands'
                    : 'Ranked by purchase value',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.rank});

  final int? rank;

  @override
  Widget build(BuildContext context) {
    final text = rank == null ? '—' : '$rank';
    final colors = switch (rank) {
      1 => (fg: const Color(0xFF8A6508), bg: const Color(0xFFFFF5D4)),
      2 => (fg: const Color(0xFF66707E), bg: const Color(0xFFEDF1F5)),
      3 => (fg: const Color(0xFF925A2D), bg: const Color(0xFFFFF0E3)),
      _ => (fg: _muted, bg: _surfaceStrong),
    };

    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: colors.fg,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _BrandLogo extends StatelessWidget {
  const _BrandLogo({
    required this.brandName,
    required this.isOthers,
    required this.size,
  });

  final String brandName;
  final bool isOthers;
  final double size;

  @override
  Widget build(BuildContext context) {
    final slug = _brandSlug(brandName);
    final borderRadius = BorderRadius.circular(size * 0.31);

    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _surface,
        border: Border.all(color: _line),
        borderRadius: borderRadius,
      ),
      child: isOthers || slug.isEmpty
          ? _LogoFallback(brandName: brandName, isOthers: isOthers)
          : Image.asset(
              'assets/logos/thumb/$slug.png',
              width: size * 0.64,
              height: size * 0.64,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.low,
              errorBuilder: (_, _, _) {
                return _LogoFallback(brandName: brandName, isOthers: isOthers);
              },
            ),
    );
  }
}

class _LogoFallback extends StatelessWidget {
  const _LogoFallback({required this.brandName, required this.isOthers});

  final String brandName;
  final bool isOthers;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        isOthers ? '•••' : _initials(brandName),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: _primaryDark,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _CarCountBadge extends StatelessWidget {
  const _CarCountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final text = '$count';
    final width = math.max(22.0, 14 + (text.length * 7.0));

    return SizedBox(
      width: width,
      height: 22,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: _primarySoft,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: _primaryDark,
              fontSize: 9.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChevronBox extends StatelessWidget {
  const _ChevronBox({required this.isOpen});

  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 190),
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isOpen ? _primary : _surfaceSoft,
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedRotation(
        duration: const Duration(milliseconds: 190),
        turns: isOpen ? 0.5 : 0,
        child: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: isOpen ? Colors.white : _muted,
          size: 22,
        ),
      ),
    );
  }
}

class _CompactMetricTile extends StatelessWidget {
  const _CompactMetricTile({
    required this.label,
    required this.value,
    required this.hidden,
    this.color = _text,
  });

  final String label;
  final double value;
  final bool hidden;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: _surfaceSoft,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _muted,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          _MoneyValue(
            value: value,
            hidden: hidden,
            color: color,
            strong: true,
            alignRight: false,
          ),
        ],
      ),
    );
  }
}

class _BrandDetails extends StatelessWidget {
  const _BrandDetails({
    required this.brand,
    required this.isCompact,
    required this.hideFinancials,
  });

  final _BrandAnalysis brand;
  final bool isCompact;
  final bool hideFinancials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF7FAFC),
      padding: EdgeInsets.fromLTRB(isCompact ? 13 : 78, 16, 17, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DetailSummary(
            brand: brand,
            hideFinancials: hideFinancials,
            isCompact: isCompact,
          ),
          const SizedBox(height: 12),
          _CarsPanel(
            cars: brand.safeCars,
            isCompact: isCompact,
            hideFinancials: hideFinancials,
          ),
        ],
      ),
    );
  }
}

class _DetailSummary extends StatelessWidget {
  const _DetailSummary({
    required this.brand,
    required this.hideFinancials,
    required this.isCompact,
  });

  final _BrandAnalysis brand;
  final bool hideFinancials;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _DetailCardData('Total Paid', brand.safeTotalPaid, _red),
      _DetailCardData('Total Received', brand.safeTotalReceived, _green),
      _DetailCardData(
        'Expense / Revenue Net',
        brand.safeExpensesRevenueNet,
        _netColor(brand.safeExpensesRevenueNet),
      ),
      _DetailCardData(
        'Total Net',
        brand.safeTotalNet,
        _netColor(brand.safeTotalNet),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = isCompact
            ? 2
            : constraints.maxWidth > 960
            ? 4
            : 2;
        final spacing = isCompact ? 8.0 : 10.0;
        final width =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final card in cards)
              SizedBox(
                width: width,
                child: _DetailCard(data: card, hidden: hideFinancials),
              ),
          ],
        );
      },
    );
  }
}

class _DetailCardData {
  const _DetailCardData(this.label, this.value, this.color);

  final String label;
  final double value;
  final Color color;
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.data, required this.hidden});

  final _DetailCardData data;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _surface,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _muted,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 8),
          _MoneyValue(
            value: data.value,
            hidden: hidden,
            color: data.color,
            strong: true,
            fontSize: 15,
            alignRight: false,
          ),
        ],
      ),
    );
  }
}

class _CarsPanel extends StatelessWidget {
  const _CarsPanel({
    required this.cars,
    required this.isCompact,
    required this.hideFinancials,
  });

  final List<_CarAnalysis> cars;
  final bool isCompact;
  final bool hideFinancials;

  @override
  Widget build(BuildContext context) {
    if (cars.isEmpty) {
      return const _CarsEmptyState();
    }

    return Container(
      decoration: BoxDecoration(
        color: _surface,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: isCompact
          ? _CompactCarsList(cars: cars, hideFinancials: hideFinancials)
          : _DesktopCarsTable(cars: cars, hideFinancials: hideFinancials),
    );
  }
}

class _DesktopCarsTable extends StatefulWidget {
  const _DesktopCarsTable({required this.cars, required this.hideFinancials});

  final List<_CarAnalysis> cars;
  final bool hideFinancials;

  @override
  State<_DesktopCarsTable> createState() => _DesktopCarsTableState();
}

class _DesktopCarsTableState extends State<_DesktopCarsTable> {
  int _currentRowPage = 0;

  int get _rowPageCount =>
      math.max(1, (widget.cars.length / _carsRowsPerPage).ceil());

  int get _lastRowPage => math.max(0, _rowPageCount - 1);

  int get _rowStart => _currentRowPage * _carsRowsPerPage;

  int get _rowEnd => math.min(_rowStart + _carsRowsPerPage, widget.cars.length);

  List<_CarAnalysis> get _visibleCars =>
      widget.cars.skip(_rowStart).take(_carsRowsPerPage).toList();

  @override
  void didUpdateWidget(covariant _DesktopCarsTable oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_currentRowPage > _lastRowPage) {
      _currentRowPage = _lastRowPage;
    }
  }

  void _goToRowPage(int page) {
    final nextPage = page.clamp(0, _lastRowPage).toInt();
    if (nextPage == _currentRowPage) return;
    setState(() => _currentRowPage = nextPage);
  }

  @override
  Widget build(BuildContext context) {
    final visibleCars = _visibleCars;
    final showRowPager = _rowPageCount > 1;
    final tableHeight =
        42.0 + (visibleCars.length * 49.0) + (showRowPager ? 38.0 : 0);

    return SizedBox(
      height: tableHeight,
      child: Column(
        children: [
          _CarTableHeader(columns: _carMetricColumns),
          for (var index = 0; index < visibleCars.length; index++) ...[
            _CarTableRow(
              car: visibleCars[index],
              index: _rowStart + index,
              columns: _carMetricColumns,
              hideFinancials: widget.hideFinancials,
            ),
            if (index != visibleCars.length - 1)
              const Divider(height: 1, thickness: 1, color: _line),
          ],
          if (showRowPager)
            _CarRowsPagerBar(
              currentPage: _currentRowPage,
              pageCount: _rowPageCount,
              startRow: _rowStart + 1,
              endRow: _rowEnd,
              totalRows: widget.cars.length,
              onFirst: () => _goToRowPage(0),
              onPrevious: () => _goToRowPage(_currentRowPage - 1),
              onNext: () => _goToRowPage(_currentRowPage + 1),
              onLast: () => _goToRowPage(_lastRowPage),
            ),
        ],
      ),
    );
  }
}

class _CarRowsPagerBar extends StatelessWidget {
  const _CarRowsPagerBar({
    required this.currentPage,
    required this.pageCount,
    required this.startRow,
    required this.endRow,
    required this.totalRows,
    required this.onFirst,
    required this.onPrevious,
    required this.onNext,
    required this.onLast,
  });

  final int currentPage;
  final int pageCount;
  final int startRow;
  final int endRow;
  final int totalRows;
  final VoidCallback onFirst;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onLast;

  @override
  Widget build(BuildContext context) {
    final canGoBack = currentPage > 0;
    final canGoForward = currentPage < pageCount - 1;

    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: _surface,
        border: Border(top: BorderSide(color: _line)),
      ),
      child: Row(
        children: [
          const Icon(Icons.directions_car_outlined, size: 16, color: _muted),
          const SizedBox(width: 7),
          Text(
            'Cars $startRow-$endRow of $totalRows',
            style: const TextStyle(
              color: _muted,
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          _InnerTablePagerButton(
            icon: Icons.keyboard_double_arrow_left_rounded,
            enabled: canGoBack,
            onPressed: onFirst,
          ),
          const SizedBox(width: 5),
          _InnerTablePagerButton(
            icon: Icons.chevron_left_rounded,
            enabled: canGoBack,
            onPressed: onPrevious,
          ),
          Container(
            height: 26,
            constraints: const BoxConstraints(minWidth: 44),
            margin: const EdgeInsets.symmetric(horizontal: 7),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _surfaceSoft,
              border: Border.all(color: _line),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${currentPage + 1} / $pageCount',
              style: const TextStyle(
                color: _text,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          _InnerTablePagerButton(
            icon: Icons.chevron_right_rounded,
            enabled: canGoForward,
            onPressed: onNext,
          ),
          const SizedBox(width: 5),
          _InnerTablePagerButton(
            icon: Icons.keyboard_double_arrow_right_rounded,
            enabled: canGoForward,
            onPressed: onLast,
          ),
        ],
      ),
    );
  }
}

class _InnerTablePagerButton extends StatelessWidget {
  const _InnerTablePagerButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: OutlinedButton(
        onPressed: enabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: _muted,
          disabledForegroundColor: _muted.withValues(alpha: 0.35),
          backgroundColor: _surfaceSoft,
          disabledBackgroundColor: _surfaceSoft,
          padding: EdgeInsets.zero,
          minimumSize: const Size(28, 28),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          side: BorderSide(
            color: enabled ? _lineStrong : _line.withValues(alpha: 0.55),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}

class _CarTableHeader extends StatelessWidget {
  const _CarTableHeader({required this.columns});

  final List<_CarMetricColumn> columns;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: _surfaceSoft,
        border: Border(bottom: BorderSide(color: _line)),
      ),
      child: _CarGridRow(
        isHeader: true,
        cells: [
          const Text('#'),
          const Text('BRAND / MODEL / TRIM'),
          for (final column in columns) Text(column.label),
        ],
      ),
    );
  }
}

class _CarTableRow extends StatelessWidget {
  const _CarTableRow({
    required this.car,
    required this.index,
    required this.columns,
    required this.hideFinancials,
  });

  final _CarAnalysis car;
  final int index;
  final List<_CarMetricColumn> columns;
  final bool hideFinancials;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: _CarGridRow(
        cells: [
          _CarIndexBadge(index: index + 1),
          _VehicleInlineName(car: car),
          for (final column in columns)
            _MoneyValue(
              value: column.value(car),
              hidden: hideFinancials,
              color: column.color?.call(car) ?? _text,
              strong: column.strong,
            ),
        ],
      ),
    );
  }
}

class _CarGridRow extends StatelessWidget {
  const _CarGridRow({required this.cells, this.isHeader = false});

  final List<Widget> cells;
  final bool isHeader;

  static const _fixedFlexes = [5, 31];
  static const _metricFlex = 16;

  @override
  Widget build(BuildContext context) {
    final flexes = [
      ..._fixedFlexes,
      for (var i = 0; i < cells.length - _fixedFlexes.length; i++) _metricFlex,
    ];

    return Row(
      children: [
        for (var i = 0; i < cells.length; i++) ...[
          Expanded(
            flex: flexes[i],
            child: Align(
              alignment: i <= 1 ? Alignment.centerLeft : Alignment.centerRight,
              child: DefaultTextStyle.merge(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: _muted,
                  fontSize: isHeader ? 9 : 11,
                  fontWeight: isHeader ? FontWeight.w900 : FontWeight.w800,
                  letterSpacing: isHeader ? 0.35 : 0,
                ),
                child: cells[i],
              ),
            ),
          ),
          if (i != cells.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _CompactCarsList extends StatefulWidget {
  const _CompactCarsList({required this.cars, required this.hideFinancials});

  final List<_CarAnalysis> cars;
  final bool hideFinancials;

  @override
  State<_CompactCarsList> createState() => _CompactCarsListState();
}

class _CompactCarsListState extends State<_CompactCarsList> {
  int _currentRowPage = 0;

  int get _rowPageCount =>
      math.max(1, (widget.cars.length / _carsRowsPerPage).ceil());

  int get _lastRowPage => math.max(0, _rowPageCount - 1);

  int get _rowStart => _currentRowPage * _carsRowsPerPage;

  int get _rowEnd => math.min(_rowStart + _carsRowsPerPage, widget.cars.length);

  List<_CarAnalysis> get _visibleCars =>
      widget.cars.skip(_rowStart).take(_carsRowsPerPage).toList();

  @override
  void didUpdateWidget(covariant _CompactCarsList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_currentRowPage > _lastRowPage) {
      _currentRowPage = _lastRowPage;
    }
  }

  void _goToRowPage(int page) {
    final nextPage = page.clamp(0, _lastRowPage).toInt();
    if (nextPage == _currentRowPage) return;
    setState(() => _currentRowPage = nextPage);
  }

  @override
  Widget build(BuildContext context) {
    final visibleCars = _visibleCars;
    final showRowPager = _rowPageCount > 1;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              for (var index = 0; index < visibleCars.length; index++) ...[
                _CompactCarCard(
                  car: visibleCars[index],
                  index: _rowStart + index,
                  hideFinancials: widget.hideFinancials,
                ),
                if (index != visibleCars.length - 1) const SizedBox(height: 9),
              ],
            ],
          ),
        ),
        if (showRowPager)
          _CompactRowsPagerBar(
            currentPage: _currentRowPage,
            pageCount: _rowPageCount,
            startRow: _rowStart + 1,
            endRow: _rowEnd,
            totalRows: widget.cars.length,
            onFirst: () => _goToRowPage(0),
            onPrevious: () => _goToRowPage(_currentRowPage - 1),
            onNext: () => _goToRowPage(_currentRowPage + 1),
            onLast: () => _goToRowPage(_lastRowPage),
          ),
      ],
    );
  }
}

class _CompactRowsPagerBar extends StatelessWidget {
  const _CompactRowsPagerBar({
    required this.currentPage,
    required this.pageCount,
    required this.startRow,
    required this.endRow,
    required this.totalRows,
    required this.onFirst,
    required this.onPrevious,
    required this.onNext,
    required this.onLast,
  });

  final int currentPage;
  final int pageCount;
  final int startRow;
  final int endRow;
  final int totalRows;
  final VoidCallback onFirst;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onLast;

  @override
  Widget build(BuildContext context) {
    final canGoBack = currentPage > 0;
    final canGoForward = currentPage < pageCount - 1;

    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: _surface,
        border: Border(top: BorderSide(color: _line)),
      ),
      child: Row(
        children: [
          Text(
            '$startRow-$endRow / $totalRows',
            style: const TextStyle(
              color: _muted,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          _InnerTablePagerButton(
            icon: Icons.keyboard_double_arrow_left_rounded,
            enabled: canGoBack,
            onPressed: onFirst,
          ),
          const SizedBox(width: 5),
          _InnerTablePagerButton(
            icon: Icons.chevron_left_rounded,
            enabled: canGoBack,
            onPressed: onPrevious,
          ),
          Container(
            height: 26,
            constraints: const BoxConstraints(minWidth: 42),
            margin: const EdgeInsets.symmetric(horizontal: 6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _surfaceSoft,
              border: Border.all(color: _line),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${currentPage + 1} / $pageCount',
              style: const TextStyle(
                color: _text,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          _InnerTablePagerButton(
            icon: Icons.chevron_right_rounded,
            enabled: canGoForward,
            onPressed: onNext,
          ),
          const SizedBox(width: 5),
          _InnerTablePagerButton(
            icon: Icons.keyboard_double_arrow_right_rounded,
            enabled: canGoForward,
            onPressed: onLast,
          ),
        ],
      ),
    );
  }
}

class _CompactCarCard extends StatelessWidget {
  const _CompactCarCard({
    required this.car,
    required this.index,
    required this.hideFinancials,
  });

  final _CarAnalysis car;
  final int index;
  final bool hideFinancials;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: _surfaceSoft,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _CarIndexBadge(index: index + 1),
              const SizedBox(width: 9),
              Expanded(child: _VehicleInlineName(car: car, compact: true)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _TinyMoneyTile(
                  label: 'Buy',
                  value: car.safeBuyPrice,
                  hidden: hideFinancials,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _TinyMoneyTile(
                  label: 'Sell',
                  value: car.safeSellPrice,
                  hidden: hideFinancials,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: _TinyMoneyTile(
                  label: 'Net',
                  value: car.safeTotalNet,
                  color: _netColor(car.safeTotalNet),
                  hidden: hideFinancials,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VehicleInlineName extends StatelessWidget {
  const _VehicleInlineName({required this.car, this.compact = false});

  final _CarAnalysis car;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final meta = [
      if (car.year.isNotEmpty) car.year,
      if (car.safeStatus.isNotEmpty) car.safeStatus,
    ].join('  ·  ');

    return Row(
      children: [
        _BrandLogo(
          brandName: car.safeBrandName,
          isOthers: false,
          size: compact ? 34 : 34,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: TextStyle(
                    color: _text,
                    fontSize: compact ? 12 : 11,
                    fontWeight: FontWeight.w900,
                  ),
                  children: [
                    TextSpan(
                      text: car.safeBrandName,
                      style: const TextStyle(color: _primaryDark),
                    ),
                    const TextSpan(
                      text: ' / ',
                      style: TextStyle(color: _muted),
                    ),
                    TextSpan(text: car.safeModelName),
                    if (car.safeTrim.isNotEmpty) ...[
                      const TextSpan(
                        text: ' / ',
                        style: TextStyle(color: _muted),
                      ),
                      TextSpan(
                        text: car.safeTrim,
                        style: const TextStyle(color: _muted),
                      ),
                    ],
                  ],
                ),
              ),
              if (meta.isNotEmpty) ...[
                const SizedBox(height: 3),
                Text(
                  meta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _CarIndexBadge extends StatelessWidget {
  const _CarIndexBadge({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _surfaceStrong,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$index',
        style: const TextStyle(
          color: _muted,
          fontSize: 9,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _TinyMoneyTile extends StatelessWidget {
  const _TinyMoneyTile({
    required this.label,
    required this.value,
    required this.hidden,
    this.color = _text,
  });

  final String label;
  final double value;
  final bool hidden;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _muted,
            fontSize: 9,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        _MoneyValue(
          value: value,
          hidden: hidden,
          color: color,
          strong: true,
          fontSize: 11,
          alignRight: false,
        ),
      ],
    );
  }
}

class _MoneyValue extends StatelessWidget {
  const _MoneyValue({
    required this.value,
    required this.hidden,
    this.color = _text,
    this.strong = false,
    this.fontSize = 12,
    this.alignRight = true,
  });

  final double value;
  final bool hidden;
  final Color color;
  final bool strong;
  final double fontSize;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    final display = hidden ? '••••••' : priceFormat.format(value);

    return Text(
      display,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: alignRight ? TextAlign.right : TextAlign.left,
      style: TextStyle(
        color: hidden ? _muted.withValues(alpha: 0.72) : color,
        fontSize: fontSize,
        height: 1.1,
        fontWeight: strong ? FontWeight.w900 : FontWeight.w800,
        letterSpacing: hidden ? 1.4 : 0,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
  }
}

class _AnalysisLoadingState extends StatelessWidget {
  const _AnalysisLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 32,
        height: 32,
        child: CircularProgressIndicator(strokeWidth: 3, color: _primary),
      ),
    );
  }
}

class _AnalysisEmptyState extends StatelessWidget {
  const _AnalysisEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        decoration: BoxDecoration(
          color: _surfaceSoft,
          border: Border.all(color: _line),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.directions_car_filled_outlined, color: _muted, size: 34),
            SizedBox(height: 10),
            Text(
              'No cars to analyze',
              style: TextStyle(
                color: _text,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Change the filters and run Find to see brand performance.',
              style: TextStyle(
                color: _muted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CarsEmptyState extends StatelessWidget {
  const _CarsEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(28),
      child: Text(
        'No cars are available for this brand.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: _muted,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CarMetricColumn {
  const _CarMetricColumn({
    required this.label,
    required this.value,
    this.color,
    this.strong = false,
  });

  final String label;
  final double Function(_CarAnalysis car) value;
  final Color Function(_CarAnalysis car)? color;
  final bool strong;
}

List<_BrandAnalysis> _buildBrandAnalysis(
  List<vehicle_analysis_model.VehicleAnalysisModel> analysis, {
  _VehicleStatusFilter statusFilter = _VehicleStatusFilter.all,
}) {
  if (statusFilter == _VehicleStatusFilter.all) {
    return analysis.toList(growable: false);
  }

  final accumulators = <String, _BrandAnalysisAccumulator>{};

  for (final brand in analysis) {
    for (final car in brand.cars ?? const <vehicle_analysis_model.Cars>[]) {
      if (!statusFilter.matches(car.safeStatus)) continue;

      final brandName = _displayText(
        car.brandName ?? brand.brandName,
        fallback: 'Unknown Brand',
      );
      final brandId = (car.brandId ?? brand.brandId ?? '').trim();
      final key = brandId.isNotEmpty ? brandId : brandName.toLowerCase();

      accumulators
          .putIfAbsent(
            key,
            () => _BrandAnalysisAccumulator(
              brandId: brandId,
              brandName: brandName,
            ),
          )
          .add(car);
    }
  }

  if (accumulators.isEmpty) return const [];

  final sortedAccumulators = accumulators.values.toList()
    ..sort((a, b) => b.buyPrice.compareTo(a.buyPrice));

  final result = <_BrandAnalysis>[];
  _BrandAnalysisAccumulator? others;

  for (var index = 0; index < sortedAccumulators.length; index++) {
    final accumulator = sortedAccumulators[index];
    if (index < 10) {
      result.add(accumulator.toModel());
    } else {
      others ??= _BrandAnalysisAccumulator(
        brandId: 'others',
        brandName: 'Others',
      );
      others.addAccumulator(accumulator);
    }
  }

  if (others != null && others.carCount > 0) {
    result.add(others.toModel());
  }

  return result;
}

class _BrandAnalysisAccumulator {
  _BrandAnalysisAccumulator({required this.brandId, required this.brandName});

  final String brandId;
  final String brandName;
  final List<_CarAnalysis> cars = [];
  int carCount = 0;
  double buyPrice = 0;
  double sellPrice = 0;
  double totalPaid = 0;
  double totalReceived = 0;
  double expenses = 0;
  double revenue = 0;

  void add(_CarAnalysis car) {
    cars.add(car);
    carCount += 1;
    buyPrice += car.safeBuyPrice;
    sellPrice += car.safeSellPrice;
    totalPaid += car.safeTotalPaid;
    totalReceived += car.safeTotalReceived;
    expenses += car.safeExpenses;
    revenue += car.safeRevenue;
  }

  void addAccumulator(_BrandAnalysisAccumulator accumulator) {
    cars.addAll(accumulator.cars);
    carCount += accumulator.carCount;
    buyPrice += accumulator.buyPrice;
    sellPrice += accumulator.sellPrice;
    totalPaid += accumulator.totalPaid;
    totalReceived += accumulator.totalReceived;
    expenses += accumulator.expenses;
    revenue += accumulator.revenue;
  }

  _BrandAnalysis toModel() {
    return vehicle_analysis_model.VehicleAnalysisModel(
      brandId: brandId,
      brandName: brandName,
      carCount: carCount,
      buyPrice: buyPrice,
      sellPrice: sellPrice,
      buySellNet: sellPrice - buyPrice,
      totalPaid: totalPaid,
      totalReceived: totalReceived,
      expenses: expenses,
      revenue: revenue,
      expensesRevenueNet: revenue - expenses,
      totalNet: totalReceived - totalPaid,
      cars: cars,
    );
  }
}

extension _VehicleAnalysisBrandModelView on _BrandAnalysis {
  String get key {
    final normalizedBrandId = brandId?.trim() ?? '';
    if (normalizedBrandId.isNotEmpty) return normalizedBrandId;
    return name.toLowerCase();
  }

  String get name => _displayText(brandName, fallback: 'Unknown Brand');

  bool get isOthers => key.toLowerCase() == 'others';

  int get safeCarCount => carCount ?? safeCars.length;

  List<_CarAnalysis> get safeCars {
    final sortedCars = [...(cars ?? const <vehicle_analysis_model.Cars>[])]
      ..sort((a, b) => b.safeBuyPrice.compareTo(a.safeBuyPrice));
    return sortedCars;
  }

  double get safeBuyPrice => buyPrice ?? 0;

  double get safeSellPrice => sellPrice ?? 0;

  double get safeBuySellNet => buySellNet ?? (safeSellPrice - safeBuyPrice);

  double get safeExpenses => expenses ?? 0;

  double get safeRevenue => revenue ?? 0;

  double get safeExpensesRevenueNet =>
      expensesRevenueNet ?? (safeRevenue - safeExpenses);

  double get safeTotalPaid => totalPaid ?? 0;

  double get safeTotalReceived => totalReceived ?? 0;

  double get safeTotalNet => totalNet ?? (safeTotalReceived - safeTotalPaid);
}

extension _VehicleAnalysisCarModelView on _CarAnalysis {
  String get safeBrandName =>
      _displayText(brandName, fallback: 'Unknown Brand');

  String get safeModelName =>
      _displayText(modelName, fallback: 'Unknown Model');

  String get safeTrim => trim?.trim() ?? '';

  String get year => '';

  String get safeStatus => status?.trim() ?? '';

  double get safeBuyPrice => buyPrice ?? 0;

  double get safeSellPrice => sellPrice ?? 0;

  double get safeBuySellNet => buySellNet ?? (safeSellPrice - safeBuyPrice);

  double get safeExpenses => expenses ?? 0;

  double get safeRevenue => revenue ?? 0;

  double get safeExpensesRevenueNet =>
      expensesRevenueNet ?? (safeRevenue - safeExpenses);

  double get safeTotalPaid => totalPaid ?? 0;

  double get safeTotalReceived => totalReceived ?? 0;

  double get safeTotalNet => totalNet ?? (safeTotalReceived - safeTotalPaid);
}

String _displayText(String? value, {required String fallback}) {
  final normalized = value?.trim() ?? '';
  return normalized.isEmpty ? fallback : normalized;
}

Color _netColor(double value) {
  if (value > 0) return _green;
  if (value < 0) return _red;
  return _blue;
}

String _initials(String value) {
  final parts = value
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .take(2)
      .toList();

  if (parts.isEmpty) return '?';
  return parts.map((part) => part.substring(0, 1)).join().toUpperCase();
}

String _brandSlug(String brandName) {
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
