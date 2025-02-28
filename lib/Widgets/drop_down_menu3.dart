import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropdownController extends GetxController {
  OverlayEntry? overlayEntry;
  RxString selectedKey = "".obs;
  RxMap selectedValue = {}.obs;
  RxString searchQuery = "".obs;
  Map allItems = {};
  RxMap filteredItems = {}.obs;
  RxBool isValid = true.obs;
  Rx<TextEditingController> query = TextEditingController().obs;

  /// A function that extracts the search text from the itemBuilder widget.
  String extractSearchableText(Widget widget) {
    if (widget is ListTile) {
      if (widget.title is Text) {
        return (widget.title as Text).data ?? "";
      }
    } else if (widget is Text) {
      return widget.data ?? "";
    }
    return "";
  }

  /// Shows the dropdown overlay.
  void showDropdown(
    BuildContext context,
    GlobalKey buttonKey,
    Map items, {
    required Widget Function(BuildContext, String, dynamic) itemBuilder,
    void Function(String, dynamic)? onChanged,
  }) {
    if (overlayEntry != null) return;

    allItems = items;
    filteredItems.assignAll(items);
    query.value.text = searchQuery.value;

    RenderBox renderBox =
        buttonKey.currentContext!.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    final hoveredItemKey = Rxn<dynamic>(); // Track hovered item

    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Tapping outside closes the dropdown.
          Positioned.fill(
            child: GestureDetector(
              onTap: hideDropdown,
              child: Container(color: Colors.transparent),
            ),
          ),
          // Dropdown overlay.
          Positioned(
            left: offset.dx,
            top: offset.dy + renderBox.size.height,
            width: renderBox.size.width,
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Search bar with clear (X) button.
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: query.value,
                      onChanged: (query) {
                        searchQuery.value = query;
                        filterItems(itemBuilder);
                      },
                      decoration: InputDecoration(
                        hintText: "Search...",
                        suffixIcon: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            searchQuery.value = '';
                            query.value.clear();
                            filterItems(itemBuilder);
                          },
                        ),
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                      ),
                    ),
                  ),
                  // List of filtered items built via the custom itemBuilder.
                  Obx(() => filteredItems.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8),
                          child: const Text("No results found",
                              style: TextStyle(color: Colors.grey)),
                        )
                      : Container(
                          constraints: BoxConstraints(maxHeight: 200),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: filteredItems.entries.map((entry) {
                                bool isHovered =
                                    hoveredItemKey.value == entry.key;
                                return MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  onEnter: (_) =>
                                      hoveredItemKey.value = entry.key,
                                  onExit: (_) => hoveredItemKey.value = null,
                                  child: GestureDetector(
                                    onTap: () {
                                      selectedKey.value = entry.key;
                                      selectedValue.value = entry.value;
                                      isValid.value = true;
                                      hideDropdown();
                                      if (onChanged != null) {
                                        onChanged(entry.key, entry.value);
                                      }
                                    },
                                    child: Container(
                                      color: isHovered
                                          ? Colors.grey[300]
                                          : Colors.transparent,
                                      child: itemBuilder(
                                          context, entry.key, entry.value),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
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

  /// Hides the dropdown overlay.
  void hideDropdown() {
    query.value.clear();
    overlayEntry?.remove();
    overlayEntry = null;
  }

  /// Filters items based on the text inside itemBuilder.
  void filterItems(Widget Function(BuildContext, String, dynamic) itemBuilder) {
    if (searchQuery.value.isEmpty) {
      filteredItems.assignAll(allItems);
    } else {
      filteredItems.assignAll(Map.fromEntries(
        allItems.entries.where((entry) {
          Widget builtItem = itemBuilder(Get.context!, entry.key, entry.value);
          String searchText = extractSearchableText(builtItem);
          return searchText
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase());
        }),
      ));
    }
  }

  /// Validates whether a selection has been made.
  void validateSelection() {
    isValid.value = selectedKey.value.isNotEmpty;
  }

  /// Programmatically sets the selected value.
  void setValue(String key) {
    if (allItems.containsKey(key)) {
      selectedKey.value = key;
      selectedValue.value = allItems[key];
      isValid.value = true;
    }
  }
}

class CustomDropdown extends StatelessWidget {
  final Map items;
  final String hintText;
  final BoxDecoration? dropdownDecoration;
  final BoxDecoration? disabledDecoration;
  final void Function(String, dynamic)? onChanged;
  final Widget Function(BuildContext, String, dynamic) itemBuilder;
  final String textcontroller;
  final bool? enabled; // Marked final
  final TextStyle? enabledTextStyle;
  final TextStyle? disabledTextStyle;
  final String showedSelectedName;
  final bool? validator;

  CustomDropdown({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.textcontroller = '',
    this.onChanged,
    this.hintText = "Select an option",
    this.dropdownDecoration,
    this.disabledDecoration,
    this.enabled = true,
    this.enabledTextStyle,
    this.disabledTextStyle,
    this.showedSelectedName = '',
    this.validator,
  });

  final GlobalKey buttonKey = GlobalKey();
  final DropdownController controller = DropdownController();
  final RxString textControllerValue = RxString('');

  @override
  Widget build(BuildContext context) {
    // Default decoration for the enabled state.
    BoxDecoration defaultEnabledDecoration = BoxDecoration(
      color: Colors.grey.shade200,
      border: Border.all(
          color: controller.isValid.value ? Colors.grey : Colors.red),
      borderRadius: BorderRadius.circular(5),
    );

    // Default decoration for the disabled state (similar to a disabled TextFormField).
    BoxDecoration defaultDisabledDecoration = BoxDecoration(
      border: Border.all(
        color: Colors.grey.shade400,
      ),
      borderRadius: BorderRadius.circular(5),
    );

    // Default text styles.
    TextStyle defaultEnabledTextStyle = showedSelectedName.isEmpty && textControllerValue.isEmpty 
        ? TextStyle(fontSize: 16, color: Colors.grey.shade700)
        : TextStyle(fontSize: 16, color: Colors.black);
    TextStyle defaultDisabledTextStyle =
        const TextStyle(color: Colors.grey, fontSize: 16);

    textControllerValue.value = textcontroller;

    bool isEnabled = items.isEmpty ? false : enabled ?? true;

    return FormField<dynamic>(
      validator: (value) {
        if (validator == true) {
          if (value == null || value.isEmpty) {
            return "    Please Select an Option";
          }
          return null;
        } else {
          return null;
        }
      },
      builder: (FormFieldState<dynamic> state) {
        return Column(
          children: [
            GestureDetector(
              key: buttonKey,
              onTap: isEnabled
                  ? () {
                      controller.showDropdown(
                        context,
                        buttonKey,
                        items,
                        itemBuilder: itemBuilder,
                        onChanged: (key, value) {
                          textControllerValue.value = '';
                          controller.selectedKey.value = key;
                          controller.selectedValue.value = value;
                          controller.isValid.value = true;
                          controller.hideDropdown();
                          // Notify the FormField that the value has changed.
                          state.didChange(value);
                          if (onChanged != null) {
                            onChanged!(key, value);
                          }
                        },
                      );
                    }
                  : null,
              child: Obx(() => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    decoration: isEnabled
                        ? (dropdownDecoration ?? defaultEnabledDecoration)
                        : (disabledDecoration ?? defaultDisabledDecoration),
                    child: Row(
                      children: [
                        Text(
                          textControllerValue.isEmpty
                              ? controller.selectedKey.isEmpty
                                  ? hintText
                                  : controller.selectedValue[showedSelectedName]
                                      .toString()
                              : textControllerValue.value,
                          style: isEnabled
                              ? (enabledTextStyle ?? defaultEnabledTextStyle)
                              : (disabledTextStyle ?? defaultDisabledTextStyle),
                        ),
                        const Spacer(),
                        Icon(Icons.arrow_drop_down,
                            color: isEnabled ? Colors.black : Colors.grey),
                      ],
                    ),
                  )),
            ),
            controller.isValid.value
                ? const SizedBox()
                : const SizedBox(height: 5),
            Obx(() => controller.isValid.value
                ? const SizedBox.shrink()
                : const Text("    Please Select an Option",
                    style: TextStyle(color: Colors.red))),
            // Display the FormField error message, if any.
            state.hasError
                ? Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(state.errorText ?? "",
                          style:
                              TextStyle(color: Colors.red[900], fontSize: 13)),
                    ),
                  )
                : const SizedBox(),
          ],
        );
      },
    );
  }
}
