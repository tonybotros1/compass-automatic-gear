import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../Models/car trading/car_trading_items_model.dart';
import '../../../Models/car trading/car_trading_purchase_agreement_model.dart';
import '../../../consts.dart';
import '../../main screen widgets/auto_size_box.dart';
import 'item_dialog.dart';
import 'sales_agreement_item_dialog.dart';

Widget addNewCarTradeItemsOrEdit({
  required BuildContext context,
  required CarTradingDashboardController controller,
  required bool canEdit,
  required BoxConstraints constraints,
  required String screen,
}) {
  final isItemsScreen = screen == 'items';

  return Form(
    key: controller.carTradeFormKey,
    child: ColoredBox(
      color: Colors.white,
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            hasScrollBody: true,
            child: ColoredBox(
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _TradeTotals(
                    constraints: constraints,
                    isItems: isItemsScreen,
                  ),
                  Expanded(
                    child: GetX<CarTradingDashboardController>(
                      builder: (controller) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SizedBox(
                            width: constraints.maxWidth,
                            child: isItemsScreen
                                ? tableOfScreens(
                                    constraints: constraints,
                                    context: context,
                                    controller: controller,
                                  )
                                : tableOfScreensForSalesAgreement(
                                    constraints: constraints,
                                    context: context,
                                    controller: controller,
                                  ),
                          ),
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
  );
}

class _TradeTotals extends StatelessWidget {
  const _TradeTotals({required this.constraints, required this.isItems});

  final BoxConstraints constraints;
  final bool isItems;

  @override
  Widget build(BuildContext context) {
    return GetX<CarTradingDashboardController>(
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    final slide = Tween<Offset>(
                      begin: const Offset(0, 0.06),
                      end: Offset.zero,
                    ).animate(animation);
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(position: slide, child: child),
                    );
                  },
                  child: Align(
                    key: ValueKey(isItems),
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      runSpacing: 8,
                      children: isItems
                          ? [
                              _SummaryMetricBox(
                                label: 'TOTAL PAID',
                                value: '${controller.totalPays.value}',
                                icon: Icons.arrow_upward_rounded,
                                color: const Color(0xFFDC2626),
                              ),
                              _SummaryMetricBox(
                                label: 'TOTAL RECEIVED',
                                value: '${controller.totalReceives.value}',
                                icon: Icons.arrow_downward_rounded,
                                color: const Color(0xFF16A34A),
                              ),
                              _SummaryMetricBox(
                                label: 'NET',
                                value: '${controller.totalNETs.value}',
                                icon: Icons.account_balance_wallet_outlined,
                                color: const Color(0xFF475569),
                              ),
                            ]
                          : [
                              _SummaryMetricBox(
                                label: 'TOTAL AMOUNT',
                                value:
                                    '${controller.totalPurchaseAgreementAmount.value}',
                                icon: Icons.payments_outlined,
                                color: const Color(0xFF0F766E),
                              ),
                              _SummaryMetricBox(
                                label: 'TOTAL DOWN PAYMENT',
                                value:
                                    '${controller.totalPurchaseAgreementDownPayment.value}',
                                icon: Icons.pie_chart_outline_rounded,
                                color: const Color(0xFFEA580C),
                              ),
                            ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: KeyedSubtree(
                  key: ValueKey('new-button-$isItems'),
                  child: isItems
                      ? newItemButton(context, controller)
                      : newItemButtonForSalesAgreement(
                          context,
                          controller,
                          constraints,
                        ),
                ),
              ),
            ],
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
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final numericValue = double.tryParse(value);
    final displayValue = numericValue == null
        ? value
        : priceFormat.format(numericValue);

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
                    displayValue,
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

Widget _modernTableSurface({required Widget child}) {
  return Padding(padding: const EdgeInsets.fromLTRB(8, 2, 8, 8), child: child);
}

WidgetStateProperty<Color?> _tableRowColor(int index) {
  return WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.hovered)) {
      return const Color(0xFFF0F7FF);
    }
    return index.isEven ? Colors.white : const Color(0xFFF8FAFC);
  });
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: textForDataRowInTable(text: value, isBold: true, color: color),
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

Widget tableOfScreens({
  required BoxConstraints constraints,
  required BuildContext context,
  required CarTradingDashboardController controller,
}) {
  final source =
      controller.filteredAddedItems.isEmpty &&
          controller.searchForItems.value.text.isEmpty
      ? controller.addedItems
      : controller.filteredAddedItems;
  final items = source.where((item) => item.deleted == false).toList();

  return _modernTableSurface(
    child: DataTable(
      horizontalMargin: 16,
      headingRowHeight: 46,
      dataRowMinHeight: 54,
      dataRowMaxHeight: 58,
      columnSpacing: 18,
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
      columns: [
        DataColumn(
          label: AutoSizedText(text: 'ACTIONS', constraints: constraints),
        ),
        DataColumn(
          label: AutoSizedText(text: 'DATE', constraints: constraints),
        ),
        DataColumn(
          label: AutoSizedText(constraints: constraints, text: 'ITEM'),
        ),
        DataColumn(
          label: AutoSizedText(constraints: constraints, text: 'ACCOUNT'),
        ),
        DataColumn(
          label: AutoSizedText(constraints: constraints, text: 'COMMENTS'),
        ),
        DataColumn(
          numeric: true,
          label: AutoSizedText(constraints: constraints, text: 'PAID'),
        ),
        DataColumn(
          numeric: true,
          label: AutoSizedText(constraints: constraints, text: 'RECEIVED'),
        ),
      ],
      rows: [
        for (var index = 0; index < items.length; index++)
          dataRowForTheTable(
            items[index],
            context,
            constraints,
            controller,
            index,
          ),
      ],
    ),
  );
}

DataRow dataRowForTheTable(
  CarTradingItemsModel itemData,
  context,
  constraints,
  CarTradingDashboardController controller,
  int index,
) {
  return DataRow(
    color: _tableRowColor(index),
    cells: [
      DataCell(
        Row(
          spacing: 5,
          children: [
            deleteSection(controller, context, itemData),
            editSection(context, controller, itemData, constraints),
          ],
        ),
      ),
      DataCell(_DateBadge(value: textToDate(itemData.date))),
      DataCell(
        _PrimaryTableCell(
          text: itemData.item ?? '',
          icon: Icons.inventory_2_outlined,
          color: const Color(0xFF2563EB),
        ),
      ),
      DataCell(
        _PrimaryTableCell(
          text: itemData.accountName ?? '',
          icon: Icons.account_balance_wallet_outlined,
          color: const Color(0xFF7C3AED),
        ),
      ),
      DataCell(
        Text(
          itemData.comment ?? '',
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

Widget deleteSection(
  CarTradingDashboardController controller,
  BuildContext context,
  CarTradingItemsModel itemData,
) {
  return _TableActionButton(
    tooltip: 'Delete item',
    icon: Icons.delete_outline_rounded,
    color: const Color(0xFFDC2626),
    onPressed: () {
      alertDialog(
        context: context,
        content: 'This will be deleted permanently',
        onPressed: () async {
          final deleted = await controller.deleteItem(itemData.id ?? '');
          if (deleted) controller.calculateTotals();
        },
      );
    },
  );
}

Widget deleteSectionForPurchaseAgreement(
  CarTradingDashboardController controller,
  BuildContext context,
  CarTradingPurchaseAgreementModel itemData,
) {
  return _TableActionButton(
    tooltip: 'Delete agreement',
    icon: Icons.delete_outline_rounded,
    color: const Color(0xFFDC2626),
    onPressed: () {
      alertDialog(
        context: context,
        content: 'Are you sure you want to delete purchase agreement item?',
        onPressed: () async {
          final deleted = await controller.deletePurchaseAgreementItem(
            itemData.id ?? '',
          );
          if (deleted) controller.calculatePurchaseAgreementTotals();
        },
      );
    },
  );
}

Widget printeSectionForPurchaseAgreement(
  CarTradingDashboardController controller,
  BuildContext context,
  CarTradingPurchaseAgreementModel itemData,
) {
  return _TableActionButton(
    tooltip: 'Print Sales Agreement',
    icon: Icons.print_outlined,
    color: const Color(0xFF0F766E),
    onPressed: () {
      controller.printPurchaseAgreementOrQuotation(itemData, 'sales agreement');
    },
  );
}

Widget printeSectionForQuotation(
  CarTradingDashboardController controller,
  BuildContext context,
  CarTradingPurchaseAgreementModel itemData,
) {
  return _TableActionButton(
    tooltip: 'Print Quotation',
    icon: Icons.request_quote_outlined,
    color: const Color(0xFF7C3AED),
    onPressed: () {
      controller.printPurchaseAgreementOrQuotation(itemData, 'quotation');
    },
  );
}

Widget editSection(
  BuildContext context,
  CarTradingDashboardController controller,
  CarTradingItemsModel itemData,
  BoxConstraints constraints,
) {
  return _TableActionButton(
    tooltip: 'Edit item',
    icon: Icons.edit_outlined,
    color: const Color(0xFF2563EB),
    onPressed: () async {
      controller.item.text = itemData.item.toString();
      controller.itemId.value = itemData.itemId.toString();
      controller.pay.text = itemData.pay.toString();
      controller.receive.text = itemData.receive.toString();
      controller.accountName.text = itemData.accountName ?? '';
      controller.accountNameId.value = itemData.accountNameId ?? '';
      controller.comments.value.text = itemData.comment.toString();
      controller.itemDate.value.text = textToDate(itemData.date);
      itemDialog(
        isGeneralExpenses: false,
        isTrade: true,
        controller: controller,
        canEdit: true,
        onPressed: () async {
          final saved = await controller.updateItem(itemData.id ?? '');
          if (saved) controller.calculateTotals();
        },
      );
    },
  );
}

Widget editSectionForPurchaseAgreement(
  BuildContext context,
  CarTradingDashboardController controller,
  CarTradingPurchaseAgreementModel itemData,
  BoxConstraints constraints,
) {
  return _TableActionButton(
    tooltip: 'Edit agreement',
    icon: Icons.edit_outlined,
    color: const Color(0xFF2563EB),
    onPressed: () async {
      controller.agreementNumber.text = itemData.agreementNumber ?? '';
      controller.agreementdate.text = textToDate(itemData.agreementDate);
      controller.buyerName.text = itemData.buyerName ?? '';
      controller.buyerID.text = itemData.buyerID ?? '';
      controller.buyerEmail.text = itemData.buyerEmail ?? '';
      controller.buyerPhone.text = itemData.buyerPhone ?? '';
      controller.sellerName.text = itemData.sellerName ?? '';
      controller.sellerID.text = itemData.sellerID ?? '';
      controller.sellerEmail.text = itemData.sellerEmail ?? '';
      controller.sellerPhone.text = itemData.sellerPhone ?? '';
      controller.agreementTotal.text = itemData.amount?.toString() ?? '0';
      controller.agreementdownpayment.text =
          itemData.aownpayment?.toString() ?? '0';
      controller.agreementNote.text = itemData.note ?? '';
      salesAgreementItemDialog(
        controller: controller,
        constraints: constraints,
        canEdit: true,
        onPressed: () async {
          final saved = await controller.updatePurchaseAgreementItem(
            itemData.id ?? '',
          );
          if (saved) controller.calculatePurchaseAgreementTotals();
        },
      );
    },
  );
}

ElevatedButton newItemButton(
  BuildContext context,
  CarTradingDashboardController controller,
) {
  return ElevatedButton(
    onPressed: () {
      if (controller.currentTradId.value.isEmpty) {
        alertMessage(context: context, content: 'Please save trade first');
        return;
      }
      controller.item.clear();
      controller.itemId.value = '';
      controller.pay.text = '';
      controller.receive.text = '';
      controller.accountName.clear();
      controller.accountNameId.value = '';
      controller.comments.value.text = '';
      controller.itemDate.value.text = textToDate(DateTime.now());
      itemDialog(
        isGeneralExpenses: false,
        isTrade: true,
        controller: controller,
        canEdit: true,
        onPressed: () async {
          final saved = await controller.addNewItem();
          if (saved) controller.calculateTotals();
        },
      );
    },
    style: newButtonStyle,
    child: const Text('New Line'),
  );
}

Widget tableOfScreensForSalesAgreement({
  required BoxConstraints constraints,
  required BuildContext context,
  required CarTradingDashboardController controller,
}) {
  final source =
      controller.filteredPurchaseAgreementAddedItems.isEmpty &&
          controller.searchForItems.value.text.isEmpty
      ? controller.purchaseAgreementAddedItems
      : controller.filteredPurchaseAgreementAddedItems;
  final items = source.where((item) => item.deleted == false).toList();

  return _modernTableSurface(
    child: DataTable(
      horizontalMargin: horizontalMarginForTable,
      headingRowHeight: 46,
      dataRowMaxHeight: 58,
      dataRowMinHeight: 54,
      columnSpacing: 18,
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
      columns: [
        DataColumn(
          label: AutoSizedText(text: 'ACTIONS', constraints: constraints),
        ),
        DataColumn(
          label: AutoSizedText(text: 'AGREEMENT', constraints: constraints),
        ),
        DataColumn(
          label: AutoSizedText(constraints: constraints, text: 'DATE'),
        ),
        DataColumn(
          label: AutoSizedText(constraints: constraints, text: 'SELLER'),
        ),
        DataColumn(
          label: AutoSizedText(constraints: constraints, text: 'BUYER'),
        ),
        DataColumn(
          numeric: true,
          label: AutoSizedText(constraints: constraints, text: 'TOTAL'),
        ),
        DataColumn(
          numeric: true,
          label: AutoSizedText(constraints: constraints, text: 'DOWN PAYMENT'),
        ),
      ],
      rows: [
        for (var index = 0; index < items.length; index++)
          dataRowForTheTableForPurchaseAgreemnt(
            items[index],
            context,
            constraints,
            controller,
            index,
          ),
      ],
    ),
  );
}

DataRow dataRowForTheTableForPurchaseAgreemnt(
  CarTradingPurchaseAgreementModel itemData,
  BuildContext context,
  BoxConstraints constraints,
  CarTradingDashboardController controller,
  int index,
) {
  return DataRow(
    color: _tableRowColor(index),
    cells: [
      DataCell(
        Row(
          spacing: 5,
          children: [
            deleteSectionForPurchaseAgreement(controller, context, itemData),
            editSectionForPurchaseAgreement(
              context,
              controller,
              itemData,
              constraints,
            ),
            printeSectionForPurchaseAgreement(controller, context, itemData),
            printeSectionForQuotation(controller, context, itemData),
          ],
        ),
      ),
      DataCell(
        _PrimaryTableCell(
          text: itemData.agreementNumber ?? '',
          icon: Icons.description_outlined,
          color: const Color(0xFF2563EB),
        ),
      ),
      DataCell(_DateBadge(value: textToDate(itemData.agreementDate))),
      DataCell(
        _PrimaryTableCell(
          text: itemData.sellerName ?? '',
          icon: Icons.person_outline_rounded,
          color: const Color(0xFF475569),
        ),
      ),
      DataCell(
        _PrimaryTableCell(
          text: itemData.buyerName ?? '',
          icon: Icons.person_outline_rounded,
          color: const Color(0xFF7C3AED),
        ),
      ),
      DataCell(
        _AmountBadge(
          value: itemData.amount?.toString() ?? '0',
          color: const Color(0xFF16A34A),
        ),
      ),
      DataCell(
        _AmountBadge(
          value: itemData.aownpayment?.toString() ?? '0',
          color: const Color(0xFFDC2626),
        ),
      ),
    ],
  );
}

ElevatedButton newItemButtonForSalesAgreement(
  BuildContext context,
  CarTradingDashboardController controller,
  BoxConstraints constraints,
) {
  return ElevatedButton(
    onPressed: () {
      if (controller.currentTradId.value.isEmpty) {
        alertMessage(context: Get.context!, content: 'Save trade first');
        return;
      }
      controller.agreementNumber.clear();
      controller.agreementdate.text = textToDate(DateTime.now());
      controller.buyerName.text = '';
      controller.buyerID.text = '';
      controller.buyerEmail.text = '';
      controller.buyerPhone.text = '';
      controller.sellerName.text = 'ISSA HASSAN YAKOUB';
      controller.sellerID.text = '784-1988-2628387-5';
      controller.sellerEmail.text = 'sales@compass-at.com';
      controller.sellerPhone.text = '054 567 6644';
      controller.agreementTotal.clear();
      controller.agreementdownpayment.clear();
      controller.agreementNote.clear();
      salesAgreementItemDialog(
        constraints: constraints,
        controller: controller,
        canEdit: true,
        onPressed: () async {
          final saved = await controller.addNewPurchaseAgreementItem();
          if (saved) controller.calculatePurchaseAgreementTotals();
        },
      );
    },
    style: newButtonStyle,
    child: const Text('New Sales Agreement'),
  );
}
