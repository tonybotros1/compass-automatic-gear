import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../Models/menus_functions_roles/menus_model.dart';
import '../../Models/screen_tree_model.dart';
import '../../consts.dart';
import 'main_screen_contro.dart';

class MenusController extends GetxController {
  // final RxList<DocumentSnapshot> allMenus = RxList<DocumentSnapshot>([]);
  late TextEditingController menuName =
      TextEditingController(); // new menu name
  late TextEditingController code = TextEditingController();
  late TextEditingController menuRoute = TextEditingController();
  RxList menuIDFromList = RxList([]);
  RxList screenIDFromList = RxList([]);

  // RxList<MenuModel> allMenus = RxList<MenuModel>();
  RxMap<String, dynamic> allMenus = RxMap<String, dynamic>({});
  RxMap allScreens = RxMap({});
  RxList menusSubMenusChildren = RxList([]);
  RxList menusSscreensChildren = RxList([]);
  RxMap<String, dynamic> filteredMenus = RxMap<String, dynamic>({});
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoading = RxBool(false);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);

  // ========== test=================
  RxDouble containerWidth = RxDouble(300);
  // RxList rolesMenus = RxList([]);
  late TreeController<MyTreeNode> treeController;
  RxList<MyTreeNode> roots = <MyTreeNode>[].obs;
  RxBool isLoading = RxBool(true);
  RxBool errorLoading = RxBool(false);
  var buttonLoadingStates = <String, bool>{}.obs;
  RxString selectedMenuID = RxString('');
  RxString selectedMenuName = RxString(''); // the menu i want to add a child to
  RxBool selectedMenuCanDelete = RxBool(false);
  RxBool addingNewMenuProcess = RxBool(false);
  RxBool addingExistingMenuProcess = RxBool(false);
  RxBool addingExistingScreenProcess = RxBool(false);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxMap<String, String> selectFromScreens = RxMap({});
  WebSocketChannel? channel;
  String backendUrl = backendTestURI;
  @override
  void onInit() {
    connectWebSocket();

    getMenus();
    getScreens();
    // search.value.addListener(() {
    //   filterMenus();
    // });
    super.onInit();
  }

  String getScreenNameForHeader() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();

    return mainScreenController.selectedScreenName.value;
  }

  void connectWebSocket() {
    channel = WebSocketChannel.connect(Uri.parse(webSocketURL));

    channel!.stream.listen((event) {
      final message = jsonDecode(event);

      switch (message["type"]) {
        case "menu_created":
          final newMenu = MenuModel.fromJson(message["data"]);
          allMenus[newMenu.id] = newMenu.toJson();
          break;

        case "menu_updated":
          final updated = MenuModel.fromJson(message["data"]);
          if (allMenus.containsKey(updated.id)) {
            allMenus[updated.id] = updated.toJson();
          }
          break;

        case "menu_deleted":
          final deletedId = message["data"]["_id"];
          allMenus.remove(deletedId);
      }
    });
  }

  Future<void> getMenus() async {
    try {
      isScreenLoading.value = true;

      var url = Uri.parse('$backendUrl/menus/get_menus');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<MenuModel> menuList = (decoded["menus"] as List)
            .map((json) => MenuModel.fromJson(json))
            .toList();
        allMenus.value = {for (var menu in menuList) menu.id: menu.toJson()};
        isScreenLoading.value = false;
      }
    } catch (e) {
      isScreenLoading.value = false;
    }
  }

  Future<void> addNewMenu() async {
    try {
      addingNewMenuProcess.value = true;
      var url = Uri.parse('$backendUrl/menus/add_new_menu');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": menuName.text,
          "code": code.text,
          "route": menuRoute.text,
        }),
      );
      if (response.statusCode == 200) {
        addingNewMenuProcess.value = false;

        Get.back();
        showSnackBar('Done', 'Menu added successfully');
      } else {
        Get.back();
        addingNewMenuProcess.value = false;
        showSnackBar('Alert', 'Something went wrong please try again');
      }
    } catch (e) {
      Get.back();
      addingNewMenuProcess.value = false;
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  Future<void> deleteMenuAndUpdateChildren(String menuId) async {
    try {
      Get.back();
      var url = Uri.parse('$backendUrl/menus/delete_menu/$menuId');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        showSnackBar('Done', 'Menu deleted successfully');
      } else {
        showSnackBar('Error', 'Failed to delete menu');
      }
    } catch (e) {
      showSnackBar('Error', 'Failed to delete menu');
    }
  }

  Future<void> editMenu(String menuID) async {
    try {
      addingNewMenuProcess.value = true;
      var url = Uri.parse('$backendUrl/menus/update_menu/$menuID');
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": menuName.text,
          "code": code.text,
          "route": menuRoute.text,
        }),
      );
      if (response.statusCode == 200) {
        addingNewMenuProcess.value = false;

        Get.back();
        showSnackBar('Done', 'Menu updated successfully');
      } else {
        Get.back();
        addingNewMenuProcess.value = false;
        showSnackBar('Alert', 'Something went wrong please try again');
      }
    } catch (e) {
      Get.back();
      addingNewMenuProcess.value = false;
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  Future<void> removeNodeFromTheTree(String nodeID, String parentID) async {
    try {
      var url = Uri.parse(
        '$backendUrl/menus/remove_node_from_the_tree/$parentID/$nodeID',
      );
      final response = await http.patch(url);
      if (response.statusCode == 200) {
        removeNode(roots, nodeID, parentID);
      } else {
        showSnackBar('Alert', 'Can\'t remove node please try again');
      }
    } catch (e) {
      showSnackBar('Alert', 'Can\'t remove node please try again');
    }
  }

  // =====================================================================================================================

  // this function is to remove a menu from the list
  void removeMenuFromList(int index) {
    menuIDFromList.removeAt(index);
  }

  // this function is to remove a screen from the list
  void removeScreenFromList(int index) {
    screenIDFromList.removeAt(index);
  }

  // this function to get menu name by id and add it to the screen
  String getMenuName(String menuID) {
    // Find the entry with the matching key
    final matchingEntry = allMenus.entries.firstWhere(
      (entry) => entry.key == menuID,
      orElse: () =>
          const MapEntry('', 'Unknown'), // Handle cases where no match is found
    );
    final menuName = matchingEntry.value["name"]
        .replaceAll(RegExp(r'\s*\(.*?\)'), '')
        .trim();

    return menuName;
  }

  // this function to get screen name by id and add it to the screen
  String getScreenName(String screenID) {
    // Find the entry with the matching key
    final matchingEntry = allScreens.entries.firstWhere(
      (entry) => entry.key == screenID,
      orElse: () =>
          const MapEntry('', 'Unknown'), // Handle cases where no match is found
    );

    return matchingEntry.value['name'];
  }

  // this function is to add the sub menu to DB and to the tree
  Future<void> addExistingSubMenuToMenu() async {
    try {
      addingExistingMenuProcess.value = true;

      // Fetch the selected menu
      var menu = await FirebaseFirestore.instance
          .collection('menus ')
          .doc(selectedMenuID.value)
          .get();

      if (menu.exists) {
        var menuData = menu.data();
        var childrenList = List<String>.from(menuData?['children'] ?? []);

        // Check for loop prevention
        for (var childId in menuIDFromList) {
          if (await isLoopDetected(childId, selectedMenuID.value)) {
            // Log or show error message for the user
            showSnackBar('Please note', 'Cannot add! it creates a loop!');
            addingExistingMenuProcess.value = false;
            return; // Stop the process
          }
        }

        // Update the children list
        List<String> finalChildrenList = [...childrenList, ...menuIDFromList];

        // Update the selected menu's 'children' field
        await FirebaseFirestore.instance
            .collection('menus ')
            .doc(selectedMenuID.value)
            .update({'children': finalChildrenList});

        // Add the new nodes to the tree
        for (var child in menuIDFromList) {
          var theSelectedMenu = await FirebaseFirestore.instance
              .collection('menus ')
              .doc(child)
              .get();

          if (theSelectedMenu.exists) {
            Map<String, dynamic>? selectedMenuData = theSelectedMenu.data();

            addChildToNode(
              roots,
              selectedMenuName.value,
              MyTreeNode(
                parent: MyTreeNode(
                  title: selectedMenuName.value,
                  id: selectedMenuID.value,
                ),
                title: getMenuName(child),
                children: await buildMenus(selectedMenuData!),
                canRemove: true,
                id: child,
                isMenu: true,
              ),
            );
          }
        }

        treeController.rebuild();
      }

      addingExistingMenuProcess.value = false;
    } catch (e) {
      addingExistingMenuProcess.value = false;
    }
  }

  /// Helper Function to Check for Loop Detection
  Future<bool> isLoopDetected(String childId, String targetMenuId) async {
    // Base case: if the child is the target, a loop would be created
    if (childId == targetMenuId) {
      return true;
    }

    // Fetch the child menu data
    var menu = await FirebaseFirestore.instance
        .collection('menus ')
        .doc(childId)
        .get();

    if (!menu.exists) return false;

    var children = List<String>.from(menu.data()?['children'] ?? []);

    // Recursively check if any child of this menu contains the target
    for (var subChildId in children) {
      if (await isLoopDetected(subChildId, targetMenuId)) {
        return true; // Loop detected in the hierarchy
      }
    }

    return false; // No loop detected
  }

  // this function is to add s screen to DB and to the tree
  Future<void> addExistingScreenToMenu() async {
    try {
      addingExistingScreenProcess.value = true;
      var menu = await FirebaseFirestore.instance
          .collection('menus ')
          .where(FieldPath.documentId, isEqualTo: selectedMenuID.value)
          .get();
      if (menu.docs.isNotEmpty) {
        var menuDoc = menu.docs.first;
        var menuData = menuDoc.data();
        var childrenList = List<String>.from(menuData['children'] ?? []);

        List<String> finalChildrenList = [...childrenList, ...screenIDFromList];

        // Update the selected menu's 'children' field
        await menuDoc.reference.update({'children': finalChildrenList});

        for (var child in screenIDFromList) {
          var theSelectedMenu = await FirebaseFirestore.instance
              .collection('screens')
              .where(FieldPath.documentId, isEqualTo: child)
              .get();

          var selectedScreenData = theSelectedMenu.docs.first.data();

          addChildToNode(
            roots,
            selectedMenuName.value,
            MyTreeNode(
              parent: MyTreeNode(
                title: selectedMenuName.value,
                id: selectedMenuID.value,
              ),
              title: getScreenName(child),
              children: await buildMenus(selectedScreenData),
              canRemove: true,
              id: child,
              isMenu: false,
            ),
          );
        }

        treeController.rebuild();
      }
      addingExistingScreenProcess.value = false;
    } catch (e) {
      addingExistingScreenProcess.value = false;
    }
  }

  // this function is to add the new menu to the menus tree
  void addChildToNode(
    List<MyTreeNode> nodes, // The current list of nodes to search
    String selectedMenuName, // The title of the node to match
    MyTreeNode newChild, // The new child to add
  ) {
    for (var node in nodes) {
      if (node.title == selectedMenuName) {
        // Add the new child if the node matches
        node.children.add(newChild);
        return; // Exit once the child is added
      } else if (node.children.isNotEmpty) {
        // Recursively search in the children
        addChildToNode(node.children, selectedMenuName, newChild);
      }
    }
  }

  // this function is to remove a menu from the tree
  void removeNode(
    List<MyTreeNode> nodes, // The list of nodes to search
    String targetID, // The title of the node to remove
    String parentID,
  ) {
    for (var i = 0; i < nodes.length; i++) {
      if (nodes[i].id == targetID && nodes[i].parent!.id == parentID) {
        // Remove the node if the title matches
        nodes.removeAt(i);
        return; // Exit once the node is removed
      } else if (nodes[i].children.isNotEmpty) {
        // Recursively search in the children
        removeNode(nodes[i].children, targetID, parentID);
      }
    }
    treeController.rebuild();
  }

  // function to manage loading button
  void setButtonLoading(String menuId, bool isLoading) {
    buttonLoadingStates[menuId] = isLoading;
    buttonLoadingStates.refresh(); // Notify listeners
  }

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    // Convert allMenus map to a list of entries for sorting
    final entries = allMenus.entries.toList();

    if (columnIndex == 0) {
      // Sort by 'name' field
      entries.sort((entry1, entry2) {
        final String? value1 = entry1.value.name as String?;
        final String? value2 = entry2.value.name as String?;

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      // Sort by 'added_date' field
      entries.sort((entry1, entry2) {
        final String? value1 = entry1.value.createdAt as String?;
        final String? value2 = entry2.value.createdAt as String?;

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    }

    // Re-construct the sorted map
    allMenus
      ..clear()
      ..addEntries(entries);

    // Update sorting state
    sortColumnIndex.value = columnIndex;
    isAscending.value = ascending;
  }

  int compareString(bool ascending, String value1, String value2) {
    int comparison = value1.compareTo(value2);
    return ascending ? comparison : -comparison; // Reverse if descending
  }

  // this function is to filter the search results for web
  void filterMenus() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredMenus.clear();
    } else {
      filteredMenus.assignAll(
        Map.fromEntries(
          allMenus.entries
              .where(
                (entry) =>
                    entry.value.name.toString().toLowerCase().contains(
                      query.value,
                    ) ||
                    entry.value.code.toString().toLowerCase().contains(
                      query.value,
                    ),
              )
              .map((entry) => MapEntry(entry.key, entry.value)),
        ),
      );
    }
  }

  // Function to get main screens in the system
  Future<void> getScreens() async {
    try {
      allScreens.clear();

      FirebaseFirestore.instance
          .collection('screens')
          .orderBy('name', descending: false)
          .snapshots()
          .listen((screens) {
            allScreens.value = {
              for (var doc in screens.docs) doc.id: doc.data(),
            };
          });
    } catch (e) {
      //
    }
  }

  MyTreeNode buildTreeFromJson(
    Map<String, dynamic> json, {
    bool isRoot = false,
  }) {
    final childrenJson = json['children'] as List<dynamic>? ?? [];

    // تحويل كل طفل recursively
    final childrenNodes = childrenJson
        .map<MyTreeNode>((childJson) => buildTreeFromJson(childJson))
        .toList();

    return MyTreeNode(
      id: json['_id'],
      title: json['name'] ?? '',
      isMenu: json['isMenu'],
      canRemove: json['can_remove'] ?? !isRoot,
      children: childrenNodes,
    );
  }

  Future<void> getMenuTree(String menuId) async {
    try {
      var url = Uri.parse('$backendUrl/menus/get_menu_tree/$menuId');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        roots.value = [buildTreeFromJson(jsonData, isRoot: true)];
        treeController = TreeController<MyTreeNode>(
          roots: roots,
          childrenProvider: (node) => node.children,
          parentProvider: (node) => node.parent,
        );

        treeController.expandAll();
        isLoading.value = false;
      } else {
        isLoading.value = false;
        errorLoading.value = true;
      }
    } catch (e) {
      isLoading.value = false;
      errorLoading.value = true;
    }
  }

  // // this function is to get the tree structure of the selected menu
  // Future<void> getMenusScreens(menuID) async {
  //   try {
  //     // Build tree structure
  //     final menuSnapshot = await FirebaseFirestore.instance
  //         .collection('menus ')
  //         .where(FieldPath.documentId, isEqualTo: menuID)
  //         .get();

  //     roots.value = await Future.wait(
  //       menuSnapshot.docs.map((menuDoc) async {
  //         final children = await buildMenus(menuDoc.data());
  //         return MyTreeNode(
  //           canRemove: false,
  //           id: menuDoc.id,
  //           title: menuDoc.data()['name'],
  //           children: children,
  //           isMenu: true,
  //         );
  //       }),
  //     );

  //     treeController = TreeController<MyTreeNode>(
  //       roots: roots,
  //       childrenProvider: (node) => node.children,
  //       parentProvider: (node) => node.parent,
  //     );
  //     treeController.expandAll();

  //     isLoading.value = false;
  //   } catch (e) {
  //     errorLoading.value = true;
  //     isLoading.value = false;
  //     // print(e);
  //   }
  // }

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
    final menuNodes = await Future.wait(
      menuSnapshot.docs.map((menuDoc) async {
        final children = await buildMenus(menuDoc.data());
        return MyTreeNode(
          canRemove: true,
          id: menuDoc.id,
          title: menuDoc.data()['name'],
          children: children,
          isMenu: true,
        );
      }),
    );

    final screenNodes = screenSnapshot.docs.map((screenDoc) {
      return MyTreeNode(
        canRemove: true,
        id: screenDoc.id,
        title: screenDoc.data()['name'],
        children: [],
        isMenu: false,
      );
    }).toList();

    return [...menuNodes, ...screenNodes];
  }
}
