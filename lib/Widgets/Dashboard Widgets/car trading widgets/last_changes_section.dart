import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../Models/car trading/last_changes_model.dart';
import '../../../consts.dart';
import '../../drop_down_menu3.dart';

const _surface = Colors.white;
const _surfaceSoft = Color(0xFFF8FAFC);
const _surfaceStrong = Color(0xFFEDF2F7);
const _line = Color(0xFFDFE7EF);
const _lineStrong = Color(0xFFCFD9E5);
const _text = Color(0xFF172231);
const _muted = Color(0xFF6C798A);
const _orange = Color(0xFFF08A24);
const _orangeDark = Color(0xFFC96A0C);
const _orangeSoft = Color(0xFFFFF3E8);
const _green = Color(0xFF2F9E62);
const _greenSoft = Color(0xFFEAF8EF);
const _red = Color(0xFFD95757);
const _redSoft = Color(0xFFFFEFEF);
const _blue = Color(0xFF2F78C4);
const _blueSoft = Color(0xFFEDF5FD);
const _purple = Color(0xFF7C3AED);
const _purpleSoft = Color(0xFFF2EDFF);
const _shadow = Color(0x141B2C45);
const _minimumTableWidth = 1240.0;

class LastChangesSection extends StatefulWidget {
  const LastChangesSection({super.key});

  @override
  State<LastChangesSection> createState() => _LastChangesSectionState();
}

