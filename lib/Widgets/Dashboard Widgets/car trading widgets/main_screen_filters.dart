import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';
import '../../my_text_field.dart';
import 'car_trade_dialog.dart';

class MainScreenFilters extends StatelessWidget {
  const MainScreenFilters({super.key, required this.constraints});

  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          GetX<CarTradingDashboardController>(
            builder: (controller) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth - 28,
                  ),
                  child: Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          MenuWithValues(
                            labelText: 'Car Brand',
                            headerLqabel: 'Brands',
                            dialogWidth: 600,
                            width: 170,
                            controller: controller.carBrandFilter.value,
                            displayKeys: const ['name'],
                            displaySelectedKeys: const ['name'],
                            onOpen: () {
                              return controller.getCarBrands();
                            },
                            onDelete: () {
                              controller.allModels.clear();
                              controller.carModelFilter.value.clear();
                              controller.carBrandFilter.value.clear();
                              controller.carBrandFilterId.value = '';
                              controller.carModelFilterId.value = '';
                            },
                            onSelected: (value) {
                              controller.carModelFilter.value.clear();
                              controller.getModelsByCarBrand(value['_id']);
                              controller.carBrandFilter.value.text =
                                  value['name'];
                              controller.carBrandFilterId.value = value['_id'];
                              controller.carModelFilterId.value = '';
                            },
                          ),
                          MenuWithValues(
                            labelText: 'Car Model',
                            headerLqabel: 'Models',
                            dialogWidth: 600,
                            width: 170,
                            controller: controller.carModelFilter.value,
                            displayKeys: const ['name'],
                            displaySelectedKeys: const ['name'],
                            onOpen: () {
                              return controller.getModelsByCarBrand(
                                controller.carBrandFilterId.value,
                              );
                            },
                            onDelete: () {
                              controller.carModelFilter.value.clear();
                              controller.carModelFilterId.value = '';
                            },
                            onSelected: (value) {
                              controller.carModelFilter.value.text =
                                  value['name'];
                              controller.carModelFilterId.value = value['_id'];
                            },
                          ),
                          MenuWithValues(
                            labelText: 'Bought From',
                            headerLqabel: 'Bought from',
                            dialogWidth: 600,
                            width: 200,
                            controller: controller.carBoughtFromFilter.value,
                            displayKeys: const ['name'],
                            displaySelectedKeys: const ['name'],
                            onOpen: () {
                              return controller.getBuyersAndSellers();
                            },
                            onDelete: () {
                              controller.carBoughtFromFilter.value.clear();
                              controller.carBoughtFromFilterId.value = '';
                            },
                            onSelected: (value) {
                              controller.carBoughtFromFilter.value.text =
                                  value['name'];
                              controller.carBoughtFromFilterId.value =
                                  value['_id'];
                            },
                          ),
                          MenuWithValues(
                            labelText: 'Bought By',
                            headerLqabel: 'Bought By',
                            dialogWidth: 600,
                            width: 200,
                            controller: controller.carBoughtByFilter.value,
                            displayKeys: const ['name'],
                            displaySelectedKeys: const ['name'],
                            onOpen: () {
                              return controller.getBuyersAndSellersBy();
                            },
                            onDelete: () {
                              controller.carBoughtByFilter.value.clear();
                              controller.carBoughtByFilterId.value = '';
                            },
                            onSelected: (value) {
                              controller.carBoughtByFilter.value.text =
                                  value['name'];
                              controller.carBoughtByFilterId.value =
                                  value['_id'];
                            },
                          ),

