import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../Models/car trading/capitals_outstanding_model.dart';
import '../../../consts.dart';
import 'item_dialog.dart';

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
const _greenSoft = Color(0xFFEAF8EF);
const _red = Color(0xFFD95757);
const _redSoft = Color(0xFFFFEFEF);
const _blue = Color(0xFF2F78C4);
const _blueSoft = Color(0xFFEDF5FD);
const _purple = Color(0xFF7C3AED);
const _purpleSoft = Color(0xFFF2EDFF);
const _shadow = Color(0x141B2C45);
const _minimumTableWidth = 1040.0;

class CapitalSection extends StatefulWidget {
  const CapitalSection({super.key});

  @override
  State<CapitalSection> createState() => _CapitalSectionState();
}

class _CapitalSectionState extends State<CapitalSection> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _horizontalController = ScrollController();

  String _query = '';
  int _page = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _refresh(Get.find<CarTradingDashboardController>());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<CarTradingDashboardController>(
      builder: (controller) {
        final items = _visibleItems(controller.allCapitals);
        final totalPaid = items.fold<double>(0, (sum, item) => sum + item.pay);
        final totalReceived = items.fold<double>(
          0,
          (sum, item) => sum + item.receive,
        );

        return ColoredBox(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CapitalToolbar(
                searchController: _searchController,
                entryCount: items.length,
                isRefreshing: controller.isCapitalLoading.value,
                onSearchChanged: (value) {
                  setState(() {
                    _query = value;
                    _page = 0;
                  });
                },
                onRefresh: () => _refresh(controller),
                onNew: () => _openNewCapital(controller),
              ),
              const SizedBox(height: 10),
              _CapitalTotals(
                paid: totalPaid,
                received: totalReceived,
                net: totalReceived - totalPaid,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _CapitalPanel(
                  items: items,
                  isLoading: controller.isCapitalLoading.value,
                  requestedPage: _page,
                  horizontalController: _horizontalController,
                  onPageChanged: (page) => setState(() => _page = page),
                  onEdit: (item) => _openEditCapital(controller, item),
                  onDelete: (item) => _deleteCapital(controller, item),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<CapitalsAndOutstandingModel> _visibleItems(
    List<CapitalsAndOutstandingModel> source,
  ) {
    final query = _query.trim().toLowerCase();
    final result = source
        .where((item) {
          if (query.isEmpty) return true;
          return [
            item.name,
            item.accountName,
            item.comment,
            item.pay,
            item.receive,
            item.net,
            textToDate(item.date),
          ].join(' ').toLowerCase().contains(query);
        })
        .toList(growable: false);

    result.sort((a, b) => b.date.compareTo(a.date));
    return result;
  }

  Future<void> _refresh(CarTradingDashboardController controller) async {
    if (controller.isCapitalLoading.value) return;
    await Future.wait([
      controller.getAllCapitalsOROutstanding('capitals'),
      controller.getCapitalsOROutstandingSummary('capitals'),
    ]);
  }

  void _resetEditor(CarTradingDashboardController controller) {
    controller.name.clear();
    controller.nameId.value = '';
    controller.item.clear();
    controller.itemId.value = '';
    controller.accountName.clear();
    controller.accountNameId.value = '';
    controller.tradingCar.clear();
    controller.tradingCarId.value = '';
    controller.pay.text = '0';
    controller.receive.text = '0';
    controller.comments.value.clear();
    controller.itemDate.value.text = textToDate(DateTime.now());
  }

  void _openNewCapital(CarTradingDashboardController controller) {
    _resetEditor(controller);
    itemDialog(
      isGeneralExpenses: false,
      isTrade: false,
      controller: controller,
      canEdit: true,
      onPressed: () {
        controller.addNewCapitalOrOutstandingOrGeneralExpenses('capitals');
      },
    );
  }

  void _openEditCapital(
    CarTradingDashboardController controller,
    CapitalsAndOutstandingModel item,
  ) {
    controller.name.text = item.name;
    controller.nameId.value = item.nameId;
    controller.accountName.text = item.accountName;
    controller.accountNameId.value = item.accountNameId;
    controller.pay.text = item.pay.toString();
    controller.receive.text = item.receive.toString();
    controller.comments.value.text = item.comment;
    controller.itemDate.value.text = textToDate(item.date);
    controller.tradingCar.clear();
    controller.tradingCarId.value = '';
    itemDialog(
      isGeneralExpenses: false,
      isTrade: false,
      controller: controller,
      canEdit: true,
      onPressed: () {
        controller.updateCapitalOrOutstandingOrGeneralExpenses(
          'capitals',
          item.id,
        );
      },
    );
  }

  void _deleteCapital(
    CarTradingDashboardController controller,
    CapitalsAndOutstandingModel item,
  ) {
    if (item.id.isEmpty) return;
    alertDialog(
      context: context,
      content: 'This capital entry will be deleted permanently.',
      onPressed: () {
        controller.deleteCapitalOrOutstandingOrGeneralExpenses(
          'capitals',
          item.id,
        );
      },
    );
  }
}

class _CapitalToolbar extends StatelessWidget {
  const _CapitalToolbar({
    required this.searchController,
    required this.entryCount,
    required this.isRefreshing,
    required this.onSearchChanged,
    required this.onRefresh,
    required this.onNew,
  });

  final TextEditingController searchController;
  final int entryCount;
  final bool isRefreshing;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onRefresh;
  final VoidCallback onNew;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 700;
        final search = _CapitalSearchField(
          controller: searchController,
          onChanged: onSearchChanged,
        );
        final actions = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _EntriesPill(count: entryCount),
            const SizedBox(width: 8),
            _RefreshButton(isRefreshing: isRefreshing, onPressed: onRefresh),
            const SizedBox(width: 8),
            _NewCapitalButton(isLoading: isRefreshing, onPressed: onNew),
          ],
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              search,
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: actions,
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: search),
            const SizedBox(width: 14),
            actions,
          ],
        );
      },
    );
  }
}

