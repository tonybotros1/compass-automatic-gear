import 'package:compass_automatic_gear/Responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import '../../Controllers/Main screen controllers/main_screen_contro.dart';
import '../../Models/screen_tree_model.dart';
import '../../Widgets/main screen widgets/expand_icon.dart';
import '../../consts.dart';

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
          if (ScreenSize.isWeb(context)) sideMenuWidget(),
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
                      if (!ScreenSize.isWeb(context))
                        Builder(
                          builder: (context) => IconButton(
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              icon: const Icon(Icons.menu)),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Obx(() =>
                            mainScreenController.selectedScreenName.value),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Obx(() => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                elevation: 5,
                              ),
                              onPressed: () {},
                              child: Text(
                                  'Welcome ${mainScreenController.userName}'))))
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

  Container sideMenuWidget() {
    return Container(
        decoration: BoxDecoration(
          color: mainColorForWeb,
          // border: Border(
          //     right: BorderSide(color: mainColorForWeb, width: 2)),
        ),
        width: 200,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                    width: 45,
                  ),
                  Image.asset(
                    'assets/logo2.png',
                    width: 90,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          mainScreenController.treeController.collapseAll();
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: const Icon(
                          color: Colors.grey,
                          Icons.close_fullscreen_rounded,
                          size: 20,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     mainScreenController.getScreens();
                      //   },
                      //   splashColor: Colors.transparent,
                      //   highlightColor: Colors.transparent,
                      //   child: const Icon(
                      //     color: Colors.grey,
                      //     Icons.replay,
                      //     size: 20,
                      //   ),
                      // ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: Obx(() => mainScreenController.isLoading.value == false &&
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
              child: Text(
                'Compass Automatic Gear',
                style: footerTextStylr,
              ),
            )
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
                  color: entry.node.children.isNotEmpty
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

              child: entry.node.children.isNotEmpty
                  ? TreeIndentation(
                      entry: entry,
                      child: myTreeNodeTile,
                    )
                  : Container(
                      width: null,
                      // color: entry.node.isPressed == true
                      //     ? Colors.grey.withOpacity(0.5)
                      //     : null,
                      child: InkWell(
                        onTap: () {
                          entry.node.isPressed = true;

                          mainScreenController.treeController.rebuild();
                          mainScreenController.selectedScreen.value =
                              mainScreenController
                                  .getScreenFromRoute(entry.node.routeName);
                          mainScreenController.selectedScreenName.value =
                              mainScreenController
                                  .getScreenName(entry.node.title);
                        },
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
