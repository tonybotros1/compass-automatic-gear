import 'dart:convert';
import 'package:datahubai/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/menus_functions_roles/menus_model.dart';
import '../../Models/menus_functions_roles/screens_model.dart';
import '../../Models/screen_tree_model.dart';
import '../../consts.dart';
import 'main_screen_contro.dart';
import 'websocket_controller.dart';

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
  RxMap<String, dynamic> allScreens = RxMap<String, dynamic>({});
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
  WebSocketService ws = Get.find<WebSocketService>();
  String backendUrl = backendTestURI;
  Helpers helper = Helpers();
  final secureStorage = const FlutterSecureStorage();

  @override
  void onInit() {
    connectWebSocket();
    getMenus();
    super.onInit();
  }

  String getScreenNameForHeader() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();

    return mainScreenController.selectedScreenName.value;
  }

  void connectWebSocket() {
    ws.events.listen((message) {
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
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendUrl/menus/get_menus');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<MenuModel> menuList = (decoded["menus"] as List)
            .map((json) => MenuModel.fromJson(json))
            .toList();
        allMenus.value = {for (var menu in menuList) menu.id: menu.toJson()};
        isScreenLoading.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getMenus();
        } else if (refreshed == RefreshResult.invalidToken) {
          isScreenLoading.value = false;
          logout();
        } else {
          isScreenLoading.value = false;
        }
      } else if (response.statusCode == 401) {
        isScreenLoading.value = false;
        logout();
      } else {
        isScreenLoading.value = false;
      }
    } catch (e) {
      isScreenLoading.value = false;
    }
  }

  Future<void> addNewMenu() async {
    try {
      addingNewMenuProcess.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendUrl/menus/add_new_menu');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
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
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewMenu();
        } else if (refreshed == RefreshResult.invalidToken) {
          addingNewMenuProcess.value = false;
          logout();
        } else {
          addingNewMenuProcess.value = false;
        }
      } else if (response.statusCode == 401) {
        addingNewMenuProcess.value = false;
        logout();
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
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendUrl/menus/delete_menu/$menuId');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        Get.back();

        // showSnackBar('Done', 'Menu deleted successfully');
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteMenuAndUpdateChildren(menuId);
        } else if (refreshed == RefreshResult.invalidToken) {
          Get.back();
          logout();
        }
      } else if (response.statusCode == 401) {
        Get.back();
        logout();
      } else {
        Get.back();
        showSnackBar('Error', 'Failed to delete menu');
      }
    } catch (e) {
      Get.back();
      showSnackBar('Error', 'Failed to delete menu');
    }
  }

  Future<void> editMenu(String menuID) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      addingNewMenuProcess.value = true;
      var url = Uri.parse('$backendUrl/menus/update_menu/$menuID');
      final response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
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
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await editMenu(menuID);
        } else if (refreshed == RefreshResult.invalidToken) {
          addingNewMenuProcess.value = false;
          logout();
        } else {
          addingNewMenuProcess.value = false;
        }
      } else if (response.statusCode == 401) {
        addingNewMenuProcess.value = false;
        logout();
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
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendUrl/menus/remove_node_from_the_tree/$parentID/$nodeID',
      );
      final response = await http.patch(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        removeNode(roots, nodeID, parentID);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await removeNodeFromTheTree(nodeID, parentID);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        showSnackBar('Alert', 'Can\'t remove node please try again');
      }
    } catch (e) {
      showSnackBar('Alert', 'Can\'t remove node please try again');
    }
  }

  // this function is to remove a menu from the list
  void removeMenuOrScreenFromList(int index, RxList<dynamic> list) {
    list.removeAt(index);
  }

  // this function to get menu name by id and add it to the screen
  String getMenuOrScreenName(String menuID, RxMap<String, dynamic> dataMap) {
    // Find the entry with the matching key
    final matchingEntry = dataMap.entries.firstWhere(
      (entry) => entry.key == menuID,
      orElse: () =>
          const MapEntry('', 'Unknown'), // Handle cases where no match is found
    );
    final menuName = matchingEntry.value["name"]
        .replaceAll(RegExp(r'\s*\(.*?\)'), '')
        .trim();

    return menuName;
  }

  Future<void> addSubMenuToExistingMenu() async {
    try {
      addingExistingMenuProcess.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendUrl/menus/add_sub_menus/${selectedMenuID.value}',
      );
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({"submenus": menuIDFromList}),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        MyTreeNode newTree = buildTreeFromJson(decoded, isRoot: true);

        for (var child in newTree.children) {
          if (menuIDFromList.contains(child.id)) {
            addChildToNode(
              roots,
              selectedMenuID.value,
              MyTreeNode(
                parent: MyTreeNode(
                  title: selectedMenuName.value,
                  id: selectedMenuID.value,
                ),
                title: child.title,
                children: child.children,
                canRemove: child.canRemove,
                id: child.id,
                isMenu: child.isMenu,
              ),
            );
          }
        }
        treeController.expandAll();
        treeController.rebuild();

        addingExistingMenuProcess.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addSubMenuToExistingMenu();
        } else if (refreshed == RefreshResult.invalidToken) {
          addingExistingMenuProcess.value = false;
          logout();
        }
      } else if (response.statusCode == 401) {
        addingExistingMenuProcess.value = false;
        logout();
      } else {
        showSnackBar('Alert', 'Can\'t add');
        addingExistingMenuProcess.value = false;
      }
    } catch (e) {
      addingExistingMenuProcess.value = false;
    }
  }

  // =====================================================================================================================

  Future<void> addScreenToExistringMenu() async {
    try {
      addingExistingScreenProcess.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendUrl/menus/add_sub_menus/${selectedMenuID.value}',
      );
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({"submenus": screenIDFromList, "is_menu": false}),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        MyTreeNode newTree = buildTreeFromJson(decoded, isRoot: true);

        for (var child in newTree.children) {
          if (screenIDFromList.contains(child.id)) {
            addChildToNode(
              roots,
              selectedMenuID.value,
              MyTreeNode(
                parent: MyTreeNode(
                  title: selectedMenuName.value,
                  id: selectedMenuID.value,
                ),
                title: child.title,
                children: child.children,
                canRemove: child.canRemove,
                id: child.id,
                isMenu: child.isMenu,
              ),
            );
          }
        }
        treeController.expandAll();
        treeController.rebuild();

        addingExistingScreenProcess.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addScreenToExistringMenu();
        } else if (refreshed == RefreshResult.invalidToken) {
          addingExistingScreenProcess.value = false;
          logout();
        }
      } else if (response.statusCode == 401) {
        addingExistingScreenProcess.value = false;
        logout();
      } else {
        showSnackBar('Alert', 'Can\'t add');
        addingExistingScreenProcess.value = false;
      }
    } catch (e) {
      addingExistingScreenProcess.value = false;
    }
  }

  // this function is to add the new menu to the menus tree
  void addChildToNode(
    List<MyTreeNode> nodes, // The current list of nodes to search
    String selectedMenuId, // The title of the node to match
    MyTreeNode newChild, // The new child to add
  ) {
    for (var node in nodes) {
      if (node.id == selectedMenuId) {
        node.children.add(newChild);
      } else if (node.children.isNotEmpty) {
        addChildToNode(node.children, selectedMenuId, newChild);
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
        nodes.removeAt(i);
      } else if (nodes[i].children.isNotEmpty) {
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
    final entries = allMenus.entries.toList();

    if (columnIndex == 0) {
      // Sort by 'name' field
      entries.sort((entry1, entry2) {
        final String? value1 = entry1.value["name"] as String?;
        final String? value2 = entry2.value["name"] as String?;

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      // Sort by 'added_date' field
      entries.sort((entry1, entry2) {
        final String? value1 = entry1.value['createdAt'] as String?;
        final String? value2 = entry2.value['createdAt'] as String?;

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
                    entry.value['name'].toString().toLowerCase().contains(
                      query.value,
                    ) ||
                    entry.value['code'].toString().toLowerCase().contains(
                      query.value,
                    ),
              )
              .map((entry) => MapEntry(entry.key, entry.value)),
        ),
      );
    }
  }

  Future<void> getScreens() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendTestURI/functions/get_screens');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<FunctionsModel> menuList = (decoded["screens"] as List)
            .map((json) => FunctionsModel.fromJson(json))
            .toList();
        allScreens.value = {for (var menu in menuList) menu.id: menu.toJson()};
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getScreens();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
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
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendUrl/menus/get_menu_tree/$menuId');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
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
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getMenuTree(menuId);
        } else if (refreshed == RefreshResult.invalidToken) {
          errorLoading.value = true;
          isLoading.value = false;
          logout();
        } else {
          errorLoading.value = true;
          isLoading.value = false;
        }
      } else {
        errorLoading.value = true;
        isLoading.value = false;
        logout();
      }
    } catch (e) {
      isLoading.value = false;
      errorLoading.value = true;
    }
  }
}
