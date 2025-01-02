import 'package:compass_automatic_gear/Models/screen_tree_model.dart';
import 'package:compass_automatic_gear/Widgets/main%20screen%20widgets/auto_size_box.dart';
import 'package:compass_automatic_gear/Widgets/main%20screen%20widgets/expand_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';

import 'drop_down_menu.dart';

Widget addNewMenuOrView({
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
        Obx(
          () => Expanded(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey),
                ),
              ),
              child: controller.selectedMenuID.value != ''
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 2,
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
                                    text:
                                        '${controller.selectedMenuName.value}',
                                  ),
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  elevation: 5,
                                  minimumSize: const Size(100, 40),
                                ),
                                onPressed: controller
                                            .selectedMenuCanDelete.value ==
                                        false
                                    ? null
                                    : controller.deletingProcess.value == false
                                        ? () {
                                            controller.deleteMenu();
                                          }
                                        : null,
                                child: controller.deletingProcess.value == false
                                    ? AutoSizedText(
                                        style: const TextStyle(fontSize: 13),
                                        text: 'Delete',
                                        constraints: constraints,
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
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Form(
                            key: controller.formKey,
                            child: myTextFormField2(
                              constraints: constraints,
                              obscureText: false,
                              controller: controller.menuName,
                              labelText: 'Menu Name',
                              hintText: 'Enter Menu name',
                              keyboardType: TextInputType.name,
                              validate: true,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
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
                                  onPressed: controller
                                              .addingNewMenuProcess.value ==
                                          false
                                      ? () async {
                                          if (controller.formKey.currentState!
                                              .validate()) {
                                            await controller.addNewMenu();
                                          } else {
                                            // Form is invalid, show errors
                                          }
                                        }
                                      : null,
                                  child:
                                      controller.addingNewMenuProcess.value ==
                                              false
                                          ? const Text('Add')
                                          : const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Divider(),
                        ),
                        Form(
                          key: controller.formKeyForDropDownList,
                          child: dropDownValues(
                              
                              menuIDFromList: controller.menuIDFromList,
                              labelText: 'Menus',
                              hintText: 'Select Menu',
                              menus: controller.selectFromMenus,
                              validate: true,
                              controller: controller.menuNameFromList),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
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
                                  onPressed: controller
                                              .addingExistingMenuProcess
                                              .value ==
                                          false
                                      ? () async {
                                          if (controller.formKeyForDropDownList
                                              .currentState!
                                              .validate()) {
                                            await controller
                                                .addExistingSubMenuToMenu();
                                          } else {
                                            // Form is invalid, show errors
                                          }
                                        }
                                      : null,
                                  child: controller.addingExistingMenuProcess
                                              .value ==
                                          false
                                      ? const Text('Add')
                                      : const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )),
                            ),
                          ],
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
        ),
        const Expanded(
          child: Column(
            children: [],
          ),
        ),
      ],
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
                                entry.node.canDelete;
                            controller.menuName.clear();
                          },
                          child: const Icon(
                            Icons.settings,
                            size: 25,
                            color: Colors.grey,
                          ),
                        )
                      : const SizedBox(
                          height: 25,
                          width: 25,
                        ),
                )
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
