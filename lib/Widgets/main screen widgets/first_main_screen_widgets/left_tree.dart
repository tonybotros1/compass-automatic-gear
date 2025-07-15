import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/main_screen_contro.dart';
import '../../../Models/screen_tree_model.dart';
import '../../../consts.dart';
import '../auto_size_box.dart';
import '../expand_icon.dart';

Widget sideMenuWidget(MainScreenController mainScreenController) {
  return Obx(() => Stack(
        children: [
          // Main Side Menu
          Container(
            width: mainScreenController.menuWidth.value,
            decoration: BoxDecoration(
              color: mainColorForWeb,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Obx(
                        () => Center(
                          child: mainScreenController
                                  .companyImageURL.value.isNotEmpty
                              ? Image.network(
                                  mainScreenController.companyImageURL.value,
                                  width: 100,
                                )
                              : const SizedBox(
                                  height: 100,
                                  width: 100,
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 10,
                        child: Obx(
                          () => mainScreenController.isLoading.value == false
                              ? InkWell(
                                  onTap: () {
                                    if (mainScreenController
                                        .treeController.isTreeExpanded) {
                                      mainScreenController.treeController
                                          .collapseAll();
                                    } else {
                                      mainScreenController.treeController
                                          .expandAll();
                                    }
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: const Icon(
                                    color: Colors.grey,
                                    Icons.account_tree,
                                    size: 20,
                                  ),
                                )
                              : const SizedBox(
                                  width: 20,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(() => mainScreenController.isLoading.value ==
                              false &&
                          mainScreenController.errorLoading.value != true
                      ? leftTree(mainScreenController)
                      : mainScreenController.isLoading.value == true &&
                              mainScreenController.errorLoading.value != true
                          ? const Center(child: CircularProgressIndicator())
                          : const Center(
                              child: Text('Network error please try again'))),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(
                    () => Text(
                      textAlign: TextAlign.center,
                      mainScreenController.companyName.value,
                      style: footerTextStylr,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeLeftRight,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  mainScreenController.menuWidth.value += details.delta.dx;
                  mainScreenController.menuWidth.value =
                      mainScreenController.menuWidth.value.clamp(200.0, 400.0);
                },
                child: Container(
                  width: 5,
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ));
}

AnimatedTreeView<MyTreeNode> leftTree(
    MainScreenController mainScreenController) {
  return AnimatedTreeView<MyTreeNode>(
    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
    treeController: mainScreenController.treeController,
    nodeBuilder: (context, entry) {
      return TreeDragTarget<MyTreeNode>(
        node: entry.node,
        onNodeAccepted: (details) {
          mainScreenController.treeController
              .setExpansionState(details.targetNode, true);

          mainScreenController.treeController.rebuild();
        },
        builder: (context, details) {
          Widget myTreeNodeTile = Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: entry.node.isMenu == true ? mainColor : secColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: AutoSizedText(
                      text: entry.node.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                  entry.node.children.isNotEmpty
                      ? CustomExpandIcon(
                          key: GlobalObjectKey(entry.node),
                          isExpanded: entry.isExpanded,
                          color: Colors.grey,
                          expandedColor: Colors.grey.shade500,
                          onPressed: (_) => mainScreenController.treeController
                              .toggleExpansion(entry.node),
                        )
                      : const SizedBox()
                ],
              ),
            ),
          );

          // If details is not null, a dragging tree node is hovering this
          // drag target. Add some decoration to give feedback to the user.
          if (details != null) {
            myTreeNodeTile = ColoredBox(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
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

            child:
                // entry.node.isMenu == true
                //     ? TreeIndentation(
                //         entry: entry,
                //         child: myTreeNodeTile,
                //       )
                //     :
                Container(
              width: null,
              color: entry.node.isPressed == true
                  ? Colors.grey.withValues(alpha: (0.5))
                  : null,
              child: InkWell(
                onTap: entry.node.routeName != null
                    ? () {
                        if (mainScreenController.previouslySelectedNode !=
                            null) {
                          mainScreenController
                              .previouslySelectedNode!.isPressed = false;
                        }

                        entry.node.isPressed = true;
                        mainScreenController.previouslySelectedNode =
                            entry.node;
                        mainScreenController.treeController.rebuild();
                        mainScreenController.selectedScreen.value =
                            mainScreenController
                                .getScreenFromRoute(entry.node.routeName);
                        mainScreenController.selectedScreenRoute.value =
                            '${entry.node.routeName}';
                        mainScreenController.selectedScreenName.value =
                            entry.node.title;
                        mainScreenController.selectedScreenDescription.value =
                            '${entry.node.description}';
                        Scaffold.of(context).closeDrawer();
                      }
                    : null,
                child: TreeIndentation(
                  entry: entry,
                  child: myTreeNodeTile,
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