class _CapitalSearchField extends StatelessWidget {
  const _CapitalSearchField({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(
          color: _text,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          hintText: 'Search name, account, date, amount, or comment',
          hintStyle: const TextStyle(
            color: Color(0xFF9AA7B7),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 18,
            color: Color(0xFF91A0B2),
          ),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Clear search',
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                  icon: const Icon(Icons.close_rounded, size: 16),
                  color: _muted,
                  splashRadius: 16,
                ),
          contentPadding: const EdgeInsets.symmetric(vertical: 9),
          filled: true,
          fillColor: _surface,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _lineStrong),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _primary),
          ),
        ),
      ),
    );
  }
}

class _EntriesPill extends StatelessWidget {
  const _EntriesPill({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: _primarySoft,
        border: Border.all(color: _primary.withValues(alpha: .16)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.account_balance_wallet_outlined,
            size: 15,
            color: _primaryDark,
          ),
          const SizedBox(width: 7),
          Text(
            '$count ${count == 1 ? 'ENTRY' : 'ENTRIES'}',
            style: const TextStyle(
              color: _primaryDark,
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton({required this.isRefreshing, required this.onPressed});

  final bool isRefreshing;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Refresh capital entries',
      child: SizedBox(
        width: 36,
        height: 36,
        child: OutlinedButton(
          onPressed: isRefreshing ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: _primaryDark,
            disabledForegroundColor: _primary,
            backgroundColor: _surface,
            disabledBackgroundColor: _surfaceSoft,
            padding: EdgeInsets.zero,
            side: const BorderSide(color: _lineStrong),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: SizedBox(
            width: 17,
            height: 17,
            child: isRefreshing
                ? const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _primary,
                  )
                : const Icon(Icons.refresh_rounded, size: 18),
          ),
        ),
      ),
    );
  }
}

class _NewCapitalButton extends StatelessWidget {
  const _NewCapitalButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: const Icon(Icons.add_rounded, size: 17),
        label: const Text('New Capital'),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _surfaceStrong,
          disabledForegroundColor: _muted,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          textStyle: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class _CapitalTotals extends StatelessWidget {
  const _CapitalTotals({
    required this.paid,
    required this.received,
    required this.net,
  });

  final double paid;
  final double received;
  final double net;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cards = [
          _TotalCard(
            title: 'TOTAL PAID',
            value: paid,
            icon: Icons.north_east_rounded,
            color: _red,
            background: _redSoft,
          ),
          _TotalCard(
            title: 'TOTAL RECEIVED',
            value: received,
            icon: Icons.south_west_rounded,
            color: _green,
            background: _greenSoft,
          ),
          _TotalCard(
            title: 'NET BALANCE',
            value: net,
            icon: Icons.account_balance_wallet_outlined,
            color: _netColor(net),
            background: net >= 0 ? _blueSoft : _redSoft,
          ),
        ];

        if (constraints.maxWidth < 560) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: cards
                  .map(
                    (card) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: SizedBox(width: 180, child: card),
                    ),
                  )
                  .toList(growable: false),
            ),
          );
        }

        return Row(
          children: cards
              .expand(
                (card) => [
                  Expanded(child: card),
                  if (card != cards.last) const SizedBox(width: 8),
                ],
              )
              .toList(growable: false),
        );
      },
    );
  }
}

class _TotalCard extends StatelessWidget {
  const _TotalCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.background,
  });

  final String title;
  final double value;
  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: _surface,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: _shadow, blurRadius: 14, offset: Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 17, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .25,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  priceFormat.format(value),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 15,
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

