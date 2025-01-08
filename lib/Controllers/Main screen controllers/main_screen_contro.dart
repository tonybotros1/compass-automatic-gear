import 'dart:convert';

import 'package:compass_automatic_gear/Screens/Main%20screens/System%20Administrator/User%20Management/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/screen_tree_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Screens/Main screens/System Administrator/User Management/menus.dart';
import '../../Screens/Main screens/System Administrator/User Management/responsibilities.dart';
import '../../Screens/Main screens/System Administrator/User Management/users.dart';
import '../../consts.dart';

class MainScreenController extends GetxController {
  late TreeController<MyTreeNode> treeController;
  RxList<MyTreeNode> roots = <MyTreeNode>[].obs;
  RxBool isLoading = RxBool(false);
  RxString uid = RxString('');
  RxList<String> userRoles = RxList([]);
  // RxString roleMenus = RxString('');
  RxList<String> roleMenus = RxList([]);
  RxList<MyTreeNode> finalMenu = RxList([]);
  RxBool arrow = RxBool(false);
  Rx<Widget> selectedScreen = const SizedBox().obs;
  Rx<Text> selectedScreenName = const Text('').obs;
  RxString userName = RxString('');
  RxBool errorLoading = RxBool(false);
  RxMap allMenus = RxMap({});
  RxMap allScreens = RxMap({});

  @override
  void onInit() {
    // init();
    getScreens();
    super.onInit();
  }

// this function is to get the screen and show it on the right side of the main screen
  Widget getScreenFromRoute(String? routeName) {
    switch (routeName) {
      case '/users':
        return SizedBox(child: Users());
      case '/functions':
        return const SizedBox(child: Functions());
      case '/menus':
        return const SizedBox(child: Menus());
      case '/responsibilities':
        return const SizedBox(child: Responsibilities());
      // Add more cases as needed
      default:
        return const SizedBox(child: Center(child: Text('Screen not found')));
    }
  }

  // this function is to get the name of the screen of the right side of the main screen
  Text getScreenName(name) {
    return Text(
      name,
      style: fontStyleForAppBar,
    );
  }

  // Future<void> getScreens() async {
  //   try {
  //     isLoading.value = true;

  //     final SharedPreferences prefs = await SharedPreferences.getInstance();

  //     String? action = prefs.getString('userId');
  //     if (action == null || action == '') return;

  //     uid.value = action;

  //     // Fetch user roles
  //     final userSnapshot = await FirebaseFirestore.instance
  //         .collection('sys-users')
  //         .doc(uid.value)
  //         .get();

  //     if (!userSnapshot.exists) return;

  //     userRoles.assignAll(userSnapshot.data()!['roles']);
  //     userName.value = userSnapshot.data()!['user_name'];

  //     // Fetch role menus
  //     final roleSnapshot = await FirebaseFirestore.instance
  //         .collection('sys-roles')
  //         .where(FieldPath.documentId, whereIn: userRoles)
  //         .get();

  //     // roleMenus.assignAll(await roleSnapshot.docs.first
  //     //     .data()['menuID']); //=await roleSnapshot.docs.first.data()['menuID'];
  //     for (var element in roleSnapshot.docs) {
  //       roleMenus.add(element.data()['menuID']);
  //     }

  //     // Build tree structure
  //     final menuSnapshot = await FirebaseFirestore.instance
  //         .collection('menus ')
  //         .where(FieldPath.documentId, whereIn: roleMenus)
  //         .get();

  //     final roots = await Future.wait(menuSnapshot.docs.map((menuDoc) async {
  //       final children = await buildMenus(menuDoc.data());
  //       return MyTreeNode(
  //         isMenu: true,
  //         title: menuDoc.data()['name'],
  //         children: children,
  //         routeName: menuDoc.data()['routeName'],
  //       );
  //     }));

  //     treeController = TreeController<MyTreeNode>(
  //       roots: roots,
  //       childrenProvider: (node) => node.children,
  //       parentProvider: (node) => node.parent,
  //     );

  //     isLoading.value = false;
  //   } catch (e) {
  //     errorLoading.value = true;
  //     isLoading.value = false;
  //     // print(e);
  //   }
  // }

  // Future<List<MyTreeNode>> buildMenus(Map<String, dynamic> menuDetail) async {
  //   List<String> childrenIds = List<String>.from(menuDetail['children'] ?? []);

  //   if (childrenIds.isEmpty) return [];

  //   // Fetch child menus
  //   final menuSnapshot = await FirebaseFirestore.instance
  //       .collection('menus ')
  //       .where(FieldPath.documentId, whereIn: childrenIds)
  //       .get();

  //   // Fetch child screens
  //   final screenSnapshot = await FirebaseFirestore.instance
  //       .collection('screens')
  //       .where(FieldPath.documentId, whereIn: childrenIds)
  //       .get();

  //   // Build nodes for menus and screens
  //   final menuNodes = await Future.wait(menuSnapshot.docs.map((menuDoc) async {
  //     final children = await buildMenus(menuDoc.data());
  //     return MyTreeNode(
  //       isMenu: true,
  //       title: menuDoc.data()['name'],
  //       children: children,
  //       routeName: menuDoc.data()['routeName'],
  //     );
  //   }));

