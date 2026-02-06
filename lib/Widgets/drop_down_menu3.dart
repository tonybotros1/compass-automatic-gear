// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import '../consts.dart';

// class DropdownController extends GetxController {
//   OverlayEntry? overlayEntry;
//   RxString selectedKey = "".obs;
//   RxMap selectedValue = {}.obs;
//   RxString searchQuery = "".obs;
//   Map allItems = {};
//   RxMap filteredItems = {}.obs;
//   RxBool isValid = true.obs;
//   Rx<TextEditingController> query = TextEditingController().obs;
//   RxString textController = RxString('');
//   RxString showedSelectedName = RxString('');
//   FocusNode overlayFocusNode = FocusNode();
//   FocusNode searchFocusNode = FocusNode();
//   ScrollController scrollController = ScrollController();
//   RxString highlightedKey = RxString('');
//   final Map<String, GlobalKey> _itemKeys = {};
//   bool _arrowNavStarted = false;
//   final FocusNode focusNode = FocusNode();
//   FocusNode? nextFocusNode = FocusNode();
//   final RxBool isDropdownOpen = false.obs;

//   /// ✅ New reactive variable for loading state
//   RxBool isLoading = false.obs;

//   @override
//   void onClose() {
//     query.value.dispose();
//     overlayFocusNode.dispose();
//     searchFocusNode.dispose();
//     scrollController.dispose();
//     super.onClose();
//   }

//   void assignValues(String controller, String showedName) {
//     textController.value = controller;
//     showedSelectedName.value = showedName;
//   }

//   String extractSearchableText(Widget widget) {
//     if (widget is ListTile) {
//       if (widget.title is Text) {
//         return (widget.title as Text).data ?? "";
//       }
//     } else if (widget is Text) {
//       return widget.data ?? "";
//     } else if (widget is Container) {
//       return (widget.child as Text).data ?? '';
//     }
//     return "";
//   }

//   void showDropdown(
//     BuildContext context,
//     GlobalKey buttonKey,
//     Map items, {
//     required Widget Function(BuildContext, String, dynamic) itemBuilder,
//     void Function(String, dynamic)? onChanged,
//     required LayerLink layerLink,
//     Future<Map<String, dynamic>> Function()? onOpen, // ✅ new optional callback
//   }) async {
//     if (overlayEntry != null) return;
//     // isDropdownOpen.value = true;

//     // ✅ Fetch items if onOpen is provided
//     if (onOpen != null) {
//       // print("yes");
//       // isLoading.value = true;
//       // try {
//       //   filteredItems.assignAll(await onOpen());
//       // } catch (e) {
//       //   filteredItems.clear();
//       // } finally {
//       //   isLoading.value = false;
//       // }
//     } else {
//       allItems = items;
//       filteredItems.assignAll(items);
//     }

//     query.value.text = searchQuery.value;
//     _arrowNavStarted = false;

//     final renderBox = buttonKey.currentContext!.findRenderObject() as RenderBox;
//     final fieldOffset = renderBox.localToGlobal(Offset.zero);
//     final fieldSize = renderBox.size;
//     final screenSize = Get.size;
//     const double margin = 8.0;
//     final spaceBelow =
//         screenSize.height - fieldOffset.dy - fieldSize.height - margin;
//     double dropdownMaxHeight = 175;
//     final spaceAbove = fieldOffset.dy - margin;
//     final showAbove = spaceBelow < dropdownMaxHeight && spaceAbove > spaceBelow;
//     final maxHeight = (showAbove ? spaceAbove : spaceBelow).clamp(
//       0.0,
//       dropdownMaxHeight,
//     );

