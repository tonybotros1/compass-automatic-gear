import 'package:compass_automatic_gear/Models/screen_tree_model.dart';
import 'package:compass_automatic_gear/Widgets/main%20screen%20widgets/auto_size_box.dart';
import 'package:compass_automatic_gear/Widgets/main%20screen%20widgets/expand_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';

import 'drop_down_menu.dart';

Widget viewMenu({
  required BoxConstraints constraints,
  required BuildContext context,
  required controller,
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
                  border: Border(
                    right: BorderSide(color: Colors.grey),
                  ),
                ),
                child: controller.isLoading.value == false &&
                        controller.errorLoading.value != true
                    ? leftTree(controller: controller)
                    : controller.isLoading.value == true &&
                            controller.errorLoading.value != true
                        ? const Center(child: CircularProgressIndicator())
                        : const Center(
                            child: Text('Network error please try again')),
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
                        .containerWidth.value
                        .clamp(200.0, constraints.maxWidth / 2.5);
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeLeftRight,
                    child: Container(
                      width: 10,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        menuSection(controller, constraints),
        screenSection(controller, constraints),
      ],
    ),
  );
}

Obx screenSection(controller, BoxConstraints constraints) {
  return Obx(() {
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
                              text: '${controller.selectedMenuName.value}',
                            ),
                          ),
                        ),
                        Form(
                          key: controller.formKeyForDropDownListForScreens,
                          child: dropDownValues(
                            ids: controller.screenIDFromList,
                            labelText: 'Screens',
                            hintText: 'Select Screen',
                            menus: controller.selectFromScreens,
                            validate: true,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Wrap(
                            spacing: 10, // Horizontal spacing between items
                            runSpacing: 10, // Vertical spacing between rows
                            children: List.generate(
                                controller.screenIDFromList.length, (i) {
                              return Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffA6AEBF),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '${controller.getScreenName(controller.screenIDFromList[i])}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () {
                                        controller.removeScreenFromList(i);
                                      },
                                      child: const Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      elevation: 5,
                      minimumSize: const Size(100, 40),
                    ),
                    onPressed:
                        controller.addingExistingScreenProcess.value == false
                            ? () async {
                                if (controller.screenIDFromList.isEmpty &&
                                    !controller.formKeyForDropDownListForScreens
                                        .currentState!
                                        .validate()) {
                                  // Do nothing: this ensures validation is triggered when required
                                } else {
                                  await controller.addExistingScreenToMenu();
                                }
                              }
                            : null,
                    child: controller.addingExistingScreenProcess.value == false
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
                      borderRadius: BorderRadius.circular(10)),
                  child: const Text(
                    'Select menu to start',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
    );
  });
}

Obx menuSection(controller, BoxConstraints constraints) {
  return Obx(
    () => Expanded(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(color: Colors.grey),
          ),
        ),
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
                                text: '${controller.selectedMenuName.value}',
                              ),
                            ),
                          ),
                          Form(
                            key: controller.formKeyForDropDownListForMenus,
                            child: dropDownValues(
                              ids: controller.menuIDFromList,
                              labelText: 'Menus',
                              hintText: 'Select Menu',
                              menus: controller.selectFromMenus,
                              validate: true,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Wrap(
                              spacing: 10, // Horizontal spacing between items
                              runSpacing: 10, // Vertical spacing between rows
                              children: List.generate(
                                  controller.menuIDFromList.length, (i) {
                                return Stack(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: const Color(0xffA6AEBF),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        '${controller.getMenuName(controller.menuIDFromList[i])}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: InkWell(
                                        onTap: () {
                                          controller.removeMenuFromList(i);
                                        },
                                        child: const Icon(
                                          Icons.remove_circle,
                                          color: Colors.red,
                                          size: 20,
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 5,
                        minimumSize: const Size(100, 40),
                      ),
                      onPressed:
                          controller.addingExistingMenuProcess.value == false
                              ? () async {
                                  if (controller.menuIDFromList.isEmpty &&
                                      !controller.formKeyForDropDownListForMenus
                                          .currentState!
                                          .validate()) {
                                    // Do nothing: this ensures validation is triggered when required
                                  } else {
                                    await controller.addExistingSubMenuToMenu();
                                  }
                                }
                              : null,
                      child: controller.addingExistingMenuProcess.value == false
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
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      'Select menu to start',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
      ),
    ),
  );
}

AnimatedTreeView<MyTreeNode> leftTree({
  required controller,
}) {
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
                                fontSize: 10),
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
                            : const SizedBox()
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: entry.node.isMenu == true
                      ? InkWell(
                          onTap: () {
                            controller.selectedMenuID.value = entry.node.id;
                            controller.selectedMenuName.value =
                                entry.node.title;
                            controller.selectedMenuCanDelete.value =
                                entry.node.canRemove;
                            controller.menuName.clear();
                          },
                          child: const Icon(
                            Icons.add_circle,
                            size: 25,
                            color: Colors.green,
                          ),
                        )
                      : const SizedBox(
                          height: 25,
                          width: 25,
                        ),
                ),
                // entry.node.isMenu == true
                //     ?
                InkWell(
                  onTap: entry.node.canRemove == false ||
                          entry.node.canRemove == null
                      ? null
                      : () {
                          showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                title: const Text("Alert"),
                                content: Text(entry.node.isMenu == true
                                    ? "Are you sure you want to remove this sub menu?"
                                    : "Are you sure you want to remove this screen?"),
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
                                          entry.node.id, entry.node.parent!.id);
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
                    color: entry.node.canRemove == false ||
                            entry.node.canRemove == null
                        ? Colors.grey
                        : Colors.red,
                  ),
                )
                // : const SizedBox(
                //     height: 25,
                //     width: 25,
                //   )
              ],
            ),
          );

          // If details is not null, a dragging tree node is hovering this
          // drag target. Add some decoration to give feedback to the user.
          if (details != null) {
            myTreeNodeTile = ColoredBox(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              child: myTreeNodeTile,
            );
          }

          return TreeDraggable<MyTreeNode>(
              node: entry.node,

              // Show some feedback to the user under the dragging pointer,
              // this can be any widget.
              feedback: IntrinsicWidth(
                child: Material(
                  elevation: 4,
                  child: myTreeNodeTile,
                ),
              ),
              child: TreeIndentation(
                entry: entry,
                child: myTreeNodeTile,
              ));
        },
      );
    },
  );
}

Widget myTextFormField2({
  required String labelText,
  required String hintText,
  required controller,
  required validate,
  required obscureText,
  IconButton? icon,
  required constraints,
  keyboardType,
}) {
  return TextFormField(
    obscureText: obscureText,
    keyboardType: keyboardType,
    controller: controller,
    decoration: InputDecoration(
      suffixIcon: icon,
      hintStyle: const TextStyle(color: Colors.grey),
      labelText: labelText,
      hintText: hintText,
      labelStyle: TextStyle(color: Colors.grey.shade700),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 2.0),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1.0),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2.0),
      ),
    ),
    validator: validate != false
        ? (value) {
            if (value!.isEmpty) {
              return 'Please Enter $labelText';
            }
            return null;
          }
        : null,
  );
}
