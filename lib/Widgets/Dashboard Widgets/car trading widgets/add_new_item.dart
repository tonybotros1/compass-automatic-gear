import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../consts.dart';

Widget addNewItemOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required CarTradingDashboardController controller,
  required bool canEdit,
  required bool isGeneralExpenses,
  required bool isTrade,
}) {
  return GetX<CarTradingDashboardController>(
    builder: (controller) {
      bool isItemsLoading = controller.allItems.isEmpty;
      bool isNamesLoading = controller.allNames.isEmpty;
      return ListView(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: myTextFormFieldWithBorder(
                  focusNode: controller.focusNode,
                  onFieldSubmitted: (_) {
                    normalizeDate(
                      controller.itemDate.value.text,
                      controller.itemDate.value,
                    );
                  },
                  onTapOutside: (_) {
                    normalizeDate(
                      controller.itemDate.value.text,
                      controller.itemDate.value,
                    );
                  },
                  validate: true,
                  controller: controller.itemDate.value,
                  labelText: 'Date',
                  // isDate: true
                ),
              ),
              const Expanded(flex: 3, child: SizedBox()),
            ],
          ),
          const SizedBox(height: 10),
          isTrade == true || isGeneralExpenses == true
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: CustomDropdown(
                        validator: true,
                        textcontroller: controller.item.text,
                        showedSelectedName: 'name',
                        hintText: 'Item',
                        items: isItemsLoading ? {} : controller.allItems,
                        onChanged: (key, value) {
                          controller.item.text = value['name'];
                          controller.itemId.value = key;
                        },
                        onDelete: () {
                          controller.item.clear();
                          controller.itemId.value = '';
                        },
                      ),
                    ),
                    // valSectionInTheTable(
                    //   controller.listOfValuesController,
                    //   controller.newItemListID.value,
                    //   context,
                    //   constraints,
                    //   controller.newItemListMasteredByID.value,
                    //   'New Item',
                    //   'Items',
                    //   valuesSection(
                    //     constraints: constraints,
                    //     context: context,
                    //   ),
                    // ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: CustomDropdown(
                        validator: true,
                        textcontroller: controller.name.text,
                        showedSelectedName: 'name',
                        hintText: 'Name',
                        items: isNamesLoading ? {} : controller.allNames,
                        onChanged: (key, value) {
                          controller.name.text = value['name'];
                          controller.nameId.value = key;
                        },
                        onDelete: () {
                          controller.name.clear();
                          controller.nameId.value = '';
                        },
                      ),
                    ),
                    // valSectionInTheTable(
                    //   controller.listOfValuesController,
                    //   controller.namesListId.value,
                    //   context,
                    //   constraints,
                    //   controller.namesListMasterdById.value,
                    //   'New Name',
                    //   'Names of People',
                    //   valuesSection(
                    //     constraints: constraints,
                    //     context: context,
                    //   ),
                    // ),
                  ],
                ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: myTextFormFieldWithBorder(
                  validate: true,
                  controller: controller.pay,
                  labelText: 'Paid',
                  isDouble: true,
                ),
              ),
              const Expanded(flex: 3, child: SizedBox()),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: myTextFormFieldWithBorder(
                  validate: true,
                  controller: controller.receive,
                  labelText: 'Received',
                  isDouble: true,
                ),
              ),
              const Expanded(flex: 3, child: SizedBox()),
            ],
          ),
          const SizedBox(height: 10),
          myTextFormFieldWithBorder(
            controller: controller.comments.value,
            labelText: 'Comments',
            maxLines: 7,
          ),
        ],
      );
    },
  );
}