//     overlayEntry = OverlayEntry(
//       builder: (ctx) => Stack(
//         children: [
//           Positioned.fill(
//             child: GestureDetector(
//               onTap: hideDropdown,
//               child: Container(color: Colors.transparent),
//             ),
//           ),
//           CompositedTransformFollower(
//             link: layerLink,
//             showWhenUnlinked: false,
//             targetAnchor: showAbove ? Alignment.topLeft : Alignment.bottomLeft,
//             followerAnchor: showAbove
//                 ? Alignment.bottomLeft
//                 : Alignment.topLeft,
//             child: Focus(
//               focusNode: overlayFocusNode,
//               onKeyEvent: (node, event) {
//                 if (event is KeyDownEvent) {
//                   if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
//                     _moveHighlight(1);
//                     return KeyEventResult.handled;
//                   } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
//                     _moveHighlight(-1);
//                     return KeyEventResult.handled;
//                   } else if (event.logicalKey == LogicalKeyboardKey.enter) {
//                     _selectHighlightedItem(onChanged);
//                     return KeyEventResult.handled;
//                   } else if (event.logicalKey == LogicalKeyboardKey.tab) {
//                     if (nextFocusNode != null) {
//                       hideDropdown();
//                       FocusScope.of(context).requestFocus(nextFocusNode);
//                       isValid.refresh();
//                     }
//                   }
//                 }
//                 return KeyEventResult.ignored;
//               },
//               child: Material(
//                 color: Colors.white,
//                 elevation: 4,
//                 borderRadius: BorderRadius.circular(5),
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(
//                     maxWidth: fieldSize.width,
//                     maxHeight: maxHeight,
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: SizedBox(
//                           height: textFieldHeight,
//                           child: TextField(
//                             autofocus: true,

//                             focusNode: searchFocusNode,
//                             controller: query.value,
//                             onChanged: (q) {
//                               searchQuery.value = q;
//                               filterItems(itemBuilder);
//                             },
//                             decoration: InputDecoration(
//                               hintText: 'Search…',
//                               hintStyle: textFieldFontStyle,
//                               suffixIcon: IconButton(
//                                 focusNode: FocusNode(skipTraversal: true),
//                                 icon: const Icon(Icons.close, size: 20),
//                                 onPressed: () {
//                                   searchQuery.value = '';
//                                   query.value.clear();
//                                   filterItems(itemBuilder);
//                                 },
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               focusedBorder: const OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   color: Colors.blue,
//                                   width: 2,
//                                 ),
//                               ),
//                               contentPadding: const EdgeInsets.symmetric(
//                                 vertical: 8,
//                                 horizontal: 10,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       // ✅ Loading spinner or results list
//                       Obx(() {
//                         if (isLoading.isTrue) {
//                           return Padding(
//                             padding: const EdgeInsets.all(16),
//                             child: Center(child: loadingProcess),
//                           );
//                         }
//                         if (filteredItems.isEmpty && isLoading.isFalse) {
//                           return const Padding(
//                             padding: EdgeInsets.all(8),
//                             child: Text(
//                               "No results found",
//                               style: TextStyle(color: Colors.grey),
//                             ),
//                           );
//                         }
//                         return Expanded(
//                           child: Scrollbar(
//                             controller: scrollController,
//                             thumbVisibility: true,
//                             trackVisibility: true,
//                             child: ListView.builder(
//                               controller: scrollController,
//                               itemCount: filteredItems.length,
//                               itemBuilder: (ctx, i) {
//                                 final key = filteredItems.keys.elementAt(i);
//                                 final val = filteredItems[key]!;
//                                 final itemKey = _itemKeys.putIfAbsent(
//                                   key,
//                                   () => GlobalKey(),
//                                 );
//                                 return MouseRegion(
//                                   cursor: SystemMouseCursors.click,
//                                   onEnter: (_) => highlightedKey.value = key,
//                                   onExit: (_) => highlightedKey.value = '',
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       selectedKey.value = key;
//                                       selectedValue.value = val;
//                                       textController.value = '';
//                                       isValid.value = true;
//                                       hideDropdown();
//                                       onChanged?.call(key, val);
//                                       if (nextFocusNode != null) {
//                                         FocusScope.of(
//                                           context,
//                                         ).requestFocus(nextFocusNode);
//                                       }
//                                     },
//                                     child: Obx(
//                                       () => Container(
//                                         key: itemKey,
//                                         color: _getItemColor(key, val),
//                                         child: itemBuilder(ctx, key, val),
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         );
//                       }),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );

//     // Overlay.of(Get.overlayContext!).insert(overlayEntry!);
//     // searchFocusNode.requestFocus();
//     final overlayState = Overlay.of(context);

//     overlayState.insert(overlayEntry!);
//     searchFocusNode.requestFocus();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _arrowNavStarted = false;
//       String? initialKey;
//       if (selectedKey.value.isNotEmpty &&
//           filteredItems.containsKey(selectedKey.value)) {
//         initialKey = selectedKey.value;
//       } else if (textController.value.isNotEmpty) {
//         initialKey = _findKeyByTextValue();
//       }
//       if (filteredItems.isNotEmpty) {
//         highlightedKey.value = initialKey ?? filteredItems.keys.first;
//       }
//     });
//   }

//   String? _findKeyByTextValue() {
//     for (var entry in filteredItems.entries) {
//       if (showedSelectedName.value.isNotEmpty) {
//         if (entry.value[showedSelectedName.value] == textController.value) {
//           return entry.key;
//         }
//       } else {
//         return null;
//       }
//     }
//     return null;
//   }

//   Color _getItemColor(String key, dynamic value) {
//     if (selectedKey.value == key) return Colors.grey.shade300;
//     if (highlightedKey.value == key) return Colors.blue[100]!;
//     if (showedSelectedName.value.isNotEmpty &&
//         textController.value.isNotEmpty &&
//         value[showedSelectedName.value] == textController.value) {
//       return Colors.grey.shade300;
//     }
//     return Colors.transparent;
//   }

//   void _moveHighlight(int direction) {
//     if (filteredItems.isEmpty) return;
//     final keys = filteredItems.keys.toList();
//     int currentIndex;
//     if (!_arrowNavStarted) {
//       currentIndex = -1;
//       _arrowNavStarted = true;
//     } else {
//       currentIndex = keys.indexOf(highlightedKey.value);
//     }
//     if (currentIndex == -1) {
//       highlightedKey.value = keys.first;
//     } else {
//       int newIndex = (currentIndex + direction).clamp(0, keys.length - 1);
//       highlightedKey.value = keys[newIndex];
//     }
//     _scrollToHighlightedItem();
//   }

//   void _scrollToHighlightedItem() {
//     final key = _itemKeys[highlightedKey.value];
//     if (key?.currentContext != null) {
//       Scrollable.ensureVisible(
//         key!.currentContext!,
//         duration: const Duration(milliseconds: 200),
//         curve: Curves.easeInOut,
//         alignment: 0.5,
//       );
//     }
//   }

//   void _selectHighlightedItem(void Function(String, dynamic)? onChanged) {
//     if (highlightedKey.value.isNotEmpty &&
//         filteredItems.containsKey(highlightedKey.value)) {
//       selectedKey.value = highlightedKey.value;
//       selectedValue.value = filteredItems[highlightedKey.value];
//       textController.value = '';
//       isValid.value = true;
//       onChanged?.call(
//         highlightedKey.value,
//         filteredItems[highlightedKey.value],
//       );
//       hideDropdown();
//     }
//   }

//   void hideDropdown() {
//     query.value.clear();
//     overlayEntry?.remove();
//     overlayEntry = null;
//     highlightedKey.value = '';
//     isDropdownOpen.value = false;
//   }

//   void filterItems(Widget Function(BuildContext, String, dynamic) itemBuilder) {
//     if (searchQuery.value.isEmpty) {
//       filteredItems.assignAll(allItems);
//     } else {
//       filteredItems.assignAll(
//         Map.fromEntries(
//           allItems.entries.where((entry) {
//             Widget builtItem = itemBuilder(
//               Get.context!,
//               entry.key,
//               entry.value,
//             );
//             String searchText = extractSearchableText(builtItem);
//             return searchText.toLowerCase().contains(
//               searchQuery.value.toLowerCase(),
//             );
//           }),
//         ),
//       );
//     }
//     String? newHighlightKey;
//     if (selectedKey.value.isNotEmpty &&
//         filteredItems.containsKey(selectedKey.value)) {
//       newHighlightKey = selectedKey.value;
//     } else if (textController.value.isNotEmpty) {
//       newHighlightKey = _findKeyByTextValue();
//     } else if (filteredItems.isNotEmpty) {
//       newHighlightKey = filteredItems.keys.first;
//     }
//     highlightedKey.value = newHighlightKey ?? '';
//   }

//   void validateSelection() {
//     isValid.value = selectedKey.value.isNotEmpty;
//   }

//   void setValue(String key) {
//     if (allItems.containsKey(key)) {
//       selectedKey.value = key;
//       selectedValue.value = allItems[key];
//       isValid.value = true;
//     }
//   }
// }

// class CustomDropdown extends StatelessWidget {
//   final Map items;
//   final String hintText;
//   final BoxDecoration? dropdownDecoration;
//   final BoxDecoration? disabledDecoration;
//   final void Function(String, dynamic)? onChanged;
//   final Widget Function(BuildContext, String, dynamic)? itemBuilder;
//   final String textcontroller;
//   final bool? enabled;
//   final TextStyle? enabledTextStyle;
//   final TextStyle? disabledTextStyle;
//   final String showedSelectedName;
//   final double width;
//   final bool? validator;
//   final Widget Function(String, dynamic)? showedResult;
//   final FocusNode? focusNode;
//   final FocusNode? nextFocusNode;
//   final void Function()? onDelete;
//   final Future<Map<String, dynamic>> Function()? onOpen; // ✅ added callback

//   CustomDropdown({
//     super.key,
//     this.items = const {},
//     this.itemBuilder,
//     this.textcontroller = '',
//     this.onChanged,
//     this.focusNode,
//     this.nextFocusNode,
//     this.hintText = "Select an option",
//     this.dropdownDecoration,
//     this.disabledDecoration,
//     this.width = 150,
//     this.enabled = true,
//     this.enabledTextStyle,
//     this.disabledTextStyle,
//     this.showedSelectedName = '',
//     this.validator,
//     this.showedResult,
//     this.onDelete,
//     this.onOpen, // ✅ added
//   });

//   final GlobalKey buttonKey = GlobalKey();
//   final DropdownController controller = DropdownController();
//   final LayerLink _layerLink = LayerLink();

//   @override
//   Widget build(BuildContext context) {
//     // BoxDecoration defaultEnabledDecoration = BoxDecoration(
//     //   color: Colors.white,
//     //   border: Border.all(
//     //     color: controller.isValid.value ? Colors.grey : Colors.red,
//     //   ),
//     //   borderRadius: BorderRadius.circular(5),
//     // );
//     focusNode?.addListener(() {
//       controller.isValid.refresh();
//     });
//     BoxDecoration defaultEnabledDecoration = BoxDecoration(
//       color: Colors.white,
//       border: Border.all(
//         color: focusNode?.hasFocus == true
//             ? Colors.blue
//             : controller.isValid.value
//             ? Colors.grey
//             : Colors.red,
//         width: focusNode?.hasFocus == true ? 2 : 1,
//       ),
//       borderRadius: BorderRadius.circular(5),
//     );

//     BoxDecoration defaultDisabledDecoration = BoxDecoration(
//       border: Border.all(color: Colors.grey.shade400),
//       borderRadius: BorderRadius.circular(5),
//     );
//     TextStyle defaultDisabledTextStyle = const TextStyle(
//       color: Colors.grey,
//       fontSize: 16,
//     );

//     controller.assignValues(textcontroller, showedSelectedName);
//     controller.nextFocusNode = nextFocusNode;
//     bool isEnabled = enabled ?? true;

//     return SizedBox(
//       width: width,
//       child: FormField<dynamic>(
//         validator: (value) {
//           if (validator == true) {
//             // if textcontroller has a value, accept it as valid automatically
//             if (controller.textController.value.isNotEmpty) {
//               return null;
//             }

//             // if user selected a value, it's valid
//             if (controller.selectedKey.isNotEmpty) {
//               return null;
//             }

//             // otherwise invalid
//             return "    Please Select an Option";
//           }
//           return null;
//         },

//         builder: (FormFieldState<dynamic> state) {
//           if (state.hasError) {
//             controller.isValid.value = false;
//           }
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CompositedTransformTarget(
//                 link: _layerLink,
//                 child: FocusableActionDetector(
//                   focusNode: focusNode,
//                   autofocus: false,
//                   shortcuts: {
//                     LogicalKeySet(LogicalKeyboardKey.tab):
//                         const ActivateIntent(),
//                     LogicalKeySet(LogicalKeyboardKey.enter):
//                         const ActivateIntent(),
//                   },
//                   actions: {
//                     ActivateIntent: CallbackAction<ActivateIntent>(
//                       onInvoke: (intent) {
//                         if (isEnabled) {
//                           if (controller.isDropdownOpen.isFalse) {
//                             controller.showDropdown(
//                               context,
//                               buttonKey,
//                               items,
//                               itemBuilder:
//                                   itemBuilder ??
//                                   (context, key, value) {
//                                     return Container(
//                                       alignment: Alignment.centerLeft,
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 12,
//                                         vertical: 4,
//                                       ),
//                                       child: Text(value[showedSelectedName]),
//                                     );
//                                   },
//                               onChanged: (key, value) {
//                                 controller.textController.value = '';
//                                 controller.selectedKey.value = key;
//                                 controller.selectedValue.value = value;
//                                 controller.isValid.value = true;
//                                 controller.hideDropdown();
//                                 state.didChange(key);
//                                 onChanged?.call(key, value);
//                                 if (nextFocusNode != null) {
//                                   FocusScope.of(
//                                     context,
//                                   ).requestFocus(nextFocusNode);
//                                 }
//                               },
//                               layerLink: _layerLink,
//                               onOpen: onOpen, // ✅ call the callback
//                             );
//                             if (onOpen != null) {
//                               controller.isLoading.value =
//                                   true; // start loading

//                               onOpen!()
//                                   .then((fetchedItems) {
//                                     controller.allItems = fetchedItems;
//                                     controller.filteredItems.assignAll(
//                                       fetchedItems,
//                                     );

//                                     // Set initial highlight
//                                     controller.highlightedKey.value =
//                                         fetchedItems.isNotEmpty
//                                         ? fetchedItems.keys.first
//                                         : '';
//                                     controller.isLoading.value =
//                                         false; // stop loading
//                                   })
//                                   .catchError((e) {
//                                     controller.isLoading.value =
//                                         false; // stop loading even on error
//                                   });
//                             }
//                           } else {
//                             controller.hideDropdown();
//                             if (nextFocusNode != null) {
//                               FocusScope.of(
//                                 context,
//                               ).requestFocus(nextFocusNode);
//                               controller.isValid.refresh();
//                             }
//                           }
//                         } else if (nextFocusNode != null) {
//                           FocusScope.of(context).requestFocus(nextFocusNode);
//                           controller.isValid.refresh();
//                         }
//                         return null;
//                       },
//                     ),
//                   },
//                   child: GestureDetector(
//                     key: buttonKey,
//                     onTap: isEnabled
//                         ? () {
//                             if (controller.isDropdownOpen.isFalse) {
//                               // 1️⃣ Open dropdown immediately with current items
//                               controller.showDropdown(
//                                 context,
//                                 buttonKey,
//                                 items, // can be empty initially
//                                 itemBuilder:
//                                     itemBuilder ??
//                                     (c, k, v) {
//                                       return Container(
//                                         alignment: Alignment.centerLeft,
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 12,
//                                           vertical: 4,
//                                         ),
//                                         child: Text(v[showedSelectedName]),
//                                       );
//                                     },
//                                 onChanged: (key, value) {
//                                   controller.textController.value = '';
//                                   controller.selectedKey.value = key;
//                                   controller.selectedValue.value = value;
//                                   controller.isValid.value = true;

//                                   state.didChange(key); // ✔ IMPORTANT
//                                   onChanged?.call(key, value); // callback

//                                   if (nextFocusNode != null) {
//                                     FocusScope.of(
//                                       context,
//                                     ).requestFocus(nextFocusNode);
//                                   }
//                                 },
//                                 layerLink: _layerLink,
//                               );

//                               // 2️⃣ Fetch data asynchronously
//                               if (onOpen != null) {
//                                 controller.isLoading.value =
//                                     true; // start loading

//                                 onOpen!()
//                                     .then((fetchedItems) {
//                                       controller.allItems = fetchedItems;
//                                       controller.filteredItems.assignAll(
//                                         fetchedItems,
//                                       );

//                                       // Set initial highlight
//                                       controller.highlightedKey.value =
//                                           fetchedItems.isNotEmpty
//                                           ? fetchedItems.keys.first
//                                           : '';
//                                       controller.isLoading.value =
//                                           false; // stop loading
//                                     })
//                                     .catchError((e) {
//                                       controller.isLoading.value =
//                                           false; // stop loading even on error
//                                     });
//                               }
//                             } else {
//                               controller.hideDropdown();
//                             }
//                           }
//                         : null,

//                     child: Obx(() {
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(left: 2),
//                             child: Text(
//                               hintText,
//                               style: textFieldLabelStyle,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           Container(
//                             height: textFieldHeight,
//                             padding: const EdgeInsets.symmetric(horizontal: 10),
//                             decoration: controller.isValid.isFalse
//                                 ? BoxDecoration(
//                                     color: Colors.grey.shade200,
//                                     border: Border.all(color: Colors.red),
//                                     borderRadius: BorderRadius.circular(5),
//                                   )
//                                 : isEnabled
//                                 ? (dropdownDecoration ??
//                                       (defaultEnabledDecoration))
//                                 : (disabledDecoration ??
//                                       defaultDisabledDecoration),
//                             child: Row(
//                               children: [
//                                 Expanded(
//                                   child:
//                                       showedResult != null &&
//                                           controller.selectedKey.isNotEmpty
//                                       ? showedResult!(
//                                           controller.selectedKey.value,
//                                           controller.selectedValue,
//                                         )
//                                       : Text(
//                                           controller
//                                                   .textController
//                                                   .value
//                                                   .isEmpty
//                                               ? controller.selectedKey.isEmpty
//                                                     ? ''
//                                                     : showedSelectedName
//                                                           .isNotEmpty
//                                                     ? controller
//                                                               .selectedValue[showedSelectedName]
//                                                               ?.toString() ??
//                                                           ''
//                                                     : ''
//                                               : controller.textController.value,
//                                           style: isEnabled
//                                               ? (enabledTextStyle ??
//                                                     (controller
//                                                                 .textController
//                                                                 .value
//                                                                 .isEmpty &&
//                                                             controller
//                                                                 .selectedKey
//                                                                 .isEmpty
//                                                         ? TextStyle(
//                                                             fontSize: 14,
//                                                             color: Colors
//                                                                 .grey
//                                                                 .shade700,
//                                                           )
//                                                         : textFieldFontStyle))
//                                               : (disabledTextStyle ??
//                                                     defaultDisabledTextStyle),
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                 ),
//                                 Icon(
//                                   Icons.arrow_drop_down,
//                                   color: isEnabled ? Colors.black : Colors.grey,
//                                 ),
//                                 if (controller.selectedKey.isNotEmpty ||
//                                     controller.textController.value.isNotEmpty)
//                                   InkWell(
//                                     child: const Icon(
//                                       Icons.clear,
//                                       size: 18,
//                                       color: Colors.red,
//                                     ),
//                                     onTap: () {
//                                       controller.selectedKey.value = '';
//                                       controller.selectedValue.value = {};
//                                       controller.textController.value = '';
//                                       controller.isValid.value = true;
//                                       state.didChange(null);
//                                       onDelete?.call();
//                                     },
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       );
//                     }),
//                   ),
//                 ),
//               ),
//               if (state.hasError)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 2),
//                   child: Text(
//                     state.errorText ?? "",
//                     style: TextStyle(color: Colors.red[900], fontSize: 13),
//                   ),
//                 ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../consts.dart';

