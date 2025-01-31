import 'package:datahubai/Controllers/Main%20screen%20controllers/job_card_controller.dart';
import 'package:datahubai/Widgets/main%20screen%20widgets/entity_informations_widgets/dynamic_field.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import '../../../Models/dynamic_field_models.dart';

Widget addNewJobCardOrEdit({
  required BoxConstraints constraints,
  required BuildContext context,
  required JobCardController controller,
  bool? canEdit,
}) {
  return SizedBox(
    width: constraints.maxWidth / 1.2,
    child: ListView(
      children: [
        Container(
          height: 50,
          decoration: BoxDecoration(
              color: Colors.grey[400], borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: Text(
              'Car Informations',
              style: fontStyleForAppBar,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        GetX<JobCardController>(builder: (controller) {
          var isBrandsLoading = controller.allBrands.isEmpty;
          return dynamicFields(dynamicConfigs: [
            DynamicConfig(
              isDropdown: false,
              flex: 1,
              fieldConfig: FieldConfig(
                textController: controller.jobCardCounter,
                labelText: 'Job Card No.',
                hintText: 'Enter Job Card No.',
                validate: false,
              ),
            ),
            DynamicConfig(
              isDropdown: true,
              flex: 1,
              dropdownConfig: DropdownConfig(
                textController: controller.carBrand,
                labelText: isBrandsLoading ? 'Loading...' : 'Brand',
                hintText: 'Select Brand',
                menuValues: isBrandsLoading ? {} : controller.allBrands,
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text('${suggestion['name']}'),
                  );
                },
                onSelected: (suggestion) {
                  controller.carBrand.text = suggestion['name'];
                  controller.allBrands.entries.where((entry) {
                    return entry.value['name'] == suggestion['name'].toString();
                  }).forEach(
                    (entry) {
                      controller.carModel.clear();
                      controller.onSelectForBrandsAndModels(entry.key);

                      controller.carBrandId.value = entry.key;
                    },
                  );
                },
              ),
            ),
            DynamicConfig(
              isDropdown: true,
              flex: 1,
              dropdownConfig: DropdownConfig(
                suggestionsController: SuggestionsController(),
                onTap: SuggestionsController().refresh,
                textController: controller.carModel,
                labelText: 'Model',
                hintText: 'Select Model',
                menuValues: controller.filterdModelsByBrands.isEmpty
                    ? {}
                    : controller.filterdModelsByBrands,
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text('${suggestion['name']}'),
                  );
                },
                onSelected: (suggestion) {
                  controller.carModel.text = suggestion['name'];
                  controller.filterdModelsByBrands.entries.where((entry) {
                    return entry.value['name'] == suggestion['name'].toString();
                  }).forEach(
                    (entry) {
                      controller.carModelId.value = entry.key;
                    },
                  );
                },
              ),
            ),
            DynamicConfig(
              isDropdown: false,
              flex: 1,
              fieldConfig: FieldConfig(
                textController: controller.plateNumber,
                labelText: 'Plate No.',
                hintText: 'Enter Plate No.',
                validate: false,
              ),
            ),
            DynamicConfig(
              isDropdown: false,
              flex: 1,
              fieldConfig: FieldConfig(
                textController: controller.carCode,
                labelText: 'Code',
                hintText: 'Enter Car Code',
                validate: false,
              ),
            ),
          ]);
        }),
        SizedBox(
          height: 20,
        ),
      ],
    ),
  );
}
