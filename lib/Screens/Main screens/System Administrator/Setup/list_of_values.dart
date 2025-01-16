import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/list_of_values_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/add_or_edit_new_list.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../Widgets/main screen widgets/values_section_in_list_of_values.dart';
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
                        controller: controller,
                        title: 'Search for Lists',
                        button: newListButton(context, constraints, controller),
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
          text: 'Creation Date',
        ),
        onSort: controller.onSortForLists,
      ),
      DataColumn(
        headingRowAlignment: MainAxisAlignment.center,
        label: AutoSizedText(
          constraints: constraints,
          text: 'Action',
        ),
      ),
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
      Text(
        listData['added_date'] != null
            ? controller.textToDate(listData['added_date']) //
            : 'N/A',
      ),
    ),
    DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            style: viewButtonStyle,
            onPressed: () {
              controller.listIDToWorkWithNewValue.value = listId;
              controller.getListValues(listId);
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      actionsPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      content: valuesSection(
                        controller: controller,
                        constraints: constraints,
                        context: context,
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            style: cancelButtonStyle,
                            child: controller.addingNewListValue.value == false
                                ? const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.white),
                                  )
                                : const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    );
                  });
            },
            child: const Text('Values')),
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: editButton(controller, listData, listId, context, constraints),
        ),
        deleteSection(controller, listId, context, constraints),
      ],
    )),
  ]);
}

ElevatedButton deleteSection(controller, listId, context, constraints) {
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

ElevatedButton editButton(controller, listData, listId, context, constraints) {
  return ElevatedButton(
    onPressed: () {
      controller.listName.text = listData['list_name'];
      controller.code.text = listData['code'];
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
              content: addNewListOrEdit(
                controller: controller,
                constraints: constraints,
                context: context,
              ),
              actions: [
                GetX<ListOfValuesController>(
                    builder: (controller) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: ElevatedButton(
                            onPressed: controller.addingNewListProcess.value
                                ? null
                                : () async {
                                    if (!controller
                                        .formKeyForAddingNewList.currentState!
                                        .validate()) {
                                    } else {
                                      await controller.editList(listId);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child:
                                controller.addingNewListProcess.value == false
                                    ? const Text(
                                        'Save',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : const SizedBox(
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
    style: editButtonStyle,
    child: const Text('Edit'),
  );
}

ElevatedButton newListButton(
    BuildContext context, BoxConstraints constraints, controller) {
  return ElevatedButton(
    onPressed: () {
      controller.listName.clear();
      controller.code.clear();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
              content: addNewListOrEdit(
                controller: controller,
                constraints: constraints,
                context: context,
              ),
              actions: [
                GetX<ListOfValuesController>(
                    builder: (controller) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: ElevatedButton(
                            onPressed: controller.addingNewListProcess.value
                                ? null
                                : () async {
                                    if (!controller
                                        .formKeyForAddingNewList.currentState!
                                        .validate()) {
                                    } else {
                                      await controller.addNewList();
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child:
                                controller.addingNewListProcess.value == false
                                    ? const Text(
                                        'Save',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : const SizedBox(
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
                  child: controller.addingNewListProcess.value == false
                      ? const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        )
                      : const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            );
          });
    },
    style: newButtonStyle,
    child: const Text('New List'),
  );
}