  //   final screenNodes = screenSnapshot.docs.map((screenDoc) {
  //     return MyTreeNode(
  //       isMenu: false,
  //       title: screenDoc.data()['name'],
  //       children: [],
  //       routeName: screenDoc.data()['routeName'],
  //     );
  //   }).toList();

  //   return [...menuNodes, ...screenNodes];
  // }

  Future<void> getScreens() async {
    try {
      isLoading.value = true;

      // Fetch user ID from SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final action = prefs.getString('userId');
      if (action == null || action.isEmpty) return;

      uid.value = action;

      // Check for cached data
      final cachedMenus = prefs.getString('cachedMenus');
      final cachedScreens = prefs.getString('cachedScreens');
      final cachedRoles = prefs.getStringList('cachedRoles');
      final cachedRoleMenus = prefs.getStringList('cachedRoleMenus');

      // Fetch user data from Firestore
      final userSnapshot = await FirebaseFirestore.instance
          .collection('sys-users')
          .doc(uid.value)
          .get();

      if (!userSnapshot.exists) return;

      final fetchedRoles =
          List<String>.from(userSnapshot.data()?['roles'] ?? []);
      userName.value = userSnapshot.data()?['user_name'] ?? '';

      bool rolesChanged = false;

      // Check if roles have changed
      if (cachedRoles == null ||
          !const ListEquality().equals(cachedRoles, fetchedRoles)) {
        rolesChanged = true;
      }

      if (!rolesChanged &&
          cachedMenus != null &&
          cachedScreens != null &&
          cachedRoleMenus != null) {
        // Use cached data
        allMenus.value = Map<String, dynamic>.from(jsonDecode(cachedMenus));
        allScreens.value = Map<String, dynamic>.from(jsonDecode(cachedScreens));
        userRoles.assignAll(cachedRoles!);
        roleMenus.assignAll(cachedRoleMenus);

      } else {
        // Fetch role menus if roles have changed or no cache exists
        userRoles.assignAll(fetchedRoles);

        final roleSnapshot = await FirebaseFirestore.instance
            .collection('sys-roles')
            .where(FieldPath.documentId, whereIn: userRoles)
            .get();

        roleMenus.clear();
        for (var doc in roleSnapshot.docs) {
          final menuID = doc.data()['menuID'];
          if (menuID is String) {
            roleMenus.add(menuID);
          } else if (menuID is List) {
            roleMenus.addAll(List<String>.from(menuID));
          }
        }

        // Fetch menus and screens
        final collections = await Future.wait([
          FirebaseFirestore.instance.collection('menus ').get(),
          FirebaseFirestore.instance.collection('screens').get(),
        ]);

        allMenus.value = {
          for (var menu in collections[0].docs) menu.id: menu.data()
        };
        allScreens.value = {
          for (var screen in collections[1].docs) screen.id: screen.data()
        };

        // Cache the updated data
        await prefs.setString('cachedMenus', jsonEncode(allMenus));
        await prefs.setString('cachedScreens', jsonEncode(allScreens));
        await prefs.setStringList('cachedRoles', userRoles);
        await prefs.setStringList('cachedRoleMenus', roleMenus);

        print('Data fetched and cached.');
      }

      // Filter menus based on role menus
      final menuSnapshot = allMenus.entries
          .where((entry) => roleMenus.contains(entry.key))
          .toList();

      // Build tree structure
      final roots = await Future.wait(menuSnapshot.map((menuDoc) async {
        final children = await buildMenus(menuDoc.value);
        return MyTreeNode(
          isMenu: true,
          title: menuDoc.value['name'],
          children: children,
          routeName: menuDoc.value['routeName'],
        );
      }));

      // Initialize tree controller
      treeController = TreeController<MyTreeNode>(
        roots: roots,
        childrenProvider: (node) => node.children,
        parentProvider: (node) => node.parent,
      );

      isLoading.value = false;
    } catch (e) {
      errorLoading.value = true;
      isLoading.value = false;
      print('Error loading screens: $e');
    }
  }

  Future<List<MyTreeNode>> buildMenus(Map<String, dynamic> menuDetail) async {
    List<String> childrenIds = List<String>.from(menuDetail['children'] ?? []);

    if (childrenIds.isEmpty) return [];

    // Fetch child menus
    final menuSnapshot = allMenus.entries
        .where((entry) => childrenIds.contains(entry.key))
        .toList();

    // Fetch child screens
    final screenSnapshot = allScreens.entries
        .where((entry) => childrenIds.contains(entry.key))
        .toList();

    // Build nodes for menus and screens
    final menuNodes = await Future.wait(menuSnapshot.map((menuDoc) async {
      final children = await buildMenus(menuDoc.value);
      return MyTreeNode(
        isMenu: true,
        title: menuDoc.value['name'],
        children: children,
        routeName: menuDoc.value['routeName'],
      );
    }));

    final screenNodes = screenSnapshot.map((screenDoc) {
      return MyTreeNode(
        isMenu: false,
        title: screenDoc.value['name'],
        children: [],
        routeName: screenDoc.value['routeName'],
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
