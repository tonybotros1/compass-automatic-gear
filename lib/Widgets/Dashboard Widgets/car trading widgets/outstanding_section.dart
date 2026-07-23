import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../Models/car trading/capitals_outstanding_model.dart';
import '../../../consts.dart';
import 'item_dialog.dart';

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
const _greenSoft = Color(0xFFEAF8EF);
const _red = Color(0xFFD95757);
const _redSoft = Color(0xFFFFEFEF);
const _blue = Color(0xFF2F78C4);
const _blueSoft = Color(0xFFEDF5FD);
const _shadow = Color(0x141B2C45);
const _detailsRowsPerPage = 4;
const _minimumTableWidth = 920.0;

class OutstandingSection extends StatefulWidget {
  const OutstandingSection({super.key});

  @override
  State<OutstandingSection> createState() => _OutstandingSectionState();
}

class _OutstandingSectionState extends State<OutstandingSection> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _expandedTableController = ScrollController();
  final Map<String, int> _detailPages = <String, int>{};

  String _query = '';
  String? _expandedGroupKey;
  int _groupPageStart = 0;
  bool _hideSettled = true;

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
    _expandedTableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetX<CarTradingDashboardController>(
      builder: (controller) {
        final searchedItems = _filterItems(controller.allOutstanding);
        final allGroups = _groupItems(searchedItems);
        final groups = _hideSettled
            ? allGroups
                  .where((group) => !_isSettled(group.net))
                  .toList(growable: false)
            : allGroups;
        final visibleItems = groups
            .expand((group) => group.items)
            .toList(growable: false);
        final totalPaid = visibleItems.fold<double>(
          0,
          (sum, item) => sum + item.pay,
        );
        final totalReceived = visibleItems.fold<double>(
          0,
          (sum, item) => sum + item.receive,
        );
        final totalNet = totalReceived - totalPaid;
        final isLoading = controller.isCapitalLoading.value;

        return ColoredBox(
          color: _pageBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _OutstandingToolbar(
                searchController: _searchController,
                entryCount: visibleItems.length,
                isRefreshing: isLoading,
                hideSettled: _hideSettled,
                onSearchChanged: (value) {
                  setState(() {
                    _query = value;
                    _expandedGroupKey = null;
                    _groupPageStart = 0;
                    _detailPages.clear();
                  });
                },
                onHideSettledChanged: (value) {
                  setState(() {
                    _hideSettled = value;
                    _expandedGroupKey = null;
                    _groupPageStart = 0;
                    _detailPages.clear();
                  });
                },
                onRefresh: () => _refresh(controller),
                onNew: () => _openNewOutstanding(controller),
              ),
              const SizedBox(height: 10),
              _OutstandingTotals(
                paid: totalPaid,
                received: totalReceived,
                net: totalNet,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _OutstandingPanel(
                  groups: groups,
                  isLoading: isLoading,
                  emptyBecauseSettled:
                      _hideSettled && allGroups.isNotEmpty && groups.isEmpty,
                  expandedGroupKey: _expandedGroupKey,
                  requestedStartIndex: _groupPageStart,
                  detailPages: _detailPages,
                  horizontalController: _horizontalController,
                  expandedTableController: _expandedTableController,
                  onCollapseAll: () {
                    if (_expandedGroupKey == null) return;
                    setState(() => _expandedGroupKey = null);
                  },
                  onToggleGroup: (group) {
                    setState(() {
                      _expandedGroupKey = _expandedGroupKey == group.key
                          ? null
                          : group.key;
                      _detailPages.putIfAbsent(group.key, () => 0);
                    });
                  },
                  onGroupPageChanged: (startIndex) {
                    setState(() {
                      _groupPageStart = startIndex;
                      _expandedGroupKey = null;
                    });
                  },
                  onPageChanged: (groupKey, page) {
                    setState(() => _detailPages[groupKey] = page);
                  },
                  onEdit: (item) => _openEditOutstanding(controller, item),
                  onDelete: (item) => _deleteOutstanding(controller, item),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<CapitalsAndOutstandingModel> _filterItems(
    List<CapitalsAndOutstandingModel> source,
  ) {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return source.toList(growable: false);

    return source
        .where((item) {
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
  }

  Future<void> _refresh(CarTradingDashboardController controller) async {
    if (controller.isCapitalLoading.value) return;
    await Future.wait([
      controller.getAllCapitalsOROutstanding('outstanding'),
      controller.getCapitalsOROutstandingSummary('outstanding'),
    ]);
  }

  void _openNewOutstanding(CarTradingDashboardController controller) {
    controller.name.clear();
    controller.nameId.value = '';
    controller.item.clear();
    controller.itemId.value = '';
    controller.accountName.clear();
    controller.accountNameId.value = '';
    controller.pay.clear();
    controller.receive.clear();
    controller.comments.value.clear();
    controller.itemDate.value.text = textToDate(DateTime.now());
    itemDialog(
      isGeneralExpenses: false,
      isTrade: false,
      controller: controller,
      canEdit: true,
      onPressed: () {
        controller.addNewCapitalOrOutstandingOrGeneralExpenses('outstanding');
      },
    );
  }

  void _openEditOutstanding(
    CarTradingDashboardController controller,
    CapitalsAndOutstandingModel item,
  ) {
    controller.name.text = item.name;
    controller.nameId.value = item.nameId;
    controller.pay.text = item.pay.toString();
    controller.accountName.text = item.accountName;
    controller.accountNameId.value = item.accountNameId;
    controller.receive.text = item.receive.toString();
    controller.comments.value.text = item.comment;
    controller.itemDate.value.text = textToDate(item.date);
    itemDialog(
      isGeneralExpenses: false,
      isTrade: false,
      controller: controller,
      canEdit: true,
      onPressed: () {
        controller.updateCapitalOrOutstandingOrGeneralExpenses(
          'outstanding',
          item.id,
        );
      },
    );
  }

  void _deleteOutstanding(
    CarTradingDashboardController controller,
    CapitalsAndOutstandingModel item,
  ) {
    if (item.id.isEmpty) return;
    alertDialog(
      context: context,
      content: 'This outstanding entry will be deleted permanently.',
      onPressed: () {
        controller.deleteCapitalOrOutstandingOrGeneralExpenses(
          'outstanding',
          item.id,
        );
      },
    );
  }
}

class _OutstandingToolbar extends StatelessWidget {
  const _OutstandingToolbar({
    required this.searchController,
    required this.entryCount,
    required this.isRefreshing,
    required this.hideSettled,
    required this.onSearchChanged,
    required this.onHideSettledChanged,
    required this.onRefresh,
    required this.onNew,
  });

  final TextEditingController searchController;
  final int entryCount;
  final bool isRefreshing;
  final bool hideSettled;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<bool> onHideSettledChanged;
  final VoidCallback onRefresh;
  final VoidCallback onNew;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 700;
        final search = _OutstandingSearchField(
          controller: searchController,
          onChanged: onSearchChanged,
        );
        final actions = Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _HideSettledToggle(
              value: hideSettled,
              onChanged: onHideSettledChanged,
            ),
            _EntriesPill(count: entryCount),
            _OutstandingRefreshButton(
              isRefreshing: isRefreshing,
              onPressed: onRefresh,
            ),
            _NewOutstandingButton(isLoading: isRefreshing, onPressed: onNew),
          ],
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              search,
              const SizedBox(height: 8),
              Align(alignment: Alignment.centerRight, child: actions),
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

class _OutstandingSearchField extends StatelessWidget {
  const _OutstandingSearchField({
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
          hintText: 'Search name, account, date, or comment',
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
            Icons.receipt_long_outlined,
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

class _HideSettledToggle extends StatelessWidget {
  const _HideSettledToggle({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: value
          ? 'Settled rows with zero net are hidden'
          : 'Show or hide rows with zero net',
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: value ? _primarySoft : _surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: value ? _primary : _lineStrong),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: value ? _primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: value ? _primary : _lineStrong,
                    width: 1.4,
                  ),
                ),
                child: value
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 13,
                      )
                    : null,
              ),
              const SizedBox(width: 7),
              Text(
                'HIDE SETTLED',
                style: TextStyle(
                  color: value ? _primaryDark : _muted,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutstandingRefreshButton extends StatelessWidget {
  const _OutstandingRefreshButton({
    required this.isRefreshing,
    required this.onPressed,
  });

  final bool isRefreshing;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Refresh outstanding data',
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

class _NewOutstandingButton extends StatelessWidget {
  const _NewOutstandingButton({
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: const Icon(Icons.add_rounded, size: 17),
        label: const Text('New Outstanding'),
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

class _OutstandingTotals extends StatelessWidget {
  const _OutstandingTotals({
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
          _OutstandingTotalCard(
            title: 'TOTAL PAID',
            value: paid,
            icon: Icons.north_east_rounded,
            color: _red,
            background: _redSoft,
          ),
          _OutstandingTotalCard(
            title: 'TOTAL RECEIVED',
            value: received,
            icon: Icons.south_west_rounded,
            color: _green,
            background: _greenSoft,
          ),
          _OutstandingTotalCard(
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

class _OutstandingTotalCard extends StatelessWidget {
  const _OutstandingTotalCard({
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

class _OutstandingPanel extends StatelessWidget {
  const _OutstandingPanel({
    required this.groups,
    required this.isLoading,
    required this.emptyBecauseSettled,
    required this.expandedGroupKey,
    required this.requestedStartIndex,
    required this.detailPages,
    required this.horizontalController,
    required this.expandedTableController,
    required this.onCollapseAll,
    required this.onToggleGroup,
    required this.onGroupPageChanged,
    required this.onPageChanged,
    required this.onEdit,
    required this.onDelete,
  });

  final List<_OutstandingGroup> groups;
  final bool isLoading;
  final bool emptyBecauseSettled;
  final String? expandedGroupKey;
  final int requestedStartIndex;
  final Map<String, int> detailPages;
  final ScrollController horizontalController;
  final ScrollController expandedTableController;
  final VoidCallback onCollapseAll;
  final ValueChanged<_OutstandingGroup> onToggleGroup;
  final ValueChanged<int> onGroupPageChanged;
  final void Function(String groupKey, int page) onPageChanged;
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
          if (isLoading && groups.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(
                color: _primary,
                strokeWidth: 2.5,
              ),
            );
          }
          if (groups.isEmpty) {
            return _OutstandingEmptyState(settledOnly: emptyBecauseSettled);
          }

          final tableWidth = math.max(_minimumTableWidth, constraints.maxWidth);
          return Scrollbar(
            controller: horizontalController,
            thumbVisibility: constraints.maxWidth < _minimumTableWidth,
            notificationPredicate: (notification) => notification.depth == 1,
            child: SingleChildScrollView(
              controller: horizontalController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: tableWidth,
                height: constraints.maxHeight,
                child: Column(
                  children: [
                    _OutstandingTableHeader(
                      canCollapse: expandedGroupKey != null,
                      onCollapseAll: onCollapseAll,
                    ),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, bodyConstraints) {
                          const groupRowHeight = 62.0;
                          const pageFooterHeight = 48.0;

                          final expandedIndex = groups.indexWhere(
                            (group) => group.key == expandedGroupKey,
                          );
                          final availableRowsHeight = math.max(
                            groupRowHeight,
                            bodyConstraints.maxHeight - pageFooterHeight - 1,
                          );
                          final rowsPerPage = math.max(
                            1,
                            availableRowsHeight ~/ groupRowHeight,
                          );
                          final pageCount = math.max(
                            1,
                            (groups.length / rowsPerPage).ceil(),
                          );
                          final maxStart = math.max(
                            0,
                            groups.length - rowsPerPage,
                          );
                          var start = requestedStartIndex.clamp(0, maxStart);
                          if (expandedIndex != -1) {
                            if (expandedIndex < start) {
                              start = expandedIndex;
                            } else if (expandedIndex >= start + rowsPerPage) {
                              start = math.max(
                                0,
                                expandedIndex - rowsPerPage + 1,
                              );
                            }
                          }
                          final end = math.min(
                            start + rowsPerPage,
                            groups.length,
                          );
                          final page = (start ~/ rowsPerPage).clamp(
                            0,
                            pageCount - 1,
                          );
                          final pageGroups = groups.sublist(start, end);
                          final groupSections = pageGroups
                              .map((group) {
                                final isExpanded =
                                    group.key == expandedGroupKey;
                                return _OutstandingGroupSection(
                                  group: group,
                                  isExpanded: isExpanded,
                                  page: detailPages[group.key] ?? 0,
                                  detailsRowsPerPage: _detailsRowsPerPage,
                                  onToggle: () => onToggleGroup(group),
                                  onPageChanged: (detailPage) =>
                                      onPageChanged(group.key, detailPage),
                                  onEdit: onEdit,
                                  onDelete: onDelete,
                                );
                              })
                              .toList(growable: false);
                          final footer = _OutstandingGroupPaginationFooter(
                            start: start,
                            end: end,
                            total: groups.length,
                            page: page,
                            pageCount: pageCount,
                            rowsPerPage: rowsPerPage,
                            onPageChanged: onGroupPageChanged,
                          );

                          if (expandedIndex != -1) {
                            return Scrollbar(
                              controller: expandedTableController,
                              thumbVisibility: true,
                              interactive: true,
                              child: SingleChildScrollView(
                                controller: expandedTableController,
                                physics: const ClampingScrollPhysics(),
                                child: Column(
                                  children: [...groupSections, footer],
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: [
                              ...groupSections,
                              const Spacer(),
                              footer,
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

class _OutstandingTableHeader extends StatelessWidget {
  const _OutstandingTableHeader({
    required this.canCollapse,
    required this.onCollapseAll,
  });

  final bool canCollapse;
  final VoidCallback onCollapseAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: const BoxDecoration(
        color: _surfaceSoft,
        border: Border(bottom: BorderSide(color: _lineStrong)),
      ),
      child: _OutstandingSummaryGrid(
        isHeader: true,
        name: const Text('NAME'),
        count: const Text('COUNT'),
        paid: const Text('PAID'),
        received: const Text('RECEIVED'),
        net: const Text('NET'),
        trailing: _CollapseButton(
          enabled: canCollapse,
          onPressed: onCollapseAll,
        ),
      ),
    );
  }
}

class _OutstandingGroupSection extends StatelessWidget {
  const _OutstandingGroupSection({
    required this.group,
    required this.isExpanded,
    required this.page,
    required this.detailsRowsPerPage,
    required this.onToggle,
    required this.onPageChanged,
    required this.onEdit,
    required this.onDelete,
  });

  final _OutstandingGroup group;
  final bool isExpanded;
  final int page;
  final int detailsRowsPerPage;
  final VoidCallback onToggle;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<CapitalsAndOutstandingModel> onEdit;
  final ValueChanged<CapitalsAndOutstandingModel> onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: isExpanded ? const Color(0xFFF7FBFC) : _surface,
          child: InkWell(
            onTap: onToggle,
            hoverColor: _surfaceSoft,
            child: SizedBox(
              height: 62,
              child: _OutstandingSummaryGrid(
                name: _OutstandingNameCell(group: group),
                count: _CountBadge(count: group.items.length),
                paid: _MoneyText(value: group.paid, color: _red),
                received: _MoneyText(value: group.received, color: _green),
                net: _MoneyText(value: group.net, color: _netColor(group.net)),
                trailing: _ExpandButton(isExpanded: isExpanded),
              ),
            ),
          ),
        ),
        if (isExpanded)
          _OutstandingDetailsPanel(
            group: group,
            requestedPage: page,
            rowsPerPage: detailsRowsPerPage,
            onPageChanged: onPageChanged,
            onEdit: onEdit,
            onDelete: onDelete,
          ),
      ],
    );
  }
}

class _OutstandingSummaryGrid extends StatelessWidget {
  const _OutstandingSummaryGrid({
    required this.name,
    required this.count,
    required this.paid,
    required this.received,
    required this.net,
    required this.trailing,
    this.isHeader = false,
  });

  final Widget name;
  final Widget count;
  final Widget paid;
  final Widget received;
  final Widget net;
  final Widget trailing;
  final bool isHeader;

  @override
  Widget build(BuildContext context) {
    final tableTheme = Theme.of(context).dataTableTheme;

    Widget cell(Widget child, {Alignment alignment = Alignment.centerLeft}) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
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
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _line)),
      ),
      child: Row(
        children: [
          Expanded(flex: 4, child: cell(name)),
          Expanded(flex: 1, child: cell(count, alignment: Alignment.center)),
          Expanded(
            flex: 2,
            child: cell(paid, alignment: Alignment.centerRight),
          ),
          Expanded(
            flex: 2,
            child: cell(received, alignment: Alignment.centerRight),
          ),
          Expanded(flex: 2, child: cell(net, alignment: Alignment.centerRight)),
          SizedBox(width: 52, child: Center(child: trailing)),
        ],
      ),
    );
  }
}

class _OutstandingNameCell extends StatelessWidget {
  const _OutstandingNameCell({required this.group});

  final _OutstandingGroup group;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: _primarySoft,
            border: Border.all(color: _primary.withValues(alpha: .14)),
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            size: 18,
            color: _primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                group.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).dataTableTheme.dataTextStyle?.copyWith(color: _text),
              ),
              const SizedBox(height: 2),
              Text(
                '${group.items.length} outstanding ${group.items.length == 1 ? 'entry' : 'entries'}',
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
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 32),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: _primarySoft,
        border: Border.all(color: _primary.withValues(alpha: .14)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: _primaryDark,
          fontSize: 10.5,
          fontWeight: FontWeight.w900,
        ),
      ),
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

class _CollapseButton extends StatelessWidget {
  const _CollapseButton({required this.enabled, required this.onPressed});

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Collapse details',
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: enabled ? _primarySoft : Colors.transparent,
            border: Border.all(color: enabled ? _lineStrong : _line),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.keyboard_arrow_up_rounded,
            size: 18,
            color: enabled ? _primaryDark : _lineStrong,
          ),
        ),
      ),
    );
  }
}

class _ExpandButton extends StatelessWidget {
  const _ExpandButton({required this.isExpanded});

  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 170),
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isExpanded ? _primarySoft : _surfaceSoft,
        borderRadius: BorderRadius.circular(9),
      ),
      child: AnimatedRotation(
        duration: const Duration(milliseconds: 170),
        turns: isExpanded ? .5 : 0,
        child: Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 19,
          color: isExpanded ? _primaryDark : _muted,
        ),
      ),
    );
  }
}

class _OutstandingGroupPaginationFooter extends StatelessWidget {
  const _OutstandingGroupPaginationFooter({
    required this.start,
    required this.end,
    required this.total,
    required this.page,
    required this.pageCount,
    required this.rowsPerPage,
    required this.onPageChanged,
  });

  final int start;
  final int end;
  final int total;
  final int page;
  final int pageCount;
  final int rowsPerPage;
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
            'Showing ${total == 0 ? 0 : start + 1}–$end of $total people',
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
            enabled: start > 0,
            onPressed: () => onPageChanged(0),
          ),
          const SizedBox(width: 5),
          _PageButton(
            tooltip: 'Previous page',
            icon: Icons.chevron_left_rounded,
            enabled: start > 0,
            onPressed: () => onPageChanged(math.max(0, start - rowsPerPage)),
          ),
          Container(
            height: 28,
            constraints: const BoxConstraints(minWidth: 64),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 9),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _primarySoft,
              border: Border.all(color: _primary.withValues(alpha: .14)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${page + 1} / $pageCount',
              style: const TextStyle(
                color: _primaryDark,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          _PageButton(
            tooltip: 'Next page',
            icon: Icons.chevron_right_rounded,
            enabled: end < total,
            onPressed: () => onPageChanged(end),
          ),
          const SizedBox(width: 5),
          _PageButton(
            tooltip: 'Last page',
            icon: Icons.last_page_rounded,
            enabled: end < total,
            onPressed: () => onPageChanged(math.max(0, total - rowsPerPage)),
          ),
        ],
      ),
    );
  }
}

class _OutstandingDetailsPanel extends StatelessWidget {
  const _OutstandingDetailsPanel({
    required this.group,
    required this.requestedPage,
    required this.rowsPerPage,
    required this.onPageChanged,
    required this.onEdit,
    required this.onDelete,
  });

  final _OutstandingGroup group;
  final int requestedPage;
  final int rowsPerPage;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<CapitalsAndOutstandingModel> onEdit;
  final ValueChanged<CapitalsAndOutstandingModel> onDelete;

  @override
  Widget build(BuildContext context) {
    final pageCount = math.max(1, (group.items.length / rowsPerPage).ceil());
    final page = requestedPage.clamp(0, pageCount - 1);
    final start = page * rowsPerPage;
    final end = math.min(start + rowsPerPage, group.items.length);
    final pageItems = group.items.sublist(start, end);

    return Container(
      color: _surfaceStrong,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: _surface,
          border: Border.all(color: _lineStrong),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const _OutstandingDetailsHeader(),
            ...pageItems.asMap().entries.map((entry) {
              return _OutstandingDetailRow(
                item: entry.value,
                shaded: entry.key.isOdd,
                onEdit: () => onEdit(entry.value),
                onDelete: () => onDelete(entry.value),
              );
            }),
            _OutstandingDetailsFooter(
              start: start,
              end: end,
              total: group.items.length,
              page: page,
              pageCount: pageCount,
              onPageChanged: onPageChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _OutstandingDetailsHeader extends StatelessWidget {
  const _OutstandingDetailsHeader();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 38,
      child: _OutstandingDetailGrid(
        isHeader: true,
        action: Text('ACTION'),
        date: Text('DATE'),
        account: Text('ACCOUNT'),
        comment: Text('COMMENT'),
        paid: Text('PAID'),
        received: Text('RECEIVED'),
        net: Text('NET'),
      ),
    );
  }
}

class _OutstandingDetailRow extends StatelessWidget {
  const _OutstandingDetailRow({
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
      height: 50,
      color: shaded ? const Color(0xFFFBFCFE) : _surface,
      child: _OutstandingDetailGrid(
        action: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DetailActionButton(
              tooltip: 'Edit entry',
              icon: Icons.edit_note_rounded,
              color: _blue,
              background: _blueSoft,
              onPressed: onEdit,
            ),
            const SizedBox(width: 4),
            _DetailActionButton(
              tooltip: 'Delete entry',
              icon: Icons.delete_outline_rounded,
              color: _red,
              background: _redSoft,
              onPressed: onDelete,
            ),
          ],
        ),
        date: Text(textToDate(item.date)),
        account: _AccountNameCell(name: item.accountName),
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

class _OutstandingDetailGrid extends StatelessWidget {
  const _OutstandingDetailGrid({
    required this.action,
    required this.date,
    required this.account,
    required this.comment,
    required this.paid,
    required this.received,
    required this.net,
    this.isHeader = false,
  });

  final Widget action;
  final Widget date;
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
          SizedBox(width: 80, child: cell(action, alignment: Alignment.center)),
          Expanded(flex: 2, child: cell(date)),
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

class _AccountNameCell extends StatelessWidget {
  const _AccountNameCell({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: _surface,
            border: Border.all(color: _line),
            borderRadius: BorderRadius.circular(7),
          ),
          child: const Icon(
            Icons.account_balance_outlined,
            size: 13,
            color: _primary,
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            name.trim().isEmpty ? '—' : name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _DetailActionButton extends StatelessWidget {
  const _DetailActionButton({
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

class _OutstandingDetailsFooter extends StatelessWidget {
  const _OutstandingDetailsFooter({
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
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      color: const Color(0xFFFBFCFE),
      child: Row(
        children: [
          Text(
            'Showing ${total == 0 ? 0 : start + 1}–$end of $total entries',
            style: const TextStyle(
              color: _muted,
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          _PageButton(
            tooltip: 'Previous page',
            icon: Icons.chevron_left_rounded,
            enabled: page > 0,
            onPressed: () => onPageChanged(page - 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '${page + 1} / $pageCount',
              style: const TextStyle(
                color: _text,
                fontSize: 9.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          _PageButton(
            tooltip: 'Next page',
            icon: Icons.chevron_right_rounded,
            enabled: page < pageCount - 1,
            onPressed: () => onPageChanged(page + 1),
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

class _OutstandingEmptyState extends StatelessWidget {
  const _OutstandingEmptyState({required this.settledOnly});

  final bool settledOnly;

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
            Text(
              settledOnly
                  ? 'All matching rows are settled'
                  : 'No outstanding entries found',
              style: const TextStyle(
                color: _text,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              settledOnly
                  ? 'Turn off Hide Settled to show rows with a zero net.'
                  : 'Try changing the search or add a new outstanding entry.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: _muted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutstandingGroup {
  const _OutstandingGroup({
    required this.key,
    required this.name,
    required this.items,
    required this.paid,
    required this.received,
  });

  final String key;
  final String name;
  final List<CapitalsAndOutstandingModel> items;
  final double paid;
  final double received;

  double get net => received - paid;
}

List<_OutstandingGroup> _groupItems(List<CapitalsAndOutstandingModel> items) {
  final grouped = <String, List<CapitalsAndOutstandingModel>>{};
  final names = <String, String>{};

  for (final item in items) {
    final normalizedName = item.name.trim();
    final key = item.nameId.trim().isNotEmpty
        ? item.nameId.trim()
        : normalizedName.toLowerCase();
    grouped.putIfAbsent(key, () => <CapitalsAndOutstandingModel>[]).add(item);
    names[key] = normalizedName.isEmpty ? 'Unnamed' : normalizedName;
  }

  final result = grouped.entries
      .map((entry) {
        final groupItems = entry.value
          ..sort((a, b) => b.date.compareTo(a.date));
        final paid = groupItems.fold<double>(0, (sum, item) => sum + item.pay);
        final received = groupItems.fold<double>(
          0,
          (sum, item) => sum + item.receive,
        );
        return _OutstandingGroup(
          key: entry.key,
          name: names[entry.key] ?? 'Unnamed',
          items: groupItems,
          paid: paid,
          received: received,
        );
      })
      .toList(growable: false);

  result.sort((a, b) {
    final netComparison = a.net.compareTo(b.net);
    if (netComparison != 0) return netComparison;
    return a.name.toLowerCase().compareTo(b.name.toLowerCase());
  });
  return result;
}

Color _netColor(double value) {
  if (value > 0) return _green;
  if (value < 0) return _red;
  return _blue;
}

bool _isSettled(double value) => value.abs() < 0.005;
