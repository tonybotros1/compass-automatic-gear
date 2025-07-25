import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/list_of_values_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/lists_widgets/list_dialog.dart';
import '../../../../Widgets/main screen widgets/lists_widgets/values_section_in_list_of_values.dart';
import '../../../../consts.dart';

class ListOfValues extends StatelessWidget {
  const ListOfValues({super.key});

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
                  GetX<ListOfValuesController>(
                    init: ListOfValuesController(),
                    builder: (controller) {
                      return searchBar(
                        search: controller.searchForLists,
                        constraints: constraints,
                        context: context,
                        // controller: controller,
                        title: 'Search for Lists',
                        button: controller.userEmail.value ==
                                'datahubai@gmail.com'
                            ? newListButton(context, constraints, controller)
                            : null,
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<ListOfValuesController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.allLists.isEmpty) {
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
    required ListOfValuesController controller}) {
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
        label: AutoSizedText(
          text: 'Code',
          constraints: constraints,
        ),
        onSort: controller.onSortForLists,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Name',
        ),
        onSort: controller.onSortForLists,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Parent (LOV)',
        ),
        onSort: controller.onSortForLists,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Creation Date',
        ),
        onSort: controller.onSortForLists,
      ),
      const DataColumn(
          headingRowAlignment: MainAxisAlignment.center, label: Text('')),
    ],
    rows: controller.filteredLists.isEmpty &&
            controller.searchForLists.value.text.isEmpty
        ? controller.allLists.map<DataRow>((list) {
            final listData = list.data() as Map<String, dynamic>;
            final listId = list.id;
            return dataRowForTheTable(
                listData, context, constraints, listId, controller);
          }).toList()
        : controller.filteredLists.map<DataRow>((list) {
            final listData = list.data() as Map<String, dynamic>;
            final listId = list.id;
            return dataRowForTheTable(
                listData, context, constraints, listId, controller);
          }).toList(),
  );
}

DataRow dataRowForTheTable(Map<String, dynamic> listData, context, constraints,
    listId, ListOfValuesController controller) {
  return DataRow(cells: [
    DataCell(Text(
      listData['code'] ?? 'no code',
    )),
    DataCell(
      Text(
        listData['list_name'] ?? 'no list name',
      ),
    ),
    DataCell(
      Text(controller.getListNameById(listData['mastered_by'])),
    ),
    DataCell(
      Text(
        listData['added_date'] != null
            ? textToDate(listData['added_date']) //
            : 'N/A',
      ),
    ),
    DataCell(Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        valSectionInTheTable(
            controller, listId, context, constraints, listData),
        controller.userEmail.value == 'datahubai@gmail.com'
            ? publicPrivateSection(listData, controller, listId)
            : const SizedBox(),
        controller.userEmail.value == 'datahubai@gmail.com'
            ? editButton(controller, listData, listId, context, constraints)
            : const SizedBox(),
        controller.userEmail.value == 'datahubai@gmail.com'
            ? deleteSection(controller, listId, context)
            : const SizedBox(),
      ],
    )),
  ]);
}

ElevatedButton publicPrivateSection(
    listData, ListOfValuesController controller, listId) {
  return ElevatedButton(
      style: listData['is_public'] == false
          ? privateButtonStyle
          : publicButtonStyle,
      onPressed: () {
        bool status;
        if (listData['is_public'] == false) {
          status = true;
        } else {
          status = false;
        }
        controller.editPublicOrPrivate(listId, status);
      },
      child: listData['is_public'] == true
          ? const Text('Public')
          : const Text('Private'));
}

ElevatedButton valSectionInTheTable(ListOfValuesController controller, listId,
    context, BoxConstraints constraints, listData) {
  return ElevatedButton(
      style: viewButtonStyle,
      onPressed: () {
        controller.searchForValues.value.clear();
        controller.valueMap.clear();
        controller.listIDToWorkWithNewValue.value = listId;
        controller.getListValues(listId, listData['mastered_by']);
        Get.dialog(
            barrierDismissible: false,
            Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: SizedBox(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        color: mainColor,
                      ),
                      child: Row(
                        children: [
                          Text(
                            controller.getScreenName(),
                            style: fontStyleForScreenNameUsedInButtons,
                          ),
                          const Spacer(),
                          closeButton
                        ],
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: valuesSection(
                        constraints: constraints,
                        context: context,
                      ),
                    ))
                  ],
                ),
              ),
            ));
      },
      child: const Text('Values'));
}

ElevatedButton deleteSection(controller, listId, context) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        alertDialog(
            context: context,
            controller: controller,
            content: "The list will be deleted permanently",
            onPressed: () {
              controller.deleteList(listId);
            });
      },
      child: const Text("Delete"));
}

ElevatedButton editButton(
    ListOfValuesController controller, listData, listId, context, constraints) {
  return ElevatedButton(
    onPressed: () {
      controller.listName.text = listData['list_name'] ?? '';
      controller.code.text = listData['code'] ?? '';
      controller.masteredByIdForList.value = '';
      controller.masteredByForList.text =
          controller.getListNameById(listData['mastered_by']);
      listOfValuesDialog(
          constraints: constraints,
          controller: controller,
          onPressed: controller.addingNewListProcess.value
              ? null
              : () async {
                  if (!controller.formKeyForAddingNewList.currentState!
                      .validate()) {
                  } else {
                    await controller.editList(listId);
                  }
                });
    },
    style: editButtonStyle,
    child: const Text('Edit'),
  );
}

ElevatedButton newListButton(BuildContext context, BoxConstraints constraints,
    ListOfValuesController controller) {
  return ElevatedButton(
    onPressed: () {
      controller.searchForLists.value.clear();
      controller.listName.clear();
      controller.code.clear();
      controller.masteredByForList.clear();
      controller.masteredByIdForList.value = '';
      listOfValuesDialog(
          constraints: constraints,
          controller: controller,
          onPressed: controller.addingNewListProcess.value
              ? null
              : () async {
                  if (!controller.formKeyForAddingNewList.currentState!
                      .validate()) {
                  } else {
                    await controller.addNewList();
                  }
                });
    },
    style: newButtonStyle,
    child: const Text('New List'),
  );
}
