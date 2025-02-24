import 'package:datahubai/Controllers/Main%20screen%20controllers/job_card_controller.dart';
import 'package:datahubai/Widgets/main%20screen%20widgets/dynamic_field.dart';
import 'package:flutter/material.dart';

import '../../../Models/dynamic_field_models.dart';
import '../../../consts.dart';

Container quotationsSection(context,JobCardController controller) {
  return Container(
      padding: EdgeInsets.all(20),
      decoration: containerDecor,
      child: Column(spacing: 20, children: [
        dynamicFields(dynamicConfigs: [
          DynamicConfig(
            isDropdown: false,
            flex: 1,
            fieldConfig: FieldConfig(
              isEnabled: false,
              textController: controller.quotationCounter.value,
              labelText: 'Quotation No.',
              hintText: 'Enter Quotation No.',
              validate: false,
            ),
          ),
          DynamicConfig(
            isDropdown: false,
            flex: 2,
            fieldConfig: FieldConfig(
              isDate: true,
              suffixIcon: IconButton(
                  onPressed: () {
                    controller.selectDateContext(
                        context, controller.quotationDate.value);
                  },
                  icon: Icon(Icons.date_range)),
              textController: controller.quotationDate.value,
              labelText: 'Quotation Date',
              hintText: 'Enter Quotation Date',
              validate: false,
            ),
          ),
          DynamicConfig(
            isDropdown: false,
            flex: 2,
            fieldConfig: FieldConfig(
              onChanged: (value) {
                if (controller.quotationDays.value.text.isEmpty) {
                  controller.validityEndDate.value.clear();
                } else {
                  if (int.parse(value) < 3000) {
                    controller.changeQuotationEndDateDependingOnDays();
                  }
                }
              },
              isnumber: true,
              textController: controller.quotationDays.value,
              labelText: 'Validity',
              hintText: '(days)',
              validate: false,
            ),
          ),
          DynamicConfig(
            isDropdown: false,
            flex: 2,
            fieldConfig: FieldConfig(
              isDate: true,
              suffixIcon: IconButton(
                  onPressed: () async {
                    await controller.selectDateContext(
                        context, controller.validityEndDate.value);
                    controller.changingDaysDependingOnQuotationEndDate();
                  },
                  icon: Icon(Icons.date_range)),
              textController: controller.validityEndDate.value,
              labelText: 'Expiry Date',
              hintText: 'Enter Expiry Date',
              validate: false,
            ),
          ),
          DynamicConfig(
            isDropdown: false,
            flex: 2,
            fieldConfig: FieldConfig(
              textController: controller.referenceNumber.value,
              labelText: 'Reference No.',
              hintText: 'Enter Reference No.',
              validate: false,
            ),
          ),
          DynamicConfig(
            isDropdown: false,
            flex: 2,
            fieldConfig: FieldConfig(
              textController: controller.deliveryTime.value,
              labelText: 'Delivery Time',
              hintText: 'Enter Delivery Time',
              validate: false,
            ),
          ),
          DynamicConfig(
            isDropdown: false,
            flex: 2,
            fieldConfig: FieldConfig(
              isnumber: true,
              textController: controller.quotationWarrentyDays.value,
              labelText: 'Warrenty Days',
              hintText: 'Enter Warrenty Days',
              validate: false,
            ),
          ),
          DynamicConfig(
            isDropdown: false,
            flex: 2,
            fieldConfig: FieldConfig(
              isnumber: true,
              textController: controller.quotationWarrentyKM.value,
              labelText: 'Warrenty KM',
              hintText: 'Enter Warrenty KM',
              validate: false,
            ),
          ),
        ]),
        dynamicFields(dynamicConfigs: [
          DynamicConfig(
              isDropdown: false,
              fieldConfig: FieldConfig(
                labelText: 'Quotation Notes',
                hintText: 'Enter Quotation Notes',
                textController: controller.quotationNotes,
                maxLines: null,
                minLines: 1,
                keyboardType: TextInputType.multiline,
              ))
        ])
      ]));
}
