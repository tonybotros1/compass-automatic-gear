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
  RxList userRoles = RxList([]);
  RxList roleMenus = RxList([]);
  RxList<MyTreeNode> finalMenu = RxList([]);
  RxBool arrow = RxBool(false);

  @override
  void onInit() {
    // init();
    getScreens();
    super.onInit();
  }

  Future<void> getScreens() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      uid.value = currentUser.uid;

      // Fetch user roles
      final userSnapshot = await FirebaseFirestore.instance
          .collection('sys-users')
          .where('user_id', isEqualTo: uid.value)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) return;

      userRoles.assignAll(userSnapshot.docs.first.data()['roles']);

      // Fetch role menus
      final roleSnapshot = await FirebaseFirestore.instance
          .collection('sys-roles')
          .where(FieldPath.documentId, whereIn: userRoles)
          .get();

      roleMenus.assignAll(roleSnapshot.docs.first.data()['menuID']);

      // Build tree structure
      final menuSnapshot = await FirebaseFirestore.instance
          .collection('menus ')
          .where(FieldPath.documentId, whereIn: roleMenus)
          .get();

      final roots = await Future.wait(menuSnapshot.docs.map((menuDoc) async {
        final children = await buildMenus(menuDoc.data());
        return MyTreeNode(
          title: menuDoc.data()['name'],
          children: children,
          routeName: menuDoc.data()['routeName'],
        );
      }));

      treeController = TreeController<MyTreeNode>(
        roots: roots,
        childrenProvider: (node) => node.children,
        parentProvider: (node) => node.parent,
      );

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      // print(e);
    }
  }

  Future<List<MyTreeNode>> buildMenus(Map<String, dynamic> menuDetail) async {
    List<String> childrenIds = List<String>.from(menuDetail['children'] ?? []);

    if (childrenIds.isEmpty) return [];

    // Fetch child menus
    final menuSnapshot = await FirebaseFirestore.instance
        .collection('menus ')
        .where(FieldPath.documentId, whereIn: childrenIds)
        .get();

    // Fetch child screens
    final screenSnapshot = await FirebaseFirestore.instance
        .collection('screens')
        .where(FieldPath.documentId, whereIn: childrenIds)
        .get();

    // Build nodes for menus and screens
    final menuNodes = await Future.wait(menuSnapshot.docs.map((menuDoc) async {
      final children = await buildMenus(menuDoc.data());
      return MyTreeNode(
        title: menuDoc.data()['name'],
        children: children,
        routeName: menuDoc.data()['routeName'],
      );
    }));

    final screenNodes = screenSnapshot.docs.map((screenDoc) {
      return MyTreeNode(
        title: screenDoc.data()['name'],
        children: [],
        routeName: screenDoc.data()['routeName'],
      );
    }).toList();

    return [...menuNodes, ...screenNodes];
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
    isLoading.value = false;
  }
}
