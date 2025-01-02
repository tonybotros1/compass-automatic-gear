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
                        // button: newMenuButton(context, constraints, controller),
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
          constraints: constraints,
          text: 'Creation Date',
        ),
        onSort: controller.onSort,
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
        minimumSize: const Size(100, 40),
      ),
      onPressed: controller.buttonLoadingStates[menuId] == null ||
              controller.buttonLoadingStates[menuId] == false
          ? () async {
              controller.setButtonLoading(menuId, true); // Start loading
              await controller.getMenusScreens(menuId);
              controller.setButtonLoading(menuId, false); // Stop loading
              showDialog(
                  context: context,
                  builder: (context) {
                    controller.selectedMenuID.value = '';
                    return AlertDialog(
                      actionsPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      content: addNewMenuOrView(
                        controller: controller,
                        constraints: constraints,
                        context: context,
                      ),
                      actions: [
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(vertical: 16),
                        //   child: ElevatedButton(
                        //     onPressed: controller.addingNewMenuProcess.value
                        //         ? null
                        //         : () {
                        //             controller.updateScreen(menuId);
                        //             if (controller.addingNewMenuProcess.value ==
                        //                 false) {
                        //               Get.back();
                        //             }
                        //           },
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: Colors.green,
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(5),
                        //       ),
                        //     ),
                        //     child: controller.addingNewMenuProcess.value == false
                        //         ? const Text(
                        //             'Save',
                        //             style: TextStyle(color: Colors.white),
                        //           )
                        //         : const Padding(
                        //             padding: EdgeInsets.all(8.0),
                        //             child: CircularProgressIndicator(
                        //               color: Colors.white,
                        //             ),
                        //           ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            child:
                                controller.addingNewMenuProcess.value == false
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
            : const Text("View");
      }),
    )),
  ]);
}

// ElevatedButton newMenuButton(
//     BuildContext context, BoxConstraints constraints, controller) {
//   return ElevatedButton(
//     onPressed: () {
//       showDialog(
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//               actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
//               content: addNewMenuOrView(
//                 controller: controller,
//                 constraints: constraints,
//                 context: context,
//               ),
//               // actions: [
//               //   GetX<MenusController>(
//               //       builder: (controller) => Padding(
//               //             padding: const EdgeInsets.symmetric(vertical: 16),
//               //             child: ElevatedButton(
//               //               onPressed: controller.addingNewMenuProcess.value
//               //                   ? null
//               //                   : () async {
//               //                       await controller.addNewMenu();
//               //                       if (controller.addingNewMenuProcess.value ==
//               //                           false) {
//               //                         Get.back();
//               //                       }
//               //                     },
//               //               style: ElevatedButton.styleFrom(
//               //                 backgroundColor: Colors.green,
//               //                 shape: RoundedRectangleBorder(
//               //                   borderRadius: BorderRadius.circular(5),
//               //                 ),
//               //               ),
//               //               child:
//               //                   controller.addingNewMenuProcess.value == false
//               //                       ? const Text(
//               //                           'Save',
//               //                           style: TextStyle(color: Colors.white),
//               //                         )
//               //                       : const Padding(
//               //                           padding: EdgeInsets.all(8.0),
//               //                           child: CircularProgressIndicator(
//               //                             color: Colors.white,
//               //                           ),
//               //                         ),
//               //             ),
//               //           )),
//               //   ElevatedButton(
//               //     onPressed: () {
//               //       Get.back();
//               //     },
//               //     style: ElevatedButton.styleFrom(
//               //       backgroundColor: mainColor,
//               //       shape: RoundedRectangleBorder(
//               //         borderRadius: BorderRadius.circular(5),
//               //       ),
//               //     ),
//               //     child: controller.addingNewMenuProcess.value == false
//               //         ? const Text(
//               //             'Cancel',
//               //             style: TextStyle(color: Colors.white),
//               //           )
//               //         : const Padding(
//               //             padding: EdgeInsets.all(8.0),
//               //             child: CircularProgressIndicator(
//               //               color: Colors.white,
//               //             ),
//               //           ),
//               //   ),
//               // ],
//             );
//           });
//     },
//     style: ElevatedButton.styleFrom(
//       backgroundColor: Colors.green,
//       foregroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(5),
//       ),
//       elevation: 5,
//     ),
//     child: const Text('New Screen'),
//   );
// }
