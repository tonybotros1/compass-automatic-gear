import 'package:datahubai/Models/entity%20information/entity_information_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/entity_informations_widgets/add_new_entity_or_edit.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/text_button.dart';
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
                        onChanged: (_) {
                          controller.filterEntities();
                        },
                        onPressedForClearSearch: () {
                          controller.search.value.clear();
                          controller.filterEntities();
                        },
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        title: 'Search for entities',
                        button: newContactButton(
                          context,
                          constraints,
                          controller,
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<EntityInformationsController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return Center(child: loadingProcess);
                        }
                        if (controller.allEntities.isEmpty) {
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
            ),
          );
        },
      ),
    );
  }
}

Widget tableOfScreens({
  required BoxConstraints constraints,
  required BuildContext context,
  required EntityInformationsController controller,
}) {
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
      const DataColumn(label: Text('')),
      DataColumn(
        label: AutoSizedText(text: 'Name', constraints: constraints),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(text: 'Country', constraints: constraints),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(text: 'City', constraints: constraints),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(text: 'Phone', constraints: constraints),
      ),
    ],
    rows:
        controller.filteredEntities.isEmpty &&
            controller.search.value.text.isEmpty
        ? controller.allEntities.map<DataRow>((entity) {
            final entityId = entity.id;
            return dataRowForTheTable(
              entity,
              context,
              constraints,
              entityId,
              controller,
            );
          }).toList()
        : controller.filteredEntities.map<DataRow>((entity) {
            final entityId = entity.id;
            return dataRowForTheTable(
              entity,
              context,
              constraints,
              entityId,
              controller,
            );
          }).toList(),
  );
}

DataRow dataRowForTheTable(
  EntityInformationModel entityData,
  context,
  constraints,
  entityId,
  EntityInformationsController controller,
) {
  final addresses = entityData.entityAddress;

  return DataRow(
    cells: [
      DataCell(
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            deleteSection(controller, entityId, context),
            editSection(context, entityData, constraints, entityId),
            activeInActiveSection(controller, entityData, entityId),
          ],
        ),
      ),
      DataCell(
        textForDataRowInTable(
          maxWidth: null,
          text: entityData.entityName ?? '',
        ),
      ),
      DataCell(
        textForDataRowInTable(
          maxWidth: null,
          text: (addresses != null && addresses.isNotEmpty)
              ? addresses
                    .where((address) => address.isPrimary == true)
                    .map((address) => address.country)
                    .first
                    .toString()
              : "",
        ),
      ),
      DataCell(
        textForDataRowInTable(
          maxWidth: null,
          text: (addresses != null && addresses.isNotEmpty)
              ? addresses
                    .where((address) => address.isPrimary == true)
                    .map((address) => address.city)
                    .first
                    .toString()
              : "",
        ),
      ),
      DataCell(
        textForDataRowInTable(
          maxWidth: 300,
          text: entityData.entityPhone!
              .map((phoneData) => phoneData.number)
              .take(2)
              .join('/'),
        ),
      ),
    ],
  );
}

IconButton activeInActiveSection(
  EntityInformationsController controller,
  EntityInformationModel entityData,
  String entityId,
) {
  return IconButton(
    tooltip: entityData.status == true ? 'Inactive' : 'Active',
    onPressed: () {
      bool status;
      entityData.status == false ? status = true : status = false;

      controller.changeEntityStatus(entityId, status);
    },
    icon: entityData.status == true ? activeIcon : inActiveIcon,
  );
}

IconButton deleteSection(
  EntityInformationsController controller,
  entityId,
  context,
) {
  return IconButton(
    tooltip: 'Delete',
    onPressed: () {
      alertDialog(
        context: context,
        content: "The entity will be deleted permanently",
        onPressed: () {
          controller.deleteEntity(entityId);
        },
      );
    },
    icon: deleteIcon,
  );
}

Widget editSection(
  BuildContext context,
  EntityInformationModel entityData,
  BoxConstraints constraints,
  String entityId,
) {
  return GetX<EntityInformationsController>(
    builder: (controller) {
      final isLoading = controller.buttonLoadingStates[entityId] ?? false;
      return IconButton(
        tooltip: 'Edit',
        onPressed: () async {
          controller.setButtonLoading(entityId, true);
          await controller.loadEntityData(entityData);
          controller.setButtonLoading(entityId, false);

          Get.dialog(
            barrierDismissible: false,
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              insetPadding: const EdgeInsets.all(8),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        width: constraints.maxWidth,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                          ),
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
                                return ClickableHoverText(
                                  onTap: controller.addingNewEntity.value
                                      ? null
                                      : () {
                                          controller.updateEntity(entityId);
                                        },
                                  text:
                                      controller.addingNewEntity.value == false
                                      ? 'Save'
                                      : '•••',
                                );
                              },
                            ),
                            separator(),
                            closeIcon(),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: addNewEntityOrEdit(controller: controller),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
        icon: isLoading
            ? const SpinKitDoubleBounce(color: Colors.grey, size: 20)
            : editIcon,
      );
    },
  );
}

ElevatedButton newContactButton(
  BuildContext context,
  BoxConstraints constraints,
  EntityInformationsController controller,
) {
  return ElevatedButton(
    onPressed: () {
      controller.clearAllVariables();
      Get.dialog(
        barrierDismissible: false,
        Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          insetPadding: const EdgeInsets.all(8),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: constraints.maxWidth,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
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
                          builder: (controller) => ClickableHoverText(
                            onTap: controller.addingNewEntity.value
                                ? null
                                : () async {
                                    await controller.addNewEntity();
                                  },
                            text: controller.addingNewEntity.value == false
                                ? 'Save'
                                : '•••',
                          ),
                        ),
                        separator(),
                        closeIcon(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: addNewEntityOrEdit(controller: controller),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
    style: newButtonStyle,
    child: const Text('New Entity'),
  );
}
