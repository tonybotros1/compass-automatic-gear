import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../Widgets/Dashboard Widgets/car trading widgets/capital_dialog.dart';
import '../../Widgets/Dashboard Widgets/car trading widgets/car_trade_dialog.dart';
import '../../Widgets/Dashboard Widgets/trading dashboard widgets/custom_box.dart';
import '../../Widgets/Dashboard Widgets/car trading widgets/table_section_for_car_trading.dart';
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
                    spacing: 10,
                    children: [
                      GetX<CarTradingDashboardController>(
                        init: CarTradingDashboardController(),
                        builder: (controller) {
                          bool isBrandLoading = controller.allBrands.isEmpty;
                          bool isModelLoading = controller.allModels.isEmpty;
                          bool isEngineSizeLoading =
                              controller.allEngineSizes.isEmpty;
                          bool isBoughtFromLoading =
                              controller.allBuyersAndSellers.isEmpty;
                          bool isSoldToLoading =
                              controller.allBuyersAndSellers.isEmpty;
                          bool isSpecificationsLoading =
                              controller.allCarSpecifications.isEmpty;
                          return Row(
                            spacing: 10,
                            children: [
                              CustomDropdown(
                                width: 170,
                                showedSelectedName: 'name',
                                textcontroller:
                                    controller.carBrandFilter.value.text,
                                hintText: 'Car Brand',
                                items: isBrandLoading
                                    ? {}
                                    : controller.allBrands,
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
                                width: 150,
                                hintText: 'Specification',
                                showedSelectedName: 'name',
                                textcontroller: controller
                                    .carSpecificationFilter
                                    .value
                                    .text,
                                items: isSpecificationsLoading
                                    ? {}
                                    : controller.allCarSpecifications,
                                onChanged: (key, value) {
                                  controller.carSpecificationFilter.value.text =
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
                              ),
                              CustomDropdown(
                                width: 150,
                                hintText: 'Engine Size',
                                showedSelectedName: 'name',
                                textcontroller:
                                    controller.carEngineSizeFilter.value.text,
                                items: isEngineSizeLoading
                                    ? {}
                                    : controller.allEngineSizes,
                                onChanged: (key, value) {
                                  controller.carEngineSizeFilter.value.text =
                                      value['name'];
                                  controller.carEngineSizeFilterId.value = key;
                                },
                                onDelete: () {
                                  controller.carEngineSizeFilter.value.clear();
                                  controller.carEngineSizeFilterId.value = '';
                                },
                              ),
                              CustomDropdown(
                                width: 150,
                                hintText: 'Bought From',
                                textcontroller:
                                    controller.carBoughtFromFilter.value.text,
                                showedSelectedName: 'name',
                                items: isBoughtFromLoading
                                    ? {}
                                    : controller.allBuyersAndSellers,
                                onChanged: (key, value) {
                                  controller.carBoughtFromFilter.value.text =
                                      value['name'];
                                  controller.carBoughtFromFilterId.value = key;
                                },
                                onDelete: () {
                                  controller.carBoughtFromFilter.value.clear();
                                  controller.carBoughtFromFilterId.value = '';
                                },
                              ),
                              CustomDropdown(
                                width: 150,
                                hintText: 'Sold To',
                                items: isSoldToLoading
                                    ? {}
                                    : controller.allBuyersAndSellers,
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
                              ),
                            ],
                          );
                        },
                      ),
                      GetX<CarTradingDashboardController>(
                        builder: (controller) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            spacing: 10,
                            children: [
                              myTextFormFieldWithBorder(
                                width: 130,
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
                                width: 130,
                                controller: controller.toDate.value,
                                labelText: 'To Date',
                                onFieldSubmitted: (_) async {
                                  normalizeDate(
                                    controller.toDate.value.text,
                                    controller.toDate.value,
                                  );
                                },
                              ),
                              ElevatedButton(
                                style: allButtonStyle,
                                onPressed: () {
                                  controller.onTapForAll();
                                },
                                child: const Text('All'),
                              ),
                              ElevatedButton(
                                style: todayButtonStyle,
                                onPressed: controller.isTodaySelected.isFalse
                                    ? () {
                                        controller.isTodaySelected.value = true;
                                        controller.isThisMonthSelected.value =
                                            false;
                                        controller.isThisYearSelected.value =
                                            false;
                                      }
                                    : null,
                                child: const Text('Today'),
                              ),
                              ElevatedButton(
                                style: thisMonthButtonStyle,
                                onPressed:
                                    controller.isThisMonthSelected.isFalse
                                    ? () {
                                        controller.isTodaySelected.value =
                                            false;
                                        controller.isThisMonthSelected.value =
                                            true;
                                        controller.isThisYearSelected.value =
                                            false;
                                      }
                                    : null,
                                child: const Text('This Month'),
                              ),
                              ElevatedButton(
                                style: thisYearButtonStyle,
                                onPressed: controller.isThisYearSelected.isFalse
                                    ? () {
                                        controller.isTodaySelected.value =
                                            false;
                                        controller.isThisMonthSelected.value =
                                            false;
                                        controller.isThisYearSelected.value =
                                            true;
                                      }
                                    : null,
                                child: const Text('This Year'),
                              ),
                              ElevatedButton(
                                style: controller.isNewStatusSelected.isFalse
                                    ? isNotPressedButtonStyle
                                    : newButtonStyle,
                                onPressed: () {
                                  if (controller.isNewStatusSelected.isFalse) {
                                    controller.isNewStatusSelected.value = true;
                                    controller.isSoldStatusSelected.value =
                                        false;
                                  } else {
                                    controller.isNewStatusSelected.value =
                                        false;
                                  }
                                  controller.filterTradesByDate();
                                },
                                child: const Text('New'),
                              ),
                              ElevatedButton(
                                style: controller.isSoldStatusSelected.isFalse
                                    ? isNotPressedButtonStyle
                                    : soldButtonStyle,
                                onPressed: () {
                                  if (controller.isSoldStatusSelected.isFalse) {
                                    controller.isSoldStatusSelected.value =
                                        true;
                                    controller.isNewStatusSelected.value =
                                        false;
                                  } else {
                                    controller.isSoldStatusSelected.value =
                                        false;
                                  }
                                  controller.filterTradesByDate();
                                },
                                child: const Text('Sold'),
                              ),
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
                            ],
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
                              child: const Icon(
                                Icons.add,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                          ),
                          customBox(
                            title: 'EXPENSES',
                            value: textForDataRowInTable(
                              text: '${controller.totalPaysForAllTrades.value}',
                              color: Colors.red,
                              fontSize: 16,
                              isBold: true,
                            ),
                          ),
                          customBox(
                            title: 'REVENUE',
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
                              child: const Icon(
                                Icons.add,
                                color: Colors.grey,
                                size: 20,
                              ),
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
                                      color: Colors.grey,
                                      size: 20,
                                    )
                                  : const SpinKitDoubleBounce(
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                            ),
                          ),
                          customBox(
                            title: 'EXPENSES',
                            value: textForDataRowInTable(
                              text:
                                  '${controller.totalPaysForAllCapitals.value}',
                              color: const Color(0xff3D365C),
                              fontSize: 16,
                              isBold: true,
                            ),
                          ),
                          customBox(
                            title: 'REVENUE',
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
                              child: const Icon(
                                Icons.add,
                                color: Colors.grey,
                                size: 20,
                              ),
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
                                      color: Colors.grey,
                                      size: 20,
                                    )
                                  : const SpinKitDoubleBounce(
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                            ),
                          ),
                          customBox(
                            title: 'EXPENSES',
                            value: textForDataRowInTable(
                              text:
                                  '${controller.totalPaysForAllOutstanding.value}',
                              color: const Color(0xff4A102A),
                              fontSize: 16,
                              isBold: true,
                            ),
                          ),
                          customBox(
                            title: 'REVENUE',
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
                              child: const Icon(
                                Icons.add,
                                color: Colors.grey,
                                size: 20,
                              ),
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
                                      color: Colors.grey,
                                      size: 20,
                                    )
                                  : const SpinKitDoubleBounce(
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                            ),
                          ),
                          customBox(
                            title: 'EXPENSES',
                            value: textForDataRowInTable(
                              text:
                                  '${controller.totalPaysForAllGeneralExpenses.value}',
                              color: const Color(0xffBF9264),
                              fontSize: 16,
                              isBold: true,
                            ),
                          ),
                          customBox(
                            title: 'REVENUE',
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
