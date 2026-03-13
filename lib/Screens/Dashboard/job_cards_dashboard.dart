import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/Widgets/text_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/Dashboard Controllers/job_cards_dashboard_controller.dart';
import '../../Models/dynamic_boxes_line_model.dart';
import '../../Widgets/Dashboard Widgets/job cards dashboard widgets/accounts_summary_table.dart';
import '../../Widgets/Dashboard Widgets/job cards dashboard widgets/customer_aging_summary_table.dart';
import '../../Widgets/Dashboard Widgets/job cards dashboard widgets/daily_job_cards_summary_table.dart';
import '../../Widgets/Dashboard Widgets/job cards dashboard widgets/daily_new_job_cards_summary_table.dart';
import '../../Widgets/Dashboard Widgets/job cards dashboard widgets/monthly_job_cards_summary_table.dart';
import '../../Widgets/Dashboard Widgets/job cards dashboard widgets/salesman_table_summary.dart';
import '../../Widgets/dynamic_boxes_line.dart';
import '../../consts.dart';

class JobCardsDashboard extends StatelessWidget {
  const JobCardsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobCardsDashboardController>(
      init: JobCardsDashboardController(),
      builder: (controller) {
        return Obx(
          () => MouseRegion(
            cursor:
                controller.isScreenLoadingForJobCards.value ||
                    controller.isScreenLoadingForCustomerAging.value ||
                    controller.isScreenLoadingForJobDialyNewSummary.value
                ? SystemMouseCursors.wait
                : SystemMouseCursors.basic,
            child: AbsorbPointer(
              absorbing:
                  controller.isScreenLoadingForJobCards.value ||
                  controller.isScreenLoadingForCustomerAging.value ||
                  controller.isScreenLoadingForJobDialyNewSummary.value,
              child: const _DashBoardBody(),
            ),
          ),
        );
      },
    );
  }
}

