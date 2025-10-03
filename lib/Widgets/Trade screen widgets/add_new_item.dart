import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/Trading Controllers/car_trading_controller.dart';
import '../main screen widgets/lists_widgets/values_section_in_list_of_values.dart';
import 'car_information_section.dart';

Widget addNewItemOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required CarTradingController controller,
  required bool canEdit,
  required bool isGeneralExpenses,
  required bool isTrade,
}) {
  return GetX<CarTradingController>(builder: (controller) {
    bool isItemsLoading = controller.allItems.isEmpty;
    bool isNamesLoading = controller.allNames.isEmpty;
    return ListView(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: myTextFormFieldWithBorder(
                suffixIcon: IconButton(
                    onPressed: () {
                      controller.selectDateContext(
                          context, controller.itemDate.value);
                    },
                    icon: const Icon(Icons.date_range)),
                validate: true,
                controller: controller.itemDate.value,
                labelText: 'Date',
                // isDate: true
              ),
            ),
            const Expanded(flex: 3, child: SizedBox())
          ],
        ),
        const SizedBox(
          height: 10,
        ),
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
                      // itemBuilder: (context, key, value) {
                      //   return ListTile(
                      //     title: Text(value['name']),
                      //   );
                      // },
                      onChanged: (key, value) {
                        controller.item.text = value['name'];
                        controller.itemId.value = key;
                      },
                    ),
                  ),
                  valSectionInTheTable(
                    controller.listOfValuesController,
                    controller.newItemListID.value,
                    context,
                    constraints,
                    controller.newItemListMasteredByID.value,
                    'New Item',
                    'Items',
                    valuesSection(
                      constraints: constraints,
                      context: context,
                    ),
                  ),
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
                    ),
                  ),
                  valSectionInTheTable(
                    controller.listOfValuesController,
                    controller.namesListId.value,
                    context,
                    constraints,
                    controller.namesListMasterdById.value,
                    'New Name',
                    'Names of People',
                    valuesSection(
                      constraints: constraints,
                      context: context,
                    ),
                  ),
                ],
              ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
                child: myTextFormFieldWithBorder(
                    validate: true,
                    controller: controller.pay,
                    labelText: 'Paid',
                    isDouble: true)),
            const Expanded(flex: 3, child: SizedBox())
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
                child: myTextFormFieldWithBorder(
                    validate: true,
                    controller: controller.receive,
                    labelText: 'Received',
                    isDouble: true)),
            const Expanded(flex: 3, child: SizedBox())
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        myTextFormFieldWithBorder(
            controller: controller.comments.value,
            labelText: 'Comments',
            maxLines: 7),
      ],
    );
  });
}
