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
      appBar: AppBar(
        backgroundColor: mainColorForWeb,
        toolbarHeight: 80,
      ),
      body: Row(
        children: [
          Container(
              width: 200,
              color: mainColorForWeb,
              child: Obx(()=> mainScreenController.isLoading.value == false? AnimatedTreeView<MyTreeNode>(
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
                        child: Text(entry.node.title),
                      );

                      // If details is not null, a dragging tree node is hovering this
                      // drag target. Add some decoration to give feedback to the user.
                      if (details != null) {
                        myTreeNodeTile = ColoredBox(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3),
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

                        child: InkWell(
                          onTap: () => mainScreenController.treeController
                              .toggleExpansion(entry.node),
                          child: TreeIndentation(
                            entry: entry,
                            child: myTreeNodeTile,
                          ),
                        ),
                      );
                    },
                  );
                },
              ): const CircularProgressIndicator())),
          Expanded(
              flex: 5,
              child: Container(
                color: Colors.white,
                child: const Column(
                  children: [],
                ),
              )),
        ],
      ),
    );
  }
}