class _LastChangesSectionState extends State<LastChangesSection> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _horizontalController = ScrollController();

  String _query = '';
  int _selectedRange = 1;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final controller = Get.find<CarTradingDashboardController>();
      if (controller.lastChanges.isEmpty) {
        controller.onChooseForDatePickerForChanges(_selectedRange);
      }
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
        final items = _visibleItems(controller.lastChanges);
        return ColoredBox(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _LastChangesToolbar(
                searchController: _searchController,
                resultCount: items.length,
                isRefreshing: controller.changesSearching.value,
                onSearchChanged: (value) {
                  setState(() {
                    _query = value;
                    _page = 0;
                  });
                },
                onRefresh: () => _find(controller),
              ),
              const SizedBox(height: 9),
              _LastChangesFilters(
                controller: controller,
                selectedRange: _selectedRange,
                isSearching: controller.changesSearching.value,
                onRangeChanged: (range) {
                  setState(() {
                    _selectedRange = range;
                    _page = 0;
                  });
                  controller.onChooseForDatePickerForChanges(range);
                },
                onFind: () => _find(controller),
                onClear: () => _clear(controller),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _LastChangesPanel(
                  items: items,
                  isLoading: controller.changesSearching.value,
                  requestedPage: _page,
                  horizontalController: _horizontalController,
                  onPageChanged: (page) => setState(() => _page = page),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<LastCarTradingChangesModel> _visibleItems(
    List<LastCarTradingChangesModel> source,
  ) {
    final query = _query.trim().toLowerCase();
    final result = source
        .where((item) {
          if (query.isEmpty) return true;
          return [
            item.type,
            item.brandName,
            item.modelName,
            item.year,
            item.accountName,
            item.itemName,
            item.description,
            item.pay,
            item.receive,
            textToDate(item.updatedAt),
          ].join(' ').toLowerCase().contains(query);
        })
        .toList(growable: false);

    result.sort((a, b) {
      final aDate = a.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });
    return result;
  }

  void _find(CarTradingDashboardController controller) {
    setState(() => _page = 0);
    controller.filterLastChangesSearch();
  }

  Future<void> _clear(CarTradingDashboardController controller) async {
    controller.clearCangesVariables();
    _searchController.clear();
    setState(() {
      _query = '';
      _selectedRange = 0;
      _page = 0;
    });
    await controller.getLastChanges({});
  }
}

class _LastChangesToolbar extends StatelessWidget {
  const _LastChangesToolbar({
    required this.searchController,
    required this.resultCount,
    required this.isRefreshing,
    required this.onSearchChanged,
    required this.onRefresh,
  });

  final TextEditingController searchController;
  final int resultCount;
  final bool isRefreshing;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 38,
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              style: const TextStyle(
                color: _text,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                hintText: 'Search the loaded changes',
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
                suffixIcon: searchController.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Clear table search',
                        onPressed: () {
                          searchController.clear();
                          onSearchChanged('');
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
                  borderSide: const BorderSide(color: _orange),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        _ResultPill(count: resultCount),
        const SizedBox(width: 8),
        _RefreshButton(isRefreshing: isRefreshing, onPressed: onRefresh),
      ],
    );
  }
}

class _ResultPill extends StatelessWidget {
  const _ResultPill({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: _orangeSoft,
        border: Border.all(color: _orange.withValues(alpha: .24)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.history_rounded, size: 15, color: _orangeDark),
          const SizedBox(width: 7),
          Text(
            '$count ${count == 1 ? 'CHANGE' : 'CHANGES'}',
            style: const TextStyle(
              color: _orangeDark,
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
      message: 'Refresh last changes',
      child: SizedBox(
        width: 36,
        height: 36,
        child: OutlinedButton(
          onPressed: isRefreshing ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: _orangeDark,
            disabledForegroundColor: _orange,
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
                    color: _orange,
                  )
                : const Icon(Icons.refresh_rounded, size: 18),
          ),
        ),
      ),
    );
  }
}

class _LastChangesFilters extends StatelessWidget {
  const _LastChangesFilters({
    required this.controller,
    required this.selectedRange,
    required this.isSearching,
    required this.onRangeChanged,
    required this.onFind,
    required this.onClear,
  });

  final CarTradingDashboardController controller;
  final int selectedRange;
  final bool isSearching;
  final ValueChanged<int> onRangeChanged;
  final VoidCallback onFind;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
      decoration: BoxDecoration(
        color: _surfaceSoft,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _FilterTextField(
              width: 125,
              label: 'FROM DATE',
              controller: controller.fromDateForChanges.value,
              hintText: 'DD/MM/YYYY',
              onSubmitted: (_) => normalizeDate(
                controller.fromDateForChanges.value.text,
                controller.fromDateForChanges.value,
              ),
              onTapOutside: (_) => normalizeDate(
                controller.fromDateForChanges.value.text,
                controller.fromDateForChanges.value,
              ),
              suffixIcon: IconButton(
                tooltip: 'Select from date',
                onPressed: () => selectDateContext(
                  context,
                  controller.fromDateForChanges.value,
                ),
                icon: const Icon(Icons.calendar_today_outlined, size: 15),
              ),
            ),
            const SizedBox(width: 8),
            _FilterTextField(
              width: 125,
              label: 'TO DATE',
              controller: controller.toDateForChanges.value,
              hintText: 'DD/MM/YYYY',
              onSubmitted: (_) => normalizeDate(
                controller.toDateForChanges.value.text,
                controller.toDateForChanges.value,
              ),
              onTapOutside: (_) => normalizeDate(
                controller.toDateForChanges.value.text,
                controller.toDateForChanges.value,
              ),
              suffixIcon: IconButton(
                tooltip: 'Select to date',
                onPressed: () => selectDateContext(
                  context,
                  controller.toDateForChanges.value,
                ),
                icon: const Icon(Icons.calendar_today_outlined, size: 15),
              ),
            ),
            const SizedBox(width: 8),
            CustomDropdown(
              width: 220,
              fieldheigth: 36,
              hintText: 'Account',
              showedSelectedName: 'name',
              textcontroller: controller.accountForLastChanges.value.text,
              onChanged: (key, value) {
                controller.accountForLastChanges.value.text = value['name'];
              },
              onDelete: controller.accountForLastChanges.value.clear,
              onOpen: controller.getNamesOfAccount,
            ),
            const SizedBox(width: 8),
            _FilterTextField(
              width: 115,
              label: 'MIN AMOUNT',
              controller: controller.minAmount.value,
              hintText: '0.00',
              number: true,
            ),
            const SizedBox(width: 8),
            _FilterTextField(
              width: 115,
              label: 'MAX AMOUNT',
              controller: controller.maxAmount.value,
              hintText: '0.00',
              number: true,
            ),
            const SizedBox(width: 10),
            _RangePicker(value: selectedRange, onChanged: onRangeChanged),
            const SizedBox(width: 10),
            SizedBox(
              height: 36,
              child: ElevatedButton.icon(
                onPressed: isSearching ? null : onFind,
                icon: isSearching
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.search_rounded, size: 16),
                label: const Text('Find'),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: _orange,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: _orange.withValues(alpha: .55),
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  textStyle: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 7),
            SizedBox(
              height: 36,
              child: OutlinedButton.icon(
                onPressed: isSearching ? null : onClear,
                icon: const Icon(Icons.cleaning_services_outlined, size: 15),
                label: const Text('Clear'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _muted,
                  side: const BorderSide(color: _lineStrong),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  textStyle: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
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

class _FilterTextField extends StatelessWidget {
  const _FilterTextField({
    required this.width,
    required this.label,
    required this.controller,
    required this.hintText,
    this.number = false,
    this.suffixIcon,
    this.onSubmitted,
    this.onTapOutside,
  });

  final double width;
  final String label;
  final TextEditingController controller;
  final String hintText;
  final bool number;
  final Widget? suffixIcon;
  final ValueChanged<String>? onSubmitted;
  final TapRegionCallback? onTapOutside;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 3),
            child: Text(
              label,
              style: const TextStyle(
                color: _muted,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: .25,
              ),
            ),
          ),
          SizedBox(
            height: 36,
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              onTapOutside: onTapOutside,
              keyboardType: number
                  ? const TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.text,
              inputFormatters: number
                  ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,-]'))]
                  : null,
              style: const TextStyle(
                color: _text,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Color(0xFF9AA7B7)),
                suffixIcon: suffixIcon,
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 32,
                  maxWidth: 36,
                ),
                filled: true,
                fillColor: _surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 8,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _lineStrong),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: _orange),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RangePicker extends StatelessWidget {
  const _RangePicker({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: _surfaceStrong,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          _RangeOption(
            text: 'TODAY',
            selected: value == 1,
            onTap: () => onChanged(1),
          ),
          _RangeOption(
            text: 'THIS MONTH',
            selected: value == 2,
            onTap: () => onChanged(2),
          ),
          _RangeOption(
            text: 'THIS YEAR',
            selected: value == 3,
            onTap: () => onChanged(3),
          ),
        ],
      ),
    );
  }
}

