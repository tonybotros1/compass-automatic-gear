import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../consts.dart';

class MenuWithValues extends StatelessWidget {
  const MenuWithValues({
    super.key,
    required this.controller,
    this.width,
    this.isEnabled = true,
    this.readOnly,
    this.onTapOutside,
    this.onEditingComplete,
    this.textInputAction,
    this.focusNode,
    this.onFieldSubmitted,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.dialogWidth,
    this.dialogHeight,
    this.data,
    required this.displayKeys,
    this.onOpen,
    this.onSelected,
    required this.displaySelectedKeys,
    this.labelText,
    this.onDelete,
    this.headerLqabel,
    this.flexList = const [], // default: empty list
  });
  final TextEditingController controller;
  final double? width;
  final bool isEnabled;
  final bool? readOnly;
  final void Function(PointerDownEvent)? onTapOutside;
  final void Function()? onEditingComplete;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final TextAlign? textAlign;
  final int maxLines;
  final int? minLines;
  final void Function(String)? onChanged;
  final double? dialogWidth;
  final double? dialogHeight;
  final dynamic data;
  final List<String> displayKeys;
  final List<int> flexList;
  final List<String> displaySelectedKeys;
  final Future<dynamic> Function()? onOpen;
  final dynamic Function(dynamic)? onSelected;
  final String? labelText;
  final void Function()? onDelete;
  final String? headerLqabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelText != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    labelText!,
                    style: textFieldLabelStyle,
                  ),
                )
              : const SizedBox(),
          TextFormField(
            canRequestFocus: true,
            readOnly: readOnly ?? false,
            onTapOutside: onTapOutside,
            onEditingComplete: onEditingComplete,
            textInputAction: textInputAction,
            focusNode: focusNode,
            onFieldSubmitted: (value) {
              showResponsiveDialog(
                context,
                dialogWidth,
                controller,
                dialogHeight,
                data: data,
                initialSearch: value,
                flexList: flexList,
                onOpen: onOpen,
                displayKeys: displayKeys,
                displaySelectedKeys: displaySelectedKeys,
                onSelected: onSelected,
                headerLqabel: headerLqabel,
              );
              onFieldSubmitted?.call(value);
            },
            textAlign: textAlign!,
            style: textFieldFontStyle,
            minLines: minLines,
            maxLines: maxLines,
            onChanged: (value) {
              if (controller.text.isEmpty) {
                onDelete?.call();
              }
              onChanged?.call(value);
            },
            enabled: isEnabled,
            controller: controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: !kIsWeb ? 7 : 11,
              ),
              isDense: true,

              suffixIcon: ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (context, value, _) {
                  final hasText = value.text.trim().isNotEmpty;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ExcludeFocus(
                      child: SizedBox(
                        width: 50,
                        child: Row(
                          spacing: 4,
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MiniIcon(
                              icon: Icons.more_horiz,
                              onTap: () {
                                showResponsiveDialog(
                                  context,
                                  dialogWidth,
                                  controller,
                                  dialogHeight,
                                  flexList: flexList,
                                  initialSearch: controller.text,
                                  data: data,
                                  onOpen: onOpen,
                                  displayKeys: displayKeys,
                                  displaySelectedKeys: displaySelectedKeys,
                                  onSelected: onSelected,
                                  headerLqabel: headerLqabel,
                                );
                              },
                            ),
                            if (hasText)
                              MiniIcon(
                                icon: Icons.close,
                                color: Colors.red,
                                onTap: () {
                                  controller.clear();
                                  onDelete?.call();
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              suffixIconConstraints: const BoxConstraints(
                maxHeight: 30,
                maxWidth: 70,
              ),
              prefixIconConstraints: const BoxConstraints(
                maxHeight: 15,
                maxWidth: 15,
              ),
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              alignLabelWithHint: true,

              labelStyle: TextStyle(
                color: isEnabled == false
                    ? Colors.grey.shade500
                    : Colors.grey.shade700,
              ),
              fillColor: isEnabled == true
                  ? Colors.white
                  : Colors.grey.shade200,
              filled: true,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400, width: 1.0),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1.0),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> showResponsiveDialog(
  BuildContext context,
  double? width,
  TextEditingController? controller,
  double? height, {
  String? initialSearch,
  dynamic data,
  List<String> displayKeys = const ['name'],
  List<int> flexList = const [],
  List<String> displaySelectedKeys = const ['name'],
  Map<String, String>? labels,
  Function(dynamic selected)? onSelected,
  Future<dynamic> Function()? onOpen,
  String? headerLqabel,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) => _LargeDataDialog(
      initialSearch: initialSearch,
      headerLqabel: headerLqabel,
      width: width,
      height: height,
      controller: controller,
      data: data,
      displayKeys: displayKeys,
      flexList: flexList,
      displaySelectedKeys: displaySelectedKeys,
      onSelected: onSelected,
      onOpen: onOpen,
    ),
  );
}

class _LargeDataDialog extends StatefulWidget {
  const _LargeDataDialog({
    required this.width,
    required this.height,
    required this.controller,
    required this.data,
    required this.displayKeys,
    required this.flexList,
    required this.displaySelectedKeys,
    required this.onSelected,
    required this.onOpen,
    required this.headerLqabel,
    required this.initialSearch,
  });

  final double? width;
  final double? height;
  final TextEditingController? controller;
  final dynamic data;
  final List<String> displayKeys;
  final List<int> flexList;
  final List<String> displaySelectedKeys;
  final Function(dynamic selected)? onSelected;
  final Future<dynamic> Function()? onOpen;
  final String? headerLqabel;
  final String? initialSearch;

  @override
  State<_LargeDataDialog> createState() => _LargeDataDialogState();
}

class _LargeDataDialogState extends State<_LargeDataDialog> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  final _scrollController = ScrollController();

  Timer? _debounce;
  int _filterRequestId = 0;

  bool _isLoading = true;
  bool _isFiltering = false;
  String? _errorMessage;

  List<Map<String, dynamic>> _items = const <Map<String, dynamic>>[];
  List<String> _effectiveKeys = const <String>[];
  List<String> _searchIndex = const <String>[];
  List<int> _allIndexes = const <int>[];
  List<int> _visibleIndexes = const <int>[];

  String _lastQuery = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialSearch != null &&
        widget.initialSearch!.trim().isNotEmpty) {
      _searchController.text = widget.initialSearch!;
    }
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _searchFocusNode.requestFocus();
        if (widget.initialSearch != null) {
          _applyFilter(widget.initialSearch!);
        }
      }
    });
    _loadData();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      _applyFilter(_searchController.text);
    });
  }

  Map<String, dynamic> _normalizeItem(dynamic item) {
    if (item is Map) {
      return item.map((k, v) => MapEntry(k.toString(), v));
    }
    return {'value': item};
  }

  Future<List<Map<String, dynamic>>> _normalizeItemsAsync(dynamic items) async {
    const chunkSize = 400;
    final out = <Map<String, dynamic>>[];

    if (items is Map) {
      var i = 0;
      for (final e in items.entries) {
        final valueMap = _normalizeItem(e.value);
        out.add({'_id': e.key.toString(), ...valueMap});
        i++;
        if (i % chunkSize == 0) {
          await Future<void>.delayed(Duration.zero);
        }
      }
      return out;
    }

    if (items is Iterable) {
      var i = 0;
      for (final item in items) {
        out.add(_normalizeItem(item));
        i++;
        if (i % chunkSize == 0) {
          await Future<void>.delayed(Duration.zero);
        }
      }
      return out;
    }

    return out;
  }

  List<String> _resolveKeys(
    List<Map<String, dynamic>> items,
    List<String> preferred,
  ) {
    if (items.isEmpty) {
      return preferred.isNotEmpty ? preferred : const ['value'];
    }

    if (preferred.isNotEmpty &&
        items.any((m) => preferred.any(m.containsKey))) {
      return preferred;
    }

    for (final item in items) {
      item.putIfAbsent('value', () => item.toString());
    }
    return const ['value'];
  }

  Future<List<String>> _buildSearchIndexAsync(
    List<Map<String, dynamic>> items,
    List<String> keys,
  ) async {
    const chunkSize = 400;
    final out = List<String>.filled(items.length, '', growable: false);

    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      out[i] = keys
          .map((k) => (item[k] ?? '').toString().toLowerCase())
          .join(' ');
      if ((i + 1) % chunkSize == 0) {
        await Future<void>.delayed(Duration.zero);
      }
    }

    return out;
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 1️⃣ Get data (sync or async)
      final allItems = widget.onOpen == null
          ? widget.data
          : await widget.onOpen!();

      // 2️⃣ Normalize
      final normalized = await _normalizeItemsAsync(allItems);

      // 3️⃣ Resolve keys
      final keys = _resolveKeys(normalized, widget.displayKeys);

      // 4️⃣ Build search index
      final searchIndex = await _buildSearchIndexAsync(normalized, keys);

      if (!mounted) return;

      // 5️⃣ Generate all indexes
      final allIndexes = List<int>.generate(
        normalized.length,
        (i) => i,
        growable: false,
      );

      // 6️⃣ Check if there is initial search text
      final initialQuery = _searchController.text.trim().toLowerCase();

      List<int> visibleIndexes = allIndexes;

      if (initialQuery.isNotEmpty) {
        visibleIndexes = [];

        for (var i = 0; i < searchIndex.length; i++) {
          if (searchIndex[i].contains(initialQuery)) {
            visibleIndexes.add(i);
          }
        }
      }

      // 7️⃣ Apply everything in ONE setState (no flicker)
      setState(() {
        _items = normalized;
        _effectiveKeys = keys;
        _searchIndex = searchIndex;
        _allIndexes = allIndexes;
        _visibleIndexes = visibleIndexes;
        _lastQuery = initialQuery;
        _isLoading = false;
        _isFiltering = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _isFiltering = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _applyFilter(String rawQuery) async {
    // if (_isLoading) return;

    final query = rawQuery.trim().toLowerCase();
    final requestId = ++_filterRequestId;

    if (query == _lastQuery) return;

    if (query.isEmpty) {
      if (!mounted) return;
      setState(() {
        _visibleIndexes = _allIndexes;
        _lastQuery = '';
        _isFiltering = false;
      });
      return;
    }

    setState(() => _isFiltering = true);

    final source = (_lastQuery.isNotEmpty && query.startsWith(_lastQuery))
        ? _visibleIndexes
        : _allIndexes;

    const chunkSize = 500;
    final result = <int>[];

    for (var i = 0; i < source.length; i++) {
      final idx = source[i];
      if (_searchIndex[idx].contains(query)) {
        result.add(idx);
      }

      if ((i + 1) % chunkSize == 0) {
        await Future<void>.delayed(Duration.zero);
        if (!mounted || requestId != _filterRequestId) return;
      }
    }

    if (!mounted || requestId != _filterRequestId) return;

    setState(() {
      _visibleIndexes = result;
      _lastQuery = query;
      _isFiltering = false;
    });
  }

  void _selectItem(Map<String, dynamic> item) {
    final text = widget.displaySelectedKeys
        .map((k) => item[k]?.toString() ?? '')
        .where((v) => v.trim().isNotEmpty)
        .join(' - ');
    widget.controller?.text = text;
    Navigator.of(context).pop();
    widget.onSelected?.call(item);
  }

  @override
  Widget build(BuildContext context) {
    final String label = widget.headerLqabel ?? '';
    return Dialog(
      constraints: BoxConstraints(
        maxHeight: widget.height ?? MediaQuery.of(context).size.height / 1.5,
        maxWidth: widget.width ?? MediaQuery.of(context).size.width,
      ),
      insetPadding: const EdgeInsets.all(20),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    label.isEmpty ? 'Select Item' : label,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 4),

            SearchBox(
              controller: _searchController,
              focusNode: _searchFocusNode,
            ),
            if (_isFiltering) const LinearProgressIndicator(minHeight: 2),
            const Divider(),
            Expanded(
              child: _isLoading
                  ? Center(child: loadingProcess)
                  : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _loadData,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : _visibleIndexes.isEmpty
                  ? const Center(child: Text('No items found'))
                  : Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _visibleIndexes.length,
                        itemExtent: 52,
                        itemBuilder: (context, rowIndex) {
                          final item = _items[_visibleIndexes[rowIndex]];
                          final isEven = rowIndex % 2 == 0;

                          return Material(
                            borderRadius: rowIndex == 0
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  )
                                : rowIndex == _visibleIndexes.length - 1
                                ? const BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  )
                                : null,
                            color: isEven
                                ? Colors.grey.shade100
                                : Colors.blue.shade50,
                            child: InkWell(
                              onTap: () => _selectItem(item),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Row(
                                  children: [
                                    for (
                                      var i = 0;
                                      i < _effectiveKeys.length;
                                      i++
                                    )
                                      Expanded(
                                        flex:
                                            (i < widget.flexList.length &&
                                                widget.flexList[i] > 0)
                                            ? widget.flexList[i]
                                            : 1,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            right: 12,
                                          ),
                                          child: Text(
                                            item[_effectiveKeys[i]]
                                                    ?.toString() ??
                                                '-',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  const SearchBox({
    super.key,
    required this.controller,
    this.focusNode,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8FA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        decoration: const InputDecoration(
          icon: Icon(Icons.search, color: Colors.grey),
          hintText: "Search...",
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}

class MiniIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;

  const MiniIcon({super.key, required this.icon, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 15,
      child: Icon(icon, size: 18, color: color),
    );
  }
}
