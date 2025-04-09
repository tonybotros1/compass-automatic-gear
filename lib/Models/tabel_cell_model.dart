class TableCellConfig {
  final String label;
  final int flex;
  final bool hasBorder;

  TableCellConfig({
    required this.label,
    this.flex = 1,
    this.hasBorder = false,
  });
}