class _CapitalPanel extends StatelessWidget {
  const _CapitalPanel({
    required this.items,
    required this.isLoading,
    required this.requestedPage,
    required this.horizontalController,
    required this.onPageChanged,
    required this.onEdit,
    required this.onDelete,
  });

  final List<CapitalsAndOutstandingModel> items;
  final bool isLoading;
  final int requestedPage;
  final ScrollController horizontalController;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<CapitalsAndOutstandingModel> onEdit;
  final ValueChanged<CapitalsAndOutstandingModel> onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _surface,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: _shadow, blurRadius: 28, offset: Offset(0, 10)),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (isLoading && items.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: _primary,
                strokeWidth: 2.5,
              ),
            );
          }
          if (items.isEmpty) return const _CapitalEmptyState();

          final tableWidth = math.max(_minimumTableWidth, constraints.maxWidth);
          return Scrollbar(
            controller: horizontalController,
            thumbVisibility: constraints.maxWidth < _minimumTableWidth,
            child: SingleChildScrollView(
              controller: horizontalController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: tableWidth,
                height: constraints.maxHeight,
                child: Column(
                  children: [
                    const _CapitalTableHeader(),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, bodyConstraints) {
                          const rowHeight = 58.0;
                          const footerHeight = 48.0;
                          final availableHeight = math.max(
                            rowHeight,
                            bodyConstraints.maxHeight - footerHeight - 1,
                          );
                          final rowsPerPage = math.max(
                            1,
                            availableHeight ~/ rowHeight,
                          );
                          final pageCount = math.max(
                            1,
                            (items.length / rowsPerPage).ceil(),
                          );
                          final page = requestedPage.clamp(0, pageCount - 1);
                          final start = page * rowsPerPage;
                          final end = math.min(
                            start + rowsPerPage,
                            items.length,
                          );

                          return Column(
                            children: [
                              ...items
                                  .sublist(start, end)
                                  .asMap()
                                  .entries
                                  .map(
                                    (entry) => _CapitalRow(
                                      item: entry.value,
                                      shaded: entry.key.isOdd,
                                      onEdit: () => onEdit(entry.value),
                                      onDelete: () => onDelete(entry.value),
                                    ),
                                  ),
                              const Spacer(),
                              _CapitalPaginationFooter(
                                start: start,
                                end: end,
                                total: items.length,
                                page: page,
                                pageCount: pageCount,
                                onPageChanged: onPageChanged,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CapitalTableHeader extends StatelessWidget {
  const _CapitalTableHeader();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 44,
      child: _CapitalGrid(
        isHeader: true,
        action: Text('ACTION'),
        date: Text('DATE'),
        name: Text('NAME'),
        account: Text('ACCOUNT'),
        comment: Text('COMMENT'),
        paid: Text('PAID'),
        received: Text('RECEIVED'),
        net: Text('NET'),
      ),
    );
  }
}

class _CapitalRow extends StatelessWidget {
  const _CapitalRow({
    required this.item,
    required this.shaded,
    required this.onEdit,
    required this.onDelete,
  });

  final CapitalsAndOutstandingModel item;
  final bool shaded;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      color: shaded ? const Color(0xFFFBFCFE) : _surface,
      child: _CapitalGrid(
        action: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ActionButton(
              tooltip: 'Edit capital entry',
              icon: Icons.edit_note_rounded,
              color: _blue,
              background: _blueSoft,
              onPressed: onEdit,
            ),
            const SizedBox(width: 4),
            _ActionButton(
              tooltip: 'Delete capital entry',
              icon: Icons.delete_outline_rounded,
              color: _red,
              background: _redSoft,
              onPressed: onDelete,
            ),
          ],
        ),
        date: _DateCell(value: textToDate(item.date)),
        name: _NamedCell(
          text: item.name,
          icon: Icons.person_outline_rounded,
          color: _blue,
          background: _blueSoft,
        ),
        account: _NamedCell(
          text: item.accountName,
          icon: Icons.account_balance_outlined,
          color: _purple,
          background: _purpleSoft,
        ),
        comment: Text(
          item.comment.trim().isEmpty ? '—' : item.comment.trim(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: item.comment.trim().isEmpty ? _muted : _text,
            fontStyle: item.comment.trim().isEmpty
                ? FontStyle.italic
                : FontStyle.normal,
          ),
        ),
        paid: _MoneyText(value: item.pay, color: _red),
        received: _MoneyText(value: item.receive, color: _green),
        net: _MoneyText(value: item.net, color: _netColor(item.net)),
      ),
    );
  }
}

class _CapitalGrid extends StatelessWidget {
  const _CapitalGrid({
    required this.action,
    required this.date,
    required this.name,
    required this.account,
    required this.comment,
    required this.paid,
    required this.received,
    required this.net,
    this.isHeader = false,
  });

  final Widget action;
  final Widget date;
  final Widget name;
  final Widget account;
  final Widget comment;
  final Widget paid;
  final Widget received;
  final Widget net;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    final tableTheme = Theme.of(context).dataTableTheme;

    Widget cell(Widget child, {Alignment alignment = Alignment.centerLeft}) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9),
        child: Align(
          alignment: alignment,
          child: DefaultTextStyle(
            style:
                (isHeader
                    ? tableTheme.headingTextStyle
                    : tableTheme.dataTextStyle) ??
                DefaultTextStyle.of(context).style,
            child: child,
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isHeader ? _surfaceSoft : Colors.transparent,
        border: const Border(bottom: BorderSide(color: _line)),
      ),
      child: Row(
        children: [
          SizedBox(width: 78, child: cell(action, alignment: Alignment.center)),
          Expanded(flex: 2, child: cell(date)),
          Expanded(flex: 3, child: cell(name)),
          Expanded(flex: 3, child: cell(account)),
          Expanded(flex: 4, child: cell(comment)),
          Expanded(
            flex: 2,
            child: cell(paid, alignment: Alignment.centerRight),
          ),
          Expanded(
            flex: 2,
            child: cell(received, alignment: Alignment.centerRight),
          ),
          Expanded(flex: 2, child: cell(net, alignment: Alignment.centerRight)),
        ],
      ),
    );
  }
}

