import 'package:get/get.dart';
import '../../Models/screen_tree_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MainScreenController extends GetxController{

  
  Future<List<ScreenNode>> fetchScreensTree() async {
  final screensSnapshot = await FirebaseFirestore.instance.collection('screens').get();

  // Parse documents into nodes
  Map<String, ScreenNode> nodes = {};
  for (var doc in screensSnapshot.docs) {
    nodes[doc.id] = ScreenNode(
      title: doc['title'],
      routeName: doc['routeName'],
      parent: doc['parent'],
    );
  }

  // Build tree
  List<ScreenNode> tree = [];
  for (var node in nodes.values) {
    if (node.parent == null) {
      tree.add(node);
    } else {
      nodes[node.parent]?.subScreens.add(node);
    }
  }

  return tree;
}
}