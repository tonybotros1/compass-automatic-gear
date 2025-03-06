// import 'package:flutter/material.dart';

// class _CustomTableState extends State<CustomTable> {
//   final ScrollController _horizontalController = ScrollController();
//   final ScrollController _verticalController = ScrollController();

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return Column(
//           children: [
//             // Frozen Header
//             _buildHeaderRow(isFrozen: true),
//             Expanded(
//               child: Row(
//                 children: [
//                   // Frozen Columns
//                   if (widget.frozenColumns.isNotEmpty)
//                     _buildTable(
//                       columns: widget.frozenColumns
//                           .map((i) => widget.columns[i])
//                           .toList(),
//                       rows: widget.rows,
//                       isFrozen: true,
//                     ),
//                   // Scrollable Columns
//                   Expanded(
//                     child: SingleChildScrollView(
//                       controller: _horizontalController,
//                       scrollDirection: Axis.horizontal,
//                       child: _buildTable(
//                         columns: widget.columns
//                             .where((c) => !widget.frozenColumns
//                                 .contains(widget.columns.indexOf(c)))
//                             .toList(),
//                         rows: widget.rows,
//                         isFrozen: false,
//                         width: constraints.maxWidth,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildTable({
//     required List<DataColumn> columns,
//     required List<DataRow> rows,
//     required bool isFrozen,
//     double? width,
//   }) {
//     return Container(
//       width: width,
//       decoration: widget.showBottomBorder
//           ? BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(color: Colors.grey.shade300),
//               ),
//             )
//           : null,
//       child: Table(
//         columnWidths: _calculateColumnWidths(columns),
//         defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//         border: TableBorder.symmetric(
//           inside: BorderSide(color: Colors.grey.shade300),
//         ),
//         children: [
//           // Header Row
//           if (!isFrozen) _buildHeaderRow(isFrozen: false),
//           // Data Rows
//           ...rows.asMap().entries.map((entry) {
//             final index = entry.key;
//             final row = entry.value;
//             return _buildDataRow(row, index);
//           }),
//         ],
//       ),
//     );
//   }

//   Map<int, TableColumnWidth> _calculateColumnWidths(List<DataColumn> columns) {
//     return Map<int, TableColumnWidth>.fromIterables(
//       List<int>.generate(columns.length, (i) => i),
//       List<TableColumnWidth>.generate(
//         columns.length,
//         (i) => const IntrinsicColumnWidth(),
//       ),
//     );
//   }

//   TableRow _buildHeaderRow({required bool isFrozen}) {
//     return TableRow(
//       decoration: BoxDecoration(
//         color: widget.headingRowColor,
//       ),
//       children: widget.columns
//           .where((c) => isFrozen
//               ? widget.frozenColumns.contains(widget.columns.indexOf(c))
//               : !widget.frozenColumns.contains(widget.columns.indexOf(c)))
//           .map((column) => Padding(
//                 padding: EdgeInsets.all(widget.columnSpacing),
//                 child: SizedBox(
//                   height: widget.headingRowHeight,
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       '${column.label}',
//                       style: widget.headingTextStyle,
//                     ),
//                   ),
//                 ),
//               ))
//           .toList(),
//     );
//   }

//   TableRow _buildDataRow(DataRow row, int rowIndex) {
//     final isSelected = rowIndex == widget.selectedRowIndex;
//     return TableRow(
//       decoration: BoxDecoration(
//         color: isSelected ? Colors.blue.shade100 : null,
//       ),
//       children: row.cells
//           .map((cell) => GestureDetector(
//                 onTap: () => widget.onRowSelected?.call(
//                     isSelected ? null : rowIndex),
//                 child: Container(
//                   constraints: BoxConstraints(
//                     maxHeight: widget.dataRowMaxHeight,
//                     minHeight: widget.dataRowMinHeight,
//                   ),
//                   padding: EdgeInsets.all(widget.columnSpacing),
//                   alignment: Alignment.centerLeft,
//                   child: DefaultTextStyle(
//                     style: widget.dataTextStyle,
//                     child: cell.child,
//                   ),
//                 ),
//               ))
//           .toList(),
//     );
//   }
// }


// class CustomTable extends StatefulWidget {
//   final List<DataColumn> columns;
//   final List<DataRow> rows;
//   final List<int> frozenColumns;
//   final List<int> frozenRows;
//   final int? selectedRowIndex;
//   final ValueChanged<int?>? onRowSelected;
//   final double dataRowMaxHeight;
//   final double dataRowMinHeight;
//   final double headingRowHeight;
//   final double columnSpacing;
//   final bool showBottomBorder;
//   final TextStyle dataTextStyle;
//   final TextStyle headingTextStyle;
//   final int? sortColumnIndex;
//   final bool sortAscending;
//   final Color? headingRowColor;

//   const CustomTable({
//     super.key,
//     required this.columns,
//     required this.rows,
//     this.frozenColumns = const [],
//     this.frozenRows = const [],
//     this.selectedRowIndex,
//     this.onRowSelected,
//     this.dataRowMaxHeight = 40,
//     this.dataRowMinHeight = 30,
//     this.headingRowHeight = 70,
//     this.columnSpacing = 15,
//     this.showBottomBorder = true,
//     required this.dataTextStyle,
//     required this.headingTextStyle,
//     this.sortColumnIndex,
//     this.sortAscending = true,
//     this.headingRowColor,
//   });

//   @override
//   State<CustomTable> createState() => _CustomTableState();
// }