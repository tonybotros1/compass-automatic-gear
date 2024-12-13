class ScreenNode {
  final String title;
  final String? routeName;
  final String? parent;
  final List<ScreenNode> subScreens;

  ScreenNode({
    required this.title,
    this.routeName,
    this.parent,
    this.subScreens = const [],
  });
}