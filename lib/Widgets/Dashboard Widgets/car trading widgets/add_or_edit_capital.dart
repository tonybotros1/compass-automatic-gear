import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../consts.dart';
import '../../Auth screens widgets/register widgets/search_bar.dart';
import '../../main screen widgets/auto_size_box.dart';
import 'item_dialog.dart';

Widget addNewCapitalOrOutstandingOrGeneralExpensesOrEdit({
  required BuildContext context,
  required CarTradingDashboardController controller,
  required bool canEdit,
  required BoxConstraints constraints,
  required RxList map,
  required RxList filteredMap,
  required String collection,
  required Rx<TextEditingController> search,
  required bool isGeneralExpenses,
}) {
  return ColoredBox(
    color: Colors.white,
    child: Column(
      children: [
        Expanded(
          child: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: true,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Column(
                    children: [
                      searchBar(
                        onChanged: (_) {
                          controller
                              .filterCapitalsOrOutstandingOrGeneralExpenses(
                                search,
                                map,
                                filteredMap,
                                isGeneralExpenses,
                              );
                        },
                        onPressedForClearSearch: () {
                          search.value.clear();
                          controller
                              .filterCapitalsOrOutstandingOrGeneralExpenses(
                                search,
                                map,
                                filteredMap,
                                isGeneralExpenses,
                              );
                        },
                        search: search,
                        constraints: constraints,
                        context: context,
                        title: 'Search for Items',
                        button: newItemButton(
                          context,
                          controller,
                          collection,
                          isGeneralExpenses,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Expanded(child: _CapitalTotalsFooter()),
                          if (isGeneralExpenses) ...[
                            const SizedBox(width: 12),
                            GetX<CarTradingDashboardController>(
                              builder: (controller) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  child: CustomSlidingSegmentedControl<int>(
                                    key: ValueKey(
                                      controller
                                          .initValueForExpensesTypePicker
                                          .value,
                                    ),
                                    height: 40,
                                    initialValue: controller
                                        .initValueForExpensesTypePicker
                                        .value,
                                    children: const {
                                      1: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Text('ALL'),
                                      ),
                                      2: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Text('CARS'),
                                      ),
                                      3: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Text('GENERAL'),
                                      ),
                                    },
                                    decoration: BoxDecoration(
                                      color:
                                          CupertinoColors.lightBackgroundGray,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    thumbDecoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(20),
                                          blurRadius: 4.0,
                                          spreadRadius: 1.0,
                                          offset: const Offset(0.0, 2.0),
                                        ),
                                      ],
                                    ),
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    onValueChanged: (v) {
                                      controller.onChooseForExpensesTypes(v);
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: GetX<CarTradingDashboardController>(
                          builder: (controller) {
                            final visibleItems = _visibleItems(
                              allMap: map,
                              filteredMap: filteredMap,
                              search: search,
                              useFilteredMap:
                                  isGeneralExpenses &&
                                  controller
                                          .initValueForExpensesTypePicker
                                          .value !=
                                      1,
                            );

                            if (controller.isCapitalLoading.isTrue &&
                                map.isEmpty) {
                              return Center(child: loadingProcess);
                            }

                            if (visibleItems.isEmpty) {
                              return _EmptyTableState(
                                message: search.value.text.trim().isEmpty
                                    ? 'No Element'
                                    : 'No matching items',
                              );
                            }

                            return tableOfScreens(
                              search: search,
                              collection: collection,
                              allMap: map,
                              filteredMap: filteredMap,
                              constraints: constraints,
                              context: context,
                              controller: controller,
                              isGeneralExpenses: isGeneralExpenses,
                            );
                          },
                        ),
                      ),
                    ],
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

Widget tableOfScreens({
  required BoxConstraints constraints,
  required BuildContext context,
  required RxList allMap,
  required RxList filteredMap,
  required String collection,
  required Rx<TextEditingController> search,
  required CarTradingDashboardController controller,
  required bool isGeneralExpenses,
}) {
  final items = _visibleItems(
    allMap: allMap,
    filteredMap: filteredMap,
    search: search,
    useFilteredMap:
        isGeneralExpenses &&
        controller.initValueForExpensesTypePicker.value != 1,
  );

  return _modernTableSurface(
    child: PaginatedDataTable2(
      wrapInCard: false,
      showCheckboxColumn: false,
      showFirstLastButtons: true,
      renderEmptyRowsInTheEnd: false,
      autoRowsToHeight: true,
      minWidth: isGeneralExpenses ? 980 : 860,
      horizontalMargin: 16,
      columnSpacing: 18,
      headingRowHeight: 46,
      dataRowHeight: 58,
      dividerThickness: 0.5,
      headingRowColor: const WidgetStatePropertyAll(Color(0xFFF1F5F9)),
      headingTextStyle: const TextStyle(
        color: Color(0xFF475569),
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.5,
      ),
      dataTextStyle: const TextStyle(
        color: Color(0xFF334155),
        fontSize: 11.5,
        fontWeight: FontWeight.w600,
      ),
      empty: const _EmptyTableState(message: 'No Element'),
      columns: [
        DataColumn2(
          fixedWidth: 82,
          label: AutoSizedText(text: 'ACTIONS', constraints: constraints),
        ),
        DataColumn2(
          size: ColumnSize.S,
          label: AutoSizedText(text: 'DATE', constraints: constraints),
        ),
        DataColumn2(
          size: ColumnSize.S,
          label: AutoSizedText(
            constraints: constraints,
            text: isGeneralExpenses ? 'ITEM' : 'NAME',
          ),
        ),
        if (isGeneralExpenses)
          DataColumn2(
            size: ColumnSize.L,
            label: AutoSizedText(text: 'CAR', constraints: constraints),
          ),
        DataColumn2(
          size: ColumnSize.L,
          label: AutoSizedText(text: 'ACCOUNT', constraints: constraints),
        ),
        DataColumn2(
          size: ColumnSize.L,
          label: AutoSizedText(constraints: constraints, text: 'COMMENTS'),
        ),
        DataColumn2(
          size: ColumnSize.M,
          numeric: true,
          label: AutoSizedText(constraints: constraints, text: 'PAID'),
        ),
        DataColumn2(
          size: ColumnSize.M,
          numeric: true,
          label: AutoSizedText(constraints: constraints, text: 'RECEIVED'),
        ),
      ],
      source: _CapitalTableSource(
        items: items,
        context: context,
        constraints: constraints,
        controller: controller,
        collection: collection,
        isGeneralExpenses: isGeneralExpenses,
      ),
    ),
  );
}

DataRow dataRowForTheTable(
  dynamic itemData,
  BuildContext context,
  BoxConstraints constraints,
  CarTradingDashboardController controller,
  String capitalId,
  String collection,
  bool isGeneralExpenses,
  int index,
) {
  return DataRow2(
    color: _tableRowColor(index),
    cells: [
      DataCell(
        Row(
          spacing: 5,
          children: [
            deleteSection(controller, context, capitalId, collection),
            editSection(
              context,
              controller,
              itemData,
              constraints,
              collection,
              capitalId,
              isGeneralExpenses,
            ),
          ],
        ),
      ),
      DataCell(_DateBadge(value: textToDate(itemData.date))),
      DataCell(
        _PrimaryTableCell(
          text: isGeneralExpenses ? itemData.item : itemData.name,
          icon: isGeneralExpenses
              ? Icons.inventory_2_outlined
              : Icons.person_outline_rounded,
          color: const Color(0xFF2563EB),
        ),
      ),
      if (isGeneralExpenses)
        DataCell(
          _PrimaryTableCell(
            text: _carTextWithTrim(itemData),
            icon: Icons.directions_car_filled_outlined,
            color: const Color(0xFF0F766E),
          ),
        ),
      DataCell(
        _PrimaryTableCell(
          text: itemData.accountName,
          icon: Icons.account_balance_wallet_outlined,
          color: const Color(0xFF7C3AED),
        ),
      ),
      DataCell(
        Text(
          itemData.comment?.toString() ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.blueGrey.shade600),
        ),
      ),
      DataCell(
        _AmountBadge(
          value: itemData.pay.toString(),
          color: const Color(0xFFDC2626),
        ),
      ),
      DataCell(
        _AmountBadge(
          value: itemData.receive.toString(),
          color: const Color(0xFF16A34A),
        ),
      ),
    ],
  );
}

String _carTextWithTrim(dynamic itemData) {
  final car = itemData.car?.toString().trim() ?? '';
  final trim = itemData.trim?.toString().trim() ?? '';
  if (car.isEmpty || trim.isEmpty) return car;
  if (car.toLowerCase().contains(trim.toLowerCase())) return car;

  final mileageMatch = RegExp(
    r'\s*-\s*[^-]*\bkm\b',
    caseSensitive: false,
  ).firstMatch(car);

  if (mileageMatch == null) return '$car $trim';

  final beforeMileage = car.substring(0, mileageMatch.start).trimRight();
  final mileagePart = car.substring(mileageMatch.start);
  return '$beforeMileage $trim$mileagePart'.trim();
}

List<dynamic> _visibleItems({
  required RxList allMap,
  required RxList filteredMap,
  required Rx<TextEditingController> search,
  required bool useFilteredMap,
}) {
  final source =
      filteredMap.isEmpty && search.value.text.trim().isEmpty && !useFilteredMap
      ? allMap
      : filteredMap;
  return source.toList(growable: false);
}

Widget _modernTableSurface({required Widget child}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
    child: ClipRRect(borderRadius: BorderRadius.circular(10), child: child),
  );
}

WidgetStateProperty<Color?> _tableRowColor(int index) {
  return WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.hovered)) {
      return const Color(0xFFF0F7FF);
    }
    return index.isEven ? Colors.white : const Color(0xFFF8FAFC);
  });
}

