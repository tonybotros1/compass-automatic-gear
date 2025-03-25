import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../../Models/entity_model.dart';
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
                        title: 'Search for entities',
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
    horizontalMargin: horizontalMarginForTable,
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
          text: 'Phone',
          constraints: constraints,
        ),
      ),
      const DataColumn(label: Text('')),
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
    DataCell(textForDataRowInTable(
        maxWidth: null, text: entityData['entity_name'] ?? 'no name')),
    DataCell(
      textForDataRowInTable(
          maxWidth: 300,
          text: (entityData['entity_phone'] as List)
              .map((phoneData) => phoneData['number'])
              .take(2)
              .join('/')),
    ),
    DataCell(Row(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        activeInActiveSection(controller, entityData, entityId),
        editSection(context, controller, entityData, constraints, entityId),
        deleteSection(controller, entityId, context),
      ],
    )),
  ]);
}

ElevatedButton activeInActiveSection(EntityInformationsController controller,
    Map<String, dynamic> entityData, String entityId) {
  return ElevatedButton(
      style: entityData['status'] == false
          ? inActiveButtonStyle
          : activeButtonStyle,
      onPressed: () {
        bool status;
        entityData['status'] == false ? status = true : status = false;

        controller.changeEntityStatus(entityId, status);
      },
      child: entityData['status'] == true
          ? const Text('Active')
          : const Text('Inactive'));
}

ElevatedButton deleteSection(
    EntityInformationsController controller, entityId, context) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        alertDialog(
            context: context,
            controller: controller,
            content: "The entity will be deleted permanently",
            onPressed: () {
              controller.deleteEntity(entityId);
            });
      },
      child: const Text("Delete"));
}

ElevatedButton editSection(context, EntityInformationsController controller,
    Map<String, dynamic> entityData, constraints, entityId) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () {
        controller.loadEntityData(EntityModel.fromJson(entityData));
        Get.dialog(
            barrierDismissible: false,
            Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              insetPadding: const EdgeInsets.all(8),
              child: LayoutBuilder(builder: (context, constraints) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5)),
                        color: mainColor,
                      ),
                      child: Row(
                        spacing: 10,
                        children: [
                          Text(
                            controller.getScreenName(),
                            style: fontStyleForScreenNameUsedInButtons,
                          ),
                          const Spacer(),
                          GetX<EntityInformationsController>(
                              builder: (controller) {
                            return ElevatedButton(
                              onPressed: controller.addingNewEntity.value
                                  ? null
                                  : () {
                                      controller.editEntity(entityId);
                                    },
                              style: new2ButtonStyle,
                              child: controller.addingNewEntity.value == false
                                  ? const Text(
                                      'Save',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  : const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                            );
                          }),
                          closeButton
                        ],
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: addNewEntityOrEdit(
                        controller: controller,
                        constraints: constraints,
                      ),
                    ))
                  ],
                );
              }),
            ));
      },
      child: const Text('Edit'));
}

ElevatedButton newContactButton(BuildContext context,
    BoxConstraints constraints, EntityInformationsController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.clearAllVariables();
      Get.dialog(
          barrierDismissible: false,
          Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            insetPadding: const EdgeInsets.all(8),
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5)),
                      color: mainColor,
                    ),
                    child: Row(
                      spacing: 10,
                      children: [
                        Text(
                          controller.getScreenName(),
                          style: fontStyleForScreenNameUsedInButtons,
                        ),
                        const Spacer(),
                        GetX<EntityInformationsController>(
                            builder: (controller) => ElevatedButton(
                                  onPressed: controller.addingNewEntity.value
                                      ? null
                                      : () async {
                                          await controller.addNewEntity();
                                        },
                                  style: new2ButtonStyle,
                                  child: controller.addingNewEntity.value ==
                                          false
                                      ? const Text(
                                          'Save',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        )
                                      : const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                )),
                        closeButton
                      ],
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: addNewEntityOrEdit(
                      controller: controller,
                      constraints: constraints,
                    ),
                  ))
                ],
              );
            }),
          ));
    },
    style: newButtonStyle,
    child: const Text('New Entity'),
  );
}
