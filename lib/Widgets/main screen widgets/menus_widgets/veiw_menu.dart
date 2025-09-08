import 'package:datahubai/Models/screen_tree_model.dart';
import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/Widgets/main%20screen%20widgets/auto_size_box.dart';
import 'package:datahubai/Widgets/main%20screen%20widgets/expand_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/menus_controller.dart';
import '../../../consts.dart';

Widget viewMenu({
  required BoxConstraints constraints,
  required BuildContext context,
  required MenusController controller,
}) {
  return SizedBox(
    width: constraints.maxWidth,
    height: null,
    child: Row(
      children: [
        Obx(
          () => Stack(
            children: [
              Container(
                width: controller.containerWidth.value,
                decoration: const BoxDecoration(
                  border: Border(right: BorderSide(color: Colors.grey)),
                ),
                child:
                    controller.isLoading.value == false &&
                        controller.errorLoading.value != true
                    ? leftTree(controller: controller)
                    : controller.isLoading.value == true &&
                          controller.errorLoading.value != true
                    ? const Center(child: CircularProgressIndicator())
                    : const Center(
                        child: Text('Network error please try again'),
                      ),
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onHorizontalDragUpdate: (details) {
                    controller.containerWidth.value += details.delta.dx;
                    controller.containerWidth.value = controller
                        .containerWidth
                        .value
                        .clamp(200.0, constraints.maxWidth / 2.5);
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeLeftRight,
                    child: Container(width: 10, color: Colors.transparent),
                  ),
                ),
              ),
            ],
          ),
        ),
        menuSection(controller, constraints),
        const VerticalDivider(width: 1, thickness: 1, color: Colors.grey),
        screenSection(controller, constraints),
      ],
    ),
  );
}

Obx screenSection(MenusController controller, BoxConstraints constraints) {
  return Obx(() {
    return addScreenOrMenu(
      controller: controller,
      constraints: constraints,
      dropDownMenu: CustomDropdown(
        width: double.infinity,
        validator: true,
        hintText: 'Screens',
        items: controller.allScreens,
        itemBuilder: (context, key, value) {
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(value['name']),
          );
        },
        onChanged: (key, value) {
          if (!controller.screenIDFromList.contains(key)) {
            controller.screenIDFromList.add(key);
          }
        },
      ),
      onAdd: controller.addingExistingScreenProcess.value == false
          ? () async {
              if (controller.screenIDFromList.isNotEmpty) {
                await controller.addScreenToExistringMenu();
                controller.screenIDFromList.clear();
              } else {
                showSnackBar('Alert', 'Please select screen first');
              }
            }
          : null,
      dataMap: controller.allScreens,
      list: controller.screenIDFromList,
      addingLoading: controller.addingExistingScreenProcess,
    );
  });
}

Obx menuSection(MenusController controller, BoxConstraints constraints) {
  return Obx(() {
    return addScreenOrMenu(
      controller: controller,
      constraints: constraints,
      dropDownMenu: CustomDropdown(
        width: double.infinity,
        hintText: 'Menus',
        validator: true,
        items: controller.allMenus,
        itemBuilder: (context, key, value) {
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text('${value['name']} ${value['code']}'),
          );
        },
        onChanged: (key, value) {
          if (!controller.menuIDFromList.contains(key)) {
            controller.menuIDFromList.add(key);
          }
        },
      ),
      onAdd: controller.addingExistingMenuProcess.value == false
          ? () async {
              if (controller.menuIDFromList.isNotEmpty) {
                await controller.addSubMenuToExistingMenu();
                controller.menuIDFromList.clear();
              } else {
                showSnackBar('Alert', 'Please select menu first');
              }
            }
          : null,
      dataMap: controller.allMenus,
      list: controller.menuIDFromList,
      addingLoading: controller.addingExistingMenuProcess,
    );
  });
}

