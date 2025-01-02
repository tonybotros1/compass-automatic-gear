import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Models/screen_tree_model.dart';

class MenusController extends GetxController {
  // final RxList<DocumentSnapshot> allMenus = RxList<DocumentSnapshot>([]);
  late TextEditingController menuName =
      TextEditingController(); // new menu name
  late TextEditingController menuNameFromList = TextEditingController();
  RxString menuIDFromList = RxString('');

  RxMap allMenus = RxMap();
  RxList menusSubMenusChildren = RxList([]);
  RxList menusSscreensChildren = RxList([]);
  RxMap<String, Map<String, dynamic>> filteredMenus =
      RxMap<String, Map<String, dynamic>>();
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoading = RxBool(true);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);

// ========== test=================
  RxDouble containerWidth = RxDouble(300);
  RxList rolesMenus = RxList([]);
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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyForDropDownList = GlobalKey<FormState>();
  RxMap<String, String> selectFromMenus = RxMap({});
  RxBool deletingProcess = RxBool(false);

  @override
  void onInit() {
    getMenus();
    search.value.addListener(() {
      filterMenus();
    });
    super.onInit();
  }

  addExistingSubMenuToMenu() async {
    try {
      addingExistingMenuProcess.value = true;
      var menu = await FirebaseFirestore.instance
          .collection('menus ')
          .where(FieldPath.documentId, isEqualTo: selectedMenuID.value)
          .get();
      if (menu.docs.isNotEmpty) {
        var menuDoc = menu.docs.first;
        var menuData = menuDoc.data();
        var childrenList = List<String>.from(menuData['children'] ?? []);

        // Add the new menu ID to the children list
        childrenList.add(menuIDFromList.value);

        // Update the selected menu's 'children' field
        await menuDoc.reference.update({'children': childrenList});

        var theSelectedMenu = await FirebaseFirestore.instance
            .collection('menus ')
            .where(FieldPath.documentId, isEqualTo: menuIDFromList.value)
            .get();

        var selectedMenuData = theSelectedMenu.docs.first.data();

        await addChildToNode(
            roots,
            selectedMenuName.value,
            MyTreeNode(
              title: menuNameFromList.text,
              children: await buildMenus(selectedMenuData),
              canDelete: true,
              id: menuIDFromList.value,
              isMenu: true,
            ));
        treeController.rebuild();
      }
      addingExistingMenuProcess.value = false;
    } catch (e) {
      addingExistingMenuProcess.value = false;
    }
  }

// this function to get list of menus to select of them
  listOfMenus() async {
    try {
      var menus = await FirebaseFirestore.instance
          .collection('menus ')
          .where(FieldPath.documentId, whereNotIn: allMenus.keys)
          .get();

      if (menus.docs.isNotEmpty) {
        for (var menu in menus.docs) {
          selectFromMenus[menu.id] = menu.data()['name'];
        }
      }
    } catch (e) {
//
    }
  }

// this function is to delete a menu
  deleteMenu() async {
    try {
      deletingProcess.value = true;
      var menuToDelete = FirebaseFirestore.instance
          .collection('menus ')
          .doc(selectedMenuID.value);

      var menuDetails = await menuToDelete.get();

      if (menuDetails.exists) {
        // Get parent ID
        var parentID = menuDetails.data()?['parent_id'];

        if (parentID != null) {
          // Fetch parent menu
          var parentMenuSnapshot = await FirebaseFirestore.instance
              .collection('menus ')
              .where(FieldPath.documentId, isEqualTo: parentID)
              .get();

          if (parentMenuSnapshot.docs.isNotEmpty) {
            // Get the list of children
            var parentMenu = parentMenuSnapshot.docs.first;
            List<dynamic> listOfChildren =
                List<dynamic>.from(parentMenu.data()['children'] ?? []);

            // Remove the selected menu ID
            listOfChildren.removeWhere((id) => id == selectedMenuID.value);

            // Update the parent menu document
            await parentMenu.reference.update({'children': listOfChildren});
            await menuToDelete.delete();
            removeNode(roots, selectedMenuID.value);
            selectedMenuID.value = '';
            treeController.rebuild();
            deletingProcess.value = false;
          }
        }
      }
      deletingProcess.value = false;
    } catch (e) {
      deletingProcess.value = false;
    }
  }

  // this function is to add new menu to the system
  addNewMenu() async {
    try {
      addingNewMenuProcess.value = true;
      // Adding a new menu
      var newMenu = await FirebaseFirestore.instance.collection('menus ').add({
        'name': menuName.text,
        'added_date': DateTime.now().toString(),
        'children': [],
        'parent_id': selectedMenuID.value,
      });

      var newMenuID = newMenu.id;

      await addChildToNode(
          roots,
          selectedMenuName.value,
          MyTreeNode(
            title: menuName.text,
            children: [],
            canDelete: true,
            id: newMenuID,
            isMenu: true,
          ));
      treeController.rebuild();

      // Fetching the selected menu to update its 'children'
      var menuSnapshot = await FirebaseFirestore.instance
          .collection('menus ')
          .where(FieldPath.documentId, isEqualTo: selectedMenuID.value)
          .get();

      if (menuSnapshot.docs.isNotEmpty) {
        // Retrieve the current children list
        var menuDoc = menuSnapshot.docs.first;
        var menuData = menuDoc.data();
        var childrenList = List<String>.from(menuData['children'] ?? []);

        // Add the new menu ID to the children list
        childrenList.add(newMenuID);

        // Update the selected menu's 'children' field
        await menuDoc.reference.update({'children': childrenList});
      }

      addingNewMenuProcess.value = false;
    } catch (e) {
      addingNewMenuProcess.value = false;

      //
    }
  }

