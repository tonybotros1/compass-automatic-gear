import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../Widgets/Dashboard Widgets/car trading widgets/main_screen_filters.dart';
import '../../Widgets/Dashboard Widgets/car trading widgets/summary_box.dart';
import '../../Widgets/Dashboard Widgets/car trading widgets/table_section_for_accounts_details.dart';
import '../../Widgets/Dashboard Widgets/car trading widgets/table_section_for_summary_details.dart';
import '../../Widgets/Dashboard Widgets/car trading widgets/table_section_for_car_trading.dart';
import '../../consts.dart';

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
            child: Column(
              children: [
                // ========================================
                // Main Screen Filters
                // ========================================
                MainScreenFilters(constraints: constraints),
                // ========================================
                const SizedBox(height: 10),
                Expanded(
                  child: GetBuilder<CarTradingDashboardController>(
                    id: 'car-trading-tabs',
                    builder: (controller) {
                      return DefaultTabController(
                        length: controller.carTradingTabs.length,
                        animationDuration: Duration.zero,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),

                              child: TabBar(
                                unselectedLabelColor: Colors.grey,
                                tabAlignment: TabAlignment.start,
                                isScrollable: true,
                                indicatorColor: mainColor,
                                labelColor: mainColor,
                                splashBorderRadius: BorderRadius.circular(5),
                                dividerColor: Colors.transparent,
                                tabs: controller.carTradingTabs,
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  // TAB 1
                                  _KeepAliveTab(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: tableOfCarTrades(
                                        constraints: constraints,
                                        context: context,
                                      ),
                                    ),
                                  ),
                                  _KeepAliveTab(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      spacing: 10,
                                      children: [
                                        Expanded(
                                          child: tableOfSummaryDetails(),
                                        ),
                                        SizedBox(
                                          width: 500,
                                          height: 197,
                                          child: tableOfAccountsDetails(),
                                        ),
                                        GetX<CarTradingDashboardController>(
                                          builder: (controller) {
                                            return SizedBox(
                                              height: 197,
                                              width: 300,
                                              child: Column(
                                                spacing: 10,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: SummaryBox(
                                                      title: 'TOTAL MONEY',
                                                      value:
                                                          '${controller.totalMoneyForAccounts.value}',
                                                      icon: Icons.trolley,
                                                      iconColor: const Color(
                                                        0xFFD8C9A7,
                                                      ).withValues(alpha: 0.8),
                                                      textColor: const Color(
                                                        0xFF434E78,
                                                      ),
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
                                                      textColor:
                                                          Colors.green.shade700,
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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

class _KeepAliveTab extends StatefulWidget {
  const _KeepAliveTab({required this.child});

  final Widget child;

  @override
  State<_KeepAliveTab> createState() => _KeepAliveTabState();
}

class _KeepAliveTabState extends State<_KeepAliveTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RepaintBoundary(child: widget.child);
  }
}
