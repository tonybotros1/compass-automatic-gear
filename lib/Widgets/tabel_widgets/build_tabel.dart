import 'package:flutter/material.dart';

import '../../Models/tabel_cell_model.dart';
import '../../Models/tabel_row_model.dart';
import '../../consts.dart';
import '../my_text_field.dart';

/// Builds a dynamic receipt row given a list of [RowCellConfig] objects.
/// Optionally, you can provide a [prefix] widget (e.g. an icon or colored container)
/// and a [suffix] widget (e.g. a delete button).
Widget buildCustomRow({
  required List<RowCellConfig> cellConfigs,
  Widget? prefix,
  Widget? suffix,
}) {
  List<Widget> children = [];

  // Add the prefix widget if provided; otherwise, add a default spacer.
  children.add(prefix ?? SizedBox());

  // Loop through each configuration to build the corresponding cell.
  for (var cell in cellConfigs) {
    children.add(
      Expanded(
        flex: cell.flex,
        child: myTextFormFieldWithBorder(
          isEnabled: cell.isEnabled,
          controller: cell.controller,
          initialValue: cell.initialValue,
          onChanged: cell.onChanged ?? (value) => print(value),
        ),
      ),
    );
  }

  // Add the suffix widget if provided; otherwise, add a default TextButton.
  children.add(
    suffix ?? SizedBox(),
  );

  return Row(
    spacing: 2,
    children: children,
  );
}

/// Builds a dynamic table header row using [TableCellConfig].
Widget buildCustomTableHeader({
  required List<TableCellConfig> cellConfigs,
  Widget? prefix,
  Widget? suffix,
}) {
  List<Widget> children = [];

  // Add the prefix widget (or a default spacer)
  children.add(prefix ?? SizedBox());

  // Generate header cells
  for (var cell in cellConfigs) {
    children.add(
      Expanded(
        flex: cell.flex,
        child: Container(
            decoration: cell.hasBorder
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey),
                  )
                : null,
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.bottomLeft,
            height: textFieldHeight,
            child: RichText(
              text: TextSpan(text: cell.label, style: textFieldLabelStyle),
              textWidthBasis: TextWidthBasis.longestLine,
              softWrap: true,
              overflow: TextOverflow.visible,
            )
            //  Text(
            //   cell.label,
            //   overflow: TextOverflow.ellipsis,
            //   style: textFieldLabelStyle,
            // ),
            ),
      ),
    );
  }

  // Add the suffix widget (or a default placeholder)
  children.add(suffix ?? SizedBox());

  return Row(spacing: 2, children: children);
}

/// Builds a dynamic table footer row using [TableCellConfig].
Widget buildCustomTableFooter({
  required List<TableCellConfig> cellConfigs,
  Widget? prefix,
  Widget? suffix,
}) {
  List<Widget> children = [];

  // Add the prefix widget (or a default spacer)
  children.add(prefix ?? SizedBox());

  // Generate footer cells
  for (var cell in cellConfigs) {
    children.add(
      Expanded(
        flex: cell.flex,
        child: Container(
            decoration: cell.hasBorder
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey),
                  )
                : null,
            padding: EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.centerLeft,
            height: textFieldHeight,
            child: RichText(
              text: TextSpan(text: cell.label, style: textFieldLabelStyle),
              textWidthBasis: TextWidthBasis.longestLine,
              softWrap: true,
              overflow: TextOverflow.visible,
            )),
      ),
    );
  }

  // Add the suffix widget (or a default placeholder)
  children.add(suffix ?? SizedBox());

  return Row(spacing: 2, children: children);
}