                          MenuWithValues(
                            labelText: 'Sold By',
                            headerLqabel: 'Sold By',
                            dialogWidth: 600,
                            width: 200,
                            controller: controller.carSoldByFilter.value,
                            displayKeys: const ['name'],
                            displaySelectedKeys: const ['name'],
                            onOpen: () {
                              return controller.getBuyersAndSellersBy();
                            },
                            onDelete: () {
                              controller.carSoldByFilter.value.clear();
                              controller.carSoldByFilterId.value = '';
                            },
                            onSelected: (value) {
                              controller.carSoldByFilter.value.text =
                                  value['name'];
                              controller.carSoldByFilterId.value = value['_id'];
                            },
                          ),
                          MenuWithValues(
                            labelText: 'Capital By',
                            headerLqabel: 'Capital By',
                            dialogWidth: 600,
                            width: 200,
                            controller: controller.carInvestedByFilter.value,
                            displayKeys: const ['name'],
                            displaySelectedKeys: const ['name'],
                            onOpen: () {
                              return controller.getInvestedBy();
                            },
                            onDelete: () {
                              controller.carInvestedByFilter.value.clear();
                              controller.carInvestedByFilterId.value = '';
                            },
                            onSelected: (value) {
                              controller.carInvestedByFilter.value.text =
                                  value['name'];
                              controller.carInvestedByFilterId.value =
                                  value['_id'];
                            },
                          ),
                          MenuWithValues(
                            labelText: 'Consignment For',
                            headerLqabel: 'Consignment For',
                            dialogWidth: 600,
                            width: 200,
                            controller:
                                controller.carConsignmentForFilter.value,
                            displayKeys: const ['name'],
                            displaySelectedKeys: const ['name'],
                            onOpen: () {
                              return controller.getConsignmentsFor();
                            },
                            onDelete: () {
                              controller.carConsignmentForFilter.value.clear();
                              controller.carConsignmentForFilterId.value = '';
                            },
                            onSelected: (value) {
                              controller.carConsignmentForFilter.value.text =
                                  value['name'];
                              controller.carConsignmentForFilterId.value =
                                  value['_id'];
                            },
                          ),
                        ],
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          myTextFormFieldWithBorder(
                            width: 120,
                            controller: controller.fromDate.value,
                            labelText: 'From Date',
                            onFieldSubmitted: (_) async {
                              controller.isTodaySelected.value = false;
                              controller.isThisMonthSelected.value = false;
                              controller.isThisYearSelected.value = false;
                              normalizeDate(
                                controller.fromDate.value.text,
                                controller.fromDate.value,
                              );
                            },
                            onTapOutside: (_) {
                              controller.isTodaySelected.value = false;
                              controller.isThisMonthSelected.value = false;
                              controller.isThisYearSelected.value = false;
                              normalizeDate(
                                controller.fromDate.value.text,
                                controller.fromDate.value,
                              );
                            },
                          ),
                          myTextFormFieldWithBorder(
                            width: 120,
                            controller: controller.toDate.value,
                            labelText: 'To Date',
                            onFieldSubmitted: (_) async {
                              controller.isTodaySelected.value = false;
                              controller.isThisMonthSelected.value = false;
                              controller.isThisYearSelected.value = false;
                              normalizeDate(
                                controller.toDate.value.text,
                                controller.toDate.value,
                              );
                            },
                            onTapOutside: (_) {
                              controller.isTodaySelected.value = false;
                              controller.isThisMonthSelected.value = false;
                              controller.isThisYearSelected.value = false;
                              normalizeDate(
                                controller.toDate.value.text,
                                controller.toDate.value,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          GetX<CarTradingDashboardController>(
            builder: (controller) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth - 28,
                  ),
                  child: Row(
                    spacing: 10,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          _DashboardFilterActionButton(
                            label: 'New Car',
                            icon: Icons.directions_car_filled_outlined,
                            accentColor: const Color(0xFF2F9E62),
                            onPressed: () {
                              controller.clearValues();
                              carTradesDialog(
                                screen: 'car_trading',
                                tradeID: '',
                                controller: controller,
                                canEdit: true,
                                onPressed: controller.addingNewValue.value
                                    ? null
                                    : () async {
                                        controller.addNewTrade();
                                      },
                              );
                            },
                          ),
                        ],
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          CustomSlidingSegmentedControl<int>(
                            height: 30,
                            initialValue:
                                controller.initValueForDatePicker.value,
                            children: const {
                              1: Text('ALL'),
                              2: Text('TODAY'),
                              3: Text('THIS MONTH'),
                              4: Text('THIS YEAR'),
                            },
                            decoration: BoxDecoration(
                              color: CupertinoColors.lightBackgroundGray,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            thumbDecoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(1),
                                  blurRadius: 4.0,
                                  spreadRadius: 1.0,
                                  offset: const Offset(0.0, 2.0),
                                ),
                              ],
                            ),
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInToLinear,
                            onValueChanged: (v) {
                              controller.onChooseForDatePicker(v);
                            },
                          ),
                          separator(color: Colors.grey.shade700),
                          CustomSlidingSegmentedControl<int>(
                            height: 30,
                            initialValue:
                                controller.initValueForStatusPicker.value,
                            children: const {
                              1: Text('ALL'),
                              2: Text('NEW'),
                              3: Text('SOLD'),
                            },
                            decoration: BoxDecoration(
                              color: CupertinoColors.lightBackgroundGray,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            thumbDecoration: BoxDecoration(
                              color: CupertinoColors.white,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(1),
                                  blurRadius: 4.0,
                                  spreadRadius: 1.0,
                                  offset: const Offset(0.0, 2.0),
                                ),
                              ],
                            ),
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInToLinear,
                            onValueChanged: (v) {
                              controller.onChooseForStatusPicker(v);
                            },
                          ),
                        ],
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          _FinancialPrivacyButton(controller: controller),
                          _CarTradeViewToggleButton(controller: controller),
                          _DashboardFilterActionButton(
                            label: 'Find',
                            icon: Icons.search_rounded,
                            accentColor: const Color(0xFF547792),
                            isLoading: controller.searching.isTrue,
                            onPressed: controller.searching.isFalse
                                ? () {
                                    controller.allSearches();
                                  }
                                : null,
                          ),
                          _DashboardFilterActionButton(
                            label: 'Clear',
                            icon: Icons.cleaning_services_outlined,
                            accentColor: const Color(0xFF9A7468),
                            onPressed: () {
                              controller.clearFilters();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DashboardFilterActionButton extends StatelessWidget {
  const _DashboardFilterActionButton({
    required this.label,
    required this.icon,
    required this.accentColor,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final IconData icon;
  final Color accentColor;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(11),
          splashColor: accentColor.withValues(alpha: 0.08),
          highlightColor: accentColor.withValues(alpha: 0.04),
          child: Ink(
            decoration: BoxDecoration(
              color: Color.alphaBlend(
                accentColor.withValues(alpha: 0.035),
                Colors.white,
              ),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: Color.alphaBlend(
                  accentColor.withValues(alpha: 0.18),
                  const Color(0xFFDDE7EF),
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1B2C45).withValues(alpha: 0.045),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.055),
                  blurRadius: 10,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 4, color: accentColor),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(9, 0, 13, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.13),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: isLoading
                              ? SizedBox(
                                  width: 13,
                                  height: 13,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: accentColor,
                                  ),
                                )
                              : Icon(icon, size: 15, color: accentColor),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          label,
                          style: TextStyle(
                            color: Color.alphaBlend(
                              accentColor.withValues(alpha: 0.16),
                              const Color(0xFF23343B),
                            ),
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FinancialPrivacyButton extends StatelessWidget {
  const _FinancialPrivacyButton({required this.controller});

  final CarTradingDashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isHidden = controller.hideCarTradeFinancialValues.value;

      return Tooltip(
        message: isHidden ? 'Show financial values' : 'Hide financial values',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: controller.hideCarTradeFinancialValues.toggle,
            borderRadius: BorderRadius.circular(11),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(
                  color: isHidden
                      ? const Color(0xFF0C7C86).withValues(alpha: 0.40)
                      : const Color(0xFFDDE7EF),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1B2C45).withValues(alpha: 0.045),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        (isHidden
                                ? const Color(0xFF0C7C86)
                                : const Color(0xFF6C798A))
                            .withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      child: FadeTransition(opacity: animation, child: child),
                    ),
                    child: Icon(
                      isHidden
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      key: ValueKey(isHidden),
                      size: 16,
                      color: isHidden
                          ? const Color(0xFF0C7C86)
                          : const Color(0xFF6C798A),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _CarTradeViewToggleButton extends StatelessWidget {
  const _CarTradeViewToggleButton({required this.controller});

  final CarTradingDashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isTableView = controller.showCarTradeTableView.value;
      const accent = Color(0xFF3978C5);

      return Tooltip(
        message: isTableView
            ? 'Show vehicles as cards'
            : 'Show vehicles as table',
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: controller.toggleCarTradeViewMode,
            borderRadius: BorderRadius.circular(11),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(
                  color: isTableView
                      ? accent.withValues(alpha: 0.48)
                      : const Color(0xFFDDE7EF),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1B2C45).withValues(alpha: 0.045),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: (isTableView ? accent : const Color(0xFF6C798A))
                        .withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      child: FadeTransition(opacity: animation, child: child),
                    ),
                    child: Icon(
                      isTableView
                          ? Icons.grid_view_rounded
                          : Icons.table_rows_rounded,
                      key: ValueKey(isTableView),
                      size: 16,
                      color: isTableView ? accent : const Color(0xFF6C798A),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
