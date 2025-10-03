import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/Dashboard Controllers/trading_dashboard_controller.dart';
import '../../Widgets/Dashboard Widgets/trading dashboard widgets/bar_chart_section.dart';
import '../../Widgets/Dashboard Widgets/trading dashboard widgets/custom_box.dart';
import '../../Widgets/Dashboard Widgets/trading dashboard widgets/tabel_section.dart';
import '../../consts.dart';

class TradingDashboard extends StatelessWidget {
  const TradingDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(builder: (context, constraints) {
          return Padding(
            padding: screenPadding,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: GetX<TradingDashboardController>(
                      init: TradingDashboardController(),
                      builder: (controller) {
                        bool isYearsLoading = controller.allYears.isEmpty;
                        bool isMonthsLoading = controller.allMonths.isEmpty;
                        bool isDaysLoading = controller.allDays.isEmpty;
                        bool isBrandLoading = controller.allBrands.isEmpty;
                        bool isModelLoading = controller.allModels.isEmpty;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          spacing: 10,
                          children: [
                            Expanded(
                                child: CustomDropdown(
                              hintText: 'Year',
                              textcontroller: controller.year.value.text,
                              showedSelectedName: 'name',
                              items: isYearsLoading ? {} : controller.allYears,
                              onChanged: (key, value) {
                                controller.year.value.text = value['name'];
                                controller.month.clear();
                                controller.day.clear();
                                controller.allDays.clear();
                                // controller.calculateMonthlyTotals(
                                //     int.parse(value['name']));
                                controller.isYearSelected.value = true;
                                controller.isMonthSelected.value = false;
                                controller.isDaySelected.value = false;
                                // controller.calculateTotals('year');
                                controller.filterTradesByDate();
                              },
                            )),
                            Expanded(
                                child: CustomDropdown(
                              hintText: 'Month',
                              textcontroller: controller.month.text,
                              showedSelectedName: 'name',
                              items:
                                  isMonthsLoading ? {} : controller.allMonths,
                              onChanged: (key, value) {
                                controller.allDays
                                    .assignAll(getDaysInMonth(value['name']));
                                controller.month.text = value['name'];
                                controller.day.clear();
                                controller.isMonthSelected.value = true;
                                controller.isYearSelected.value = false;
                                controller.isDaySelected.value = false;
                                // controller.calculateTotals('month');
                                controller.filterTradesByDate();
                              },
                            )),
                            Expanded(
                                child: CustomDropdown(
                              hintText: 'Day',
                              textcontroller: controller.day.text,
                              showedSelectedName: 'name',
                              items: isDaysLoading ? {} : controller.allDays,
                              onChanged: (key, value) {
                                controller.day.text = value['name'];
                                controller.filterTradesByDate();
                                controller.isMonthSelected.value = false;
                                controller.isYearSelected.value = false;
                                controller.isDaySelected.value = true;
                                // controller.calculateTotals('day');
                              },
                            )),
                            ElevatedButton(
                                style: allButtonStyle,
                                onPressed: () {
                                  controller.filterByCurrentDate('all');
                                  // controller.isAllSelected.value = true;
                                  controller.isTodaySelected.value = false;
                                  controller.isThisMonthSelected.value = false;
                                  controller.isThisYearSelected.value = false;
                                  controller.carBrand.value.clear();
                                  controller.carModel.value.clear();
                                  controller.carBrandId.value = '';
                                  controller.carModelId.value = '';
                                  controller.allModels.clear();
                                },
                                child: const Text('All')),
                            ElevatedButton(
                                style: todayButtonStyle,
                                onPressed: controller.isTodaySelected.isFalse
                                    ? () {
                                        controller.filterByCurrentDate('today');
                                        // controller.isAllSelected.value = false;
                                        controller.isTodaySelected.value = true;
                                        controller.isThisMonthSelected.value =
                                            false;
                                        controller.isThisYearSelected.value =
                                            false;
                                        controller.isYearSelected.value = false;
                                        controller.isMonthSelected.value =
                                            false;
                                        controller.isDaySelected.value = true;
                                      }
                                    : null,
                                child: const Text('Today')),
                            ElevatedButton(
                                style: thisMonthButtonStyle,
                                onPressed: controller
                                        .isThisMonthSelected.isFalse
                                    ? () {
                                        controller.filterByCurrentDate('month');

                                        // controller.isAllSelected.value = false;
                                        controller.isTodaySelected.value =
                                            false;
                                        controller.isThisMonthSelected.value =
                                            true;
                                        controller.isThisYearSelected.value =
                                            false;
                                        controller.isYearSelected.value = false;
                                        controller.isMonthSelected.value = true;
                                        controller.isDaySelected.value = false;
                                      }
                                    : null,
                                child: const Text('This Month')),
                            ElevatedButton(
                                style: thisYearButtonStyle,
                                onPressed: controller.isThisYearSelected.isFalse
                                    ? () {
                                        controller.filterByCurrentDate('year');

                                        // controller.isAllSelected.value = false;
                                        controller.isTodaySelected.value =
                                            false;
                                        controller.isThisMonthSelected.value =
                                            false;
                                        controller.isThisYearSelected.value =
                                            true;
                                        controller.isYearSelected.value = true;
                                        controller.isMonthSelected.value =
                                            false;
                                        controller.isDaySelected.value = false;
                                      }
                                    : null,
                                child: const Text('This Year')),
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
                                child: const Text('New')),
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
                                child: const Text('Sold')),
                            Expanded(
                              child: CustomDropdown(
                                showedSelectedName: 'name',
                                textcontroller: controller.carBrand.value.text,
                                hintText: 'Car Brand',
                                items:
                                    isBrandLoading ? {} : controller.allBrands,
                                onChanged: (key, value) {
                                  controller.carModel.value.clear();
                                  controller.getModelsByCarBrand(key);
                                  controller.carBrand.value.text =
                                      value['name'];
                                  controller.carBrandId.value = key;
                                  controller.carModelId.value = '';
                                  controller.filterTradesByDate();
                                },
                              ),
                            ),
                            Expanded(
                              child: CustomDropdown(
                                showedSelectedName: 'name',
                                textcontroller: controller.carModel.value.text,
                                hintText: 'Car Model',
                                items:
                                    isModelLoading ? {} : controller.allModels,
                                onChanged: (key, value) {
                                  controller.carModel.value.text =
                                      value['name'];
                                  controller.carModelId.value = key;
                                  controller.filterTradesByDate();
                                },
                              ),
                            ),
                          ],
                        );
                      }),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 10,
                  ),
                ),
                SliverToBoxAdapter(
                  child:
                      GetX<TradingDashboardController>(builder: (controller) {
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
                                  fontSize: 16),
                            )),
                        customBox(
                            title: 'EXPENSES',
                            value: textForDataRowInTable(
                                text:
                                    '${controller.totalPaysForAllTrades.value}',
                                color: Colors.red,
                                fontSize: 16,
                                isBold: true)),
                        customBox(
                            title: 'REVENUE',
                            value: textForDataRowInTable(
                                text:
                                    '${controller.totalReceivesForAllTrades.value}',
                                color: Colors.green,
                                fontSize: 16,
                                isBold: true)),
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
                                      isBold: true)),
                              customBox(
                                  title: 'CASH IN HAND',
                                  value: textForDataRowInTable(
                                      text:
                                          '${controller.totalNETsForAll.value}',
                                      color: const Color(0xffFF7D29),
                                      fontSize: 16,
                                      isBold: true))
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 2,
                  ),
                ),
                SliverToBoxAdapter(
                  child:
                      GetX<TradingDashboardController>(builder: (controller) {
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
                                  fontSize: 16),
                            )),
                        customBox(
                            title: 'EXPENSES',
                            value: textForDataRowInTable(
                                text:
                                    '${controller.totalPaysForAllCapitals.value}',
                                color: const Color(0xff3D365C),
                                fontSize: 16,
                                isBold: true)),
                        customBox(
                            title: 'REVENUE',
                            value: textForDataRowInTable(
                                text:
                                    '${controller.totalReceivesForAllCapitals.value}',
                                color: const Color(0xff7C4585),
                                fontSize: 16,
                                isBold: true)),
                        customBox(
                            title: 'NET',
                            value: textForDataRowInTable(
                                text:
                                    '${controller.totalNETsForAllCapitals.value}',
                                color: const Color(0xffC95792),
                                fontSize: 16,
                                isBold: true)),
                      ],
                    );
                  }),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 2,
                  ),
                ),
                SliverToBoxAdapter(
                  child:
                      GetX<TradingDashboardController>(builder: (controller) {
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
                                  fontSize: 16),
                            )),
                        customBox(
                            title: 'EXPENSES',
                            value: textForDataRowInTable(
                                text:
                                    '${controller.totalPaysForAllOutstanding.value}',
                                color: const Color(0xff4A102A),
                                fontSize: 16,
                                isBold: true)),
                        customBox(
                            title: 'REVENUE',
                            value: textForDataRowInTable(
                                text:
                                    '${controller.totalReceivesForAllOutstanding.value}',
                                color: const Color(0xff85193C),
                                fontSize: 16,
                                isBold: true)),
                        customBox(
                            title: 'NET',
                            value: textForDataRowInTable(
                                text:
                                    '${controller.totalNETsForAllOutstanding.value}',
                                color: const Color(0xffC5172E),
                                fontSize: 16,
                                isBold: true)),
                      ],
                    );
                  }),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 2,
                  ),
                ),
                SliverToBoxAdapter(
                  child:
                      GetX<TradingDashboardController>(builder: (controller) {
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
                                  fontSize: 16),
                            )),
                        customBox(
                            title: 'EXPENSES',
                            value: textForDataRowInTable(
                                text:
                                    '${controller.totalPaysForAllGeneralExpenses.value}',
                                color: const Color(0xffBF9264),
                                fontSize: 16,
                                isBold: true)),
                        customBox(
                            title: 'REVENUE',
                            value: textForDataRowInTable(
                                text:
                                    '${controller.totalReceivesForAllGeneralExpenses.value}',
                                color: const Color(0xff6F826A),
                                fontSize: 16,
                                isBold: true)),
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
                                      isBold: true)),
                              customBox(
                                  title: 'NET PROFIT',
                                  value: textForDataRowInTable(
                                      text:
                                          '${controller.totalNetProfit.value}',
                                      color: const Color(0xff004030),
                                      fontSize: 16,
                                      isBold: true))
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 10,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 300),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                    ),
                    child:
                        GetX<TradingDashboardController>(builder: (controller) {
                      return controller.filteredTrades.isNotEmpty
                          ? tableOfTrades(
                              constraints: constraints,
                              context: context,
                              controller: controller,
                            )
                          : controller.filteredTrades.isEmpty &&
                                  controller.isScreenLoding.isTrue
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: mainColor,
                                      ),
                                    ),
                                  ),
                                )
                              : const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('No Data'),
                                  ),
                                );
                    }),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 10,
                  ),
                ),
                SliverToBoxAdapter(
                  child:
                      GetX<TradingDashboardController>(builder: (controller) {
                    return SyncfusionMultiBarChart(
                      labels: controller.isYearSelected.isTrue
                          ? months
                          : controller.isMonthSelected.isTrue
                              ? controller.allDays.values
                                  .map((e) => e['name'].toString())
                                  .toList()
                              : controller.isDaySelected.isTrue
                                  ? ['Today']
                                  : months,
                      expenses: controller.expenses,
                      net: controller.net,
                      revenue: controller.revenue,
                      carsNumber: controller.carsNumber,
                    );
                  }),
                ),
              ],
            ),
          );
        }));
  }

  Container hintMark({required Color color}) {
    return Container(
      height: 10,
      width: 10,
      color: color,
    );
  }
}
