import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../Widgets/Dashboard Widgets/car trading widgets/capital_dialog.dart';
import '../../Widgets/Dashboard Widgets/car trading widgets/car_trade_dialog.dart';
import '../../Widgets/Dashboard Widgets/trading dashboard widgets/custom_box.dart';
import '../../Widgets/Dashboard Widgets/car trading widgets/table_section_for_car_trading.dart';
import '../../Widgets/filter_button.dart';
import '../../Widgets/my_text_field.dart';
import '../../consts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CarTradingDashboard extends StatelessWidget {
  const CarTradingDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: screenPadding,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      GetX<CarTradingDashboardController>(
                        init: CarTradingDashboardController(),
                        builder: (controller) {
                          bool isModelLoading = controller.allModels.isEmpty;
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              spacing: 10,
                              children: [
                                CustomDropdown(
                                  width: 170,
                                  showedSelectedName: 'name',
                                  textcontroller:
                                      controller.carBrandFilter.value.text,
                                  hintText: 'Car Brand',
                                  onChanged: (key, value) {
                                    controller.carModelFilter.value.clear();
                                    controller.getModelsByCarBrand(key);
                                    controller.carBrandFilter.value.text =
                                        value['name'];
                                    controller.carBrandFilterId.value = key;
                                    controller.carModelFilterId.value = '';
                                  },
                                  onDelete: () {
                                    controller.allModels.clear();
                                    controller.carModelFilter.value.clear();
                                    controller.carBrandFilter.value.clear();
                                    controller.carBrandFilterId.value = '';
                                    controller.carModelFilterId.value = '';
                                  },
                                  onOpen: () {
                                    return controller.getCarBrands();
                                  },
                                ),
                                CustomDropdown(
                                  width: 170,
                                  showedSelectedName: 'name',
                                  textcontroller:
                                      controller.carModelFilter.value.text,
                                  hintText: 'Car Model',
                                  items: isModelLoading
                                      ? {}
                                      : controller.allModels,
                                  onChanged: (key, value) {
                                    controller.carModelFilter.value.text =
                                        value['name'];
                                    controller.carModelFilterId.value = key;
                                  },
                                  onDelete: () {
                                    controller.carModelFilter.value.clear();
                                    controller.carModelFilterId.value = '';
                                  },
                                ),
                                CustomDropdown(
                                  width: 180,
                                  hintText: 'Specification',
                                  showedSelectedName: 'name',
                                  textcontroller: controller
                                      .carSpecificationFilter
                                      .value
                                      .text,
                                  onChanged: (key, value) {
                                    controller
                                            .carSpecificationFilter
                                            .value
                                            .text =
                                        value["name"];
                                    controller.carSpecificationFilterId.value =
                                        key;
                                  },
                                  onDelete: () {
                                    controller.carSpecificationFilter.value
                                        .clear();
                                    controller.carSpecificationFilterId.value =
                                        '';
                                  },
                                  onOpen: () {
                                    return controller.getCarSpecefications();
                                  },
                                ),
                                CustomDropdown(
                                  width: 180,
                                  hintText: 'Engine Size',
                                  showedSelectedName: 'name',
                                  textcontroller:
                                      controller.carEngineSizeFilter.value.text,
                                  onChanged: (key, value) {
                                    controller.carEngineSizeFilter.value.text =
                                        value['name'];
                                    controller.carEngineSizeFilterId.value =
                                        key;
                                  },
                                  onDelete: () {
                                    controller.carEngineSizeFilter.value
                                        .clear();
                                    controller.carEngineSizeFilterId.value = '';
                                  },
                                  onOpen: () {
                                    return controller.getEngineTypes();
                                  },
                                ),
                                CustomDropdown(
                                  width: 200,
                                  hintText: 'Bought From',
                                  textcontroller:
                                      controller.carBoughtFromFilter.value.text,
                                  showedSelectedName: 'name',
                                  onChanged: (key, value) {
                                    controller.carBoughtFromFilter.value.text =
                                        value['name'];
                                    controller.carBoughtFromFilterId.value =
                                        key;
                                  },
                                  onDelete: () {
                                    controller.carBoughtFromFilter.value
                                        .clear();
                                    controller.carBoughtFromFilterId.value = '';
                                  },
                                  onOpen: () {
                                    return controller.getBuyersAndSellers();
                                  },
                                ),
                                CustomDropdown(
                                  width: 200,
                                  hintText: 'Sold To',

                                  textcontroller:
                                      controller.carSoldToFilter.value.text,
                                  showedSelectedName: 'name',
                                  onChanged: (key, value) {
                                    controller.carSoldToFilter.value.text =
                                        value['name'];
                                    controller.carSoldToFilterId.value = key;
                                  },
                                  onDelete: () {
                                    controller.carSoldToFilter.value.clear();
                                    controller.carSoldToFilterId.value = '';
                                  },
                                  onOpen: () {
                                    return controller.getBuyersAndSellers();
                                  },
                                ),
                                CustomDropdown(
                                  width: 200,
                                  hintText: 'Bought By',

                                  textcontroller:
                                      controller.carBoughtByFilter.value.text,
                                  showedSelectedName: 'name',
                                  onChanged: (key, value) {
                                    controller.carBoughtByFilter.value.text =
                                        value['name'];
                                    controller.carBoughtByFilterId.value = key;
                                  },
                                  onDelete: () {
                                    controller.carBoughtByFilter.value.clear();
                                    controller.carBoughtByFilterId.value = '';
                                  },
                                  onOpen: () {
                                    return controller.getBuyersAndSellersBy();
                                  },
                                ),
                                CustomDropdown(
                                  width: 200,
                                  hintText: 'Sold By',

                                  textcontroller:
                                      controller.carSoldByFilter.value.text,
                                  showedSelectedName: 'name',
                                  onChanged: (key, value) {
                                    controller.carSoldByFilter.value.text =
                                        value['name'];
                                    controller.carSoldByFilterId.value = key;
                                  },
                                  onDelete: () {
                                    controller.carSoldByFilter.value.clear();
                                    controller.carSoldByFilterId.value = '';
                                  },
                                  onOpen: () {
                                    return controller.getBuyersAndSellersBy();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      GetX<CarTradingDashboardController>(
                        builder: (controller) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              spacing: 10,
                              children: [
                                myTextFormFieldWithBorder(
                                  width: 170,
                                  controller: controller.fromDate.value,
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
                                filterButton(
                                  title: 'Today',
                                  onPressed: () async {
                                    controller.isTodaySelected.value = true;
                                    controller.isThisMonthSelected.value =
                                        false;
                                    controller.isThisYearSelected.value = false;
                                    controller.searching.value = true;

                                    await controller.searchEngine({
                                      "today": true,
                                    });
                                    controller.searching.value = false;
                                  },
                                  isSelected: controller.isTodaySelected.value,
                                ),
                                filterButton(
                                  title: 'This Month',
                                  onPressed: () async {
                                    controller.isTodaySelected.value = false;
                                    controller.isThisMonthSelected.value = true;
                                    controller.isThisYearSelected.value = false;
                                    controller.searching.value = true;

                                    await controller.searchEngine({
                                      "this_month": true,
                                    });
                                    controller.searching.value = false;
                                  },
                                  isSelected:
                                      controller.isThisMonthSelected.value,
                                ),
                                filterButton(
                                  title: 'This Year',
                                  onPressed: () async {
                                    controller.isTodaySelected.value = false;
                                    controller.isThisMonthSelected.value =
                                        false;
                                    controller.isThisYearSelected.value = true;
                                    controller.searching.value = true;

                                    await controller.searchEngine({
                                      "this_year": true,
                                    });
                                    controller.searching.value = false;
                                  },
                                  isSelected:
                                      controller.isThisYearSelected.value,
                                ),
                                filterButton(
                                  isStatus: true,
                                  title: 'New',
                                  onPressed: () async {
                                    if (controller
                                        .isNewStatusSelected
                                        .isFalse) {
                                      controller.isNewStatusSelected.value =
                                          true;
                                      controller.isSoldStatusSelected.value =
                                          false;
                                    } else {
                                      controller.isNewStatusSelected.value =
                                          false;
                                    }
                                    controller.searching.value = true;
                                    await controller.searchEngine({
                                      "status": 'New',
                                    });
                                    controller.searching.value = false;
                                  },
                                  isSelected:
                                      controller.isNewStatusSelected.value,
                                ),
                                filterButton(
                                  isStatus: true,
                                  title: 'Sold',
                                  onPressed: () async {
                                    if (controller
                                        .isSoldStatusSelected
                                        .isFalse) {
                                      controller.isSoldStatusSelected.value =
                                          true;
                                      controller.isNewStatusSelected.value =
                                          false;
                                    } else {
                                      controller.isSoldStatusSelected.value =
                                          false;
                                    }
                                    controller.searching.value = true;
                                    await controller.searchEngine({
                                      "status": 'Sold',
                                    });
                                    controller.searching.value = false;
                                  },
                                  isSelected:
                                      controller.isSoldStatusSelected.value,
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  style: saveButtonStyle,
                                  onPressed: controller.searching.isFalse
                                      ? () {
                                          controller.filterSearch();
                                        }
                                      : null,
                                  child: controller.searching.isFalse
                                      ? Text(
                                          'Find',
                                          style: fontStyleForElevatedButtons,
                                        )
                                      : loadingProcess,
                                ),
                                ElevatedButton(
                                  style: clearVariablesButtonStyle,
                                  onPressed: () {
                                    controller.clearFilters();
                                  },
                                  child: Text(
                                    'Clear Filters',
                                    style: fontStyleForElevatedButtons,
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
                  child: GetX<CarTradingDashboardController>(
                    builder: (controller) {
                      return Row(
                        spacing: 2,
                        children: [
                          customBox(
                            title: 'NUMBER OF CARS',
                            value: Text(
                              '${controller.numberOfCars.value}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: mainColor,
                                fontSize: 16,
                              ),
                            ),
                            addValue: InkWell(
                              onTap: () {
                                controller.clearValues();
                                carTradesDialog(
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
                              child: createButton,
                            ),
                          ),
                          customBox(
                            title: 'PAID',
                            value: textForDataRowInTable(
                              text: '${controller.totalPaysForAllTrades.value}',
                              color: Colors.red,
                              fontSize: 16,
                              isBold: true,
                            ),
                          ),
                          customBox(
                            title: 'RECEIVED',
                            value: textForDataRowInTable(
                              text:
                                  '${controller.totalReceivesForAllTrades.value}',
                              color: Colors.green,
                              fontSize: 16,
                              isBold: true,
                            ),
                          ),
                          Expanded(
                            child: Row(
                              spacing: 2,
                              children: [
                                customBox(
                                  title: 'NET',
                                  value: textForDataRowInTable(
                                    text:
                                        '${controller.totalNETsForAllTrades.value}',
                                    color: Colors.blueGrey,
                                    fontSize: 16,
                                    isBold: true,
                                  ),
                                ),
                                customBox(
                                  title: 'CASH IN HAND',
                                  value: textForDataRowInTable(
                                    text: '${controller.totalNETsForAll.value}',
                                    color: const Color(0xffFF7D29),
                                    fontSize: 16,
                                    isBold: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 2)),
                SliverToBoxAdapter(
                  child: GetX<CarTradingDashboardController>(
                    builder: (controller) {
                      return Row(
                        spacing: 2,
                        children: [
                          customBox(
                            title: 'NUMBER OF CAPITAL\'S DOCS',
                            value: Text(
                              '${controller.numberOfCapitalsDocs.value}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: mainColor,
                                fontSize: 16,
                              ),
                            ),
                            addValue: InkWell(
                              onTap: controller.isCapitalLoading.isFalse
                                  ? () async {
                                      controller
                                          .searchForCapitalsOrOutstandingOrGeneralExpenses
                                          .value
                                          .clear();
                                      controller.allCapitals.clear();
                                      controller.getAllCapitalsOROutstanding(
                                        'capitals',
                                      );
                                      capitalOrOutstandingOrGeneralExpensesDialog(
                                        isGeneralExpenses: false,
                                        search: controller
                                            .searchForCapitalsOrOutstandingOrGeneralExpenses,
                                        collection: 'capitals',
                                        filteredMap:
                                            controller.filteredCapitals,
                                        map: controller.allCapitals,
                                        screenName: 'Capitals',
                                        controller: controller,
                                        canEdit: true,
                                      );
                                    }
                                  : null,
                              child: createButton,
                            ),
                            refresh: InkWell(
                              onTap: () async {
                                controller.gettingCapitalsSummary.value = true;
                                await controller
                                    .getCapitalsOROutstandingSummary(
                                      'capitals',
                                    );
                                controller.gettingCapitalsSummary.value = false;
                              },
                              child: controller.gettingCapitalsSummary.isFalse
                                  ? const Icon(
                                      Icons.refresh,
                                      color: Colors.blueGrey,
                                      size: 20,
                                    )
                                  : const SpinKitDoubleBounce(
                                      color: Colors.blueGrey,
                                      size: 20,
                                    ),
                            ),
                          ),
                          customBox(
                            title: 'PAID',
                            value: textForDataRowInTable(
                              text:
                                  '${controller.totalPaysForAllCapitals.value}',
                              color: const Color(0xff3D365C),
                              fontSize: 16,
                              isBold: true,
                            ),
                          ),
                          customBox(
                            title: 'RECEIVED',
                            value: textForDataRowInTable(
                              text:
                                  '${controller.totalReceivesForAllCapitals.value}',
                              color: const Color(0xff7C4585),
                              fontSize: 16,
                              isBold: true,
                            ),
                          ),
                          customBox(
                            title: 'NET',
                            value: textForDataRowInTable(
                              text:
                                  '${controller.totalNETsForAllCapitals.value}',
                              color: const Color(0xffC95792),
                              fontSize: 16,
                              isBold: true,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 2)),
                SliverToBoxAdapter(
                  child: GetX<CarTradingDashboardController>(
                    builder: (controller) {
                      return Row(
                        spacing: 2,
                        children: [
                          customBox(
                            title: 'NUMBER OF OUTSTANDING\'S DOCS',
                            value: Text(
                              '${controller.numberOfOutstandingDocs.value}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: mainColor,
                                fontSize: 16,
                              ),
                            ),
                            addValue: InkWell(
                              onTap: controller.isCapitalLoading.isFalse
                                  ? () async {
                                      controller
                                          .searchForCapitalsOrOutstandingOrGeneralExpenses
                                          .value
                                          .clear();
                                      controller.allOutstanding.clear();
                                      controller.getAllCapitalsOROutstanding(
                                        'outstanding',
                                      );
                                      capitalOrOutstandingOrGeneralExpensesDialog(
                                        isGeneralExpenses: false,
                                        search: controller
                                            .searchForCapitalsOrOutstandingOrGeneralExpenses,
                                        collection: 'outstanding',
                                        filteredMap:
                                            controller.filteredOutstanding,
                                        map: controller.allOutstanding,
                                        screenName: 'Outstanding',
                                        controller: controller,
                                        canEdit: true,
                                      );
                                    }
                                  : null,
                              child: createButton,
                            ),
                            refresh: InkWell(
                              onTap: () async {
                                controller.gettingOutstandingSummary.value =
                                    true;
                                await controller
                                    .getCapitalsOROutstandingSummary(
                                      'outstanding',
                                    );
                                controller.gettingOutstandingSummary.value =
                                    false;
                              },
                              child:
                                  controller.gettingOutstandingSummary.isFalse
                                  ? const Icon(
                                      Icons.refresh,
                                      color: Colors.blueGrey,
                                      size: 20,
                                    )
                                  : const SpinKitDoubleBounce(
                                      color: Colors.blueGrey,
                                      size: 20,
                                    ),
                            ),
                          ),
                          customBox(
                            title: 'PAID',
                            value: textForDataRowInTable(
                              text:
                                  '${controller.totalPaysForAllOutstanding.value}',
                              color: const Color(0xff4A102A),
                              fontSize: 16,
                              isBold: true,
                            ),
                          ),
                          customBox(
                            title: 'RECEIVED',
                            value: textForDataRowInTable(
                              text:
                                  '${controller.totalReceivesForAllOutstanding.value}',
                              color: const Color(0xff85193C),
                              fontSize: 16,
                              isBold: true,
                            ),
                          ),
                          customBox(
                            title: 'NET',
                            value: textForDataRowInTable(
                              text:
                                  '${controller.totalNETsForAllOutstanding.value}',
                              color: const Color(0xffC5172E),
                              fontSize: 16,
                              isBold: true,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 2)),
                SliverToBoxAdapter(
                  child: GetX<CarTradingDashboardController>(
                    builder: (controller) {
                      return Row(
                        spacing: 2,
                        children: [
                          customBox(
                            title: 'NUMBER OF GENERAL EXPENSES\'S DOCS',
                            value: Text(
                              '${controller.numberOfGeneralExpensesDocs.value}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: mainColor,
                                fontSize: 16,
                              ),
                            ),
                            addValue: InkWell(
                              onTap: controller.isCapitalLoading.isFalse
                                  ? () async {
                                      controller
                                          .searchForCapitalsOrOutstandingOrGeneralExpenses
                                          .value
                                          .clear();
                                      controller.allGeneralExpenses.clear();
                                      controller.getAllGeneralExpenses();
                                      capitalOrOutstandingOrGeneralExpensesDialog(
                                        isGeneralExpenses: true,
                                        search: controller
                                            .searchForCapitalsOrOutstandingOrGeneralExpenses,
                                        collection: 'general_expenses',
                                        filteredMap:
                                            controller.filteredGeneralExpenses,
                                        map: controller.allGeneralExpenses,
                                        screenName: 'General Expenses',
                                        controller: controller,
                                        canEdit: true,
                                      );
                                    }
                                  : null,
                              child: createButton,
                            ),
                            refresh: InkWell(
                              onTap: () async {
                                controller.gettingGeneralExpensesSummary.value =
                                    true;
                                await controller.getGeneralExpensesSummary();
                                controller.gettingGeneralExpensesSummary.value =
                                    false;
                              },
                              child:
                                  controller
                                      .gettingGeneralExpensesSummary
                                      .isFalse
                                  ? const Icon(
                                      Icons.refresh,
                                      color: Colors.blueGrey,
                                      size: 20,
                                    )
                                  : const SpinKitDoubleBounce(
                                      color: Colors.blueGrey,
                                      size: 20,
                                    ),
                            ),
                          ),
                          customBox(
                            title: 'PAID',
                            value: textForDataRowInTable(
                              text:
                                  '${controller.totalPaysForAllGeneralExpenses.value}',
                              color: const Color(0xffBF9264),
                              fontSize: 16,
                              isBold: true,
                            ),
                          ),
                          customBox(
                            title: 'RECEIVED',
                            value: textForDataRowInTable(
                              text:
                                  '${controller.totalReceivesForAllGeneralExpenses.value}',
                              color: const Color(0xff6F826A),
                              fontSize: 16,
                              isBold: true,
                            ),
                          ),
                          Expanded(
                            child: Row(
                              spacing: 2,
                              children: [
                                customBox(
                                  title: 'NET',
                                  value: textForDataRowInTable(
                                    text:
                                        '${controller.totalNETsForAllGeneralExpenses.value}',
                                    color: const Color(0xff328E6E),
                                    fontSize: 16,
                                    isBold: true,
                                  ),
                                ),
                                customBox(
                                  title: 'NET PROFIT',
                                  value: textForDataRowInTable(
                                    text: '${controller.totalNetProfit.value}',
                                    color: const Color(0xff004030),
                                    fontSize: 16,
                                    isBold: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
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
          );
        },
      ),
    );
  }
}
