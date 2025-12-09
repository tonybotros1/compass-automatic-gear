import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../consts.dart';
import '../../drop_down_menu3.dart';
import 'car_information_section.dart';

Widget buySellSection({
  required BuildContext context,
  required BoxConstraints constraints,
  required CarTradingDashboardController controller,
}) {
  return Scrollbar(
    thickness: 8,
    controller: controller.scrollControllerForBuySell,
    trackVisibility: true,
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: containerDecor,
      height: 225,
      width: constraints.maxWidth,
      child: SingleChildScrollView(
        controller: controller.scrollControllerForBuySell,
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<CarTradingDashboardController>(
              builder: (controller) {
                return Column(
                  spacing: 10,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomDropdown(
                          width: 200,
                          textcontroller: controller.boughtFrom.value.text,
                          showedSelectedName: 'name',
                          hintText: 'Bought From',
                          onChanged: (key, value) {
                            controller.boughtFrom.value.text = value['name'];
                            controller.boughtFromId.value = key;
                            controller.carModified.value = true;
                          },
                          onDelete: () {
                            controller.boughtFrom.value.clear();
                            controller.boughtFromId.value = '';
                            controller.carModified.value = true;
                          },
                          onOpen: () {
                            return controller.getBuyersAndSellers();
                          },
                        ),
                        valSectionInTheTable(
                          controller.listOfValuesController,
                          context,
                          constraints,
                          'BUYERS_AND_SELLERS',
                          'New Buyers and Sellers',
                          'Buyers and Sellers',
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomDropdown(
                          width: 200,
                          showedSelectedName: 'name',
                          textcontroller: controller.soldTo.value.text,
                          hintText: 'Sold To',
                          onChanged: (key, value) {
                            controller.soldTo.value.text = value['name'];
                            controller.soldToId.value = key;
                            controller.carModified.value = true;
                          },
                          onDelete: () {
                            controller.soldTo.value.clear();
                            controller.soldToId.value = '';
                            controller.carModified.value = true;
                          },
                          onOpen: () {
                            return controller.getBuyersAndSellers();
                          },
                        ),
                        valSectionInTheTable(
                          controller.listOfValuesController,
                          context,
                          constraints,
                          'BUYERS_AND_SELLERS',
                          'New Buyers and Sellers',
                          'Buyers and Sellers',
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            GetBuilder<CarTradingDashboardController>(
              builder: (controller) {
                return Column(
                  spacing: 10,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomDropdown(
                          width: 200,
                          textcontroller: controller.boughtBy.value.text,
                          showedSelectedName: 'name',
                          hintText: 'Bought By',
                          onChanged: (key, value) {
                            controller.boughtBy.value.text = value['name'];
                            controller.boughtById.value = key;
                            controller.carModified.value = true;
                          },
                          onDelete: () {
                            controller.boughtBy.value.clear();
                            controller.boughtById.value = '';
                            controller.carModified.value = true;
                          },
                          onOpen: () {
                            return controller.getBuyersAndSellersBy();
                          },
                        ),
                        valSectionInTheTable(
                          controller.listOfValuesController,
                          context,
                          constraints,
                          'BOUGHT_SOLD_BY',
                          'New Buyers and Sellers',
                          'Buyers and Sellers',
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomDropdown(
                          width: 200,
                          showedSelectedName: 'name',
                          textcontroller: controller.soldBy.value.text,
                          hintText: 'Sold By',
                          onChanged: (key, value) {
                            controller.soldBy.value.text = value['name'];
                            controller.soldById.value = key;
                            controller.carModified.value = true;
                          },
                          onDelete: () {
                            controller.soldBy.value.clear();
                            controller.soldById.value = '';
                            controller.carModified.value = true;
                          },
                          onOpen: () {
                            return controller.getBuyersAndSellersBy();
                          },
                        ),
                        valSectionInTheTable(
                          controller.listOfValuesController,
                          context,
                          constraints,
                          'BOUGHT_SOLD_BY',
                          'New Buyers and Sellers',
                          'Buyers and Sellers',
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}
