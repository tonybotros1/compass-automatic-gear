import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropdownController extends GetxController {
  OverlayEntry? overlayEntry;
  var selectedKey = "".obs;
  var selectedValue = {}.obs;
  var searchQuery = "".obs;
  Map<String, dynamic> allItems = {};
  var filteredItems = <String, dynamic>{}.obs;
  var isValid = true.obs;

  void showDropdown(GlobalKey buttonKey, Map<String, dynamic> items) {
    if (overlayEntry != null) return;

    allItems = items;
    filteredItems.assignAll(items);

    RenderBox renderBox = buttonKey.currentContext!.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Tap outside to close
          Positioned.fill(
            child: GestureDetector(
              onTap: hideDropdown,
              child: Container(color: Colors.transparent),
            ),
          ),
          // Dropdown menu
          Positioned(
            left: offset.dx,
            top: offset.dy + renderBox.size.height,
            width: renderBox.size.width,
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Search Bar with Clear Button
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (query) {
                              searchQuery.value = query;
                              filterItems();
                            },
                            decoration: InputDecoration(
                              hintText: "Search...",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                            ),
                          ),
                        ),
                        if (searchQuery.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              searchQuery.value = "";
                              filterItems();
                            },
                          ),
                      ],
                    ),
                  ),
                  // List of filtered items
                  Obx(() => filteredItems.isEmpty
                      ? Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("No results found", style: TextStyle(color: Colors.grey)),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: filteredItems.entries
                              .map(
                                (entry) => ListTile(
                                  title: Text(entry.value["name"].toString()), // Default display
                                  onTap: () {
                                    selectedKey.value = entry.key;
                                    selectedValue.value = entry.value;
                                    isValid.value = true;
                                    hideDropdown();
                                  },
                                ),
                              )
                              .toList(),
                        )),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(Get.overlayContext!).insert(overlayEntry!);
  }

  void hideDropdown() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

 void filterItems() {
  if (searchQuery.value.isEmpty) {
    filteredItems.assignAll(allItems);
  } else {
    filteredItems.assignAll(Map.fromEntries(
      allItems.entries.where((entry) =>
          entry.value["name"].toString().toLowerCase().contains(searchQuery.value.toLowerCase())),
    ));
  }
}


  void validateSelection() {
    if (selectedKey.value.isEmpty) {
      isValid.value = false;
    } else {
      isValid.value = true;
    }
  }

  void setValue(String key) {
    if (allItems.containsKey(key)) {
      selectedKey.value = key;
      selectedValue.value = allItems[key];
      isValid.value = true;
    }
  }
}