import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../consts.dart';
import '../../main screen widgets/add_new_values_button.dart';

Widget addNewItemOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required CarTradingDashboardController controller,
  required bool canEdit,
  required bool isGeneralExpenses,
  required bool isTrade,
}) {
  return GetBuilder<CarTradingDashboardController>(
    builder: (controller) {
      return FocusTraversalGroup(
        policy: WidgetOrderTraversalPolicy(),
        child: ListView(
          children: [
            Row(
              children: [
                myTextFormFieldWithBorder(
                  width: 140,
                  focusNode: controller.focusNodeForitems1,
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
                          // focusNode: controller.focusNodeForitems2,
                          // nextFocusNode: controller.focusNodeForitems3,
                          validator: true,
                          textcontroller: controller.item.text,
                          showedSelectedName: 'name',
                          hintText: 'Item',
                          onChanged: (key, value) {
                            controller.item.text = value['name'];
                            controller.itemId.value = key;
                          },
                          onDelete: () {
                            controller.item.clear();
                            controller.itemId.value = '';
                          },
                          onOpen: () {
                            return controller.getItems();
                          },
                        ),
                      ),
                      valSectionInTheTable(
                        controller.listOfValuesController,
                        constraints,
                        'ITEMS',
                        'New Item',
                        'Items',
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: CustomDropdown(
                          // focusNode: controller.focusNodeForitems2,
                          validator: true,
                          textcontroller: controller.name.text,
                          showedSelectedName: 'name',
                          hintText: 'Name',
                          onChanged: (key, value) {
                            controller.name.text = value['name'];
                            controller.nameId.value = key;
                          },
                          onDelete: () {
                            controller.name.clear();
                            controller.nameId.value = '';
                          },
                          onOpen: () {
                            return controller.getNamesOfPeople();
                          },
                        ),
                      ),
                      valSectionInTheTable(
                        controller.listOfValuesController,
                        constraints,
                        'NAMES_OF_PEOPLE',
                        'New Name',
                        'Names of People',
                      ),
                    ],
                  ),

            const SizedBox(height: 10),
            Row(
              children: [
                myTextFormFieldWithBorder(
                  focusNode: controller.focusNodeForitems3,
                  width: 140,
                  validate: true,
                  controller: controller.pay,
                  labelText: 'Paid',
                  isDouble: true,
                ),
                const Expanded(flex: 3, child: SizedBox()),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                myTextFormFieldWithBorder(
                  focusNode: controller.focusNodeForitems4,
                  width: 140,
                  validate: true,
                  controller: controller.receive,
                  labelText: 'Received',
                  isDouble: true,
                ),
                const Expanded(flex: 3, child: SizedBox()),
              ],
            ),
            const SizedBox(height: 10),
            myTextFormFieldWithBorder(
              focusNode: controller.focusNodeForitems5,
              controller: controller.comments.value,
              labelText: 'Comments',
              maxLines: 7,
            ),
          ],
        ),
      );
    },
  );
}
