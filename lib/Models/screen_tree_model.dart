// class ScreenNode {
//   final String title;
//   final String? routeName;
//   final String? parent;
//   final int order;
//   final List<ScreenNode> subScreens;

//   ScreenNode({
//     required this.title,
//     this.routeName,
//     this.parent,
//     this.order = 0,
//     this.subScreens = const [],
//   });
// }

// class MyTreeNode {
//   MyTreeNode({
//     this.nodeP,
//     this.routeName,
//     required this.title,
//     Iterable<MyTreeNode>? children,
//   }) : children = <MyTreeNode>[] {
//     if (children == null) return;

//     for (final MyTreeNode child in children) {
//       this.children.add(child);
//       child.parent = this;
//     }
//   }

//   final String title;
//   String? routeName;
//   final List<MyTreeNode> children;
//   String? nodeP;
//   MyTreeNode? parent;
// }

class MyTreeNode {
  MyTreeNode({
    this.parent,
    this.canRemove,
    this.id,
    this.isMenu,
    this.routeName,
    this.isPressed = false,
    this.description,
    required this.title,
    Iterable<MyTreeNode>? children,
  }) : children = <MyTreeNode>[] {
    if (children == null) return;

    for (final MyTreeNode child in children) {
      this.children.add(child);
      child.parent = this;
    }
  }

  final String title;
  String? routeName;
  final List<MyTreeNode> children;
  MyTreeNode? parent;
  bool isPressed;
  bool? isMenu;
  String? id;
  bool? canRemove;
  String? description;
}
