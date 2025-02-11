import 'package:datahubai/Controllers/Main%20screen%20controllers/job_card_controller.dart';
import 'package:flutter/material.dart';
import '../../../Models/dynamic_field_models.dart';
import '../../../consts.dart';
import '../dynamic_field.dart';

Container jobCardSection(context,JobCardController controller) {
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
              textController: controller.jobCardCounter.value,
              labelText: 'Job No.',
              hintText: 'Enter Job No.',
              validate: false,
            ),
          ),
          DynamicConfig(
            isDropdown: false,
            flex: 1,
            fieldConfig: FieldConfig(
              isEnabled: false,
              textController: controller.invoiceCounter.value,
              labelText: 'Invoice No.',
              hintText: 'Enter Invoice No.',
              validate: false,
            ),
          ),
          DynamicConfig(
            isDropdown: false,
            flex: 3,
            fieldConfig: FieldConfig(
              textController: controller.lpoCounter.value,
              labelText: 'LPO No.',
              hintText: 'Enter LPO No.',
              validate: false,
            ),
          ),
          DynamicConfig(
            isDropdown: false,
            flex: 2,
            fieldConfig: FieldConfig(
              suffixIcon: IconButton(
                  onPressed: () {
                    controller.selectDateContext(
                        context, controller.jobCardDate);
                  },
                  icon: Icon(Icons.date_range)),
              isDate: true,
              textController: controller.jobCardDate.value,
              labelText: 'Job Date',
              hintText: 'Enter Job Date',
              validate: false,
            ),
          ),
          DynamicConfig(
            isDropdown: false,
            flex: 2,
            fieldConfig: FieldConfig(
              suffixIcon: IconButton(
                  onPressed: () {
                    controller.selectDateContext(
                        context, controller.invoiceDate);
                  },
                  icon: Icon(Icons.date_range)),
              isDate: true,
              textController: controller.invoiceDate.value,
              labelText: 'Invoice Date',
              hintText: 'Enter Invoice Date',
              validate: false,
            ),
          ),
          DynamicConfig(
            isDropdown: false,
            flex: 2,
            fieldConfig: FieldConfig(
              suffixIcon: IconButton(
                  onPressed: () {
                    controller.selectDateContext(
                        context, controller.approvalDate);
                  },
                  icon: Icon(Icons.date_range)),
              isDate: true,
              textController: controller.approvalDate.value,
              labelText: 'Approval Date',
              hintText: 'Enter Approval Date',
              validate: false,
            ),
          ),
          DynamicConfig(
            isDropdown: false,
            flex: 2,
            fieldConfig: FieldConfig(
              suffixIcon: IconButton(
                  onPressed: () {
                    controller.selectDateContext(context, controller.startDate);
                  },
                  icon: Icon(Icons.date_range)),
              isDate: true,
              textController: controller.startDate.value,
              labelText: 'Start Date',
              hintText: 'Enter Approval Date',
              validate: false,
            ),
          ),
          DynamicConfig(
            isDropdown: false,
            flex: 2,
            fieldConfig: FieldConfig(
              suffixIcon: IconButton(
                  onPressed: () {
                    controller.selectDateContext(
                        context, controller.finishDate);
                  },
                  icon: Icon(Icons.date_range)),
              isDate: true,
              textController: controller.finishDate.value,
              labelText: 'Finish Date',
              hintText: 'Enter Approval Date',
              validate: false,
            ),
          ),
        ]),
        dynamicFields(dynamicConfigs: [
          DynamicConfig(
            isDropdown: false,
            flex: 1,
            fieldConfig: FieldConfig(
              suffixIcon: IconButton(
                  onPressed: () {
                    controller.selectDateContext(
                        context, controller.deliveryDate);
                  },
                  icon: Icon(Icons.date_range)),
              isDate: true,
              textController: controller.deliveryDate.value,
              labelText: 'Delivery Date',
              hintText: 'Enter Delivery Date',
              validate: false,
            ),
          ),
          DynamicConfig(
            isDropdown: false,
            flex: 1,
            fieldConfig: FieldConfig(
              isnumber: true,
              textController: controller.jobWarrentyDays.value,
              labelText: 'Warrenty Days',
              hintText: 'Enter Warrenty Days',
              validate: false,
            ),
          ),
          DynamicConfig(
            isDropdown: false,
            flex: 1,
            fieldConfig: FieldConfig(
              isnumber: true,
              textController: controller.jobWarrentyKM.value,
              labelText: 'Warrenty KM',
              hintText: 'Enter Warrenty KM',
              validate: false,
            ),
          ),
          DynamicConfig(
            isDropdown: false,
            flex: 1,
            fieldConfig: FieldConfig(
              suffixIcon: IconButton(
                  onPressed: () {
                    controller.selectDateContext(
                        context, controller.jobWarrentyEndDate);
                  },
                  icon: Icon(Icons.date_range)),
              isDate: true,
              textController: controller.jobWarrentyEndDate.value,
              labelText: 'Warrenty End Date',
              hintText: 'Enter Warrenty End Date',
              validate: false,
            ),
          ),
          DynamicConfig(
            isDropdown: false,
            flex: 1,
            fieldConfig: FieldConfig(
              isnumber: true,
              textController: controller.minTestKms.value,
              labelText: 'Min Test KMs',
              hintText: 'Enter Min Test KMs',
              validate: false,
            ),
          ),
          DynamicConfig(
            isDropdown: false,
            flex: 1,
            fieldConfig: FieldConfig(
              textController: controller.reference1.value,
              labelText: 'Reference 1',
              hintText: 'Enter Reference 1',
              validate: false,
            ),
          ),
          DynamicConfig(
            isDropdown: false,
            flex: 1,
            fieldConfig: FieldConfig(
              textController: controller.reference2.value,
              labelText: 'Reference 2',
              hintText: 'Enter Reference 2',
              validate: false,
            ),
          ),
          DynamicConfig(
            isDropdown: false,
            flex: 1,
            fieldConfig: FieldConfig(
              textController: controller.reference3.value,
              labelText: 'Reference 3',
              hintText: 'Enter Reference 3',
              validate: false,
            ),
          ),
        ]),
        dynamicFields(dynamicConfigs: [
          DynamicConfig(
              isDropdown: false,
              fieldConfig: FieldConfig(
                labelText: 'Job Notes',
                hintText: 'Enter Job Notes',
                textController: controller.jobNotes,
                maxLines: null,
                minLines: 1,
                keyboardType: TextInputType.multiline,
              ))
        ]),
        dynamicFields(dynamicConfigs: [
          DynamicConfig(
              isDropdown: false,
              fieldConfig: FieldConfig(
                labelText: 'Delivery Notes',
                hintText: 'Enter Delivery Notes',
                textController: controller.deliveryNotes,
                maxLines: null,
                minLines: 1,
                keyboardType: TextInputType.multiline,
              ))
        ]),
      ]));
}
