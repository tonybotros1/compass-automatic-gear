import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../consts.dart';

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
  final Map<String, GlobalKey> _itemKeys = {};
  bool _arrowNavStarted = false;
  final FocusNode focusNode = FocusNode();
  FocusNode? nextFocusNode = FocusNode();
  final RxBool isDropdownOpen = false.obs;

  @override
  void onClose() {
    query.value.dispose();
    overlayFocusNode.dispose();
    searchFocusNode.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void assignValues(String controller, String showedName) {
    // textControllerValue.value = textcontroller;
    textController.value = controller;
    showedSelectedName.value = showedName;
  }

  String extractSearchableText(Widget widget) {
    if (widget is ListTile) {
      if (widget.title is Text) {
        return (widget.title as Text).data ?? "";
      }
    } else if (widget is Text) {
      return widget.data ?? "";
    } else if (widget is Container) {
      return (widget.child as Text).data ?? '';
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
    isDropdownOpen.value = true;

    // Initialize items and query
    allItems = items;
    filteredItems.assignAll(items);
    query.value.text = searchQuery.value;
    _arrowNavStarted = false;
    // Measure button and screen
    final renderBox = buttonKey.currentContext!.findRenderObject() as RenderBox;
    final fieldOffset = renderBox.localToGlobal(Offset.zero);
    final fieldSize = renderBox.size;
    final screenSize = MediaQuery.of(context).size;
    const double margin = 8.0;
    final spaceBelow =
        screenSize.height - fieldOffset.dy - fieldSize.height - margin;
    double dropdownMaxHeight = 175;
    final spaceAbove = fieldOffset.dy - margin;
    final showAbove = spaceBelow < dropdownMaxHeight && spaceAbove > spaceBelow;
    final maxHeight = (showAbove ? spaceAbove : spaceBelow).clamp(
      0.0,
      dropdownMaxHeight,
    );

    overlayEntry = OverlayEntry(
      builder: (ctx) => Stack(
        children: [
          // Dismiss on outside tap
          Positioned.fill(
            child: GestureDetector(
              onTap: hideDropdown,
              child: Container(color: Colors.transparent),
            ),
          ),

          // Positioning anchor
          CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            targetAnchor: showAbove ? Alignment.topLeft : Alignment.bottomLeft,
            followerAnchor: showAbove
                ? Alignment.bottomLeft
                : Alignment.topLeft,

            // Keyboard listener wraps the dropdown
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
                elevation: 4,
                borderRadius: BorderRadius.circular(5),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: fieldSize.width,
                    maxHeight: maxHeight,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Search field
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: textFieldHeight,
                          child: TextField(
                            autofocus: true,
                            focusNode: searchFocusNode,
                            controller: query.value,
                            onChanged: (q) {
                              searchQuery.value = q;
                              filterItems(itemBuilder);
                            },
                            decoration: InputDecoration(
                              hintText: 'Search…',
                              hintStyle: textFieldFontStyle,
                              suffixIcon: IconButton(
                                focusNode: FocusNode(skipTraversal: true),
                                icon: const Icon(Icons.close, size: 20),
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
                                vertical: 8,
                                horizontal: 10,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Results list
                      Obx(() {
                        if (filteredItems.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              "No results found",
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        }
                        return Expanded(
                          child: Scrollbar(
                            controller: scrollController,
                            thumbVisibility: true,
                            trackVisibility: true,
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: filteredItems.length,
                              itemBuilder: (ctx, i) {
                                final key = filteredItems.keys.elementAt(i);
                                final val = filteredItems[key]!;
                                final itemKey = _itemKeys.putIfAbsent(
                                  key,
                                  () => GlobalKey(),
                                );
                                return MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  onEnter: (_) => highlightedKey.value = key,
                                  onExit: (_) => highlightedKey.value = '',
                                  child: GestureDetector(
                                    onTap: () {
                                      selectedKey.value = key;
                                      selectedValue.value = val;
                                      textController.value = '';
                                      isValid.value = true;
                                      hideDropdown();
                                      onChanged?.call(key, val);
                                      if (nextFocusNode != null) {
                                        FocusScope.of(context).requestFocus(
                                          nextFocusNode,
                                        ); // ينتقل للي بعدو
                                      }
                                    },
                                    child: Obx(
                                      () => Container(
                                        key: itemKey,
                                        color: _getItemColor(key, val),
                                        child: itemBuilder(ctx, key, val),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }),
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

    // initial highlight & reset arrow flag
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _arrowNavStarted = false;
      String? initialKey;
      if (selectedKey.value.isNotEmpty &&
          filteredItems.containsKey(selectedKey.value)) {
        initialKey = selectedKey.value;
      } else if (textController.value.isNotEmpty) {
        initialKey = _findKeyByTextValue();
      }
      highlightedKey.value = initialKey ?? filteredItems.keys.first;
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
    if (selectedKey.value == key) return Colors.grey.shade300;
    if (highlightedKey.value == key) return Colors.blue[100]!;
    if (showedSelectedName.value.isNotEmpty &&
        textController.value.isNotEmpty &&
        value[showedSelectedName.value] == textController.value) {
      return Colors.grey.shade300;
    }
    return Colors.transparent;
  }

  void _moveHighlight(int direction) {
    if (filteredItems.isEmpty) return;
    final keys = filteredItems.keys.toList();

    int currentIndex;
    if (!_arrowNavStarted) {
      currentIndex = -1;
      _arrowNavStarted = true;
    } else {
      currentIndex = keys.indexOf(highlightedKey.value);
    }

    if (currentIndex == -1) {
      highlightedKey.value = keys.first;
    } else {
      int newIndex = (currentIndex + direction).clamp(0, keys.length - 1);
      highlightedKey.value = keys[newIndex];
    }

    _scrollToHighlightedItem();
  }

  // void _scrollToHighlightedItem() {
  //   final keys = filteredItems.keys.toList();
  //   int index = keys.indexOf(highlightedKey.value);
  //   if (index != -1 && scrollController.hasClients) {
  //     const double itemHeight = 48.0;
  //     double scrollOffset = index * itemHeight;
  //     double maxScroll = scrollController.position.maxScrollExtent;
  //     double targetOffset = scrollOffset.clamp(0.0, maxScroll);

  //     scrollController.animateTo(
  //       targetOffset,
  //       duration: const Duration(milliseconds: 200),
  //       curve: Curves.easeInOut,
  //     );
  //   }
  // }
  void _scrollToHighlightedItem() {
    final key = _itemKeys[highlightedKey.value];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        alignment: 0.5, // centers it; tweak 0.0→top, 1.0→bottom
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
        highlightedKey.value,
        filteredItems[highlightedKey.value],
      );
      hideDropdown();
    }
  }

  void hideDropdown() {
    query.value.clear();
    overlayEntry?.remove();
    overlayEntry = null;
    highlightedKey.value = '';
    isDropdownOpen.value = false;
  }

  void filterItems(Widget Function(BuildContext, String, dynamic) itemBuilder) {
    if (searchQuery.value.isEmpty) {
      filteredItems.assignAll(allItems);
    } else {
      filteredItems.assignAll(
        Map.fromEntries(
          allItems.entries.where((entry) {
            Widget builtItem = itemBuilder(
              Get.context!,
              entry.key,
              entry.value,
            );
            String searchText = extractSearchableText(builtItem);
            return searchText.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            );
          }),
        ),
      );
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
  final Widget Function(BuildContext, String, dynamic)? itemBuilder;
  final String textcontroller;
  final bool? enabled;
  final TextStyle? enabledTextStyle;
  final TextStyle? disabledTextStyle;
  final String showedSelectedName;
  final double width;
  final bool? validator;
  final Widget Function(String, dynamic)? showedResult;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final void Function()? onDelete;

  CustomDropdown({
    super.key,
    required this.items,
    this.itemBuilder,
    this.textcontroller = '',
    this.onChanged,
    this.focusNode,
    this.nextFocusNode,
    this.hintText = "Select an option",
    this.dropdownDecoration,
    this.disabledDecoration,
    this.width = 150,
    this.enabled = true,
    this.enabledTextStyle,
    this.disabledTextStyle,
    this.showedSelectedName = '',
    this.validator,
    this.showedResult,
    this.onDelete,
  });

  final GlobalKey buttonKey = GlobalKey();
  final DropdownController controller = DropdownController();
  // final RxString textControllerValue = RxString('');
  // Define a LayerLink to bind the target and follower.
  final LayerLink _layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    BoxDecoration defaultEnabledDecoration = BoxDecoration(
      color: Colors.grey.shade200,
      border: Border.all(
        color: controller.isValid.value ? Colors.grey : Colors.red,
      ),
      borderRadius: BorderRadius.circular(5),
    );

    BoxDecoration defaultDisabledDecoration = BoxDecoration(
      border: Border.all(color: Colors.grey.shade400),
      borderRadius: BorderRadius.circular(5),
    );

    TextStyle defaultDisabledTextStyle = const TextStyle(
      color: Colors.grey,
      fontSize: 16,
    );

    controller.assignValues(textcontroller, showedSelectedName);

    // textControllerValue.value = textcontroller;
    // controller.textController.value = textcontroller;
    // controller.showedSelectedName.value = showedSelectedName;
    controller.nextFocusNode = nextFocusNode;
    bool isEnabled = items.isEmpty ? false : enabled ?? true;

    return SizedBox(
      width: width,
      child: FormField<dynamic>(
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
                child: FocusableActionDetector(
                  focusNode: focusNode,
                  autofocus: false,
                  shortcuts: {
                    LogicalKeySet(LogicalKeyboardKey.tab):
                        const ActivateIntent(),
                    LogicalKeySet(LogicalKeyboardKey.enter):
                        const ActivateIntent(),
                  },
                  actions: {
                    ActivateIntent: CallbackAction<ActivateIntent>(
                      onInvoke: (intent) {
                        if (isEnabled) {
                          if (controller.isDropdownOpen.isFalse) {
                            // إذا المينيو مسكر افتحو
                            controller.showDropdown(
                              context,
                              buttonKey,
                              items,
                              itemBuilder: itemBuilder == null
                                  ? (context, key, value) {
                                      return Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        child: Text(value[showedSelectedName]),
                                      );
                                    }
                                  : itemBuilder!,
                              onChanged: (key, value) {
                                controller.textController.value = '';
                                controller.selectedKey.value = key;
                                controller.selectedValue.value = value;
                                controller.isValid.value = true;
                                controller.hideDropdown();
                                state.didChange(value);
                                onChanged?.call(key, value);
                                if (nextFocusNode != null) {
                                  FocusScope.of(context).requestFocus(
                                    nextFocusNode,
                                  ); // ينتقل للي بعدو
                                }

                                // FocusScope.of(context).nextFocus();
                              },
                              layerLink: _layerLink,
                            );
                          } else {
                            // إذا المينيو مفتوح سكروا وانتقل
                            controller.hideDropdown();
                            if (nextFocusNode != null) {
                              FocusScope.of(
                                context,
                              ).requestFocus(nextFocusNode); // ينتقل للي بعدو
                            }
                          }
                        } else {
                          if (nextFocusNode != null) {
                            FocusScope.of(
                              context,
                            ).requestFocus(nextFocusNode); // ينتقل للي بعدو
                          }
                        }

                        return null;
                      },
                    ),
                  },
                  child: GestureDetector(
                    key: buttonKey,
                    onTap: isEnabled
                        ? () {
                            if (controller.isDropdownOpen.isFalse) {
                              // إذا المينيو مسكر افتحو
                              controller.showDropdown(
                                context,
                                buttonKey,
                                items,
                                itemBuilder: itemBuilder == null
                                    ? (context, key, value) {
                                        return Container(
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 4,
                                          ),
                                          child: Text(
                                            value[showedSelectedName],
                                          ),
                                        );
                                      }
                                    : itemBuilder!,
                                onChanged: (key, value) {
                                  controller.textController.value = '';
                                  controller.selectedKey.value = key;
                                  controller.selectedValue.value = value;
                                  controller.isValid.value = true;
                                  controller.hideDropdown();
                                  state.didChange(value);
                                  onChanged?.call(key, value);
                                  if (nextFocusNode != null) {
                                    FocusScope.of(context).requestFocus(
                                      nextFocusNode,
                                    ); // ينتقل للي بعدو
                                  }
                                },
                                layerLink: _layerLink,
                              );
                            } else {
                              // إذا المينيو مفتوح سكروا وانتقل
                              controller.hideDropdown();
                              if (nextFocusNode != null) {
                                FocusScope.of(
                                  context,
                                ).requestFocus(nextFocusNode); // ينتقل للي بعدو
                              }
                            }
                          }
                        : null,
                    child: Obx(() {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: Text(
                              hintText,
                              style: textFieldLabelStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            height: textFieldHeight,
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
                                  child:
                                      showedResult != null &&
                                          controller.selectedKey.isNotEmpty
                                      ? showedResult!(
                                          controller.selectedKey.value,
                                          controller.selectedValue,
                                        )
                                      : Text(
                                          controller
                                                  .textController
                                                  .value
                                                  .isEmpty
                                              ? controller.selectedKey.isEmpty
                                                    ? ''
                                                    : showedSelectedName
                                                          .isNotEmpty
                                                    ? controller
                                                          .selectedValue[showedSelectedName]
                                                          .toString()
                                                    : ''
                                              : controller.textController.value,
                                          style: isEnabled
                                              ? (enabledTextStyle ??
                                                    (controller
                                                                .textController
                                                                .value
                                                                .isEmpty &&
                                                            controller
                                                                .selectedKey
                                                                .isEmpty
                                                        ? TextStyle(
                                                            fontSize: 14,
                                                            color: Colors
                                                                .grey
                                                                .shade700,
                                                          )
                                                        : textFieldFontStyle))
                                              : (disabledTextStyle ??
                                                    defaultDisabledTextStyle),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                ),

                                Icon(
                                  Icons.arrow_drop_down,
                                  color: isEnabled ? Colors.black : Colors.grey,
                                ),
                                if (controller.selectedKey.isNotEmpty ||
                                    controller.textController.value.isNotEmpty)
                                  InkWell(
                                    child: const Icon(
                                      Icons.clear,
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                    onTap: () {
                                      controller.selectedKey.value = '';
                                      controller.selectedValue.value = {};
                                      controller.textController.value = '';
                                      // state.didChange(null);
                                      controller.isValid.value = true;
                                      onDelete?.call(); // notify parent
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
              if (state.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    state.errorText ?? "",
                    style: TextStyle(color: Colors.red[900], fontSize: 13),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
