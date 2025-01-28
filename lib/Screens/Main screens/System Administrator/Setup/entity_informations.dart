import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/entity_informations_widgets/add_new_entity_or_edit.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../consts.dart';

class EntityInformations extends StatelessWidget {
  const EntityInformations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: screenPadding,
            child: Container(
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  GetX<EntityInformationsController>(
                    init: EntityInformationsController(),
                    builder: (controller) {
                      return searchBar(
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        controller: controller,
                        title: 'Search for Entities',
                        button:
                            newContactButton(context, constraints, controller),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<EntityInformationsController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.allEntities.isEmpty) {
                          return const Center(
                            child: Text('No Element'),
                          );
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
            ),
          );
        },
      ),
    );
  }
}

Widget tableOfScreens(
    {required constraints,
    required context,
    required EntityInformationsController controller}) {
  return DataTable(
    dataRowMaxHeight: 40,
    dataRowMinHeight: 30,
    columnSpacing: 5,
    showBottomBorder: true,
    dataTextStyle: regTextStyle,
    headingTextStyle: fontStyleForTableHeader,
    sortColumnIndex: controller.sortColumnIndex.value,
    sortAscending: controller.isAscending.value,
    headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
    columns: [
      DataColumn(
        label: AutoSizedText(
          text: 'Name',
          constraints: constraints,
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Code',
        ),
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Status',
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Creation Date',
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: AutoSizedText(
          constraints: constraints,
          text: 'Action',
        ),
      ),
    ],
    rows: controller.filteredEntities.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allEntities.map<DataRow>((entity) {
            final entityData = entity.data() as Map<String, dynamic>;
            final entityId = entity.id;
            return dataRowForTheTable(
                entityData, context, constraints, entityId, controller);
          }).toList()
        : controller.filteredEntities.map<DataRow>((entity) {
            final entityData = entity.data() as Map<String, dynamic>;
            final entityId = entity.id;
            return dataRowForTheTable(
                entityData, context, constraints, entityId, controller);
          }).toList(),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> entityData, context,
    constraints, entityId, EntityInformationsController controller) {
  return DataRow(cells: [
    DataCell(Text(
      entityData['entity_name'] ?? 'no name',
    )),
    DataCell(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entityData['entity_code'][0] ?? '',
          ),
          entityData['entity_code'].length == 2
              ? Text(
                  entityData['entity_code'][1] ?? '',
                )
              : SizedBox(),
        ],
      ),
    ),
    DataCell(
      Text(
        entityData['entity_status'][0] ?? '',
      ),
    ),
    DataCell(
      Text(
        entityData['added_date'] != null && entityData['added_date'] != ''
            ? textToDate(entityData['added_date']) //
            : 'N/A',
      ),
    ),
    DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(right: 5),
        //   child: editSection(
        //       context, controller, variableData, constraints, variableId),
        // ),
        // deleteSection(controller, variableId, context),
      ],
    )),
  ]);
}

ElevatedButton newContactButton(BuildContext context,
    BoxConstraints constraints, EntityInformationsController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.clearAllVariables();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
              content: addNewEntityOrEdit(
                controller: controller,
                constraints: constraints,
                context: context,
              ),
              actions: [
                GetX<EntityInformationsController>(
                    builder: (controller) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: ElevatedButton(
                            onPressed: controller.addingNewEntity.value
                                ? null
                                : () async {
                                    await controller.addNewEntity();
                                  },
                            style: saveButtonStyle,
                            child: controller.addingNewEntity.value == false
                                ? const Text(
                                    'Save',
                                    style: TextStyle(color: Colors.white),
                                  )
                                : SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                          ),
                        )),
                ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: cancelButtonStyle,
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            );
          });
    },
    style: newButtonStyle,
    child: const Text('New Entity'),
  );
}
