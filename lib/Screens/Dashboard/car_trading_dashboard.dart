import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../Widgets/Dashboard Widgets/car trading widgets/last_changes_dialog.dart';
import '../../Widgets/Dashboard Widgets/car trading widgets/table_section_for_summary_details.dart';
import '../../Widgets/Dashboard Widgets/car trading widgets/table_section_for_car_trading.dart';
import '../../Widgets/my_text_field.dart';
import '../../consts.dart';

class CarTradingDashboard extends StatelessWidget {
  const CarTradingDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController mainScreenController = ScrollController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Scrollbar(
        thumbVisibility: true,
        controller: mainScreenController,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: screenPadding,
              child: ScrollbarTheme(
                data: const ScrollbarThemeData(
                  thickness: WidgetStatePropertyAll(0),
                  thumbVisibility: WidgetStatePropertyAll(false),
                ),
                child: CustomScrollView(
                  controller: mainScreenController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          GetX<CarTradingDashboardController>(
                            init: CarTradingDashboardController(),
                            builder: (controller) {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: constraints.maxWidth - 28,
                                  ),
                                  child: Row(
                                    spacing: 10,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,

                                    children: [
                                      Row(
                                        spacing: 10,
                                        children: [
                                          CustomDropdown(
                                            width: 170,
                                            showedSelectedName: 'name',
                                            textcontroller: controller
                                                .carBrandFilter
                                                .value
                                                .text,
                                            hintText: 'Car Brand',
                                            onChanged: (key, value) {
                                              controller.carModelFilter.value
                                                  .clear();
                                              controller.getModelsByCarBrand(
                                                key,
                                              );
                                              controller
                                                      .carBrandFilter
                                                      .value
                                                      .text =
                                                  value['name'];
                                              controller
                                                      .carBrandFilterId
                                                      .value =
                                                  key;
                                              controller
                                                      .carModelFilterId
                                                      .value =
                                                  '';
                                            },
                                            onDelete: () {
                                              controller.allModels.clear();
                                              controller.carModelFilter.value
                                                  .clear();
                                              controller.carBrandFilter.value
                                                  .clear();
                                              controller
                                                      .carBrandFilterId
                                                      .value =
                                                  '';
                                              controller
                                                      .carModelFilterId
                                                      .value =
                                                  '';
                                            },
                                            onOpen: () {
                                              return controller.getCarBrands();
                                            },
                                          ),
                                          CustomDropdown(
                                            width: 170,
                                            showedSelectedName: 'name',
                                            textcontroller: controller
                                                .carModelFilter
                                                .value
                                                .text,
                                            hintText: 'Car Model',

                                            onChanged: (key, value) {
                                              controller
                                                      .carModelFilter
                                                      .value
                                                      .text =
                                                  value['name'];
                                              controller
                                                      .carModelFilterId
                                                      .value =
                                                  key;
                                            },
                                            onDelete: () {
                                              controller.carModelFilter.value
                                                  .clear();
                                              controller
                                                      .carModelFilterId
                                                      .value =
                                                  '';
                                            },
                                            onOpen: () {
                                              return controller
                                                  .getModelsByCarBrand(
                                                    controller
                                                        .carBrandFilterId
                                                        .value,
                                                  );
                                            },
                                          ),
                                          // CustomDropdown(
                                          //   width: 180,
                                          //   hintText: 'Specification',
                                          //   showedSelectedName: 'name',
                                          //   textcontroller: controller
                                          //       .carSpecificationFilter
                                          //       .value
                                          //       .text,
                                          //   onChanged: (key, value) {
                                          //     controller
                                          //             .carSpecificationFilter
                                          //             .value
                                          //             .text =
                                          //         value["name"];
                                          //     controller
                                          //             .carSpecificationFilterId
                                          //             .value =
                                          //         key;
                                          //   },
                                          //   onDelete: () {
                                          //     controller.carSpecificationFilter.value
                                          //         .clear();
                                          //     controller
                                          //             .carSpecificationFilterId
                                          //             .value =
                                          //         '';
                                          //   },
                                          //   onOpen: () {
                                          //     return controller
                                          //         .getCarSpecefications();
                                          //   },
                                          // ),
                                          // CustomDropdown(
                                          //   width: 180,
                                          //   hintText: 'Engine Size',
                                          //   showedSelectedName: 'name',
                                          //   textcontroller: controller
                                          //       .carEngineSizeFilter
                                          //       .value
                                          //       .text,
                                          //   onChanged: (key, value) {
                                          //     controller
                                          //             .carEngineSizeFilter
                                          //             .value
                                          //             .text =
                                          //         value['name'];
                                          //     controller.carEngineSizeFilterId.value =
                                          //         key;
                                          //   },
                                          //   onDelete: () {
                                          //     controller.carEngineSizeFilter.value
                                          //         .clear();
                                          //     controller.carEngineSizeFilterId.value =
                                          //         '';
                                          //   },
                                          //   onOpen: () {
                                          //     return controller.getEngineTypes();
                                          //   },
                                          // ),
                                          CustomDropdown(
                                            width: 200,
                                            hintText: 'Bought From',
                                            textcontroller: controller
                                                .carBoughtFromFilter
                                                .value
                                                .text,
                                            showedSelectedName: 'name',
                                            onChanged: (key, value) {
                                              controller
                                                      .carBoughtFromFilter
                                                      .value
                                                      .text =
                                                  value['name'];
                                              controller
                                                      .carBoughtFromFilterId
                                                      .value =
                                                  key;
                                            },
                                            onDelete: () {
                                              controller
                                                  .carBoughtFromFilter
                                                  .value
                                                  .clear();
                                              controller
                                                      .carBoughtFromFilterId
                                                      .value =
                                                  '';
                                            },
                                            onOpen: () {
                                              return controller
                                                  .getBuyersAndSellers();
                                            },
                                          ),
                                          CustomDropdown(
                                            width: 200,
                                            hintText: 'Sold To',

                                            textcontroller: controller
                                                .carSoldToFilter
                                                .value
                                                .text,
                                            showedSelectedName: 'name',
                                            onChanged: (key, value) {
                                              controller
                                                      .carSoldToFilter
                                                      .value
                                                      .text =
                                                  value['name'];
                                              controller
                                                      .carSoldToFilterId
                                                      .value =
                                                  key;
                                            },
                                            onDelete: () {
                                              controller.carSoldToFilter.value
                                                  .clear();
                                              controller
                                                      .carSoldToFilterId
                                                      .value =
                                                  '';
                                            },
                                            onOpen: () {
                                              return controller
                                                  .getBuyersAndSellers();
                                            },
                                          ),
                                          CustomDropdown(
                                            width: 200,
                                            hintText: 'Bought By',

                                            textcontroller: controller
                                                .carBoughtByFilter
                                                .value
                                                .text,
                                            showedSelectedName: 'name',
                                            onChanged: (key, value) {
                                              controller
                                                      .carBoughtByFilter
                                                      .value
                                                      .text =
                                                  value['name'];
                                              controller
                                                      .carBoughtByFilterId
                                                      .value =
                                                  key;
                                            },
                                            onDelete: () {
                                              controller.carBoughtByFilter.value
                                                  .clear();
                                              controller
                                                      .carBoughtByFilterId
                                                      .value =
                                                  '';
                                            },
                                            onOpen: () {
                                              return controller
                                                  .getBuyersAndSellersBy();
                                            },
                                          ),
                                          CustomDropdown(
                                            width: 200,
                                            hintText: 'Sold By',

                                            textcontroller: controller
                                                .carSoldByFilter
                                                .value
                                                .text,
                                            showedSelectedName: 'name',
                                            onChanged: (key, value) {
                                              controller
                                                      .carSoldByFilter
                                                      .value
                                                      .text =
                                                  value['name'];
                                              controller
                                                      .carSoldByFilterId
                                                      .value =
                                                  key;
                                            },
                                            onDelete: () {
                                              controller.carSoldByFilter.value
                                                  .clear();
                                              controller
                                                      .carSoldByFilterId
                                                      .value =
                                                  '';
                                            },
                                            onOpen: () {
                                              return controller
                                                  .getBuyersAndSellersBy();
                                            },
                                          ),
                                        ],
                                      ),
                                      Row(
                                        spacing: 10,
                                        children: [
                                          myTextFormFieldWithBorder(
                                            width: 120,
                                            controller:
                                                controller.fromDate.value,
                                            labelText: 'From Date',
                                            onFieldSubmitted: (_) async {
                                              controller.isTodaySelected.value =
                                                  false;
                                              controller
                                                      .isThisMonthSelected
                                                      .value =
                                                  false;
                                              controller
                                                      .isThisYearSelected
                                                      .value =
                                                  false;
                                              normalizeDate(
                                                controller.fromDate.value.text,
                                                controller.fromDate.value,
                                              );
                                            },
                                            onTapOutside: (_) {
                                              controller.isTodaySelected.value =
                                                  false;
                                              controller
                                                      .isThisMonthSelected
                                                      .value =
                                                  false;
                                              controller
                                                      .isThisYearSelected
                                                      .value =
                                                  false;
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
                                              controller.isTodaySelected.value =
                                                  false;
                                              controller
                                                      .isThisMonthSelected
                                                      .value =
                                                  false;
                                              controller
                                                      .isThisYearSelected
                                                      .value =
                                                  false;
                                              normalizeDate(
                                                controller.toDate.value.text,
                                                controller.toDate.value,
                                              );
                                            },
                                            onTapOutside: (_) {
                                              controller.isTodaySelected.value =
                                                  false;
                                              controller
                                                      .isThisMonthSelected
                                                      .value =
                                                  false;
                                              controller
                                                      .isThisYearSelected
                                                      .value =
                                                  false;
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        style: lastChangesButtonStyle,
                                        onPressed: () {
                                          controller.clearCangesVariables();
                                          lastChangesDialog();
                                        },
                                        child: Text(
                                          'Last Changes',
                                          style: fontStyleForElevatedButtons,
                                        ),
                                      ),
                                      Row(
                                        spacing: 10,
                                        children: [
                                          CustomSlidingSegmentedControl<int>(
                                            height: 30,
                                            initialValue: 1,
                                            children: const {
                                              1: Text('ALL'),
                                              2: Text('TODAY'),
                                              3: Text('THIS MONTH'),
                                              4: Text('THIS YEAR'),
                                            },
                                            decoration: BoxDecoration(
                                              color: CupertinoColors
                                                  .lightBackgroundGray,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            thumbDecoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withAlpha(
                                                    1,
                                                  ),
                                                  blurRadius: 4.0,
                                                  spreadRadius: 1.0,
                                                  offset: const Offset(
                                                    0.0,
                                                    2.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            curve: Curves.easeInToLinear,
                                            onValueChanged: (v) {
                                              controller.onChooseForDatePicker(
                                                v,
                                              );
                                            },
                                          ),
                                          separator(
                                            color: Colors.grey.shade700,
                                          ),
                                          CustomSlidingSegmentedControl<int>(
                                            height: 30,

                                            initialValue: 1,
                                            children: const {
                                              1: Text('ALL'),
                                              2: Text('NEW'),
                                              3: Text('SOLD'),
                                            },
                                            decoration: BoxDecoration(
                                              color: CupertinoColors
                                                  .lightBackgroundGray,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            thumbDecoration: BoxDecoration(
                                              color: CupertinoColors.white,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withAlpha(
                                                    1,
                                                  ),
                                                  blurRadius: 4.0,
                                                  spreadRadius: 1.0,
                                                  offset: const Offset(
                                                    0.0,
                                                    2.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            curve: Curves.easeInToLinear,
                                            onValueChanged: (v) {
                                              controller
                                                  .onChooseForStatusPicker(v);
                                            },
                                          ),
                                        ],
                                      ),
                                      Row(
                                        spacing: 10,
                                        children: [
                                          ElevatedButton(
                                            style: findButtonStyle,
                                            onPressed:
                                                controller.searching.isFalse
                                                ? () {
                                                    controller.filterSearch();
                                                    controller
                                                        .filterGeneralExpensesSearch();
                                                    controller
                                                        .getCashOnHandOrBankBalance(
                                                          'CASH',
                                                        );
                                                    controller
                                                        .getCashOnHandOrBankBalance(
                                                          'FAB BANK',
                                                        );
                                                    controller
                                                        .getCapitalsOROutstandingSummary(
                                                          'capitals',
                                                        );
                                                    controller
                                                        .getCapitalsOROutstandingSummary(
                                                          'outstanding',
                                                        );
                                                  }
                                                : null,
                                            child: controller.searching.isFalse
                                                ? Text(
                                                    'Find',
                                                    style:
                                                        fontStyleForElevatedButtons,
                                                  )
                                                : loadingProcess,
                                          ),
                                          ElevatedButton(
                                            style: clearVariablesButtonStyle,
                                            onPressed: () {
                                              controller.clearFilters();
                                            },
                                            child: Text(
                                              'Clear',
                                              style:
                                                  fontStyleForElevatedButtons,
                                            ),
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
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 10)),

                    SliverToBoxAdapter(
                      child: Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: tableOfSummaryDetails(context: context),
                          ),
                          GetX<CarTradingDashboardController>(
                            builder: (controller) {
                              return Row(
                                spacing: 10,
                                children: [
                                  SizedBox(
                                    height: 200,
                                    width: 300,
                                    child: Column(
                                      spacing: 10,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: SummaryBox(
                                            title: 'BANK BALANCE',
                                            value:
                                                '${controller.totalNETsForBanckBalance.value}',
                                            icon: Icons.account_balance,
                                            iconColor: const Color(
                                              0xFFACBAC4,
                                            ).withValues(alpha: 0.8),
                                            textColor: Colors.grey[700],
                                            showRefreshIcon: false,
                                          ),
                                        ),
                                        Expanded(
                                          child: SummaryBox(
                                            title: 'TOTAL MONEY',
                                            value:
                                                '${controller.totalNETsForBanckBalance.value + controller.totalNETsForAll.value}',
                                            icon: Icons.trolley,
                                            iconColor: const Color(
                                              0xFFD8C9A7,
                                            ).withValues(alpha: 0.8),
                                            textColor: const Color(0xFF434E78),
                                            showRefreshIcon: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 200,
                                    width: 300,
                                    child: Column(
                                      spacing: 10,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: SummaryBox(
                                            title: 'CASH ON HAND',
                                            value:
                                                '${controller.totalNETsForAll.value}',
                                            icon: Icons.wallet,
                                            iconColor: const Color(
                                              0xFFFFE8D9,
                                            ).withValues(alpha: 0.8),
                                            textColor: Colors.grey[700],
                                            showRefreshIcon: false,
                                          ),
                                        ),
                                        Expanded(
                                          child: SummaryBox(
                                            title: 'NET PROFIT',
                                            value:
                                                '${controller.totalNetProfit.value}',
                                            icon: Icons.pie_chart,
                                            iconColor: const Color(
                                              0xffB4EBE6,
                                            ).withValues(alpha: 0.8),
                                            textColor: Colors.green.shade700,
                                            showRefreshIcon: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 10)),
                    SliverToBoxAdapter(
                      child: Container(
                        height: constraints.maxHeight / 1.6,
                        constraints: const BoxConstraints(minHeight: 300),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: tableOfCarTrades(
                          constraints: constraints,
                          context: context,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SummaryBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? textColor;
  final Color iconColor;
  final bool showRefreshIcon;
  final void Function()? onPressedForRefreshIcon;
  final bool? isFormated;
  final double? width;
  const SummaryBox({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.textColor,
    required this.showRefreshIcon,
    this.onPressedForRefreshIcon,
    this.isFormated,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.shade300),
        color: const Color(0xffF4F5F8).withValues(alpha: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      showRefreshIcon == true
                          ? IconButton(
                              onPressed: onPressedForRefreshIcon,
                              icon: const Icon(
                                Icons.refresh,
                                size: 20,
                                color: Colors.grey,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  FittedBox(
                    child: textForDataRowInTable(
                      fontSize: 25,
                      isBold: true,
                      color: textColor,
                      text: value,
                      maxWidth: null,
                      formatDouble: isFormated ?? true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(icon, size: 70, color: iconColor),
          ),
        ],
      ),
    );
  }
}
