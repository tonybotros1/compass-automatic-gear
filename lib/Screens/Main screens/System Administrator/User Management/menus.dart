import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/menus_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/menus_widgets/menus_dialog.dart';
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
                        onChanged: (_) {
                          controller.filterMenus();
                        },
                        onPressedForClearSearch: () {
                          controller.search.value.clear();
                          controller.filterMenus();
                        },
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        title: 'Search for menus',
                        button: newMenuButton(context, constraints, controller),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<MenusController>(
                      builder: (controller) {
                        if (controller.isScreenLoading.value == true &&
                            controller.allMenus.isEmpty) {
                          return Center(child: loadingProcess);
                        }
                        if (controller.isScreenLoading.value == false &&
                            controller.allMenus.isEmpty) {
                          return const Center(child: Text('No Element'));
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
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
    child: Center(child: Text(content)),
  );
}

Widget tableOfMenus({
  required BoxConstraints constraints,
  required BuildContext context,
  required MenusController controller,
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
      DataColumn(
        label: AutoSizedText(text: 'Menu', constraints: constraints),
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
        label: AutoSizedText(constraints: constraints, text: 'Creation Date'),
        onSort: controller.onSort,
      ),
      const DataColumn(label: Text('')),
    ],
    rows:
        controller.filteredMenus.isEmpty && controller.search.value.text.isEmpty
        ? controller.allMenus.entries.map<DataRow>((entry) {
            final menuData = entry.value;
            final menuId = entry.key;
            return dataRowForTheTable(
              menuData,
              context,
              constraints,
              menuId,
              controller,
            );
          }).toList()
        : controller.filteredMenus.entries.map<DataRow>((entry) {
            final menuData = entry.value;
            final menuId = entry.key;
            return dataRowForTheTable(
              menuData,
              context,
              constraints,
              menuId,
              controller,
            );
          }).toList(),
  );
}

DataRow dataRowForTheTable(
  Map menuData,
  context,
  constraints,
  menuId,
  controller,
) {
  return DataRow(
    cells: [
      DataCell(Text(menuData["name"] ?? '')),
      DataCell(Text(menuData["code"] ?? '')),
      DataCell(Text(textToDate(menuData["createdAt"] ?? ''))),
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            viewSection(controller, menuId, context, constraints),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: editSection(
                controller,
                menuId,
                context,
                constraints,
                menuData,
              ),
            ),
            deleteSection(controller, menuId, context, constraints),
          ],
        ),
      ),
    ],
  );
}

ElevatedButton deleteSection(
  MenusController controller,
  menuId,
  context,
  constraints,
) {
  return ElevatedButton(
    style: deleteButtonStyle,
    onPressed: () {
      alertDialog(
        context: context,
        content: 'The menu will be deleted permanently',
        onPressed: () {
          controller.deleteMenuAndUpdateChildren(menuId);
        },
      );
    },
    child: const Text("Delete"),
  );
}

ElevatedButton editSection(
  MenusController controller,
  menuId,
  context,
  constraints,
  Map menuData,
) {
  return ElevatedButton(
    style: editButtonStyle,
    onPressed: () {
      controller.menuName.text = menuData['name'] ?? '';
      controller.code.text = menuData['code'] ?? '';
      controller.menuRoute.text = menuData['routeName'] ?? '';
      menusDialog(
        constraints: constraints,
        controller: controller,
        onPressed: () async {
          await controller.editMenu(menuId);
        },
      );
    },
    child: const Text("Edit"),
  );
}

ElevatedButton viewSection(
  MenusController controller,
  menuId,
  context,
  BoxConstraints constraints,
) {
  return ElevatedButton(
    style: viewButtonStyle,
    onPressed:
        controller.buttonLoadingStates[menuId] == null ||
            controller.buttonLoadingStates[menuId] == false
        ? () async {
            controller.menuIDFromList.clear();
            controller.selectedMenuID.value = '';
            controller.screenIDFromList.clear();
            controller.getScreens();
            controller.setButtonLoading(menuId, true); // Start loading
            await controller.getMenuTree(menuId);
            controller.setButtonLoading(menuId, false); // Stop loading
            Get.dialog(
              barrierDismissible: false,
              Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
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
                            topRight: Radius.circular(15),
                          ),
                          color: mainColor,
                        ),
                        child: Row(
                          spacing: 10,
                          children: [
                            Text(
                              controller.getScreenNameForHeader(),
                              style: fontStyleForScreenNameUsedInButtons,
                            ),
                            const Spacer(),
                            closeButton,
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: viewMenu(
                            controller: controller,
                            constraints: constraints,
                            context: context,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
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
  BuildContext context,
  BoxConstraints constraints,
  MenusController controller,
) {
  return ElevatedButton(
    onPressed: () {
      controller.menuName.clear();
      controller.code.clear();
      controller.menuRoute.clear();
      menusDialog(
        constraints: constraints,
        controller: controller,
        onPressed: controller.addingNewMenuProcess.value
            ? null
            : () async {
                await controller.addNewMenu();
              },
      );
    },
    style: newButtonStyle,
    child: const Text('New Menu'),
  );
}
