import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../Widgets/Dashboard Widgets/car trading widgets/table_section_for_summary_details.dart';
import '../../Widgets/Dashboard Widgets/car trading widgets/table_section_for_car_trading.dart';
import '../../Widgets/filter_button.dart';
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
                              bool isModelLoading =
                                  controller.allModels.isEmpty;
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
                                            items: isModelLoading
                                                ? {}
                                                : controller.allModels,
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
                                            width: 170,
                                            controller:
                                                controller.fromDate.value,
                                            labelText: 'From Date',
                                            onFieldSubmitted: (_) async {
                                              normalizeDate(
                                                controller.fromDate.value.text,
                                                controller.fromDate.value,
                                              );
                                            },
                                          ),
                                          myTextFormFieldWithBorder(
                                            width: 170,
                                            controller: controller.toDate.value,
                                            labelText: 'To Date',
                                            onFieldSubmitted: (_) async {
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
                                      Row(
                                        spacing: 10,
                                        children: [
                                          filterButton(
                                            title: 'Today',
                                            onPressed: () async {
                                              controller.isTodaySelected.value =
                                                  true;
                                              controller
                                                      .isThisMonthSelected
                                                      .value =
                                                  false;
                                              controller
                                                      .isThisYearSelected
                                                      .value =
                                                  false;
                                              controller.filterSearch();
                                              controller
                                                  .filterGeneralExpensesSearch();
                                            },
                                            isSelected: controller
                                                .isTodaySelected
                                                .value,
                                          ),
                                          filterButton(
                                            title: 'This Month',
                                            onPressed: () async {
                                              controller.isTodaySelected.value =
                                                  false;
                                              controller
                                                      .isThisMonthSelected
                                                      .value =
                                                  true;
                                              controller
                                                      .isThisYearSelected
                                                      .value =
                                                  false;
                                              controller.filterSearch();
                                              controller
                                                  .filterGeneralExpensesSearch();
                                            },
                                            isSelected: controller
                                                .isThisMonthSelected
                                                .value,
                                          ),
                                          filterButton(
                                            title: 'This Year',
                                            onPressed: () async {
                                              controller.isTodaySelected.value =
                                                  false;
                                              controller
                                                      .isThisMonthSelected
                                                      .value =
                                                  false;
                                              controller
                                                      .isThisYearSelected
                                                      .value =
                                                  true;
                                              controller.filterSearch();
                                              controller
                                                  .filterGeneralExpensesSearch();
                                            },
                                            isSelected: controller
                                                .isThisYearSelected
                                                .value,
                                          ),
                                          separator(
                                            color: Colors.grey.shade700,
                                          ),
                                          filterButton(
                                            isStatus: true,
                                            title: 'New',
                                            onPressed: () async {
                                              if (controller
                                                  .isNewStatusSelected
                                                  .isFalse) {
                                                controller
                                                        .isNewStatusSelected
                                                        .value =
                                                    true;
                                                controller
                                                        .isSoldStatusSelected
                                                        .value =
                                                    false;
                                              } else {
                                                controller
                                                        .isNewStatusSelected
                                                        .value =
                                                    false;
                                              }
                                              controller.filterSearch();
                                            },
                                            isSelected: controller
                                                .isNewStatusSelected
                                                .value,
                                          ),
                                          filterButton(
                                            isStatus: true,
                                            title: 'Sold',
                                            onPressed: () async {
                                              if (controller
                                                  .isSoldStatusSelected
                                                  .isFalse) {
                                                controller
                                                        .isSoldStatusSelected
                                                        .value =
                                                    true;
                                                controller
                                                        .isNewStatusSelected
                                                        .value =
                                                    false;
                                              } else {
                                                controller
                                                        .isSoldStatusSelected
                                                        .value =
                                                    false;
                                              }
                                              controller.filterSearch();
                                            },
                                            isSelected: controller
                                                .isSoldStatusSelected
                                                .value,
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
                              return SizedBox(
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
                                        showRefreshIcon: true,
                                        onPressedForRefreshIcon: () {
                                          controller.getCashOnHand();
                                          controller
                                              .getCapitalsOROutstandingSummary(
                                                'capitals',
                                              );
                                          controller
                                              .getCapitalsOROutstandingSummary(
                                                'outstanding',
                                              );
                                          controller
                                              .filterGeneralExpensesSearch();
                                        },
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
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 10)),
                    SliverToBoxAdapter(
                      child: Container(
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
  const SummaryBox({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.textColor,
    required this.showRefreshIcon,
    this.onPressedForRefreshIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
