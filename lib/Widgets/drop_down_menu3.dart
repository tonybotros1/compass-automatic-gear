import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  RxString textController = RxString('');
  RxString showedSelectedName = RxString('');
  FocusNode overlayFocusNode = FocusNode();
  FocusNode searchFocusNode = FocusNode();
  ScrollController scrollController = ScrollController();
  RxString highlightedKey = RxString('');

  @override
  void onClose() {
    overlayFocusNode.dispose();
    searchFocusNode.dispose();
    scrollController.dispose();
    super.onClose();
  }

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

  void showDropdown(
    BuildContext context,
    GlobalKey buttonKey,
    Map items, {
    required Widget Function(BuildContext, String, dynamic) itemBuilder,
    void Function(String, dynamic)? onChanged,
    required LayerLink layerLink,
  }) {
    if (overlayEntry != null) return;

    allItems = items;
    filteredItems.assignAll(items);
    query.value.text = searchQuery.value;

    // Obtain the size and position of the dropdown field.
    RenderBox renderBox =
        buttonKey.currentContext!.findRenderObject() as RenderBox;
    Offset fieldOffset = renderBox.localToGlobal(Offset.zero);
    double fieldWidth = renderBox.size.width;
    double fieldHeight = renderBox.size.height;
    double screenHeight = MediaQuery.of(context).size.height;
    double availableSpaceBelow = screenHeight - fieldOffset.dy - fieldHeight;
    double availableSpaceAbove = fieldOffset.dy;
    double dropdownMaxHeight = 175.0;

    bool showAbove = availableSpaceBelow < dropdownMaxHeight &&
        availableSpaceAbove > availableSpaceBelow;
    double offsetY = showAbove ? -dropdownMaxHeight : fieldHeight;

    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: hideDropdown,
              child: Container(color: Colors.transparent),
            ),
          ),
          CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            offset: Offset(0, offsetY),
            child: SizedBox(
              width: fieldWidth,
              child: Focus(
                focusNode: overlayFocusNode,
                onKeyEvent: (node, event) {
                  if (event is KeyDownEvent) {
                    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                      _moveHighlight(1);
                      return KeyEventResult.handled;
                    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                      _moveHighlight(-1);
                      return KeyEventResult.handled;
                    } else if (event.logicalKey == LogicalKeyboardKey.enter) {
                      _selectHighlightedItem(onChanged);
                      return KeyEventResult.handled;
                    }
                  }
                  return KeyEventResult.ignored;
                },
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          autofocus: true,
                          focusNode: searchFocusNode,
                          controller: query.value,
                          onChanged: (query) {
                            searchQuery.value = query;
                            filterItems(itemBuilder);
                          },
                          decoration: InputDecoration(
                            hintText: "Search...",
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                searchQuery.value = '';
                                query.value.clear();
                                filterItems(itemBuilder);
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                          ),
                        ),
                      ),
                      Obx(() => filteredItems.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("No results found",
                                  style: TextStyle(color: Colors.grey)),
                            )
                          : Container(
                              constraints: BoxConstraints(
                                maxHeight: dropdownMaxHeight,
                              ),
                              child: Scrollbar(
                                controller: scrollController,
                                thumbVisibility: true,
                                trackVisibility: true,
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children:
                                        filteredItems.entries.map((entry) {
                                      return MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        onEnter: (_) =>
                                            highlightedKey.value = entry.key,
                                        onExit: (_) =>
                                            highlightedKey.value = '',
                                        child: GestureDetector(
                                          onTap: () {
                                            selectedKey.value = entry.key;
                                            selectedValue.value = entry.value;
                                            textController.value = '';
                                            isValid.value = true;
                                            hideDropdown();
                                            onChanged?.call(
                                                entry.key, entry.value);
                                          },
                                          child: Obx(() => Container(
                                                color: _getItemColor(
                                                  entry.key,
                                                  entry.value,
                                                ),
                                                child: itemBuilder(context,
                                                    entry.key, entry.value),
                                              )),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(Get.overlayContext!).insert(overlayEntry!);
    searchFocusNode.requestFocus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      String? initialHighlightKey;

      if (selectedKey.value.isNotEmpty &&
          filteredItems.containsKey(selectedKey.value)) {
        initialHighlightKey = selectedKey.value;
      } else if (textController.value.isNotEmpty) {
        initialHighlightKey = _findKeyByTextValue();
      }

      if (initialHighlightKey == null && filteredItems.isNotEmpty) {
        initialHighlightKey = filteredItems.keys.first;
      }

      highlightedKey.value = initialHighlightKey ?? '';
      _scrollToHighlightedItem();
    });
  }

  String? _findKeyByTextValue() {
    for (var entry in filteredItems.entries) {
      if (showedSelectedName.value.isNotEmpty) {
        if (entry.value[showedSelectedName.value] == textController.value) {
          return entry.key;
        }
      } else {
        return null;
      }
    }
    return null;
  }

  Color _getItemColor(String key, dynamic value) {
    final isSelected = selectedKey.value == key;
    final isTextMatch = showedSelectedName.value.isNotEmpty
        ? textController.value.isNotEmpty &&
            value[showedSelectedName.value] == textController.value
        : false;
    final isHighlighted = highlightedKey.value == key;

    if (isSelected || isTextMatch) {
      return Colors.grey.shade300;
    } else if (isHighlighted) {
      return Colors.blue[100]!;
    }
    return Colors.transparent;
  }

  void _moveHighlight(int direction) {
    if (filteredItems.isEmpty) return;

    final keys = filteredItems.keys.toList();
    int currentIndex = keys.indexOf(highlightedKey.value);

    if (currentIndex == -1) {
      highlightedKey.value = keys.first;
    } else {
      int newIndex = currentIndex + direction;
      if (newIndex >= 0 && newIndex < keys.length) {
        highlightedKey.value = keys[newIndex];
      } else if (newIndex < 0) {
        highlightedKey.value = keys.last;
      } else {
        highlightedKey.value = keys.first;
      }
    }
    _scrollToHighlightedItem();
  }

  void _scrollToHighlightedItem() {
    final keys = filteredItems.keys.toList();
    int index = keys.indexOf(highlightedKey.value);
    if (index != -1 && scrollController.hasClients) {
      const double itemHeight = 48.0;
      double scrollOffset = index * itemHeight;
      double maxScroll = scrollController.position.maxScrollExtent;
      double targetOffset = scrollOffset.clamp(0.0, maxScroll);

      scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  void _selectHighlightedItem(void Function(String, dynamic)? onChanged) {
    if (highlightedKey.value.isNotEmpty &&
        filteredItems.containsKey(highlightedKey.value)) {
      selectedKey.value = highlightedKey.value;
      selectedValue.value = filteredItems[highlightedKey.value];
      textController.value = '';
      isValid.value = true;
      onChanged?.call(
          highlightedKey.value, filteredItems[highlightedKey.value]);
      hideDropdown();
    }
  }

  void hideDropdown() {
    query.value.clear();
    overlayEntry?.remove();
    overlayEntry = null;
    highlightedKey.value = '';
  }

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

    String? newHighlightKey;

    if (selectedKey.value.isNotEmpty &&
        filteredItems.containsKey(selectedKey.value)) {
      newHighlightKey = selectedKey.value;
    } else if (textController.value.isNotEmpty) {
      newHighlightKey = _findKeyByTextValue();
    } else if (filteredItems.isNotEmpty) {
      newHighlightKey = filteredItems.keys.first;
    }

    highlightedKey.value = newHighlightKey ?? '';
  }

  void validateSelection() {
    isValid.value = selectedKey.value.isNotEmpty;
  }

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
  final bool? enabled;
  final TextStyle? enabledTextStyle;
  final TextStyle? disabledTextStyle;
  final String showedSelectedName;
  final bool? validator;
  final Widget Function(String, dynamic)? showedResult;

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
    this.showedResult,
  });

  final GlobalKey buttonKey = GlobalKey();
  final DropdownController controller = DropdownController();
  final RxString textControllerValue = RxString('');
  // Define a LayerLink to bind the target and follower.
  final LayerLink _layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    BoxDecoration defaultEnabledDecoration = BoxDecoration(
      color: Colors.grey.shade200,
      border: Border.all(
          color: controller.isValid.value ? Colors.grey : Colors.red),
      borderRadius: BorderRadius.circular(5),
    );

    BoxDecoration defaultDisabledDecoration = BoxDecoration(
      border: Border.all(color: Colors.grey.shade400),
      borderRadius: BorderRadius.circular(5),
    );

    TextStyle defaultDisabledTextStyle =
        const TextStyle(color: Colors.grey, fontSize: 16);

    textControllerValue.value = textcontroller;
    controller.textController.value = textcontroller;
    controller.showedSelectedName.value = showedSelectedName;

    bool isEnabled = items.isEmpty ? false : enabled ?? true;

    return FormField<dynamic>(
      validator: (value) {
        if (validator == true) {
          if (value == null || value.isEmpty) {
            return "    Please Select an Option";
          }
        }
        return null;
      },
      builder: (FormFieldState<dynamic> state) {
        if (state.hasError) {
          controller.isValid.value = false;
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wrap the dropdown button with CompositedTransformTarget.
            CompositedTransformTarget(
              link: _layerLink,
              child: GestureDetector(
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
                            state.didChange(value);
                            onChanged?.call(key, value);
                          },
                          layerLink: _layerLink,
                        );
                      }
                    : null,
                child: Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 2),
                        child: Text(
                          hintText,
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        height: 35,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: controller.isValid.isFalse
                            ? BoxDecoration(
                                color: Colors.grey.shade200,
                                border: Border.all(color: Colors.red),
                                borderRadius: BorderRadius.circular(5),
                              )
                            : isEnabled
                                ? (dropdownDecoration ??
                                    (defaultEnabledDecoration))
                                : (disabledDecoration ??
                                    defaultDisabledDecoration),
                        child: Row(
                          children: [
                            Expanded(
                              child: showedResult != null &&
                                      controller.selectedKey.isNotEmpty
                                  ? showedResult!(controller.selectedKey.value,
                                      controller.selectedValue)
                                  : Text(
                                      textControllerValue.isEmpty
                                          ? controller.selectedKey.isEmpty
                                              ? hintText
                                              : showedSelectedName.isNotEmpty
                                                  ? controller.selectedValue[
                                                          showedSelectedName]
                                                      .toString()
                                                  : hintText
                                          : textControllerValue.value,
                                      style: isEnabled
                                          ? (enabledTextStyle ??
                                              (textControllerValue
                                                          .value.isEmpty &&
                                                      controller
                                                          .selectedKey.isEmpty
                                                  ? TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          Colors.grey.shade700)
                                                  : TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black)))
                                          : (disabledTextStyle ??
                                              defaultDisabledTextStyle),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                            ),
                            Icon(Icons.arrow_drop_down,
                                color: isEnabled ? Colors.black : Colors.grey),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(state.errorText ?? "",
                    style: TextStyle(color: Colors.red[900], fontSize: 13)),
              ),
          ],
        );
      },
    );
  }
}
