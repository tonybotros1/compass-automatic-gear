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
                        onChanged: (_) {
                          controller.filterLists();
                        },
                        onPressedForClearSearch: () {
                          controller.searchForLists.value.clear();
                          controller.filterLists();
                        },
                        search: controller.searchForLists,
                        constraints: constraints,
                        context: context,
                        title: 'Search for Lists',
                        button: newListButton(context, constraints, controller),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<ListOfValuesController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return Center(child: loadingProcess);
                        }
                        if (controller.listMap.isEmpty) {
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
  required ListOfValuesController controller,
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
        label: SizedBox(),
        columnWidth: IntrinsicColumnWidth(flex: 0.5),
      ),
      DataColumn(
        label: AutoSizedText(text: 'Code', constraints: constraints),
        onSort: controller.onSortForLists,
        columnWidth: const IntrinsicColumnWidth(flex: 1.5),
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Name'),
        onSort: controller.onSortForLists,
        columnWidth: const IntrinsicColumnWidth(flex: 1.5),
      ),
      DataColumn(
        label: AutoSizedText(constraints: constraints, text: 'Parent (LOV)'),
        onSort: controller.onSortForLists,
        columnWidth: const IntrinsicColumnWidth(flex: 1.5),
      ),
      // DataColumn(
      //   label: AutoSizedText(constraints: constraints, text: 'Creation Date'),
      //   onSort: controller.onSortForLists,
      //   columnWidth: const IntrinsicColumnWidth(flex: 1),
      // ),
    ],
    rows:
        controller.filteredLists.isEmpty &&
            controller.searchForLists.value.text.isEmpty
        ? controller.listMap.entries.map<DataRow>((list) {
            final listId = list.key;
            return dataRowForTheTable(
              list.value,
              context,
              constraints,
              listId,
              controller,
            );
          }).toList()
        : controller.filteredLists.entries.map<DataRow>((list) {
            final listId = list.key;
            return dataRowForTheTable(
              list.value,
              context,
              constraints,
              listId,
              controller,
            );
          }).toList(),
  );
}

DataRow dataRowForTheTable(
  Map<String, dynamic> listData,
  BuildContext context,
  BoxConstraints constraints,
  String listId,
  ListOfValuesController controller,
) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            deleteSection(controller, listId, context),
            editButton(controller, listData, listId, context, constraints),
            valSectionInTheTable(
              controller,
              listId,
              context,
              constraints,
              listData,
            ),
            // publicPrivateSection(listData, controller, listId),
          ],
        ),
      ),
      DataCell(Text(listData['code'])),
      DataCell(Text(listData['name'])),
      DataCell(Text(listData['mastered_by'])),
      // DataCell(Text(textToDate(listData['createdAt']))),
    ],
  );
}

// ElevatedButton publicPrivateSection(
//   ListModel listData,
//   ListOfValuesController controller,
//   String listId,
// ) {
//   return ElevatedButton(
//     style: listData.status == false ? privateButtonStyle : publicButtonStyle,
//     onPressed: () {
//       bool status;
//       if (listData.status == false) {
//         status = true;
//       } else {
//         status = false;
//       }
//       controller.editPublicOrPrivate(listId, status);
//     },
//     child: listData.status == true
//         ? const Text('Public')
//         : const Text('Private'),
//   );
// }

IconButton valSectionInTheTable(
  ListOfValuesController controller,
  String listId,
  BuildContext context,
  BoxConstraints constraints,
  Map<String, dynamic> listData,
) {
  return IconButton(
    onPressed: () {
      controller.searchForValues.value.clear();
      controller.valueMap.clear();
      controller.listIDToWorkWithNewValue.value = listId;
      controller.getListValues(listId, listData['mastered_by_id']);
      Get.dialog(
        barrierDismissible: false,
        Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth / 2,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                    color: mainColor,
                  ),
                  child: Row(
                    children: [
                      Text(
                        controller.getScreenName(),
                        style: fontStyleForScreenNameUsedInButtons,
                      ),
                      const Spacer(),
                      closeIcon(),
                    ],
                  ),
                ),
                Expanded(
                  child: valuesSection(
                    context: context,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    icon: valuesIcon,
  );
}

IconButton deleteSection(
  ListOfValuesController controller,
  String listId,
  BuildContext context,
) {
  return IconButton(
    onPressed: () {
      alertDialog(
        context: context,
        content: "The list will be deleted permanently",
        onPressed: () {
          controller.deleteList(listId);
        },
      );
    },
    icon: deleteIcon,
  );
}

IconButton editButton(
  ListOfValuesController controller,
  Map<String, dynamic> listData,
  String listId,
  BuildContext context,
  BoxConstraints constraints,
) {
  return IconButton(
    onPressed: () {
      controller.listName.text = listData['name'] ?? '';
      controller.code.text = listData['code'] ?? '';
      controller.masteredByIdForList.value = '';
      controller.masteredByForList.text = listData['mastered_by'];
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
              },
      );
    },
    icon: editIcon,
  );
}

ElevatedButton newListButton(
  BuildContext context,
  BoxConstraints constraints,
  ListOfValuesController controller,
) {
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
              },
      );
    },
    style: newButtonStyle,
    child: const Text('New List'),
  );
}