class _DashBoardBody extends StatelessWidget {
  const _DashBoardBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 4,

            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // spacing: 10,
                      children: [
                        GetBuilder<JobCardsDashboardController>(
                          builder: (controller) {
                            return TabBar(
                              labelPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              labelStyle: controller.headerRowTextStyle,
                              dividerHeight: 0,
                              indicatorPadding: EdgeInsetsGeometry.zero,
                              padding: EdgeInsets.zero,
                              unselectedLabelColor: Colors.grey,
                              tabAlignment: TabAlignment.start,
                              isScrollable: true,
                              indicatorColor: mainColor,
                              labelColor: mainColor,
                              splashBorderRadius: BorderRadius.circular(5),
                              dividerColor: Colors.transparent,
                              tabs: const [
                                Tab(text: 'SUMMARY'),
                                Tab(text: 'MONTHLY JOB SUMMARY'),
                              ],
                            );
                          },
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    GetX<JobCardsDashboardController>(
                                      builder: (controller) {
                                        return CustomDropdown(
                                          fieldheigth: 30,
                                          fontSize: 11,
                                          textcontroller: controller
                                              .dailyDateController
                                              .value
                                              .text,
                                          width: 200,
                                          showedSelectedName: 'date',
                                          onChanged: (key, value) {
                                            controller
                                                    .dailyDateController
                                                    .value
                                                    .text =
                                                value['date'];
                                            controller.filterSearch(
                                              controller.jobDatesType.value,
                                            );
                                          },
                                          onDelete: () {
                                            controller.dailyDateController.value
                                                .clear();
                                          },
                                          onOpen: () {
                                            return controller.getJobsDate(
                                              'day',
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                      alignment: Alignment.centerLeft,
                                      height: 25,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade400,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child:
                                          GetBuilder<
                                            JobCardsDashboardController
                                          >(
                                            builder: (controller) {
                                              return Text(
                                                'DAILY JOB CARDS SUMMARY',
                                                style:
                                                    controller.headeTextStyle,
                                              );
                                            },
                                          ),
                                    ),
                                    const SizedBox(height: 5),
                                    Expanded(child: jobsDialySummaryTable()),
                                    const SizedBox(height: 5),
                                    GetBuilder<JobCardsDashboardController>(
                                      builder: (controller) {
                                        return HeaderBuilder(
                                          lable: 'NEW JOB CARDS SUMMARY',
                                          onTap: () {
                                            controller.getNewJobsDailySummary();
                                          },
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 5),
                                    Expanded(child: newJobsDialySummaryTable()),
                                    GetBuilder<JobCardsDashboardController>(
                                      builder: (controller) {
                                        return HeaderBuilder(
                                          lable: 'ACCOUNTS SUMMARY',
                                          onTap: () {
                                            // controller.getNewJobsDailySummary();
                                          },
                                        );
                                      },
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: accountsSummaryTable(),
                                    ),
                                  ],
                                ),
                              ),
                              monthyJobsAndSalesmenSection(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: DefaultTabController(
                    length: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // spacing: 10,
                      children: [
                        GetBuilder<JobCardsDashboardController>(
                          builder: (controller) {
                            return Row(
                              children: [
                                Expanded(
                                  child: TabBar(
                                    labelPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    labelStyle: controller.headerRowTextStyle,
                                    dividerHeight: 0,
                                    indicatorPadding: EdgeInsetsGeometry.zero,
                                    padding: EdgeInsets.zero,
                                    unselectedLabelColor: Colors.grey,
                                    tabAlignment: TabAlignment.start,
                                    isScrollable: true,
                                    indicatorColor: mainColor,
                                    labelColor: mainColor,
                                    splashBorderRadius: BorderRadius.circular(
                                      5,
                                    ),
                                    dividerColor: Colors.transparent,
                                    tabs: const [Tab(text: 'CUSTOMERS AGING')],
                                  ),
                                ),
                                RefreshButton(
                                  onPressed: controller.getCustomersAging,
                                ),
                              ],
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8, top: 4),
                          child: GetX<JobCardsDashboardController>(
                            builder: (controller) {
                              return SizedBox(
                                height: 80,

                                // padding: const EdgeInsets.all(4),
                                child: dynamicBoxesLine(
                                  dynamicConfigs: [
                                    DynamicBoxesLineModel(
                                      icon: moneyIcon,
                                      iconColor: Colors.blue.shade100,
                                      width: 250,
                                      label: 'TOTAL OUTSTANDING',
                                      value:
                                          '${controller.customerAgingTotalOutstanding.value}',
                                      valueColor: Colors.blue,
                                      iconSize: 30,
                                    ),
                                    DynamicBoxesLineModel(
                                      icon: moneyIcon,
                                      iconColor: Colors.green.shade100,
                                      width: 250,
                                      label: '0 TO 90 DAYS',
                                      value:
                                          '${controller.customerAging0To90.value}',
                                      valueColor: Colors.green,
                                      iconSize: 30,
                                    ),
                                    DynamicBoxesLineModel(
                                      icon: moneyIcon,
                                      iconColor: Colors.orange.shade100,
                                      width: 250,
                                      label: '91 TO 180 DAYS',
                                      value:
                                          '${controller.customerAging91To180.value}',
                                      valueColor: Colors.orange,
                                      iconSize: 30,
                                    ),
                                    DynamicBoxesLineModel(
                                      icon: moneyIcon,
                                      iconColor: Colors.red.shade100,
                                      width: 250,
                                      label: '181 TO 360 DAYS',
                                      value:
                                          '${controller.customerAging181To360.value}',
                                      valueColor: Colors.red,
                                      iconSize: 30,
                                    ),
                                    DynamicBoxesLineModel(
                                      icon: moneyIcon,
                                      iconColor: Colors.black54,
                                      width: 250,
                                      label: '+ 360 DAYS',
                                      value:
                                          '${controller.customerAgingMoreThan360.value}',
                                      valueColor: Colors.black,
                                      iconSize: 30,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        Expanded(
                          child: TabBarView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(2, 4, 8, 0),
                                child: customerAgingTable(context: context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // const Divider(),
          // Expanded(
          //   flex: 5,
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 8),
          //     child: LayoutBuilder(
          //       builder: (context, constraints) {
          //         return GetX<JobCardController>(
          //           init: JobCardController(),
          //           builder: (controller) {
          //             return Container(
          //               // padding: const EdgeInsets.all(2),
          //               decoration: BoxDecoration(
          //                 border: Border.all(color: Colors.grey),
          //                 borderRadius: const BorderRadius.only(
          //                   bottomLeft: Radius.circular(15),
          //                   bottomRight: Radius.circular(15),
          //                   topLeft: Radius.circular(2),
          //                   topRight: Radius.circular(2),
          //                 ),
          //               ),
          //               child: SizedBox(
          //                 width: constraints.maxWidth,
          //                 child: tableOfScreensForMainJobCards(
          //                   showHistoryButton: true,
          //                   scrollController:
          //                       controller.scrollControllerFotTable1,
          //                   constraints: constraints,
          //                   context: context,
          //                   controller: controller,
          //                   data: controller.allJobCards,
          //                   isDashboard: true,
          //                 ),
          //               ),
          //             );
          //           },
          //         );
          //       },
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Padding monthyJobsAndSalesmenSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 2, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GetX<JobCardsDashboardController>(
            builder: (controller) {
              return CustomDropdown(
                fieldheigth: 30,
                fontSize: 11,
                textcontroller: controller.monthlyDateController.value.text,
                width: 200,
                showedSelectedName: 'date',
                onChanged: (key, value) {
                  controller.monthlyDateController.value.text = value['date'];
                  controller.filterSearch(controller.jobDatesType.value);
                },
                onDelete: () {
                  controller.monthlyDateController.value.clear();
                },
                onOpen: () {
                  return controller.getJobsDate('month');
                },
              );
            },
          ),
          const SizedBox(height: 5),

          Container(
            padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            height: 25,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade400,
              borderRadius: BorderRadius.circular(5),
            ),
            child: GetBuilder<JobCardsDashboardController>(
              builder: (controller) {
                return Text(
                  'MONTHLY JOB CARDS SUMMARY',
                  style: controller.headeTextStyle,
                );
              },
            ),
          ),
          const SizedBox(height: 5),
          Expanded(child: jobsMonthlySummaryTable()),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.only(left: 5),
            alignment: Alignment.centerLeft,
            height: 25,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade400,
              borderRadius: BorderRadius.circular(5),
            ),
            child: GetBuilder<JobCardsDashboardController>(
              builder: (controller) {
                return Text(
                  'MONTHLY SALESMEN SUMMARY',
                  style: controller.headeTextStyle,
                );
              },
            ),
          ),
          const SizedBox(height: 5),

          Expanded(child: jobsSalesmanSummaryTable()),
        ],
      ),
    );
  }
}

class HeaderBuilder extends StatelessWidget {
  final String? lable;
  final void Function()? onTap;
  const HeaderBuilder({super.key, required this.lable, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.centerLeft,
      height: 25,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade400,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(lable ?? '', style: headeTextStyle),
          ClickableHoverText(text: 'REFRESH', onTap: onTap, fontSize: 12),
        ],
      ),
    );
  }
}

class RefreshButton extends StatelessWidget {
  final void Function()? onPressed;
  const RefreshButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
            return Colors.grey.shade200;
          }),
        ),
        onPressed: onPressed,
        child: const Text(
          'REFRESH',
          style: TextStyle(color: Colors.red, fontSize: 12),
        ),
      ),
    );
  }
}