class _CapitalTableSource extends DataTableSource {
  _CapitalTableSource({
    required this.items,
    required this.context,
    required this.constraints,
    required this.controller,
    required this.collection,
    required this.isGeneralExpenses,
  });

  final List<dynamic> items;
  final BuildContext context;
  final BoxConstraints constraints;
  final CarTradingDashboardController controller;
  final String collection;
  final bool isGeneralExpenses;

  @override
  DataRow? getRow(int index) {
    if (index >= items.length) return null;

    final item = items[index];
    return dataRowForTheTable(
      item,
      context,
      constraints,
      controller,
      item.id,
      collection,
      isGeneralExpenses,
      index,
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => items.length;

  @override
  int get selectedRowCount => 0;
}

class _EmptyTableState extends StatelessWidget {
  const _EmptyTableState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.inbox_outlined,
              color: Color(0xFF64748B),
              size: 23,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DateBadge extends StatelessWidget {
  const _DateBadge({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    final date = value.trim();
    if (date.isEmpty) return const Text('-');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.calendar_month_outlined,
            size: 13,
            color: Color(0xFF64748B),
          ),
          const SizedBox(width: 5),
          Text(
            date,
            style: const TextStyle(
              color: Color(0xFF475569),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryTableCell extends StatelessWidget {
  const _PrimaryTableCell({
    required this.text,
    required this.icon,
    this.color = const Color(0xFF334155),
  });

  final String text;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 15, color: color),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text.trim().isEmpty ? '-' : text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF1E293B),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _AmountBadge extends StatelessWidget {
  const _AmountBadge({required this.value, required this.color});

  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final numericValue = double.tryParse(value);
    final displayValue = numericValue == null
        ? value
        : priceFormat.format(numericValue);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: textForDataRowInTable(
        text: displayValue,
        isBold: true,
        color: color,
      ),
    );
  }
}

class _TableActionButton extends StatelessWidget {
  const _TableActionButton({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          foregroundColor: color,
          backgroundColor: color.withValues(alpha: 0.08),
          hoverColor: color.withValues(alpha: 0.15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: Icon(icon, size: 16),
      ),
    );
  }
}

Widget deleteSection(
  CarTradingDashboardController controller,
  BuildContext context,
  String capitalId,
  String collection,
) {
  return _TableActionButton(
    tooltip: 'Delete line',
    icon: Icons.delete_outline_rounded,
    color: const Color(0xFFDC2626),
    onPressed: () {
      alertDialog(
        context: context,
        content: 'This will be deleted permanently',
        onPressed: () {
          controller.deleteCapitalOrOutstandingOrGeneralExpenses(
            collection,
            capitalId,
          );
        },
      );
    },
  );
}

Widget editSection(
  BuildContext context,
  CarTradingDashboardController controller,
  dynamic itemData,
  constraints,
  String collection,
  String capitalId,
  bool isGeneralExpenses,
) {
  return _TableActionButton(
    tooltip: 'Edit line',
    icon: Icons.edit_outlined,
    color: const Color(0xFF2563EB),
    onPressed: () async {
      if (isGeneralExpenses == true) {
        controller.item.text = itemData.item;
        controller.itemId.value = itemData.itemId;
        controller.tradingCar.text = _carTextWithTrim(itemData);
        controller.tradingCarId.value = itemData.tradeId;
      } else {
        controller.name.text = itemData.name;
        controller.nameId.value = itemData.nameId;
        controller.tradingCar.clear();
        controller.tradingCarId.value = '';
      }
      controller.pay.text = itemData.pay.toString();
      controller.receive.text = itemData.receive.toString();
      controller.comments.value.text = itemData.comment;
      controller.accountName.text = itemData.accountName;
      controller.accountNameId.value = itemData.accountNameId;
      controller.itemDate.value.text = textToDate(itemData.date);
      itemDialog(
        isGeneralExpenses: isGeneralExpenses,
        isTrade: false,
        controller: controller,
        canEdit: true,
        onPressed: () {
          controller.updateCapitalOrOutstandingOrGeneralExpenses(
            collection,
            capitalId,
          );
        },
      );
    },
  );
}

class _CapitalTotalsFooter extends StatelessWidget {
  const _CapitalTotalsFooter();

  @override
  Widget build(BuildContext context) {
    return GetX<CarTradingDashboardController>(
      builder: (controller) {
        return Padding(
          padding: EdgeInsets.zero,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              runSpacing: 8,
              children: [
                _SummaryMetricBox(
                  label: 'TOTAL PAID',
                  value: controller.totalPays.value,
                  icon: Icons.arrow_upward_rounded,
                  color: const Color(0xFFDC2626),
                ),
                _SummaryMetricBox(
                  label: 'TOTAL RECEIVED',
                  value: controller.totalReceives.value,
                  icon: Icons.arrow_downward_rounded,
                  color: const Color(0xFF16A34A),
                ),
                _SummaryMetricBox(
                  label: 'NET',
                  value: controller.totalNETs.value,
                  icon: Icons.account_balance_wallet_outlined,
                  color: const Color(0xFF475569),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SummaryMetricBox extends StatelessWidget {
  const _SummaryMetricBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final double value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 66,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE7EDF3)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    priceFormat.format(value),
                    style: TextStyle(
                      color: color,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.2,
                      height: 1,
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

ElevatedButton newItemButton(
  BuildContext context,
  CarTradingDashboardController controller,
  String collection,
  bool isGeneralExpenses,
) {
  return ElevatedButton(
    onPressed: () {
      controller.name.clear();
      controller.nameId.value = '';
      controller.item.clear();
      controller.itemId.value = '';
      controller.pay.text = '0';
      controller.receive.text = '0';
      controller.comments.value.text = '';
      controller.accountName.clear();
      controller.accountNameId.value = '';
      controller.tradingCar.clear();
      controller.tradingCarId.value = '';
      controller.itemDate.value.text = textToDate(DateTime.now());
      itemDialog(
        isGeneralExpenses: isGeneralExpenses,
        isTrade: false,
        controller: controller,
        canEdit: true,
        onPressed: () {
          controller.addNewCapitalOrOutstandingOrGeneralExpenses(collection);
        },
      );
    },
    style: newButtonStyle,
    child: const Text('New Line'),
  );
}
