import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';
import '../../my_text_field.dart';
import 'last_changes_dialog.dart';

class MainScreenFilters extends StatelessWidget {
  const MainScreenFilters({super.key, required this.constraints});

  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          MenuWithValues(
                            labelText: 'Car Brand',
                            headerLqabel: 'Brands',
                            dialogWidth: 600,
                            width: 170,
                            controller: controller.carBrandFilter.value,
                            displayKeys: const ['name'],
                            displaySelectedKeys: const ['name'],
                            onOpen: () {
                              return controller.getCarBrands();
                            },
                            onDelete: () {
                              controller.allModels.clear();
                              controller.carModelFilter.value.clear();
                              controller.carBrandFilter.value.clear();
                              controller.carBrandFilterId.value = '';
                              controller.carModelFilterId.value = '';
                            },
                            onSelected: (value) {
                              controller.carModelFilter.value.clear();
                              controller.getModelsByCarBrand(value['_id']);
                              controller.carBrandFilter.value.text =
                                  value['name'];
                              controller.carBrandFilterId.value = value['_id'];
                              controller.carModelFilterId.value = '';
                            },
                          ),
                          MenuWithValues(
                            labelText: 'Car Model',
                            headerLqabel: 'Models',
                            dialogWidth: 600,
                            width: 170,
                            controller: controller.carModelFilter.value,
                            displayKeys: const ['name'],
                            displaySelectedKeys: const ['name'],
                            onOpen: () {
                              return controller.getModelsByCarBrand(
                                controller.carBrandFilterId.value,
                              );
                            },
                            onDelete: () {
                              controller.carModelFilter.value.clear();
                              controller.carModelFilterId.value = '';
                            },
                            onSelected: (value) {
                              controller.carModelFilter.value.text =
                                  value['name'];
                              controller.carModelFilterId.value = value['_id'];
                            },
                          ),
                          MenuWithValues(
                            labelText: 'Bought From',
                            headerLqabel: 'Bought from',
                            dialogWidth: 600,
                            width: 200,
                            controller: controller.carBoughtFromFilter.value,
                            displayKeys: const ['name'],
                            displaySelectedKeys: const ['name'],
                            onOpen: () {
                              return controller.getBuyersAndSellers();
                            },
                            onDelete: () {
                              controller.carBoughtFromFilter.value.clear();
                              controller.carBoughtFromFilterId.value = '';
                            },
                            onSelected: (value) {
                              controller.carBoughtFromFilter.value.text =
                                  value['name'];
                              controller.carBoughtFromFilterId.value =
                                  value['_id'];
                            },
                          ),
                          MenuWithValues(
                            labelText: 'Bought By',
                            headerLqabel: 'Bought By',
                            dialogWidth: 600,
                            width: 200,
                            controller: controller.carBoughtByFilter.value,
                            displayKeys: const ['name'],
                            displaySelectedKeys: const ['name'],
                            onOpen: () {
                              return controller.getBuyersAndSellersBy();
                            },
                            onDelete: () {
                              controller.carBoughtByFilter.value.clear();
                              controller.carBoughtByFilterId.value = '';
                            },
                            onSelected: (value) {
                              controller.carBoughtByFilter.value.text =
                                  value['name'];
                              controller.carBoughtByFilterId.value =
                                  value['_id'];
                            },
                          ),

