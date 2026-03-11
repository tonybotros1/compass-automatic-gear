import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/Dashboard Controllers/job_cards_dashboard_controller.dart';
import '../../Controllers/Main screen controllers/job_card_controller.dart';
import '../../Widgets/Dashboard Widgets/job cards dashboard widgets/customer_aging_summary_table.dart';
import '../../Widgets/Dashboard Widgets/job cards dashboard widgets/daily_job_cards_summary_table.dart';
import '../../Widgets/Dashboard Widgets/job cards dashboard widgets/daily_new_job_cards_summary_table.dart';
import '../../Widgets/Dashboard Widgets/job cards dashboard widgets/monthly_job_cards_summary_table.dart';
import '../../Widgets/Dashboard Widgets/job cards dashboard widgets/salesman_table_summary.dart';
import '../../consts.dart';
import '../Main screens/System Administrator/Setup/job_card.dart';

class JobCardsDashboard extends StatelessWidget {
  const JobCardsDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobCardsDashboardController>(
      init: JobCardsDashboardController(),
      builder: (controller) {
        return Obx(
          () => MouseRegion(
            cursor: controller.isScreenLoading.value
                ? SystemMouseCursors.wait
                : SystemMouseCursors.basic,
            child: AbsorbPointer(
              absorbing: controller.isScreenLoading.value,
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
                    length: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // spacing: 10,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: GetBuilder<JobCardsDashboardController>(
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
                                    splashBorderRadius: BorderRadius.circular(
                                      5,
                                    ),
                                    dividerColor: Colors.transparent,
                                    tabs: const [
                                      Tab(text: 'DAILY JOB SUMMARY'),
                                      Tab(text: 'MONTHLY JOB SUMMARY'),
                                      Tab(text: 'SALESMEN'),
                                    ],
                                    onTap: (i) {
                                      controller.onClickForTabPage(i);
                                    },
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsGeometry.only(right: 8),
                              child: GetBuilder<JobCardsDashboardController>(
                                builder: (controller) {
                                  return CustomDropdown(
                                    textcontroller: controller.date.value.text,
                                    width: 170,
                                    hintText: 'Date',
                                    showedSelectedName: 'date',
                                    onChanged: (key, value) {
                                      controller.date.value.text =
                                          value['date'];
                                      controller.filterSearch(
                                        controller.jobDatesType.value,
                                      );
                                    },
                                    onDelete: () {},
                                    onOpen: () {
                                      return controller.getJobsDate(
                                        controller.jobDatesType.value,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Expanded(child: jobsDialySummaryTable()),
                                    DefaultTabController(
                                      length: 1,
                                      child: TabBar(
                                        labelPadding: EdgeInsets.zero,
                                        labelStyle: TextStyle(
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11,
                                        ),
                                        dividerHeight: 0,
                                        indicatorPadding:
                                            EdgeInsetsGeometry.zero,
                                        padding: EdgeInsets.zero,
                                        unselectedLabelColor: Colors.grey,
                                        tabAlignment: TabAlignment.start,
                                        isScrollable: true,
                                        indicatorColor: mainColor,
                                        labelColor: mainColor,
                                        splashBorderRadius:
                                            BorderRadius.circular(5),
                                        dividerColor: Colors.transparent,
                                        tabs: const [
                                          Tab(text: 'NEW JOBS SUMMARY'),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Expanded(child: newJobsDialySummaryTable()),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 2, 0),
                                child: jobsMonthlySummaryTable(),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 2, 0),
                                child: jobsSalesmanSummaryTable(),
                              ),
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
                                    // onTap: (i) {
                                    //   controller.onClickForTabPage(i);
                                    // },
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () {
                                    controller.getCustomersAging();
                                  },
                                  label: const Text('Refresh'),
                                ),
                              ],
                            );
                          },
                        ),
                        // GetBuilder<JobCardsDashboardController>(
                        //   builder: (controller) {
                        //     return SizedBox(
                        //       height: 50,
                        //       // padding: const EdgeInsets.all(4),
                        //       child: dynamicBoxesLine(
                        //         dynamicConfigs: [
                        //           DynamicBoxesLineModel(
                        //             isFormated: false,
                        //             width: 200,
                        //             label: 'NUMBER OF JOBS',
                        //             value: '',
                        //             valueColor: mainColor,
                        //             icon: counterIcon,
                        //             iconColor: mainColorWithAlpha,
                        //             iconSize: 10,
                        //           ),
                        //           DynamicBoxesLineModel(
                        //             icon: moneyIcon,
                        //             iconColor: Colors.green.shade100,
                        //             width: 100,
                        //             label: 'TOTAL AMOUNT',
                        //             value: '',
                        //             valueColor: Colors.green,
                        //             iconSize: 10,
                        //           ),
                        //           DynamicBoxesLineModel(
                        //             icon: moneyIcon,
                        //             iconColor: Colors.blue.shade100,
                        //             width: 100,
                        //             label: 'VAT AMOUNT',
                        //             value: '',
                        //             valueColor: Colors.blue,
                        //             iconSize: 10,
                        //           ),
                        //           DynamicBoxesLineModel(
                        //             icon: moneyIcon,
                        //             iconColor: Colors.blueGrey.shade100,
                        //             width: 100,
                        //             label: 'NET AMOUNT',
                        //             value: '',
                        //             valueColor: Colors.blueGrey,
                        //             iconSize: 10,
                        //           ),
                        //           DynamicBoxesLineModel(
                        //             icon: moneyIcon,
                        //             iconColor: Colors.orange.shade100,
                        //             width: 100,
                        //             label: 'PAID AMOUNT',
                        //             value: '',
                        //             valueColor: Colors.orange,
                        //             iconSize: 10,
                        //           ),
                        //           DynamicBoxesLineModel(
                        //             icon: moneyIcon,
                        //             iconColor: Colors.red.shade100,
                        //             width: 100,
                        //             label: 'OUTSTANDING AMOUNT',
                        //             value: '',
                        //             valueColor: Colors.red,
                        //             iconSize: 10,
                        //           ),
                        //         ],
                        //       ),
                        //     );
                        //   },
                        // ),
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
          const Divider(),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GetX<JobCardController>(
                    init: JobCardController(),
                    builder: (controller) {
                      return Container(
                        // padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                            topLeft: Radius.circular(2),
                            topRight: Radius.circular(2),
                          ),
                        ),
                        child: SizedBox(
                          width: constraints.maxWidth,
                          child: tableOfScreensForMainJobCards(
                            showHistoryButton: true,
                            scrollController:
                                controller.scrollControllerFotTable1,
                            constraints: constraints,
                            context: context,
                            controller: controller,
                            data: controller.allJobCards,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
