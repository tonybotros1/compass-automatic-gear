import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/menus_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/add_new_menu_or_view.dart';
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
                        constraints: constraints,
                        context: context,
                        controller: controller,
                        title: 'Search for menus',
                        buttonTitle: 'New Menu',
                        button: newMenuButton(context, constraints, controller),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<MenusController>(
                      builder: (controller) {
                        if (controller.isScreenLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.allMenus.isEmpty) {
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

Widget tableOfMenus(
    {required constraints, required context, required controller}) {
  return DataTable(
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
        // onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Children',
        ),
        // onSort: controller.onSort,
      ),
      DataColumn(
        label: AutoSizedText(
          constraints: constraints,
          text: 'Creation Date',
        ),
        // onSort: controller.onSort,
      ),
      DataColumn(
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
    DataCell(
      Row(
        children: [
          const Text('Show'),
          PopupMenuButton(
            icon: const Icon(Icons.arrow_drop_down_rounded),
            color: Colors.white,
            position: PopupMenuPosition.under,
            itemBuilder: (context) {
              // Retrieve the data for sub_menus and screens
              final subMenus =
                  menuData['sub_menus'] as List<Map<String, dynamic>>;
              final screens = menuData['screens'] as List<Map<String, dynamic>>;

              return [
                PopupMenuItem(
                  enabled: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      subMenus.isNotEmpty
                          ? Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    'Sub Menus',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: subMenus.map((subMenu) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.red),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              subMenu['name'] ?? 'No Name',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                      screens.isNotEmpty
                          ? Expanded(
                              child: Column(
                                children: [
                                  const Text(
                                    'Screens',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: screens.map((screen) {
                                      return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.green),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                screen['name'] ?? 'No Name',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ));
                                    }).toList(),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ];
            },
          )
        ],
      ),
    ),
    DataCell(
      Text(
        menuData['added_date'] != null
            ? controller.textToDate(menuData['added_date']) //
            : 'N/A',
      ),
    ),
    DataCell(ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          elevation: 5,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                controller.screenName.text = menuData['name'];
                controller.route.text = menuData['routeName'];

                return AlertDialog(
                  actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
                  content: addNewMenuOrView(
                    controller: controller,
                    constraints: constraints,
                    context: context,
                    screenName: controller.screenName,
                    route: controller.route,
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                        onPressed: controller.addingNewScreenProcess.value
                            ? null
                            : () {
                                controller.updateScreen(menuId);
                                if (controller.addingNewScreenProcess.value ==
                                    false) {
                                  Get.back();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: controller.addingNewScreenProcess.value == false
                            ? const Text(
                                'Save',
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
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: controller.addingNewScreenProcess.value == false
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
        child: const Text('View'))),
  ]);
}

ElevatedButton newMenuButton(
    BuildContext context, BoxConstraints constraints, controller) {
  return ElevatedButton(
    onPressed: () {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
              content: addNewMenuOrView(
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
                                    if (controller.addingNewMenuProcess.value ==
                                        false) {
                                      Get.back();
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child:
                                controller.addingNewMenuProcess.value == false
                                    ? const Text(
                                        'Save',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                          ),
                        )),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: controller.addingNewScreenProcess.value == false
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
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 5,
    ),
    child: const Text('New Screen'),
  );
}
