import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import '../../Controllers/Main screen controllers/main_screen_contro.dart';
import '../../Models/screen_tree_model.dart';
import '../../consts.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final MainScreenController mainScreenController =
      Get.put(MainScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: mainColorForWeb,
      //   // toolbarHeight: 80,
      // ),
      body: Row(
        children: [
          Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      right: BorderSide(color: mainColorForWeb, width: 2))),
              width: 250,
              child: Obx(() => mainScreenController.isLoading.value == false
                  ? leftTree()
                  : const Center(child: CircularProgressIndicator()))),
          Expanded(
            flex: 5,
            child: Obx(() => mainScreenController.selectedScreen.value),
          )
        ],
      ),
    );
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
                            fontSize: 12),
                      ),
                    ),
                    entry.node.children.isNotEmpty
                        ? Expanded(
                            flex: 1,
                            child: ExpandIcon(
                              padding: const EdgeInsets.all(0),
                              key: GlobalObjectKey(entry.node),
                              isExpanded: entry.isExpanded,

                              // Icons.keyboard_arrow_down,
                              color: Colors.grey,
                              onPressed: (_) => mainScreenController
                                  .treeController
                                  .toggleExpansion(entry.node),
                            ))
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
                  : InkWell(
                      onTap: () {
                        print(entry.node.routeName);
                        mainScreenController.selectedScreen.value =
                            mainScreenController
                                .getScreenFromRoute(entry.node.routeName);
                      },
                      child: TreeIndentation(
                        entry: entry,
                        child: myTreeNodeTile,
                      ),
                    ),
            );
          },
        );
      },
    );
  }
}
