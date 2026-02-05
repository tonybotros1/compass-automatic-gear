import 'package:data_table_2/data_table_2.dart';
import 'package:datahubai/Models/entity%20information/entity_information_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../../Widgets/drop_down_menu3.dart';
import '../../../../Widgets/main screen widgets/entity_informations_widgets/add_new_entity_or_edit.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/my_text_field.dart';
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
            child: SizedBox(
              width: constraints.maxWidth,

              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GetX<EntityInformationsController>(
                      init: EntityInformationsController(),
                      builder: (controller) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth - 28,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  spacing: 10,
                                  children: [
                                    myTextFormFieldWithBorder(
                                      width: 300,
                                      labelText: 'Name',
                                      controller: controller.entityNameFilter,
                                    ),
                                    CustomDropdown(
                                      width: 200,
                                      showedSelectedName: 'name',
                                      textcontroller:
                                          controller.countryFilter.text,
                                      hintText: 'Country',
                                      onChanged: (key, value) async {
                                        // controller.getModelsByCarBrand(key);
                                        controller.countryFilterId.value = key;
                                        controller.countryFilter.text =
                                            value['name'];
                                        controller.cityFilterId.value = '';
                                        controller.cityFilter.text = '';
                                      },
                                      onDelete: () {
                                        controller.countryFilterId.value = '';
                                        controller.countryFilter.clear();
                                        controller.cityFilterId.value = '';
                                        controller.cityFilter.text = '';
                                      },
                                      onOpen: () {
                                        return controller.getCountries();
                                      },
                                    ),
                                    CustomDropdown(
                                      width: 200,
                                      showedSelectedName: 'name',
                                      textcontroller:
                                          controller.cityFilter.text,
                                      hintText: 'City',
                                      onChanged: (key, value) async {
                                        // controller.getModelsByCarBrand(key);
                                        controller.cityFilterId.value = key;
                                        controller.cityFilter.text =
                                            value['name'];
                                      },
                                      onDelete: () {
                                        controller.cityFilterId.value = '';
                                        controller.cityFilter.text = '';
                                      },
                                      onOpen: () {
                                        return controller.getCitiesByCountryID(
                                          controller.countryFilterId.value,
                                        );
                                      },
                                    ),
                                    myTextFormFieldWithBorder(
                                      width: 200,
                                      labelText: 'Phone Number',
                                      controller: controller.phoneNumberFilter,
                                    ),
                                  ],
                                ),
                                Row(
                                  spacing: 10,
                                  children: [
                                    ElevatedButton(
                                      style: findButtonStyle,
                                      onPressed:
                                          controller.isScreenLoding.isFalse
                                          ? () async {
                                              controller.filterSearch();
                                            }
                                          : null,
                                      child: controller.isScreenLoding.isFalse
                                          ? Text(
                                              'Find',
                                              style:
                                                  fontStyleForElevatedButtons,
                                            )
                                          : loadingProcess,
                                    ),
                                    newContactButton(
                                      context,
                                      constraints,
                                      controller,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // GetX<EntityInformationsController>(
                    //   init: EntityInformationsController(),
                    //   builder: (controller) {
                    //     return searchBar(
                    //       onChanged: (_) {
                    //         controller.filterEntities();
                    //       },
                    //       onPressedForClearSearch: () {
                    //         controller.search.value.clear();
                    //         controller.filterEntities();
                    //       },
                    //       search: controller.search,
                    //       constraints: constraints,
                    //       context: context,
                    //       title: 'Search for entities',
                    //       button: newContactButton(
                    //         context,
                    //         constraints,
                    //         controller,
                    //       ),
                    //     );
                    //   },
                    // ),
                    GetX<EntityInformationsController>(
                      builder: (controller) {
                        return Container(
                          // padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                              topLeft: Radius.circular(2),
                              topRight: Radius.circular(2),
                            ),
                          ),
                          child: SizedBox(
                            width: constraints.maxWidth,
                            height: constraints.maxHeight * 6 / 7,

                            // constraints.maxHeight -
                            // (constraints.maxHeight / 7),
                            child: tableOfScreens(
                              constraints: constraints,
                              context: context,
                              controller: controller,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
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
  return PaginatedDataTable2(
    border: TableBorder.symmetric(
      inside: BorderSide(color: Colors.grey.shade200, width: 0.5),
    ),
    autoRowsToHeight: true,
    horizontalMargin: horizontalMarginForTable,
    columnSpacing: 5,
    showFirstLastButtons: true,
    sortColumnIndex: controller.sortColumnIndex.value,
    sortAscending: controller.isAscending.value,
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
      DataColumn(
        label: AutoSizedText(text: 'Contact Person', constraints: constraints),
      ),
    ],
    source: CardDataSource(
      cards: controller.allEntities.isEmpty ? [] : controller.allEntities,
      context: context,
      constraints: constraints,
      controller: controller,
    ),
  );
}

DataRow dataRowForTheTable(
  EntityInformationModel entityData,
  BuildContext context,
  BoxConstraints constraints,
  String entityId,
  EntityInformationsController controller,
  int index,
) {
  final addresses = entityData.entityAddress;
  final isEvenRow = index % 2 == 0;

  return DataRow(
    color: WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.grey.shade400;
      }
      return isEvenRow ? Colors.white : Colors.grey.shade100;
    }),
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
          formatDouble: false,
          text: entityData.entityName ?? '',
        ),
      ),
      DataCell(
        textForDataRowInTable(
          maxWidth: null,
          formatDouble: false,
          text: (addresses != null && addresses.isNotEmpty)
              ? addresses
                    .where((address) => address.isPrimary == true)
                    .map((address) => address.country ?? '')
                    .first
                    .toString()
              : "",
        ),
      ),
      DataCell(
        textForDataRowInTable(
          maxWidth: null,
          formatDouble: false,
          text: (addresses != null && addresses.isNotEmpty)
              ? addresses
                    .where((address) => address.isPrimary == true)
                    .map((address) => address.city ?? '')
                    .first
                    .toString()
              : "",
        ),
      ),
      DataCell(
        textForDataRowInTable(
          maxWidth: 300,
          formatDouble: false,
          text: entityData.entityPhone!
              .map((phoneData) => phoneData.number ?? '')
              .take(2)
              .join('/'),
        ),
      ),
      DataCell(
        textForDataRowInTable(
          maxWidth: 300,
          formatDouble: false,
          text: entityData.entityPhone!
              .map((phoneData) => phoneData.name ?? '')
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

class CardDataSource extends DataTableSource {
  final List<EntityInformationModel> cards;
  final BuildContext context;
  final BoxConstraints constraints;
  final EntityInformationsController controller;

  CardDataSource({
    required this.cards,
    required this.context,
    required this.constraints,
    required this.controller,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= cards.length) return null;

    final entityDate = cards[index];
    final cardId = entityDate.id ?? '';

    return dataRowForTheTable(
      entityDate,
      context,
      constraints,
      cardId,
      controller,
      index,
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => cards.length;

  @override
  int get selectedRowCount => 0;
}