Expanded addScreenOrMenu({
  required MenusController controller,
  required BoxConstraints constraints,
  required CustomDropdown dropDownMenu,
  required void Function()? onAdd,
  required RxMap<String, dynamic> dataMap,
  required RxList<dynamic> list,
  required RxBool addingLoading,
}) {
  return Expanded(
    child: controller.selectedMenuID.value != ''
        ? Stack(
            children: [
              ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: AutoSizedText(
                            maxLines: 2,
                            constraints: constraints,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                            text: controller.selectedMenuName.value,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: dropDownMenu,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(list.length, (i) {
                            return Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xffA6AEBF),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    controller.getMenuOrScreenName(
                                      list[i],
                                      dataMap,
                                    ),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () {
                                      controller.removeMenuOrScreenFromList(
                                        i,
                                        list,
                                      );
                                    },
                                    child: const Icon(
                                      Icons.remove_circle,
                                      color: Colors.red,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: ElevatedButton(
                  style: addButtonStyle,
                  onPressed: onAdd,
                  child: addingLoading.value == false
                      ? const Text('Add')
                      : const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                ),
              ),
            ],
          )
        : Center(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Select menu to start',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
  );
}

AnimatedTreeView<MyTreeNode> leftTree({required MenusController controller}) {
  return AnimatedTreeView<MyTreeNode>(
    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
    treeController: controller.treeController,
    nodeBuilder: (context, entry) {
      return TreeDragTarget<MyTreeNode>(
        node: entry.node,
        onNodeAccepted: (details) {
          controller.treeController.setExpansionState(details.targetNode, true);

          controller.treeController.rebuild();
        },
        builder: (context, details) {
          Widget myTreeNodeTile = Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: entry.node.isMenu == true
                          ? const Color(0xff2E5077)
                          : const Color(0xff4DA1A9),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            entry.node.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        entry.node.isMenu == true
                            ? CustomExpandIcon(
                                key: GlobalObjectKey(entry.node),
                                isExpanded: entry.isExpanded,
                                color: Colors.grey,
                                expandedColor: Colors.grey.shade500,
                                onPressed: (_) => controller.treeController
                                    .toggleExpansion(entry.node),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: entry.node.isMenu == true
                      ? InkWell(
                          onTap: () {
                            controller.selectedMenuID.value = entry.node.id!;
                            controller.selectedMenuName.value =
                                entry.node.title;
                            controller.selectedMenuCanDelete.value =
                                entry.node.canRemove!;
                            controller.menuName.clear();
                          },
                          child: const Icon(
                            Icons.add_circle,
                            size: 25,
                            color: Colors.green,
                          ),
                        )
                      : const SizedBox(height: 25, width: 25),
                ),

                InkWell(
                  onTap:
                      entry.node.canRemove == false ||
                          entry.node.canRemove == null
                      ? null
                      : () {
                          showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: const Text("Alert"),
                                content: Text(
                                  entry.node.isMenu == true
                                      ? "Are you sure you want to remove this sub menu?"
                                      : "Are you sure you want to remove this screen?",
                                ),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text("Cancel"),
                                    onPressed: () {
                                      Get.back();
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    isDestructiveAction: true,
                                    isDefaultAction: true,
                                    child: const Text("OK"),
                                    onPressed: () async {
                                      Get.back();
                                      await controller.removeNodeFromTheTree(
                                        entry.node.id ?? '',
                                        entry.node.parent!.id ?? '',
                                      );
                                      controller.selectedMenuID.value = '';
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                  child: Icon(
                    Icons.remove_circle_outline,
                    size: 25,
                    color:
                        entry.node.canRemove == false ||
                            entry.node.canRemove == null
                        ? Colors.grey
                        : Colors.red,
                  ),
                ),
              ],
            ),
          );

          // If details is not null, a dragging tree node is hovering this
          // drag target. Add some decoration to give feedback to the user.
          if (details != null) {
            myTreeNodeTile = ColoredBox(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.3),
              child: myTreeNodeTile,
            );
          }

          return TreeDraggable<MyTreeNode>(
            node: entry.node,

            // Show some feedback to the user under the dragging pointer,
            // this can be any widget.
            feedback: IntrinsicWidth(
              child: Material(elevation: 4, child: myTreeNodeTile),
            ),
            child: TreeIndentation(entry: entry, child: myTreeNodeTile),
          );
        },
      );
    },
  );
}
