import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../consts.dart';

const _background = Color(0xFFF7F9FC);
const _surface = Colors.white;
const _line = Color(0xFFE1E7EF);
const _text = Color(0xFF172231);
const _muted = Color(0xFF6C798A);
const _primary = Color(0xFF0C7C86);
const _primarySoft = Color(0xFFE7F7F8);
const _blue = Color(0xFF3978C5);
const _blueSoft = Color(0xFFEAF2FC);
const _green = Color(0xFF2F9E62);
const _greenSoft = Color(0xFFEAF8F0);
const _orange = Color(0xFFF08A24);
const _orangeSoft = Color(0xFFFFF3E8);
const _red = Color(0xFFD95757);
const _redSoft = Color(0xFFFDEEEE);
const _purple = Color(0xFF7759B8);
const _purpleSoft = Color(0xFFF1EDFA);

class SummarySection extends StatefulWidget {
  const SummarySection({super.key});

  @override
  State<SummarySection> createState() => _SummarySectionState();
}

class _SummarySectionState extends State<SummarySection>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _selectCustomRange(
    CarTradingDashboardController controller,
  ) async {
    final now = DateTime.now();
    final currentRange = controller.dashboardSummaryCustomRange.value;
    var start = currentRange?.start ?? DateTime(now.year, now.month, 1);
    var end = currentRange?.end ?? now;
    var selectingEnd = false;
    final selected = await showDialog<DateTimeRange>(
      context: context,
      barrierColor: const Color(0x660D1726),
      builder: (dialogContext) {
        final screen = MediaQuery.sizeOf(dialogContext);
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final calendarDate = selectingEnd ? end : start;
            return Dialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                width: 420,
                height: (screen.height - 36).clamp(440, 525),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFCAD6E1)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33142335),
                      blurRadius: 30,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(15, 12, 9, 12),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF075F67), Color(0xFF0C7C86)],
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 31,
                            height: 31,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .14),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: const Icon(
                              Icons.date_range_rounded,
                              size: 17,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 9),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Custom Period',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  'Choose the first and last day',
                                  style: TextStyle(
                                    color: Color(0xFFD2ECEE),
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(13, 12, 13, 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: _DateSelectionChip(
                              label: 'FROM',
                              date: start,
                              selected: !selectingEnd,
                              onPressed: () {
                                setDialogState(() => selectingEnd = false);
                              },
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: _muted,
                            ),
                          ),
                          Expanded(
                            child: _DateSelectionChip(
                              label: 'TO',
                              date: end,
                              selected: selectingEnd,
                              onPressed: () {
                                setDialogState(() => selectingEnd = true);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: Theme.of(
                            context,
                          ).colorScheme.copyWith(primary: _primary),
                        ),
                        child: CalendarDatePicker(
                          key: ValueKey(
                            '${selectingEnd ? 'end' : 'start'}-${calendarDate.year}-${calendarDate.month}',
                          ),
                          initialDate: calendarDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(now.year + 2, 12, 31),
                          onDateChanged: (date) {
                            setDialogState(() {
                              if (selectingEnd) {
                                if (date.isBefore(start)) {
                                  start = date;
                                  end = date;
                                } else {
                                  end = date;
                                }
                              } else {
                                start = date;
                                if (end.isBefore(start)) end = start;
                                selectingEnd = true;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(13, 9, 13, 13),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFAFBFD),
                        border: Border(top: BorderSide(color: _line)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 7),
                          FilledButton.icon(
                            onPressed: () {
                              Navigator.pop(
                                dialogContext,
                                DateTimeRange(start: start, end: end),
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: _primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 11,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                            icon: const Icon(Icons.check_rounded, size: 15),
                            label: const Text(
                              'Apply Period',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    if (selected == null || !mounted) return;
    await controller.changeDashboardSummaryRange(
      'custom',
      customRange: selected,
    );
  }

  void _changeRange(CarTradingDashboardController controller, String value) {
    if (controller.dashboardSummaryRange.value == value && value != 'custom') {
      return;
    }
    if (value == 'custom') {
      _selectCustomRange(controller);
      return;
    }
    controller.changeDashboardSummaryRange(value);
  }

  void _openTab(String? tab) {
    final index = switch (tab) {
      'cars' => 0,
      'expenses' => 2,
      'bank_accounts' => 5,
      'outstanding' => 6,
      _ => null,
    };
    if (index != null) DefaultTabController.of(context).animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetX<CarTradingDashboardController>(
      builder: (controller) {
        final summary = controller.dashboardExecutiveSummary;
        final loading = controller.isDashboardSummaryLoading.value;
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: _background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFDDE5ED)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D17283E),
                blurRadius: 14,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _SummaryToolbar(
                selectedRange: controller.dashboardSummaryRange.value,
                customRange: controller.dashboardSummaryCustomRange.value,
                loading: loading,
                showFinancials: controller.showDashboardSummaryFinancials.value,
                generatedAt: summary['generated_at']?.toString(),
                onRangeChanged: (value) => _changeRange(controller, value),
                onToggleFinancials: controller.toggleDashboardSummaryFinancials,
                onRefresh: loading ? null : controller.getDashboardSummary,
              ),
              Expanded(child: _buildBody(controller)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(CarTradingDashboardController controller) {
    final summary = controller.dashboardExecutiveSummary;
    final loading = controller.isDashboardSummaryLoading.value;
    final error = controller.dashboardSummaryError.value;
    final showFinancials = controller.showDashboardSummaryFinancials.value;
    if (summary.isEmpty && error == null) {
      return const _LoadingDashboard();
    }
    if (error != null && summary.isEmpty) {
      return _ErrorState(
        message: error,
        onRetry: controller.getDashboardSummary,
      );
    }

    final performance = _map(summary['performance']);
    final current = _map(performance['current']);
    final deltas = _map(performance['deltas']);
    final position = _map(summary['position']);
    final trends = _list(summary['trends']);
    final brandRows = _list(summary['brand_performance']);
    final expenses = _list(summary['expense_breakdown']);
    final accounts = _list(summary['accounts']);
    final capitalByRows = _list(summary['capital_by_summary']);
    final inventoryAging = _list(summary['inventory_aging']);
    final outstandingAging = _list(summary['outstanding_aging']);
    final topVehicles = _list(summary['top_vehicles']);
    final alerts = _list(summary['alerts']);
    final recentChanges = _list(summary['recent_changes']);

    return Stack(
      children: [
        Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(12, 12, 18, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _InsightBanner(
                  text:
                      summary['insight']?.toString() ??
                      'Your business summary is ready.',
                  period: _map(summary['period'])['label']?.toString(),
                ),
                const SizedBox(height: 14),
                const _SectionHeading(
                  title: 'Period Performance',
                  subtitle:
                      'Realized trading performance for the selected period',
                ),
                const SizedBox(height: 9),
                _MetricGrid(
                  children: [
                    _MetricCard(
                      title: 'Cars Sold',
                      value: _int(current['cars_sold']).toString(),
                      icon: Icons.directions_car_filled_rounded,
                      accent: _primary,
                      softColor: _primarySoft,
                      delta: _nullableDouble(deltas['cars_sold']),
                      hidden: false,
                      suffix: 'vehicles',
                    ),
                    _MetricCard(
                      title: 'Sales Value',
                      value: _money(current['sales_value']),
                      icon: Icons.point_of_sale_rounded,
                      accent: _blue,
                      softColor: _blueSoft,
                      delta: _nullableDouble(deltas['sales_value']),
                      hidden: !showFinancials,
                    ),
                    _MetricCard(
                      title: 'Vehicle Profit',
                      value: _money(current['vehicle_profit']),
                      icon: Icons.trending_up_rounded,
                      accent: _green,
                      softColor: _greenSoft,
                      delta: _nullableDouble(deltas['vehicle_profit']),
                      hidden: !showFinancials,
                    ),
                    _MetricCard(
                      title: 'General Expenses',
                      value: _money(current['general_expenses']),
                      icon: Icons.receipt_long_rounded,
                      accent: _red,
                      softColor: _redSoft,
                      delta: _nullableDouble(deltas['general_expenses']),
                      positiveIsGood: false,
                      hidden: !showFinancials,
                    ),
                    _MetricCard(
                      title: 'Operating Net',
                      value: _money(current['operating_net']),
                      icon: Icons.account_balance_wallet_rounded,
                      accent: _purple,
                      softColor: _purpleSoft,
                      delta: _nullableDouble(deltas['operating_net']),
                      hidden: !showFinancials,
                      emphasized: true,
                    ),
                    _MetricCard(
                      title: 'Gross Margin',
                      value:
                          '${_double(current['gross_margin']).toStringAsFixed(1)}%',
                      icon: Icons.percent_rounded,
                      accent: _orange,
                      softColor: _orangeSoft,
                      delta: _nullableDouble(deltas['gross_margin']),
                      hidden: !showFinancials,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const _SectionHeading(
                  title: 'Current Position',
                  subtitle:
                      'Today’s cash, inventory, capital, and outstanding position',
                ),
                const SizedBox(height: 9),
                _PositionStrip(
                  hidden: !showFinancials,
                  items: [
                    _PositionItem(
                      'Cash Balance',
                      _money(position['cash_balance']),
                      Icons.account_balance_rounded,
                      _primary,
                    ),
                    _PositionItem(
                      'Stock',
                      '${_int(position['stock_count'])} vehicles',
                      Icons.garage_rounded,
                      _blue,
                      financial: false,
                    ),
                    _PositionItem(
                      'Inventory Invested',
                      _money(position['inventory_investment']),
                      Icons.inventory_2_rounded,
                      _purple,
                    ),
                    _PositionItem(
                      'To Receive',
                      _money(position['outstanding_receive']),
                      Icons.south_west_rounded,
                      _green,
                    ),
                    _PositionItem(
                      'To Pay',
                      _money(position['outstanding_pay']),
                      Icons.north_east_rounded,
                      _red,
                    ),
                    _PositionItem(
                      'Capital Net',
                      _money(position['capital_net']),
                      Icons.savings_rounded,
                      _orange,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _CapitalBySummarySection(
                  rows: capitalByRows,
                  selectedId: controller.dashboardSummaryCapitalById.value,
                  hidden: !showFinancials,
                  onChanged: controller.selectDashboardSummaryCapitalBy,
                ),
                const SizedBox(height: 18),
                _ChartGrid(
                  children: [
                    _DashboardPanel(
                      title: 'Business Movement',
                      subtitle: 'Paid, received, and net by period',
                      icon: Icons.show_chart_rounded,
                      child: _PrivacyCover(
                        hidden: !showFinancials,
                        child: _MoneyTrendChart(rows: trends),
                      ),
                    ),
                    _DashboardPanel(
                      title: 'Vehicle Flow',
                      subtitle:
                          '${_int(current['cars_bought'])} bought · ${_int(current['cars_sold'])} sold',
                      icon: Icons.multiline_chart_rounded,
                      child: _VehicleFlowChart(rows: trends),
                    ),
                    _DashboardPanel(
                      title: 'Brand Profitability',
                      subtitle: 'Top brands by realized net',
                      icon: Icons.workspace_premium_rounded,
                      child: _PrivacyCover(
                        hidden: !showFinancials,
                        child: _RankingChart(
                          rows: brandRows,
                          labelKey: 'name',
                          valueKey: 'profit',
                          color: _primary,
                        ),
                      ),
                    ),
                    _DashboardPanel(
                      title: 'Expense Drivers',
                      subtitle: 'Largest general-expense categories',
                      icon: Icons.donut_large_rounded,
                      child: _PrivacyCover(
                        hidden: !showFinancials,
                        child: _RankingChart(
                          rows: expenses,
                          labelKey: 'name',
                          valueKey: 'paid',
                          color: _orange,
                        ),
                      ),
                    ),
                    _DashboardPanel(
                      title: 'Account Balances',
                      subtitle: 'Current cash and bank distribution',
                      icon: Icons.account_balance_rounded,
                      child: _PrivacyCover(
                        hidden: !showFinancials,
                        child: _RankingChart(
                          rows: accounts,
                          labelKey: 'account_name',
                          valueKey: 'final_net',
                          color: _blue,
                        ),
                      ),
                    ),
                    _DashboardPanel(
                      title: 'Inventory Aging',
                      subtitle: 'How long current stock has been held',
                      icon: Icons.timelapse_rounded,
                      child: _AgingBars(
                        rows: inventoryAging,
                        valueKey: 'count',
                        hiddenAmounts: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _BottomGrid(
                  attention: _AttentionPanel(
                    alerts: alerts,
                    hidden: !showFinancials,
                    onOpen: _openTab,
                  ),
                  aging: _DashboardPanel(
                    title: 'Outstanding Aging',
                    subtitle: 'Open amounts grouped by age',
                    icon: Icons.pending_actions_rounded,
                    child: _AgingBars(
                      rows: outstandingAging,
                      valueKey: 'received',
                      secondaryValueKey: 'paid',
                      hiddenAmounts: !showFinancials,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                _BottomGrid(
                  attention: _TopVehiclesPanel(
                    rows: topVehicles,
                    hidden: !showFinancials,
                    onOpenCars: () => _openTab('cars'),
                  ),
                  aging: _RecentActivityPanel(rows: recentChanges),
                ),
                if (error != null) ...[
                  const SizedBox(height: 12),
                  _InlineWarning(message: error),
                ],
              ],
            ),
          ),
        ),
        if (loading && summary.isNotEmpty)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              minHeight: 2,
              color: _primary,
              backgroundColor: Colors.transparent,
            ),
          ),
      ],
    );
  }
}

class _SummaryToolbar extends StatelessWidget {
  const _SummaryToolbar({
    required this.selectedRange,
    required this.customRange,
    required this.loading,
    required this.showFinancials,
    required this.generatedAt,
    required this.onRangeChanged,
    required this.onToggleFinancials,
    required this.onRefresh,
  });

  final String selectedRange;
  final DateTimeRange? customRange;
  final bool loading;
  final bool showFinancials;
  final String? generatedAt;
  final ValueChanged<String> onRangeChanged;
  final VoidCallback onToggleFinancials;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final generated = DateTime.tryParse(generatedAt ?? '')?.toLocal();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Colors.white, Color(0xFFFBFCFE)]),
        border: Border(bottom: BorderSide(color: Color(0xFFDCE5ED))),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.space_dashboard_rounded, color: _primary, size: 19),
                SizedBox(width: 7),
                Text(
                  'Executive Summary',
                  style: TextStyle(
                    color: _text,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ...const [
            ('today', 'Today'),
            ('month', 'This Month'),
            ('year', 'This Year'),
            ('all', 'All Time'),
          ].map(
            (item) => _RangeButton(
              label: item.$2,
              selected: selectedRange == item.$1,
              onPressed: () => onRangeChanged(item.$1),
            ),
          ),
          _RangeButton(
            label: selectedRange == 'custom' && customRange != null
                ? '${DateFormat('dd MMM').format(customRange!.start)} – ${DateFormat('dd MMM').format(customRange!.end)}'
                : 'Custom',
            selected: selectedRange == 'custom',
            icon: Icons.calendar_month_rounded,
            onPressed: () => onRangeChanged('custom'),
          ),
          const SizedBox(width: 5),
          Tooltip(
            message: showFinancials
                ? 'Hide all financial values'
                : 'Reveal all financial values',
            child: _ToolbarIconButton(
              icon: showFinancials
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
              color: _primary,
              onPressed: onToggleFinancials,
            ),
          ),
          Tooltip(
            message: 'Refresh summary',
            child: _ToolbarIconButton(
              icon: Icons.refresh_rounded,
              color: _muted,
              onPressed: onRefresh,
            ),
          ),
          if (generated != null)
            Text(
              'Updated ${DateFormat('HH:mm').format(generated)}',
              style: const TextStyle(
                color: _muted,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}

class _RangeButton extends StatelessWidget {
  const _RangeButton({
    required this.label,
    required this.selected,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? _primary : const Color(0xFFF3F6F9),
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: selected ? _primary : _line),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: selected ? Colors.white : _muted),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : _text,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateSelectionChip extends StatelessWidget {
  const _DateSelectionChip({
    required this.label,
    required this.date,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final DateTime date;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? _primarySoft : const Color(0xFFF7F9FC),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? _primary : const Color(0xFFDCE4EC),
              width: selected ? 1.3 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 15,
                color: selected ? _primary : _muted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: selected ? _primary : _muted,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .5,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      DateFormat('dd MMM yyyy').format(date),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _text,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolbarIconButton extends StatelessWidget {
  const _ToolbarIconButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 32,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.08),
          side: BorderSide(color: color.withValues(alpha: 0.25)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        ),
        icon: Icon(icon, size: 17, color: color),
      ),
    );
  }
}

class _InsightBanner extends StatelessWidget {
  const _InsightBanner({required this.text, required this.period});

  final String text;
  final String? period;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE7F7F8), Color(0xFFF3FAFB)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBFE4E7)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: _primary,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  period ?? 'Business Insight',
                  style: const TextStyle(
                    color: _primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .4,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  text,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
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

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _text,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 9),
        Flexible(
          child: Text(
            subtitle,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _muted,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1350
            ? 6
            : constraints.maxWidth >= 850
            ? 3
            : constraints.maxWidth >= 500
            ? 2
            : 1;
        const gap = 10.0;
        final width = (constraints.maxWidth - ((columns - 1) * gap)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: children
              .map((child) => SizedBox(width: width, child: child))
              .toList(),
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
    required this.softColor,
    required this.hidden,
    this.delta,
    this.suffix,
    this.positiveIsGood = true,
    this.emphasized = false,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accent;
  final Color softColor;
  final bool hidden;
  final double? delta;
  final String? suffix;
  final bool positiveIsGood;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final isGood = delta == null ? null : (delta! >= 0) == positiveIsGood;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      height: 112,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: emphasized ? softColor.withValues(alpha: .55) : _surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: emphasized ? accent.withValues(alpha: .35) : _line,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D1B2C45),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 29,
                height: 29,
                decoration: BoxDecoration(
                  color: softColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: accent, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .35,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: Text(
                    hidden ? '••••••' : value,
                    key: ValueKey(hidden),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: hidden ? _muted : _text,
                      fontSize: hidden ? 19 : 17,
                      fontWeight: FontWeight.w900,
                      letterSpacing: hidden ? 2 : -.25,
                    ),
                  ),
                ),
              ),
              if (!hidden && delta != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: (isGood! ? _green : _red).withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${delta! >= 0 ? '+' : ''}${delta!.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: isGood ? _green : _red,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
            ],
          ),
          if (suffix != null) ...[
            const SizedBox(height: 2),
            Text(
              suffix!,
              style: const TextStyle(
                color: _muted,
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PositionItem {
  const _PositionItem(
    this.label,
    this.value,
    this.icon,
    this.color, {
    this.financial = true,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool financial;
}

class _PositionStrip extends StatelessWidget {
  const _PositionStrip({required this.items, required this.hidden});

  final List<_PositionItem> items;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _line),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 850;
          if (compact) {
            return Wrap(
              children: items
                  .map(
                    (item) => SizedBox(
                      width: constraints.maxWidth < 500
                          ? constraints.maxWidth
                          : constraints.maxWidth / 2,
                      child: _PositionTile(item: item, hidden: hidden),
                    ),
                  )
                  .toList(),
            );
          }
          return Row(
            children: [
              for (var index = 0; index < items.length; index++) ...[
                Expanded(
                  child: _PositionTile(item: items[index], hidden: hidden),
                ),
                if (index != items.length - 1)
                  const SizedBox(
                    height: 35,
                    child: VerticalDivider(width: 1, color: _line),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _PositionTile extends StatelessWidget {
  const _PositionTile({required this.item, required this.hidden});

  final _PositionItem item;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      child: Row(
        children: [
          Icon(item.icon, size: 17, color: item.color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hidden && item.financial ? '••••••' : item.value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _text,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
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

class _CapitalBySummarySection extends StatelessWidget {
  const _CapitalBySummarySection({
    required this.rows,
    required this.selectedId,
    required this.hidden,
    required this.onChanged,
  });

  final List<Map<String, dynamic>> rows;
  final String? selectedId;
  final bool hidden;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return Container(
        height: 132,
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _line),
        ),
        child: const _EmptyPanel(
          message: 'No Capital By vehicle items in this period',
        ),
      );
    }

    final selected = rows.firstWhere(
      (row) => row['id']?.toString() == selectedId,
      orElse: () => rows.first,
    );
    final effectiveId = selected['id']?.toString() ?? '';
    final net = _double(selected['net']);

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD8E3EA)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A17283E),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 720;
          final selector = _CapitalBySelector(
            rows: rows,
            value: effectiveId,
            onChanged: onChanged,
          );
          final heading = Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0C7C86), Color(0xFF3A9DA5)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.groups_2_rounded,
                  color: Colors.white,
                  size: 19,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Capital By — Car Trade Items',
                      style: TextStyle(
                        color: _text,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Paid, received, and net from vehicle line items in the selected period',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _muted,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );

          final header = compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [heading, const SizedBox(height: 10), selector],
                )
              : Row(
                  children: [
                    Expanded(child: heading),
                    const SizedBox(width: 15),
                    SizedBox(width: 270, child: selector),
                  ],
                );

          final cardWidth = compact
              ? constraints.maxWidth
              : (constraints.maxWidth - 20) / 3;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              header,
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [
                  SizedBox(
                    width: cardWidth,
                    child: _CapitalByMetric(
                      label: 'PAID',
                      value: _money(selected['paid']),
                      icon: Icons.north_east_rounded,
                      color: _red,
                      softColor: _redSoft,
                      hidden: hidden,
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _CapitalByMetric(
                      label: 'RECEIVED',
                      value: _money(selected['received']),
                      icon: Icons.south_west_rounded,
                      color: _green,
                      softColor: _greenSoft,
                      hidden: hidden,
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _CapitalByMetric(
                      label: 'NET',
                      value: _money(net),
                      icon: Icons.account_balance_wallet_rounded,
                      color: net >= 0 ? _primary : _red,
                      softColor: net >= 0 ? _primarySoft : _redSoft,
                      hidden: hidden,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 9),
              Row(
                children: [
                  _SmallInfoChip(
                    icon: Icons.directions_car_filled_rounded,
                    label: '${_int(selected['car_count'])} cars',
                  ),
                  const SizedBox(width: 7),
                  _SmallInfoChip(
                    icon: Icons.format_list_bulleted_rounded,
                    label: '${_int(selected['items'])} line items',
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CapitalBySelector extends StatelessWidget {
  const _CapitalBySelector({
    required this.rows,
    required this.value,
    required this.onChanged,
  });

  final List<Map<String, dynamic>> rows;
  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFFD5E0E8)),
      ),
      child: Row(
        children: [
          const Icon(Icons.person_outline_rounded, color: _primary, size: 16),
          const SizedBox(width: 7),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                borderRadius: BorderRadius.circular(10),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: _muted,
                ),
                style: const TextStyle(
                  color: _text,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w900,
                ),
                items: rows.map((row) {
                  final id = row['id']?.toString() ?? '';
                  final name = row['name']?.toString().trim();
                  return DropdownMenuItem<String>(
                    value: id,
                    child: Text(
                      name == null || name.isEmpty ? 'Capital By' : name,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CapitalByMetric extends StatelessWidget {
  const _CapitalByMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.softColor,
    required this.hidden,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color softColor;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: softColor.withValues(alpha: .52),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: .18)),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: softColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .35,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hidden ? '••••••' : value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: hidden ? _muted : color,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: hidden ? 1.5 : -.2,
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

class _SmallInfoChip extends StatelessWidget {
  const _SmallInfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F5F8),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: _muted, size: 12),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: _muted,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartGrid extends StatelessWidget {
  const _ChartGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1050 ? 2 : 1;
        const gap = 12.0;
        final width = columns == 2
            ? (constraints.maxWidth - gap) / 2
            : constraints.maxWidth;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: children
              .map((child) => SizedBox(width: width, child: child))
              .toList(),
        );
      },
    );
  }
}

class _DashboardPanel extends StatelessWidget {
  const _DashboardPanel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330,
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0B1B2C45),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 12, 13, 9),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: _primarySoft,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 16, color: _primary),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: _text,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        subtitle,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: _line),
          Expanded(
            child: Padding(padding: const EdgeInsets.all(8), child: child),
          ),
        ],
      ),
    );
  }
}

class _PrivacyCover extends StatelessWidget {
  const _PrivacyCover({required this.hidden, required this.child});

  final bool hidden;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        IgnorePointer(
          ignoring: !hidden,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 220),
            opacity: hidden ? 1 : 0,
            child: ColoredBox(
              color: _surface.withValues(alpha: .96),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_outline_rounded, color: _primary, size: 24),
                    SizedBox(height: 7),
                    Text(
                      'Financial details are protected',
                      style: TextStyle(
                        color: _text,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Use the eye button to reveal them',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ChartPoint {
  const _ChartPoint(this.label, this.value);

  final String label;
  final double value;
}

class _MoneyTrendChart extends StatelessWidget {
  const _MoneyTrendChart({required this.rows});

  final List<Map<String, dynamic>> rows;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return const _EmptyPanel(message: 'No movement in this period');
    }
    final paid = rows
        .map(
          (row) => _ChartPoint(_shortLabel(row['label']), _double(row['paid'])),
        )
        .toList();
    final received = rows
        .map(
          (row) =>
              _ChartPoint(_shortLabel(row['label']), _double(row['received'])),
        )
        .toList();
    final net = rows
        .map(
          (row) => _ChartPoint(_shortLabel(row['label']), _double(row['net'])),
        )
        .toList();
    return SfCartesianChart(
      margin: const EdgeInsets.fromLTRB(4, 8, 8, 2),
      plotAreaBorderWidth: 0,
      tooltipBehavior: TooltipBehavior(enable: true),
      legend: const Legend(isVisible: true, position: LegendPosition.bottom),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        labelStyle: TextStyle(color: _muted, fontSize: 9),
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: const MajorGridLines(color: _line, width: .7),
        labelStyle: const TextStyle(color: _muted, fontSize: 8.5),
        numberFormat: NumberFormat.compact(),
      ),
      series: <CartesianSeries<_ChartPoint, String>>[
        ColumnSeries<_ChartPoint, String>(
          name: 'Paid',
          dataSource: paid,
          xValueMapper: (point, _) => point.label,
          yValueMapper: (point, _) => point.value,
          color: _red.withValues(alpha: .78),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
          width: .58,
          animationDuration: 250,
        ),
        ColumnSeries<_ChartPoint, String>(
          name: 'Received',
          dataSource: received,
          xValueMapper: (point, _) => point.label,
          yValueMapper: (point, _) => point.value,
          color: _green.withValues(alpha: .8),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
          width: .58,
          animationDuration: 250,
        ),
        SplineSeries<_ChartPoint, String>(
          name: 'Net',
          dataSource: net,
          xValueMapper: (point, _) => point.label,
          yValueMapper: (point, _) => point.value,
          color: _primary,
          width: 2.2,
          markerSettings: const MarkerSettings(
            isVisible: true,
            height: 5,
            width: 5,
          ),
          animationDuration: 250,
        ),
      ],
    );
  }
}

class _VehicleFlowChart extends StatelessWidget {
  const _VehicleFlowChart({required this.rows});

  final List<Map<String, dynamic>> rows;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return const _EmptyPanel(message: 'No vehicle movement in this period');
    }
    final bought = rows
        .map(
          (row) =>
              _ChartPoint(_shortLabel(row['label']), _double(row['bought'])),
        )
        .toList();
    final sold = rows
        .map(
          (row) => _ChartPoint(_shortLabel(row['label']), _double(row['sold'])),
        )
        .toList();
    return SfCartesianChart(
      margin: const EdgeInsets.fromLTRB(4, 8, 8, 2),
      plotAreaBorderWidth: 0,
      tooltipBehavior: TooltipBehavior(enable: true),
      legend: const Legend(isVisible: true, position: LegendPosition.bottom),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        labelStyle: TextStyle(color: _muted, fontSize: 9),
      ),
      primaryYAxis: const NumericAxis(
        minimum: 0,
        decimalPlaces: 0,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
        majorGridLines: MajorGridLines(color: _line, width: .7),
        labelStyle: TextStyle(color: _muted, fontSize: 8.5),
      ),
      series: <CartesianSeries<_ChartPoint, String>>[
        ColumnSeries<_ChartPoint, String>(
          name: 'Bought',
          dataSource: bought,
          xValueMapper: (point, _) => point.label,
          yValueMapper: (point, _) => point.value,
          color: _blue,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          width: .55,
          animationDuration: 250,
        ),
        ColumnSeries<_ChartPoint, String>(
          name: 'Sold',
          dataSource: sold,
          xValueMapper: (point, _) => point.label,
          yValueMapper: (point, _) => point.value,
          color: _primary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          width: .55,
          animationDuration: 250,
        ),
      ],
    );
  }
}

class _RankingChart extends StatelessWidget {
  const _RankingChart({
    required this.rows,
    required this.labelKey,
    required this.valueKey,
    required this.color,
  });

  final List<Map<String, dynamic>> rows;
  final String labelKey;
  final String valueKey;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return const _EmptyPanel(message: 'No data in this period');
    }
    final points = rows
        .take(7)
        .map((row) {
          final label = row[labelKey]?.toString().trim();
          return _ChartPoint(
            label == null || label.isEmpty ? 'Unknown' : label,
            _double(row[valueKey]),
          );
        })
        .toList()
        .reversed
        .toList();
    return SfCartesianChart(
      margin: const EdgeInsets.fromLTRB(4, 6, 10, 4),
      plotAreaBorderWidth: 0,
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: const CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        labelStyle: TextStyle(
          color: _muted,
          fontSize: 8.5,
          fontWeight: FontWeight.w700,
        ),
        maximumLabelWidth: 85,
      ),
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        majorGridLines: const MajorGridLines(color: _line, width: .7),
        labelStyle: const TextStyle(color: _muted, fontSize: 8.5),
        numberFormat: NumberFormat.compact(),
      ),
      series: <CartesianSeries<_ChartPoint, String>>[
        BarSeries<_ChartPoint, String>(
          dataSource: points,
          xValueMapper: (point, _) => point.label,
          yValueMapper: (point, _) => point.value,
          color: color.withValues(alpha: .86),
          borderRadius: const BorderRadius.horizontal(
            right: Radius.circular(5),
          ),
          width: .56,
          animationDuration: 250,
        ),
      ],
    );
  }
}

class _AgingBars extends StatelessWidget {
  const _AgingBars({
    required this.rows,
    required this.valueKey,
    required this.hiddenAmounts,
    this.secondaryValueKey,
  });

  final List<Map<String, dynamic>> rows;
  final String valueKey;
  final String? secondaryValueKey;
  final bool hiddenAmounts;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return const _EmptyPanel(message: 'No aging data available');
    }
    final ordered = [...rows]
      ..sort((a, b) => _ageOrder(a['label']).compareTo(_ageOrder(b['label'])));
    final values = ordered.map((row) {
      final primary = _double(row[valueKey]);
      final secondary = secondaryValueKey == null
          ? 0
          : _double(row[secondaryValueKey]);
      return primary.abs() + secondary.abs();
    }).toList();
    final maximum = values.fold<double>(
      0,
      (max, value) => value > max ? value : max,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var index = 0; index < ordered.length; index++) ...[
            _AgingRow(
              label: ordered[index]['label']?.toString() ?? 'Unknown',
              value: values[index],
              maximum: maximum,
              color: [_green, _blue, _orange, _red][index.clamp(0, 3)],
              display: hiddenAmounts
                  ? '••••••'
                  : secondaryValueKey == null
                  ? '${_int(ordered[index][valueKey])} vehicles'
                  : _money(values[index]),
            ),
            if (index != ordered.length - 1) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _AgingRow extends StatelessWidget {
  const _AgingRow({
    required this.label,
    required this.value,
    required this.maximum,
    required this.color,
    required this.display,
  });

  final String label;
  final double value;
  final double maximum;
  final Color color;
  final String display;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: _text,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Text(
              display,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: LinearProgressIndicator(
            minHeight: 7,
            value: maximum == 0 ? 0 : value / maximum,
            color: color,
            backgroundColor: color.withValues(alpha: .1),
          ),
        ),
      ],
    );
  }
}

class _BottomGrid extends StatelessWidget {
  const _BottomGrid({required this.attention, required this.aging});

  final Widget attention;
  final Widget aging;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 1000) {
          return Column(
            children: [attention, const SizedBox(height: 12), aging],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: attention),
            const SizedBox(width: 12),
            Expanded(flex: 2, child: aging),
          ],
        );
      },
    );
  }
}

class _AttentionPanel extends StatelessWidget {
  const _AttentionPanel({
    required this.alerts,
    required this.hidden,
    required this.onOpen,
  });

  final List<Map<String, dynamic>> alerts;
  final bool hidden;
  final ValueChanged<String?> onOpen;

  @override
  Widget build(BuildContext context) {
    return _ListPanel(
      title: 'Needs Attention',
      subtitle: '${alerts.length} prioritized checks',
      icon: Icons.notification_important_rounded,
      iconColor: _orange,
      child: alerts.isEmpty
          ? const _EmptyPanel(message: 'Everything looks clear')
          : Column(
              children: alerts.take(7).map((alert) {
                final severity = alert['severity']?.toString();
                final color = severity == 'high'
                    ? _red
                    : severity == 'medium'
                    ? _orange
                    : _blue;
                final amount = _double(alert['amount']);
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onOpen(alert['tab']?.toString()),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 9,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  alert['title']?.toString() ??
                                      'Needs attention',
                                  style: const TextStyle(
                                    color: _text,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Text(
                                  alert['detail']?.toString() ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: _muted,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (amount != 0)
                            Text(
                              hidden ? '••••••' : _money(amount),
                              style: TextStyle(
                                color: color,
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: _muted,
                            size: 17,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}

class _TopVehiclesPanel extends StatelessWidget {
  const _TopVehiclesPanel({
    required this.rows,
    required this.hidden,
    required this.onOpenCars,
  });

  final List<Map<String, dynamic>> rows;
  final bool hidden;
  final VoidCallback onOpenCars;

  @override
  Widget build(BuildContext context) {
    return _ListPanel(
      title: 'Top Performing Vehicles',
      subtitle: 'Highest realized net in the period',
      icon: Icons.emoji_events_rounded,
      iconColor: _green,
      child: rows.isEmpty
          ? const _EmptyPanel(message: 'No sold vehicles in this period')
          : Column(
              children: rows.asMap().entries.map((entry) {
                final row = entry.value;
                return InkWell(
                  onTap: onOpenCars,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 25,
                          height: 25,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _greenSoft,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(
                              color: _green,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            _vehicleName(row),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _text,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Text(
                          hidden ? '••••••' : _money(row['net']),
                          style: const TextStyle(
                            color: _green,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}

class _RecentActivityPanel extends StatelessWidget {
  const _RecentActivityPanel({required this.rows});

  final List<Map<String, dynamic>> rows;

  @override
  Widget build(BuildContext context) {
    return _ListPanel(
      title: 'Recent Activity',
      subtitle: 'Latest recorded changes',
      icon: Icons.history_rounded,
      iconColor: _blue,
      child: rows.isEmpty
          ? const _EmptyPanel(message: 'No recent changes')
          : Column(
              children: rows.take(7).map((row) {
                final updated = DateTime.tryParse(
                  row['updatedAt']?.toString() ?? '',
                )?.toLocal();
                final item = row['item_name']?.toString();
                final vehicle =
                    '${row['brand_name'] ?? ''} ${row['model_name'] ?? ''}'
                        .trim();
                final title = item != null && item != '-'
                    ? item
                    : vehicle.isNotEmpty && vehicle != '- -'
                    ? vehicle
                    : 'Updated record';
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 9,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: _blueSoft,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.edit_note_rounded,
                          color: _blue,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: _text,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              row['description']
                                          ?.toString()
                                          .trim()
                                          .isNotEmpty ==
                                      true
                                  ? row['description'].toString()
                                  : row['account_name']?.toString() ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: _muted,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (updated != null)
                        Text(
                          DateFormat('dd MMM\nHH:mm').format(updated),
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: _muted,
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }
}

class _ListPanel extends StatelessWidget {
  const _ListPanel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.child,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 330),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _line),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(13, 12, 13, 10),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 16, color: iconColor),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: _text,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: _line),
          child,
        ],
      ),
    );
  }
}

class _LoadingDashboard extends StatelessWidget {
  const _LoadingDashboard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 58,
            decoration: BoxDecoration(
              color: _primarySoft,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(
                    12,
                    (index) => Container(
                      width: constraints.maxWidth >= 900
                          ? (constraints.maxWidth - 20) / 3
                          : constraints.maxWidth,
                      height: index < 6 ? 112 : 190,
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _line),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const LinearProgressIndicator(
            color: _primary,
            backgroundColor: _primarySoft,
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 430),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _line),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 34, color: _red),
            const SizedBox(height: 10),
            const Text(
              'Summary could not be loaded',
              style: TextStyle(
                color: _text,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _muted,
                fontSize: 10.5,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: onRetry,
              style: FilledButton.styleFrom(backgroundColor: _primary),
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InlineWarning extends StatelessWidget {
  const _InlineWarning({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _orangeSoft,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: _orange.withValues(alpha: .35)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: _orange, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'The previous data is still displayed. Refresh failed: $message',
              style: const TextStyle(
                color: _text,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyPanel extends StatelessWidget {
  const _EmptyPanel({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inbox_outlined, color: Color(0xFFB0BAC7), size: 25),
          const SizedBox(height: 5),
          Text(
            message,
            style: const TextStyle(
              color: _muted,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

Map<String, dynamic> _map(dynamic value) {
  return value is Map ? Map<String, dynamic>.from(value) : <String, dynamic>{};
}

List<Map<String, dynamic>> _list(dynamic value) {
  if (value is! List) return const [];
  return value
      .whereType<Map>()
      .map((row) => Map<String, dynamic>.from(row))
      .toList(growable: false);
}

double _double(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

double? _nullableDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

int _int(dynamic value) => _double(value).round();

String _money(dynamic value) => 'AED ${priceFormat.format(_double(value))}';

String _shortLabel(dynamic value) {
  final text = value?.toString() ?? '';
  final date = DateTime.tryParse(text);
  if (date == null) return text;
  return text.length <= 7
      ? DateFormat('MMM').format(date)
      : DateFormat('dd MMM').format(date);
}

int _ageOrder(dynamic label) {
  final value = label?.toString() ?? '';
  if (value.startsWith('0')) return 0;
  if (value.startsWith('31')) return 1;
  if (value.startsWith('61')) return 2;
  return 3;
}

String _vehicleName(Map<String, dynamic> row) {
  final parts = [row['brand'], row['model'], row['trim']]
      .map((value) => value?.toString().trim() ?? '')
      .where((value) => value.isNotEmpty && value != 'Unknown');
  final name = parts.join(' ');
  return name.isEmpty ? 'Unknown vehicle' : name;
}