class _RangeOption extends StatelessWidget {
  const _RangeOption({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(7),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? _surface : Colors.transparent,
          border: selected ? Border.all(color: _lineStrong) : null,
          borderRadius: BorderRadius.circular(7),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x100F253B),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? _orangeDark : _muted,
            fontSize: 9,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _LastChangesPanel extends StatelessWidget {
  const _LastChangesPanel({
    required this.items,
    required this.isLoading,
    required this.requestedPage,
    required this.horizontalController,
    required this.onPageChanged,
  });

  final List<LastCarTradingChangesModel> items;
  final bool isLoading;
  final int requestedPage;
  final ScrollController horizontalController;
  final ValueChanged<int> onPageChanged;

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
                color: _orange,
                strokeWidth: 2.5,
              ),
            );
          }
          if (items.isEmpty) return const _LastChangesEmptyState();

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
                    const _LastChangesHeader(),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, bodyConstraints) {
                          const rowHeight = 56.0;
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
                                    (entry) => _LastChangeRow(
                                      item: entry.value,
                                      shaded: entry.key.isOdd,
                                    ),
                                  ),
                              const Spacer(),
                              _PaginationFooter(
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

class _LastChangesHeader extends StatelessWidget {
  const _LastChangesHeader();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 44,
      child: _LastChangeGrid(
        isHeader: true,
        date: Text('CHANGE DATE'),
        type: Text('TYPE'),
        brand: Text('BRAND'),
        model: Text('MODEL'),
        year: Text('YEAR'),
        account: Text('ACCOUNT'),
        item: Text('ITEM'),
        description: Text('DESCRIPTION'),
        paid: Text('PAID'),
        received: Text('RECEIVED'),
      ),
    );
  }
}

class _LastChangeRow extends StatelessWidget {
  const _LastChangeRow({required this.item, required this.shaded});

  final LastCarTradingChangesModel item;
  final bool shaded;

