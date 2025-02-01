import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/menus_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/menus_widgets/add_or_edit_menu.dart';
import '../../../../Widgets/main screen widgets/menus_widgets/veiw_menu.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../consts.dart';

class Menus extends StatelessWidget {
  const Menus({super.key});

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
                  GetX<MenusController>(
                    init: MenusController(),
                    builder: (controller) {
                      return searchBar(
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        controller: controller,
                        title: 'Search for menus',
                        button: newMenuButton(context, constraints, controller),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<MenusController>(
                      builder: (controller) {
                        // print(controller.isScreenLoading.value);
                        if (controller.isScreenLoading.value == true &&
                            controller.allMenus.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.isScreenLoading.value == false &&
                            controller.allMenus.isEmpty) {
                          return const Center(
                            child: Text('No Element'),
                          );
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis
                              .vertical, // Horizontal scrolling for the table
                          child: SizedBox(
                            width: constraints.maxWidth,
                            child: tableOfMenus(
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

Widget buildCell(String content) {
  return Container(
    color: Colors.white,
    margin: const EdgeInsets.all(1),
    child: Center(
      child: Text(
        content,
      ),
    ),
  );
}

Widget tableOfMenus(
    {required constraints, required context, required controller}) {
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
          text: 'Menu',
          constraints: constraints,
        ),
        onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          maxLines: 2,
          text: 'Code',
          constraints: constraints,
        ),
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
    rows:
        controller.filteredMenus.isEmpty && controller.search.value.text.isEmpty
            ? controller.allMenus.entries.map<DataRow>((entry) {
                final menuData = entry.value;
                final menuId = entry.key;
                return dataRowForTheTable(
                    menuData, context, constraints, menuId, controller);
              }).toList()
            : controller.filteredMenus.entries.map<DataRow>((entry) {
                final menuData = entry.value;
                final menuId = entry.key;
                return dataRowForTheTable(
                    menuData, context, constraints, menuId, controller);
              }).toList(),
  );
}

DataRow dataRowForTheTable(
    Map<String, dynamic> menuData, context, constraints, menuId, controller) {
  return DataRow(cells: [
    DataCell(Text(
      menuData['name'] ?? 'no name',
    )),
    DataCell(Text(
      menuData['description'] ?? 'no description',
    )),
    DataCell(
      Text(
        menuData['added_date'] != null
            ? textToDate(menuData['added_date']) //
            : 'N/A',
      ),
    ),
    DataCell(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        viewSection(controller, menuId, context, constraints),
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child:
              editSection(controller, menuId, context, constraints, menuData),
        ),
        deleteSection(controller, menuId, context, constraints)
      ],
    )),
  ]);
}

ElevatedButton deleteSection(
    MenusController controller, menuId, context, constraints) {
  return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        alertDialog(
            context: context,
            controller: controller,
            content: 'The menu will be deleted permanently',
            onPressed: () {
              controller.deleteMenuAndUpdateChildren(menuId);
            });
      },
      child: const Text("Delete"));
}

ElevatedButton editSection(controller, menuId, context, constraints, menuData) {
  return ElevatedButton(
      style: editButtonStyle,
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              controller.menuName.text = menuData['name'];
              controller.description.text = menuData['description'];
              return AlertDialog(
                actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
                content: addOrEditMenu(
                  controller: controller,
                  constraints: constraints,
                  context: context,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                        onPressed: () async {
                          await controller.editMenu(menuId);
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: cancelButtonStyle,
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                ],
              );
            });
      },
      child: const Text("Edit"));
}

ElevatedButton viewSection(controller, menuId, context, constraints) {
  return ElevatedButton(
    style: viewButtonStyle,
    onPressed: controller.buttonLoadingStates[menuId] == null ||
            controller.buttonLoadingStates[menuId] == false
        ? () async {
            controller.menuIDFromList.clear();
            controller.setButtonLoading(menuId, true); // Start loading
            await controller.listOfMenusAndScreen();
            await controller.getMenusScreens(menuId);
            controller.setButtonLoading(menuId, false); // Stop loading
            showDialog(
                context: context,
                builder: (context) {
                  controller.selectedMenuID.value = '';
                  return AlertDialog(
                    actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
                    content: viewMenu(
                      controller: controller,
                      constraints: constraints,
                      context: context,
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 23, vertical: 10),
                        child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            style: cancelButtonStyle,
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ],
                  );
                });
          }
        : null,
    child: Obx(() {
      bool isLoading = controller.buttonLoadingStates[menuId] ?? false;
      return isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Icon(
              Icons.account_tree_outlined,
              color: Colors.white,
              fill: 0,
            );
    }),
  );
}

ElevatedButton newMenuButton(
    BuildContext context, BoxConstraints constraints, controller) {
  return ElevatedButton(
    onPressed: () {
      controller.menuName.clear();
      controller.description.clear();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
              content: addOrEditMenu(
                controller: controller,
                constraints: constraints,
                context: context,
              ),
              actions: [
                GetX<MenusController>(
                    builder: (controller) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: ElevatedButton(
                              onPressed: controller.addingNewMenuProcess.value
                                  ? null
                                  : () async {
                                      await controller.addNewMenu();
                                      if (controller
                                              .addingNewMenuProcess.value ==
                                          false) {
                                        Get.back();
                                      }
                                    },
                              style: saveButtonStyle,
                              child:
                                  controller.addingNewMenuProcess.value == false
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
                                        )),
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
    child: const Text('New Menu'),
  );
}
