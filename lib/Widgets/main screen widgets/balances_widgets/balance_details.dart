import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/balances_controller.dart';
import '../../../consts.dart';
import '../../menu_dialog.dart';
import '../../my_text_field.dart';

Container balanceDetails(BuildContext context, BalancesController controller) {
  return Container(
    // height: 245,
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 50,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  myTextFormFieldWithBorder(
                    labelText: 'Balance Name',
                    controller: controller.balanceName,
                    width: 310,
                  ),
                  MenuWithValues(
                    labelText: 'Balance Type',
                    headerLqabel: 'Balance Types',
                    dialogWidth: 600,
                    width: 310,
                    controller: controller.balanceType,
                    displayKeys: const ['name'],
                    displaySelectedKeys: const ['name'],
                    data: controller.balanceTypes,
                    onDelete: () {
                      controller.balanceType.clear();
                    },
                    onSelected: (value) {
                      controller.balanceType.text = value['name'];
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: myTextFormFieldWithBorder(
                maxLines: 5,
                labelText: 'Description',
                controller: controller.balanceDescription,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: mainColor, width: 2),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 10,
                children: [
                  GetX<BalancesController>(
                    builder: (controller) {
                      return CupertinoCheckbox(
                        value: controller.showOnAssignment.value,
                        onChanged: (val) {
                          controller.showOnAssignment.value = val ?? false;
                        },
                      );
                    },
                  ),
                  Text('Show on Assignment', style: coolTextStyle),
                ],
              ),
              Row(
                spacing: 10,
                children: [
                  GetX<BalancesController>(
                    builder: (controller) {
                      return CupertinoCheckbox(
                        value: controller.showOnPayroll.value,
                        onChanged: (val) {
                          controller.showOnPayroll.value = val ?? false;
                        },
                      );
                    },
                  ),
                  Text('Show on Payroll', style: coolTextStyle),
                ],
              ),
              Row(
                spacing: 10,
                children: [
                  GetX<BalancesController>(
                    builder: (controller) {
                      return CupertinoCheckbox(
                        value: controller.showOnLeave.value,
                        onChanged: (val) {
                          controller.showOnLeave.value = val ?? false;
                        },
                      );
                    },
                  ),
                  Text('Show on Leave', style: coolTextStyle),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