  @override
  Widget build(BuildContext context) {
    final type = item.type?.trim().toLowerCase() ?? '';
    return Container(
      height: 56,
      color: shaded ? const Color(0xFFFBFCFE) : _surface,
      child: _LastChangeGrid(
        date: _DateCell(value: textToDate(item.updatedAt)),
        type: _TypeBadge(type: type),
        brand: _PlainCell(text: item.brandName),
        model: _PlainCell(text: item.modelName),
        year: _PlainCell(text: item.year, color: _orangeDark),
        account: _NamedCell(
          text: item.accountName,
          icon: Icons.account_balance_outlined,
          color: _blue,
          background: _blueSoft,
        ),
        item: _NamedCell(
          text: item.itemName,
          icon: Icons.inventory_2_outlined,
          color: _purple,
          background: _purpleSoft,
        ),
        description: _PlainCell(text: item.description, allowMuted: true),
        paid: _MoneyText(value: item.pay ?? 0, color: _red),
        received: _MoneyText(value: item.receive ?? 0, color: _green),
      ),
    );
  }
}

class _LastChangeGrid extends StatelessWidget {
  const _LastChangeGrid({
    required this.date,
    required this.type,
    required this.brand,
    required this.model,
    required this.year,
    required this.account,
    required this.item,
    required this.description,
    required this.paid,
    required this.received,
    this.isHeader = false,
  });

  final Widget date;
  final Widget type;
  final Widget brand;
  final Widget model;
  final Widget year;
  final Widget account;
  final Widget item;
  final Widget description;
  final Widget paid;
  final Widget received;
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
          SizedBox(width: 115, child: cell(date)),
          SizedBox(width: 105, child: cell(type, alignment: Alignment.center)),
          Expanded(flex: 2, child: cell(brand)),
          Expanded(flex: 2, child: cell(model)),
          SizedBox(width: 72, child: cell(year)),
          Expanded(flex: 3, child: cell(account)),
          Expanded(flex: 3, child: cell(item)),
          Expanded(flex: 4, child: cell(description)),
          SizedBox(
            width: 118,
            child: cell(paid, alignment: Alignment.centerRight),
          ),
          SizedBox(
            width: 118,
            child: cell(received, alignment: Alignment.centerRight),
          ),
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
        const Icon(Icons.schedule_rounded, size: 14, color: _orange),
        const SizedBox(width: 6),
        Expanded(
          child: Text(value, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final color = switch (type) {
      'car' => _blue,
      'expenses' => _orange,
      'outstanding' => _red,
      'capital' => _purple,
      'transfer' => _green,
      _ => _muted,
    };
    final background = switch (type) {
      'car' => _blueSoft,
      'expenses' => _orangeSoft,
      'outstanding' => _redSoft,
      'capital' => _purpleSoft,
      'transfer' => _greenSoft,
      _ => _surfaceStrong,
    };
    final label = type.trim().isEmpty ? 'UNKNOWN' : type.toUpperCase();

    return Container(
      constraints: const BoxConstraints(minWidth: 72),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _PlainCell extends StatelessWidget {
  const _PlainCell({this.text, this.color, this.allowMuted = false});

  final String? text;
  final Color? color;
  final bool allowMuted;

  @override
  Widget build(BuildContext context) {
    final value = text?.trim() ?? '';
    final isEmpty = value.isEmpty || value == '-' || value == '0';
    return Text(
      isEmpty ? '—' : value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: isEmpty && allowMuted ? _muted : color,
        fontStyle: isEmpty && allowMuted ? FontStyle.italic : FontStyle.normal,
      ),
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

  final String? text;
  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final value = text?.trim() ?? '';
    final isEmpty = value.isEmpty || value == '-' || value == '0';
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
            isEmpty ? '—' : value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isEmpty ? _muted : null,
              fontStyle: isEmpty ? FontStyle.italic : FontStyle.normal,
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

class _PaginationFooter extends StatelessWidget {
  const _PaginationFooter({
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
            'Showing ${total == 0 ? 0 : start + 1}–$end of $total changes',
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
            color: enabled ? _orangeDark : _lineStrong,
          ),
        ),
      ),
    );
  }
}

class _LastChangesEmptyState extends StatelessWidget {
  const _LastChangesEmptyState();

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
                color: _orangeSoft,
                border: Border.all(color: _orange.withValues(alpha: .22)),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.history_rounded,
                size: 25,
                color: _orange,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'No changes found',
              style: TextStyle(
                color: _text,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Try changing the filters or select a wider date range.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
