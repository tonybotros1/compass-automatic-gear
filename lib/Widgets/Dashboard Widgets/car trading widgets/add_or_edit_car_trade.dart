import 'package:flutter/material.dart';
import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../consts.dart';
import 'buy_sell_section.dart';
import 'car_information_section.dart';
import 'note_section.dart';

Widget addNewCarTradeOrEdit({
  required BuildContext context,
  required CarTradingDashboardController controller,
  required bool canEdit,
  required BoxConstraints constraints,
}) {
  return Form(
    key: controller.carTradeFormKey,
    child: Column(
      children: [
        Expanded(
          child: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 7,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: [
                              labelContainer(
                                lable: Text(
                                  'Car Information',
                                  style: fontStyle1,
                                ),
                              ),
                              carInformation(
                                context: context,
                                constraints: constraints,
                                controller: controller,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              labelContainer(
                                lable: Text('Buy / Sell', style: fontStyle1),
                              ),
                              buySellSection(
                                context: context,
                                constraints: constraints,
                                controller: controller,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: [
                              labelContainer(
                                lable: Text('Note', style: fontStyle1),
                              ),
                              noteSection(
                                context: context,
                                constraints: constraints,
                                controller: controller,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
