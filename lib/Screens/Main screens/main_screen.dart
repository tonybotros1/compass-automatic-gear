import 'package:datahubai/Widgets/main%20screen%20widgets/auto_size_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import '../../Controllers/Main screen controllers/main_screen_contro.dart';
import '../../Models/screen_tree_model.dart';
import '../../Widgets/main screen widgets/expand_icon.dart';
import '../../Widgets/overlay_button.dart';
import '../../consts.dart';
import '../../main.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final MainScreenController mainScreenController =
      Get.put(MainScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: sideMenuWidget(),
      body: Row(
        children: [
          // if (ScreenSize.isWeb(context)) sideMenuWidget(),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                Container(
                  width: Get.width,
                  color: Colors.white,
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // if (!ScreenSize.isWeb(context))
                      Builder(
                        builder: (context) => IconButton(
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                            icon: const Icon(Icons.menu)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Obx(() => Text(
                              mainScreenController.selectedScreenName.value,
                              style: fontStyleForAppBar,
                            )),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Obx(() => mainScreenController
                                  .isLoading.isFalse
                              ? SmartInfoOverlay(
                                  backgroundColor: Colors.blue.shade200,
                                  triggerBuilder: (showOverlay) => InkWell(
                                    onTap: showOverlay,
                                    child: CircleAvatar(
                                      backgroundColor: mainColor,
                                      radius: 25,
                                      child: Center(
                                        child: Text(
                                          mainScreenController
                                              .getFirstCharacter(
                                                  mainScreenController
                                                      .userName.value),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  overlayContent: (dismiss) => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(mainScreenController.userEmail.value,
                                          style: const TextStyle(
                                              color: Colors.white)),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      CircleAvatar(
                                        backgroundColor: mainColor,
                                        radius: 35,
                                        child: Text(
                                          mainScreenController
                                              .getFirstCharacter(
                                                  mainScreenController
                                                      .userName.value),
                                          style: const TextStyle(
                                              fontSize: 30,
                                              color: Colors.white),
                                        ),
                                      ),
                                      FittedBox(
                                        child: Text(
                                          'Hi, ${mainScreenController.userName.value}!',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.blue.shade400,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Text(
                                                mainScreenController
                                                    .companyName.value,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16),
                                              child: Row(
                                                children: [
                                                  const Text(
                                                    'Joining Date:',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    textToDate(
                                                        mainScreenController
                                                            .userJoiningDate
                                                            .value),
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade800,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16),
                                              child: Row(
                                                children: [
                                                  const Text(
                                                    'Expiry Date:',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    textToDate(
                                                        mainScreenController
                                                            .userExpiryDate
                                                            .value),
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade800,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton(
                                                    style: logoutButtonStyle,
                                                    onPressed: () async {
                                                      dismiss();
                                                      alertDialog(
                                                          context: context,
                                                          content:
                                                              "Are you sure you want to logout?",
                                                          onPressed: () async {
                                                            await globalPrefs
                                                                ?.remove(
                                                                    'userId');
                                                            await globalPrefs
                                                                ?.remove(
                                                                    'companyId');
                                                            await globalPrefs
                                                                ?.remove(
                                                                    'userEmail');
                                                            Get.offAllNamed(
                                                                '/');
                                                          });
                                                    },
                                                    child:
                                                        const Text('Logout')),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  maxWidth: 400,
                                  horizontalEdgeMargin: 12,
                                  verticalOffset: 8,
                                )
                              : const SizedBox())),
                    ],
                  ),
                ),
                Expanded(
                    child:
                        Obx(() => mainScreenController.selectedScreen.value)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget sideMenuWidget() {
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
                        ? leftTree()
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
                    mainScreenController.menuWidth.value = mainScreenController
                        .menuWidth.value
                        .clamp(200.0, 400.0);
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

  AnimatedTreeView<MyTreeNode> leftTree() {
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
                            onPressed: (_) => mainScreenController
                                .treeController
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
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.3),
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
                          mainScreenController.selectedScreenName.value =
                              entry.node.title;
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
}
