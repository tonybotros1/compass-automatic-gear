import 'package:datahubai/Controllers/Main%20screen%20controllers/car_brands_controller.dart';
import 'package:datahubai/Models/brands/brand_nodel_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../consts.dart';
import '../../Auth screens widgets/register widgets/search_bar.dart';
import '../auto_size_box.dart';
import 'cars_models_dialog.dart';

Widget modelsSection({
  required BoxConstraints constraints,
  required BuildContext context,
}) {
  return Container(
    width: constraints.maxWidth,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        GetX<CarBrandsController>(
          builder: (controller) {
            return searchBar(
              onChanged: (_) {
                controller.filterModels();
              },
              onPressedForClearSearch: () {
                controller.searchForModels.value.clear();
                controller.filterModels();
              },
              search: controller.searchForModels,
              constraints: constraints,
              context: context,
              // controller: controller,
              title: 'Search for models',
              button: newModelButton(context, constraints, controller),
            );
          },
        ),
        Expanded(
          child: GetX<CarBrandsController>(
            builder: (controller) {
              if (controller.loadingModels.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.allModels.isEmpty) {
                return const Center(child: Text('No Element'));
              }
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SizedBox(
                  width: constraints.maxWidth,
                  child: tableOfScreens(
                    constraints: constraints,
                    context: context,
                    controller: controller,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

Widget tableOfScreens({
  required constraints,
  required context,
  required CarBrandsController controller,
}) {
  return DataTable(
    dataRowMaxHeight: 40,
    dataRowMinHeight: 30,
    columnSpacing: 5,
    horizontalMargin: horizontalMarginForTable,
    showBottomBorder: true,
    dataTextStyle: regTextStyle,
    headingTextStyle: fontStyleForTableHeader,
    sortColumnIndex: controller.sortColumnIndex.value,
    sortAscending: controller.isAscending.value,
    headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
    columns: [
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Name'),
        // onSort: controller.onSortForModels,
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Creation Date'),
        // onSort: controller.onSortForModels,
      ),
      const DataColumn(label: Text('')),
    ],
    rows:
        controller.filteredModels.isEmpty &&
            controller.searchForModels.value.text.isEmpty
        ? controller.allModels.map<DataRow>((model) {
            final modelData = model;
            final modelId = model.id;
            return dataRowForTheTable(
              modelData,
              context,
              constraints,
              modelId,
              controller,
            );
          }).toList()
        : controller.filteredModels.map<DataRow>((model) {
            final modelData = model;
            final modelId = model.id;
            return dataRowForTheTable(
              modelData,
              context,
              constraints,
              modelId,
              controller,
            );
          }).toList(),
  );
}

DataRow dataRowForTheTable(
  Model modelData,
  context,
  constraints,
  String modelId,
  CarBrandsController controller,
) {
  return DataRow(
    cells: [
      DataCell(Text(modelData.name)),
      DataCell(Text(textToDate(modelData.createdAt))),
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            activeInActiveSection(modelData, controller, modelId),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: editSection(
                controller,
                modelData,
                context,
                constraints,
                modelId,
              ),
            ),
            deleteSection(context, controller, modelId),
          ],
        ),
      ),
    ],
  );
}

ElevatedButton deleteSection(context, CarBrandsController controller,String modelId) {
  return ElevatedButton(
    style: deleteButtonStyle,
    onPressed: () {
      alertDialog(
        context: context,
        content: 'The model will be deleted permanently',
        onPressed: () {
          controller.deleteModel(modelId);
        },
      );
    },
    child: const Text('Delete'),
  );
}

ElevatedButton editSection(
  CarBrandsController controller,
  Model modelData,
  context,
  constraints,
  String modelId,
) {
  return ElevatedButton(
    style: editButtonStyle,
    onPressed: () {
      controller.modelName.text = modelData.name;
      carModelsDialog(
        constraints: constraints,
        controller: controller,
        onPressed: controller.addingNewmodelValue.value
            ? null
            : () async {
                if (!controller.formKeyForAddingNewvalue.currentState!
                    .validate()) {
                } else {
                  controller.editModel(
                    modelId,
                  );
                }
              },
      );
    },
    child: const Text('Edit'),
  );
}

ElevatedButton activeInActiveSection(
  Model modelData,
  CarBrandsController controller,
  String modelId,
) {
  return ElevatedButton(
    style: modelData.status == false ? inActiveButtonStyle : activeButtonStyle,
    onPressed: () {
      bool status;
      if (modelData.status == false) {
        status = true;
      } else {
        status = false;
      }
      controller.editActiveOrInActiveStatusForModels(modelId, status);
    },
    child: modelData.status == true
        ? const Text('Active')
        : const Text('Inactive'),
  );
}

ElevatedButton newModelButton(
  BuildContext context,
  BoxConstraints constraints,
  CarBrandsController controller,
) {
  return ElevatedButton(
    onPressed: () {
      controller.modelName.clear();
      carModelsDialog(
        constraints: constraints,
        controller: controller,
        onPressed: controller.addingNewmodelValue.value
            ? null
            : () async {
                if (!controller.formKeyForAddingNewvalue.currentState!
                    .validate()) {
                } else {
                  await controller.addNewModel(
                    controller.brandIdToWorkWith.value,
                  );
                }
              },
      );
    },
    style: newButtonStyle,
    child: const Text('New model'),
  );
}