// this function is to add the new menu to the menus tree
  addChildToNode(
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
  ) {
    for (var i = 0; i < nodes.length; i++) {
      if (nodes[i].id == targetID) {
        // Remove the node if the title matches
        nodes.removeAt(i);
        return; // Exit once the node is removed
      } else if (nodes[i].children.isNotEmpty) {
        // Recursively search in the children
        removeNode(nodes[i].children, targetID);
      }
    }
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
        final String? value1 = entry1.value['name'] as String?;
        final String? value2 = entry2.value['name'] as String?;

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      // Sort by 'added_date' field
      entries.sort((entry1, entry2) {
        final String? value1 = entry1.value['added_date'] as String?;
        final String? value2 = entry2.value['added_date'] as String?;

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
              .where((entry) => entry.value['name']
                  .toString()
                  .toLowerCase()
                  .contains(query.value))
              .map((entry) => MapEntry(
                  entry.key as String, entry.value as Map<String, dynamic>)),
        ),
      );
    }
  }

// Function to get main menus in the system
  getMenus() async {
    try {
      rolesMenus.clear();
      allMenus.clear();

      FirebaseFirestore.instance
          .collection('sys-roles')
          .snapshots()
          .listen((roles) {
        // Flatten the list of lists into a single list
        rolesMenus.addAll(
          roles.docs
              .map((role) => role.data()['menuID'] ?? [])
              .expand((menuID) => menuID is List ? menuID : [menuID])
              .toList(),
        );

        // Ensure rolesMenus contains only unique, valid strings
        rolesMenus.value = rolesMenus
            .whereType<String>()
            .where((id) => id.isNotEmpty)
            .toSet()
            .toList();

        if (rolesMenus.isEmpty) {
          isScreenLoading.value = false;
          return;
        }

        FirebaseFirestore.instance
            .collection('menus ')
            .where(FieldPath.documentId, whereIn: rolesMenus)
            .orderBy('name', descending: false)
            .snapshots()
            .listen((menus) {
          for (var menu in menus.docs) {
            allMenus[menu.id] = {
              'name': menu.data()['name'] ?? 'Unknown',
              'added_date': menu.data()['added_date'],
            };
          }
          listOfMenus();
          isScreenLoading.value = false;
        });
      });
    } catch (e) {
      isScreenLoading.value = false;
    }
  }

// this function is to get the tree structure of the selected menu
  Future<void> getMenusScreens(menuID) async {
    try {
      // Build tree structure
      final menuSnapshot = await FirebaseFirestore.instance
          .collection('menus ')
          .where(FieldPath.documentId, isEqualTo: menuID)
          .get();

      roots.value = await Future.wait(menuSnapshot.docs.map((menuDoc) async {
        final children = await buildMenus(menuDoc.data());
        return MyTreeNode(
          canDelete: false,
          id: menuDoc.id,
          title: menuDoc.data()['name'],
          children: children,
          isMenu: true,
        );
      }));

      treeController = TreeController<MyTreeNode>(
        roots: roots,
        childrenProvider: (node) => node.children,
        parentProvider: (node) => node.parent,
      );

      isLoading.value = false;
    } catch (e) {
      errorLoading.value = true;
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
        canDelete: true,
        id: menuDoc.id,
        title: menuDoc.data()['name'],
        children: children,
        isMenu: true,
      );
    }));

    final screenNodes = screenSnapshot.docs.map((screenDoc) {
      return MyTreeNode(
        canDelete: true,
        id: screenDoc.id,
        title: screenDoc.data()['name'],
        children: [],
        isMenu: false,
      );
    }).toList();

    return [...menuNodes, ...screenNodes];
  }

  // function to convert text to date and make the format dd-mm-yyyy
  String textToDate(dynamic inputDate) {
    try {
      if (inputDate is String) {
        // Match the actual date format of the input
        DateTime parsedDate =
            DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(inputDate);
        return DateFormat("dd-MM-yyyy").format(parsedDate);
      } else if (inputDate is DateTime) {
        return DateFormat("dd-MM-yyyy").format(inputDate);
      } else {
        throw FormatException("Invalid input type for textToDate: $inputDate");
      }
    } catch (e) {
      return "Invalid Date"; // Return a default or placeholder string
    }
  }
}
