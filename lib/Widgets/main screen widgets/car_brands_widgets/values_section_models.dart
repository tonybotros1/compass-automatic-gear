import 'package:datahubai/Controllers/Main%20screen%20controllers/car_brands_controller.dart';
import 'package:datahubai/Models/brands/brand_nodel_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../consts.dart';
import '../../Auth screens widgets/register widgets/search_bar.dart';
import '../auto_size_box.dart';
import 'cars_models_dialog.dart';

Widget modelsSection({required BuildContext context}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Column(
        children: [
          GetX<CarBrandsController>(
            builder: (controller) {
              return searchBar(
                width: constraints.maxWidth / 2.5,
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
      );
    },
  );
}

Widget tableOfScreens({
  required BoxConstraints constraints,
  required BuildContext context,
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
      const DataColumn(
        label: Text(''),
        columnWidth: IntrinsicColumnWidth(flex: 1),
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Name'),
        columnWidth: const IntrinsicColumnWidth(flex: 1.5),

        // onSort: controller.onSortForModels,
      ),
      // DataColumn(
      //   label: AutoSizedText(constraints: constraints, text: 'Creation Date'),
      //   // onSort: controller.onSortForModels,
      // ),
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
  BuildContext context,
  BoxConstraints constraints,
  String modelId,
  CarBrandsController controller,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            deleteSection(context, controller, modelId),
            editSection(controller, modelData, context, constraints, modelId),
            activeInActiveSection(modelData, controller, modelId),
          ],
        ),
      ),
      DataCell(Text(modelData.name)),

      // DataCell(Text(textToDate(modelData.createdAt))),
    ],
  );
}

IconButton deleteSection(
  BuildContext context,
  CarBrandsController controller,
  String modelId,
) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: context,
        content: 'The model will be deleted permanently',
        onPressed: () {
          controller.deleteModel(modelId);
        },
      );
    },
    icon: deleteIcon,
  );
}

IconButton editSection(
  CarBrandsController controller,
  Model modelData,
  context,
  constraints,
  String modelId,
) {
  return IconButton(
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
                  controller.editModel(modelId);
                }
              },
      );
    },
    icon: editIcon,
  );
}

IconButton activeInActiveSection(
  Model modelData,
  CarBrandsController controller,
  String modelId,
) {
  return IconButton(
    onPressed: () {
      bool status;
      if (modelData.status == false) {
        status = true;
      } else {
        status = false;
      }
      controller.editActiveOrInActiveStatusForModels(modelId, status);
    },
    icon: modelData.status == true ? activeIcon : inActiveIcon,
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
