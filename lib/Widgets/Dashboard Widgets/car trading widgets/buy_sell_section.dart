import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import '../../../consts.dart';
import '../../drop_down_menu3.dart';
import '../../main screen widgets/add_new_values_button.dart';

Widget buySellSection({
  required BuildContext context,
  required BoxConstraints constraints,
  required CarTradingDashboardController controller,
}) {
  return buyerDetailsSection(
    context: context,
    constraints: constraints,
    controller: controller,
  );
}

Widget buyerDetailsSection({
  required BuildContext context,
  required BoxConstraints constraints,
  required CarTradingDashboardController controller,
}) {
  return GetBuilder<CarTradingDashboardController>(
    builder: (controller) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          spacing: 60,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ActionField(
                    field: _DropdownField(
                      width: 300,
                      textcontroller: controller.boughtFrom.value.text,
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
                    action: valSectionInTheTable(
                      controller.listOfValuesController,
                      constraints,
                      'BUYERS_AND_SELLERS',
                      'New Buyers and Sellers',
                      'Buyers and Sellers',
                    ),
                  ),

                  _ReadOnlyInfoField(
                    width: 150,
                    label: 'Buy Date',
                    value: controller.buyDate.value.text,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ActionField(
                    field: _DropdownField(
                      width: 300,
                      textcontroller: controller.boughtBy.value.text,
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
                    action: valSectionInTheTable(
                      controller.listOfValuesController,
                      constraints,
                      'BOUGHT_SOLD_BY',
                      'New Buyers and Sellers',
                      'Buyers and Sellers',
                    ),
                  ),
                  Obx(
                    () => _ReadOnlyInfoField(
                      width: 150,
                      label: 'Buy Price',
                      value: priceFormat.format(controller.totalPays.value),
                      isMoney: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget sellerDetailsSection({
  required BuildContext context,
  required BoxConstraints constraints,
  required CarTradingDashboardController controller,
}) {
  return GetBuilder<CarTradingDashboardController>(
    builder: (controller) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          spacing: 60,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ActionField(
                    field: _DropdownField(
                      width: 300,
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
                    action: valSectionInTheTable(
                      controller.listOfValuesController,
                      constraints,
                      'BUYERS_AND_SELLERS',
                      'New Buyers and Sellers',
                      'Buyers and Sellers',
                    ),
                  ),

                  _ReadOnlyInfoField(
                    width: 150,
                    label: 'Sell Date',
                    value: controller.sellDate.value.text,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ActionField(
                    field: _DropdownField(
                      width: 300,
                      textcontroller: controller.soldBy.value.text,
                      hintText: 'Seller / Sold By',
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
                    action: valSectionInTheTable(
                      controller.listOfValuesController,
                      constraints,
                      'BOUGHT_SOLD_BY',
                      'New Buyers and Sellers',
                      'Buyers and Sellers',
                    ),
                  ),
                  Obx(
                    () => _ReadOnlyInfoField(
                      width: 150,
                      label: 'Sold Price',
                      value: priceFormat.format(controller.totalReceives.value),
                      isMoney: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _ReadOnlyInfoField extends StatelessWidget {
  const _ReadOnlyInfoField({
    required this.width,
    required this.label,
    required this.value,
    this.isMoney = false,
  });

  final double width;
  final String label;
  final String value;
  final bool isMoney;

  @override
  Widget build(BuildContext context) {
    final displayValue = value.trim().isEmpty ? '—' : value;

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 6),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textFieldLabelStyle,
            ),
          ),
          SizedBox(
            height: textFieldHeight,
            child: TextFormField(
              key: ValueKey('$label:$displayValue'),
              initialValue: displayValue,
              enabled: false,
              style: textFieldFontStyle.copyWith(
                color: Colors.grey.shade700,
                fontWeight: isMoney ? FontWeight.bold : FontWeight.normal,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 11,
                ),
                isDense: true,
                fillColor: Colors.grey.shade200,
                filled: true,
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.width,
    required this.textcontroller,
    required this.hintText,
    required this.onChanged,
    required this.onDelete,
    required this.onOpen,
  });

  final double width;
  final String textcontroller;
  final String hintText;
  final void Function(String, dynamic) onChanged;
  final VoidCallback onDelete;
  final Future<Map<String, dynamic>> Function() onOpen;

  @override
  Widget build(BuildContext context) {
    return CustomDropdown(
      width: width,
      textcontroller: textcontroller,
      showedSelectedName: 'name',
      hintText: hintText,
      onChanged: onChanged,
      onDelete: onDelete,
      onOpen: onOpen,
    );
  }
}

class _ActionField extends StatelessWidget {
  const _ActionField({required this.field, required this.action});

  final Widget field;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        field,
        const SizedBox(width: 6),
        SizedBox(width: 34, height: 38, child: action),
      ],
    );
  }
}