class _DateCell extends StatelessWidget {
  const _DateCell({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.calendar_today_outlined, size: 13, color: _primary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(value, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}

class _NamedCell extends StatelessWidget {
  const _NamedCell({
    required this.text,
    required this.icon,
    required this.color,
    required this.background,
  });

  final String text;
  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final display = text.trim().isEmpty ? '—' : text.trim();
    return Row(
      children: [
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon, size: 13, color: color),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            display,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: text.trim().isEmpty ? _muted : _text,
              fontStyle: text.trim().isEmpty
                  ? FontStyle.italic
                  : FontStyle.normal,
            ),
          ),
        ),
      ],
    );
  }
}

class _MoneyText extends StatelessWidget {
  const _MoneyText({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      priceFormat.format(value),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.right,
      style: TextStyle(color: color, fontWeight: FontWeight.w800),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.background,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final Color color;
  final Color background;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(7),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }
}

class _CapitalPaginationFooter extends StatelessWidget {
  const _CapitalPaginationFooter({
    required this.start,
    required this.end,
    required this.total,
    required this.page,
    required this.pageCount,
    required this.onPageChanged,
  });

  final int start;
  final int end;
  final int total;
  final int page;
  final int pageCount;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: const BoxDecoration(
        color: Color(0xFFFBFCFE),
        border: Border(top: BorderSide(color: _lineStrong)),
      ),
      child: Row(
        children: [
          Text(
            'Showing ${total == 0 ? 0 : start + 1}–$end of $total capital entries',
            style: const TextStyle(
              color: _muted,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          _PageButton(
            tooltip: 'First page',
            icon: Icons.first_page_rounded,
            enabled: page > 0,
            onPressed: () => onPageChanged(0),
          ),
          const SizedBox(width: 5),
          _PageButton(
            tooltip: 'Previous page',
            icon: Icons.chevron_left_rounded,
            enabled: page > 0,
            onPressed: () => onPageChanged(page - 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9),
            child: Text(
              '${page + 1} / $pageCount',
              style: const TextStyle(
                color: _text,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          _PageButton(
            tooltip: 'Next page',
            icon: Icons.chevron_right_rounded,
            enabled: page < pageCount - 1,
            onPressed: () => onPageChanged(page + 1),
          ),
          const SizedBox(width: 5),
          _PageButton(
            tooltip: 'Last page',
            icon: Icons.last_page_rounded,
            enabled: page < pageCount - 1,
            onPressed: () => onPageChanged(pageCount - 1),
          ),
        ],
      ),
    );
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({
    required this.tooltip,
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(7),
        child: Container(
          width: 27,
          height: 27,
          decoration: BoxDecoration(
            color: enabled ? _surface : _surfaceSoft,
            border: Border.all(color: _line),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(
            icon,
            size: 17,
            color: enabled ? _primaryDark : _lineStrong,
          ),
        ),
      ),
    );
  }
}

class _CapitalEmptyState extends StatelessWidget {
  const _CapitalEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _surfaceSoft,
                border: Border.all(color: _line),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.account_balance_wallet_outlined,
                size: 25,
                color: _muted,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'No capital entries found',
              style: TextStyle(
                color: _text,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Try changing the search or add a new capital entry.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

Color _netColor(double value) {
  if (value > 0) return _green;
  if (value < 0) return _red;
  return _blue;
}
