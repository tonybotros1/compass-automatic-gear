import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';
import '../../Models/screen_tree_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainScreenController extends GetxController {
  late TreeController<MyTreeNode> treeController;
  RxList<MyTreeNode> roots = <MyTreeNode>[].obs;
  RxBool isLoading = RxBool(true);
  RxString uid = RxString('');
  RxList userScreens = RxList([]);
  @override
  void onInit() {
    // init();
    getScreens();
    super.onInit();
  }

  getScreens() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      uid.value = currentUser.uid;
      await FirebaseFirestore.instance
          .collection('sys-users')
          .where('user_id', isEqualTo: uid.value)
          .get()
          .then((details) {
        for (var element in details.docs.first.data()['roles']) {
          userScreens.add(element);
        }
      });
    }
    await FirebaseFirestore.instance.collection('screens').get().then((screen) {
      // Step 1: Create a map to temporarily store nodes by their unique titles/IDs
      Map<String, MyTreeNode> nodeMap = {};

      // Step 2: Populate the node map
      for (var element in screen.docs) {
        if (userScreens.contains(element.data()['title']) ||
            element.data()['parent'] != null) {
          String title = element.data()['title'];
          String? parentTitle = element.data()['parent'];

          MyTreeNode newNode = MyTreeNode(
            title: title,
            children: [],
            nodeP: parentTitle,
          );

          nodeMap[title] = newNode;
        }
      }

      if (nodeMap.isNotEmpty) {
        // Step 3: Link children to their parents
        nodeMap.forEach((title, node) {
          String? parentTitle = node.nodeP;
          if (parentTitle != null) {
            nodeMap[parentTitle]?.children.add(node);
            node.parent = nodeMap[parentTitle]; // Establish reverse link
          } else {
            // If no parent exists, it's a root node
            roots.add(node);
          }
        });
      }

      // Step 4: Configure the TreeController
      treeController = TreeController<MyTreeNode>(
        roots: roots,
        childrenProvider: (MyTreeNode node) => node.children,
        parentProvider: (MyTreeNode node) => node.parent,
      );
      isLoading.value = false;
    });
  }

// init the tree
  init() {
    final List<MyTreeNode> roots = [
      MyTreeNode(
        title: 'Root Node',
        children: [
          MyTreeNode(
            title: 'Node 1',
            children: [
              MyTreeNode(title: 'Node 1.1'),
              MyTreeNode(title: 'Node 1.2'),
            ],
          ),
          MyTreeNode(
            title: 'Node 2',
            children: [
              MyTreeNode(title: 'Node 2.1'),
              MyTreeNode(title: 'Node 2.2'),
            ],
          ),
        ],
      ),
      MyTreeNode(
        title: 'Root Node',
        children: [
          MyTreeNode(
            title: 'Node 1',
            children: [
              MyTreeNode(title: 'Node 1.1'),
              MyTreeNode(title: 'Node 1.2'),
            ],
          ),
          MyTreeNode(
            title: 'Node 2',
            children: [
              MyTreeNode(title: 'Node 2.1'),
              MyTreeNode(title: 'Node 2.2'),
            ],
          ),
        ],
      ),
    ];
    treeController = TreeController<MyTreeNode>(
      roots: roots,
      childrenProvider: (MyTreeNode node) => node.children,
      parentProvider: (MyTreeNode node) => node.parent,
    );
  }
}





// Stream<List<ScreenNode>> fetchScreensTreeStream() {
  //   return FirebaseFirestore.instance
  //       .collection('screens')
  //       .snapshots()
  //       .map((snapshot) {
  //     // Parse documents into nodes
  //     Map<String, ScreenNode> nodes = {};
  //     for (var doc in snapshot.docs) {
  //       nodes[doc.id] = ScreenNode(
  //         title: doc['title'],
  //         routeName: doc['routeName'],
  //         parent: doc['parent'],
  //         order: doc['order'],
  //         subScreens: [],
  //       );
  //     }

  //     // Link child screens to their parents
  //     for (var nodeEntry in nodes.entries) {
  //       final nodeId = nodeEntry.key; // Current node's ID
  //       final node = nodeEntry.value; // Current node's data

  //       if (node.parent != null) {
  //         print('object');
  //         // Add the current node as a child of its parent
  //         nodes[nodeId]!.subScreens.add(node);
  //       }
  //     }

  //     for (var node in nodes.values) {
  //       print(node.subScreens);
  //     }

  //     // for (var node in nodes.values) {
  //     //   print(node.subScreens);
  //     // }

  //     // Sort sub-screens by order
  //     for (var node in nodes.values) {
  //       node.subScreens.sort((a, b) => a.order.compareTo(b.order));
  //     }

  //     // Return only top-level screens (those without parents)
  //     List<ScreenNode> tree =
  //         nodes.values.where((node) => node.parent == null).toList();

  //     // Sort top-level screens by order
  //     tree.sort((a, b) => a.order.compareTo(b.order));

  //     return tree;
  //   });
  // }