                          MenuWithValues(
                            labelText: 'Sold By',
                            headerLqabel: 'Sold By',
                            dialogWidth: 600,
                            width: 200,
                            controller: controller.carSoldByFilter.value,
                            displayKeys: const ['name'],
                            displaySelectedKeys: const ['name'],
                            onOpen: () {
                              return controller.getBuyersAndSellersBy();
                            },
                            onDelete: () {
                              controller.carSoldByFilter.value.clear();
                              controller.carSoldByFilterId.value = '';
                            },
                            onSelected: (value) {
                              controller.carSoldByFilter.value.text =
                                  value['name'];
                              controller.carSoldByFilterId.value = value['_id'];
                            },
                          ),
                          MenuWithValues(
                            labelText: 'Invested By',
                            headerLqabel: 'Invested By',
                            dialogWidth: 600,
                            width: 200,
                            controller: controller.carInvestedByFilter.value,
                            displayKeys: const ['name'],
                            displaySelectedKeys: const ['name'],
                            onOpen: () {
                              return controller.getInvestedBy();
                            },
                            onDelete: () {
                              controller.carInvestedByFilter.value.clear();
                              controller.carInvestedByFilterId.value = '';
                            },
                            onSelected: (value) {
                              controller.carInvestedByFilter.value.text =
                                  value['name'];
                              controller.carInvestedByFilterId.value =
                                  value['_id'];
                            },
                          ),
                          MenuWithValues(
                            labelText: 'Consignment For',
                            headerLqabel: 'Consignment For',
                            dialogWidth: 600,
                            width: 200,
                            controller:
                                controller.carConsignmentForFilter.value,
                            displayKeys: const ['name'],
                            displaySelectedKeys: const ['name'],
                            onOpen: () {
                              return controller.getConsignmentsFor();
                            },
                            onDelete: () {
                              controller.carConsignmentForFilter.value.clear();
                              controller.carConsignmentForFilterId.value = '';
                            },
                            onSelected: (value) {
                              controller.carConsignmentForFilter.value.text =
                                  value['name'];
                              controller.carConsignmentForFilterId.value =
                                  value['_id'];
                            },
                          ),
                        ],
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          myTextFormFieldWithBorder(
                            width: 120,
                            controller: controller.fromDate.value,
                            labelText: 'From Date',
                            onFieldSubmitted: (_) async {
                              controller.isTodaySelected.value = false;
                              controller.isThisMonthSelected.value = false;
                              controller.isThisYearSelected.value = false;
                              normalizeDate(
                                controller.fromDate.value.text,
                                controller.fromDate.value,
                              );
                            },
                            onTapOutside: (_) {
                              controller.isTodaySelected.value = false;
                              controller.isThisMonthSelected.value = false;
                              controller.isThisYearSelected.value = false;
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
                              controller.isTodaySelected.value = false;
                              controller.isThisMonthSelected.value = false;
                              controller.isThisYearSelected.value = false;
                              normalizeDate(
                                controller.toDate.value.text,
                                controller.toDate.value,
                              );
                            },
                            onTapOutside: (_) {
                              controller.isTodaySelected.value = false;
                              controller.isThisMonthSelected.value = false;
                              controller.isThisYearSelected.value = false;
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            initialValue:
                                controller.initValueForDatePicker.value,
                            children: const {
                              1: Text('ALL'),
                              2: Text('TODAY'),
                              3: Text('THIS MONTH'),
                              4: Text('THIS YEAR'),
                            },
                            decoration: BoxDecoration(
                              color: CupertinoColors.lightBackgroundGray,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            thumbDecoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(1),
                                  blurRadius: 4.0,
                                  spreadRadius: 1.0,
                                  offset: const Offset(0.0, 2.0),
                                ),
                              ],
                            ),
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInToLinear,
                            onValueChanged: (v) {
                              controller.onChooseForDatePicker(v);
                            },
                          ),
                          separator(color: Colors.grey.shade700),
                          CustomSlidingSegmentedControl<int>(
                            height: 30,

                            initialValue:
                                controller.initValueForStatusPicker.value,
                            children: const {
                              1: Text('ALL'),
                              2: Text('NEW'),
                              3: Text('SOLD'),
                            },
                            decoration: BoxDecoration(
                              color: CupertinoColors.lightBackgroundGray,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            thumbDecoration: BoxDecoration(
                              color: CupertinoColors.white,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(1),
                                  blurRadius: 4.0,
                                  spreadRadius: 1.0,
                                  offset: const Offset(0.0, 2.0),
                                ),
                              ],
                            ),
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInToLinear,
                            onValueChanged: (v) {
                              controller.onChooseForStatusPicker(v);
                            },
                          ),
                        ],
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          ElevatedButton(
                            style: findButtonStyle,
                            onPressed: controller.searching.isFalse
                                ? () {
                                    controller.allSearches();
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
                              'Clear',
                              style: fontStyleForElevatedButtons,
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
    );
  }
}