class DropdownController extends GetxController {
  OverlayEntry? overlayEntry;
  final RxString selectedKey = "".obs;
  final RxMap selectedValue = {}.obs;
  final RxString searchQuery = "".obs;
  Map allItems = {};
  final RxMap filteredItems = {}.obs;
  final RxBool isValid = true.obs;
  final Rx<TextEditingController> query = TextEditingController().obs;
  final RxString textController = RxString('');
  final RxString showedSelectedName = RxString('');
  final FocusNode overlayFocusNode = FocusNode();
  final FocusNode searchFocusNode = FocusNode();
  final ScrollController scrollController = ScrollController();
  final RxString highlightedKey = RxString('');
  final Map<String, GlobalKey> _itemKeys = {};
  bool _arrowNavStarted = false;
  FocusNode? nextFocusNode;
  FocusNode? fieldFocusNode;
  final RxBool isDropdownOpen = false.obs;
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    query.value.dispose();
    overlayFocusNode.dispose();
    searchFocusNode.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void assignValues(String controller, String showedName) {
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
    Future<Map<String, dynamic>> Function()? onOpen,
    FocusNode? fieldFocusNode,
  }) async {
    if (overlayEntry != null) return;

    final buttonContext = buttonKey.currentContext;
    if (buttonContext == null) return;

    final overlayState = Overlay.of(context);

    isDropdownOpen.value = true;
    this.fieldFocusNode = fieldFocusNode;

    if (onOpen == null) {
      allItems = items;
      filteredItems.assignAll(items);
    } else {
      isLoading.value = true;
      filteredItems.clear();
    }

    query.value.text = searchQuery.value;
    _arrowNavStarted = false;

    final renderBox = buttonContext.findRenderObject() as RenderBox;
    final fieldOffset = renderBox.localToGlobal(Offset.zero);
    final fieldSize = renderBox.size;
    final screenSize = Get.size;
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
          Positioned.fill(
            child: GestureDetector(
              onTap: () => hideDropdown(restoreFocus: true),
              child: Container(color: Colors.transparent),
            ),
          ),
          CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            targetAnchor: showAbove ? Alignment.topLeft : Alignment.bottomLeft,
            followerAnchor: showAbove
                ? Alignment.bottomLeft
                : Alignment.topLeft,
            child: Focus(
              focusNode: overlayFocusNode,
              onKeyEvent: (node, event) {
                if (event is! KeyDownEvent) return KeyEventResult.ignored;

                if (event.logicalKey == LogicalKeyboardKey.escape) {
                  hideDropdown(restoreFocus: true);
                  return KeyEventResult.handled;
                }

                if (event.logicalKey == LogicalKeyboardKey.tab) {
                  hideDropdown();

                  final isShiftPressed =
                      HardwareKeyboard.instance.logicalKeysPressed.contains(
                        LogicalKeyboardKey.shiftLeft,
                      ) ||
                      HardwareKeyboard.instance.logicalKeysPressed.contains(
                        LogicalKeyboardKey.shiftRight,
                      );

                  if (isShiftPressed) {
                    FocusScope.of(context).previousFocus();
                  } else if (nextFocusNode?.canRequestFocus == true) {
                    FocusScope.of(context).requestFocus(nextFocusNode);
                  } else {
                    FocusScope.of(context).nextFocus();
                  }

                  return KeyEventResult.handled;
                }

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
                return KeyEventResult.ignored;
              },
              child: Material(
                color: Colors.white,
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: textFieldHeight,
                          child: TextField(
                            autofocus: false,
                            focusNode: searchFocusNode,
                            controller: query.value,
                            onChanged: (q) {
                              searchQuery.value = q;
                              filterItems(itemBuilder);
                            },
                            decoration: InputDecoration(
                              hintText: 'Search…',
                              hintStyle: textFieldFontStyle,
                              suffixIcon: Focus(
                                skipTraversal: true,
                                child: IconButton(
                                  icon: const Icon(Icons.close, size: 20),
                                  onPressed: () {
                                    searchQuery.value = '';
                                    query.value.clear();
                                    filterItems(itemBuilder);
                                  },
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Obx(() {
                        if (isLoading.isTrue) {
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Center(child: loadingProcess),
                          );
                        }
                        if (filteredItems.isEmpty && isLoading.isFalse) {
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
                                      if (nextFocusNode?.canRequestFocus ==
                                          true) {
                                        FocusScope.of(
                                          context,
                                        ).requestFocus(nextFocusNode);
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

    overlayState.insert(overlayEntry!);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (searchFocusNode.canRequestFocus) {
        searchFocusNode.requestFocus();
      }
      _setInitialHighlight();
    });

    if (onOpen != null) {
      try {
        final fetchedItems = await onOpen();
        allItems = fetchedItems;
        filteredItems.assignAll(fetchedItems);
      } finally {
        isLoading.value = false;
      }
      _setInitialHighlight();
    }
  }

  void _setInitialHighlight() {
    String? initialKey;
    if (selectedKey.value.isNotEmpty &&
        filteredItems.containsKey(selectedKey.value)) {
      initialKey = selectedKey.value;
    } else if (textController.value.isNotEmpty) {
      initialKey = _findKeyByTextValue();
    }
    if (filteredItems.isNotEmpty) {
      highlightedKey.value = initialKey ?? filteredItems.keys.first;
    } else {
      highlightedKey.value = '';
    }
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

  void _scrollToHighlightedItem() {
    final key = _itemKeys[highlightedKey.value];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        alignment: 0.5,
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

  void hideDropdown({bool restoreFocus = false}) {
    query.value.clear();
    overlayEntry?.remove();
    overlayEntry = null;
    highlightedKey.value = '';
    isDropdownOpen.value = false;
    if (restoreFocus && fieldFocusNode?.canRequestFocus == true) {
      fieldFocusNode!.requestFocus();
    }
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
    _setInitialHighlight();
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

class CustomDropdown extends StatefulWidget {
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
  final Future<Map<String, dynamic>> Function()? onOpen;

  const CustomDropdown({
    super.key,
    this.items = const {},
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
    this.onOpen,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  final GlobalKey buttonKey = GlobalKey();
  final LayerLink _layerLink = LayerLink();
  late final DropdownController controller;

  @override
  void initState() {
    super.initState();
    controller = DropdownController();
  }

  @override
  void dispose() {
    controller.onClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // BoxDecoration defaultEnabledDecoration = BoxDecoration(
    //   color: Colors.white,
    //   border: Border.all(
    //     color: widget.focusNode?.hasFocus == true
    //         ? Colors.blue
    //         : controller.isValid.value
    //         ? Colors.grey
    //         : Colors.red,
    //     width: widget.focusNode?.hasFocus == true ? 2 : 1,
    //   ),
    //   borderRadius: BorderRadius.circular(5),
    // );

    BoxDecoration defaultDisabledDecoration = BoxDecoration(
      border: Border.all(color: Colors.grey.shade400),
      borderRadius: BorderRadius.circular(5),
    );
    TextStyle defaultDisabledTextStyle = const TextStyle(
      color: Colors.grey,
      fontSize: 16,
    );

    controller.assignValues(widget.textcontroller, widget.showedSelectedName);
    controller.nextFocusNode = widget.nextFocusNode;
    bool isEnabled = widget.enabled ?? true;

    return SizedBox(
      width: widget.width,
      child: FormField<dynamic>(
        validator: (value) {
          if (widget.validator == true) {
            if (controller.textController.value.isNotEmpty) {
              return null;
            }
            if (controller.selectedKey.isNotEmpty) {
              return null;
            }
            return "    Please Select an Option";
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
              CompositedTransformTarget(
                link: _layerLink,
                child: FocusableActionDetector(
                  focusNode: widget.focusNode,
                  autofocus: false,
                  onFocusChange: (_) => controller.isValid.refresh(),
                  shortcuts: {
                    LogicalKeySet(LogicalKeyboardKey.enter):
                        const ActivateIntent(),
                    LogicalKeySet(LogicalKeyboardKey.space):
                        const ActivateIntent(),
                    LogicalKeySet(LogicalKeyboardKey.arrowDown):
                        const ActivateIntent(),
                  },
                  actions: {
                    ActivateIntent: CallbackAction<ActivateIntent>(
                      onInvoke: (intent) {
                        if (isEnabled) {
                          if (controller.isDropdownOpen.isFalse) {
                            widget.focusNode?.requestFocus();
                            controller.showDropdown(
                              context,
                              buttonKey,
                              widget.items,
                              itemBuilder:
                                  widget.itemBuilder ??
                                  (context, key, value) {
                                    return Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      child: Text(
                                        value[widget.showedSelectedName],
                                      ),
                                    );
                                  },
                              onChanged: (key, value) {
                                controller.textController.value = '';
                                controller.selectedKey.value = key;
                                controller.selectedValue.value = value;
                                controller.isValid.value = true;
                                controller.hideDropdown();
                                state.didChange(key);
                                widget.onChanged?.call(key, value);
                                if (widget.nextFocusNode?.canRequestFocus ==
                                    true) {
                                  FocusScope.of(
                                    context,
                                  ).requestFocus(widget.nextFocusNode);
                                }
                              },
                              layerLink: _layerLink,
                              onOpen: widget.onOpen,
                              fieldFocusNode: widget.focusNode,
                            );
                          } else {
                            controller.hideDropdown(restoreFocus: true);
                            if (widget.nextFocusNode?.canRequestFocus == true) {
                              FocusScope.of(
                                context,
                              ).requestFocus(widget.nextFocusNode);
                              controller.isValid.refresh();
                            }
                          }
                        } else if (widget.nextFocusNode?.canRequestFocus ==
                            true) {
                          FocusScope.of(
                            context,
                          ).requestFocus(widget.nextFocusNode);
                          controller.isValid.refresh();
                        }
                        return null;
                      },
                    ),
                  },
                  child: GestureDetector(
                    key: buttonKey,
                    onTap: isEnabled
                        ? () {
                            widget.focusNode?.requestFocus();
                            if (controller.isDropdownOpen.isFalse) {
                              controller.showDropdown(
                                context,
                                buttonKey,
                                widget.items,
                                itemBuilder:
                                    widget.itemBuilder ??
                                    (c, k, v) {
                                      return Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        child: Text(
                                          v[widget.showedSelectedName],
                                        ),
                                      );
                                    },
                                onChanged: (key, value) {
                                  controller.textController.value = '';
                                  controller.selectedKey.value = key;
                                  controller.selectedValue.value = value;
                                  controller.isValid.value = true;
                                  state.didChange(key);
                                  widget.onChanged?.call(key, value);
                                  if (widget.nextFocusNode?.canRequestFocus ==
                                      true) {
                                    FocusScope.of(
                                      context,
                                    ).requestFocus(widget.nextFocusNode);
                                  }
                                },
                                layerLink: _layerLink,
                                onOpen: widget.onOpen,
                                fieldFocusNode: widget.focusNode,
                              );
                            } else {
                              controller.hideDropdown(restoreFocus: true);
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
                              widget.hintText,
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
                                ? (widget.dropdownDecoration ??
                                      BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color:
                                              widget.focusNode?.hasFocus == true
                                              ? Colors.blue
                                              : controller.isValid.value
                                              ? Colors.grey
                                              : Colors.red,
                                          width:
                                              widget.focusNode?.hasFocus == true
                                              ? 2
                                              : 1,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ))
                                : (widget.disabledDecoration ??
                                      defaultDisabledDecoration),
                            child: Row(
                              children: [
                                Expanded(
                                  child:
                                      widget.showedResult != null &&
                                          controller.selectedKey.isNotEmpty
                                      ? widget.showedResult!(
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
                                                    : widget
                                                          .showedSelectedName
                                                          .isNotEmpty
                                                    ? controller
                                                              .selectedValue[widget
                                                                  .showedSelectedName]
                                                              ?.toString() ??
                                                          ''
                                                    : ''
                                              : controller.textController.value,
                                          style: isEnabled
                                              ? (widget.enabledTextStyle ??
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
                                              : (widget.disabledTextStyle ??
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
                                  ExcludeFocus(
                                    child: InkWell(
                                      focusNode: FocusNode(canRequestFocus: false),
                                      child: const Icon(
                                        Icons.clear,
                                        size: 18,
                                        color: Colors.red,
                                      ),
                                      onTap: () {
                                        controller.selectedKey.value = '';
                                        controller.selectedValue.value = {};
                                        controller.textController.value = '';
                                        controller.isValid.value = true;
                                        state.didChange(null);
                                        widget.onDelete?.call();
                                      },
                                    ),
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
