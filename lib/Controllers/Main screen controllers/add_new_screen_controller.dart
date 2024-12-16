import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNewScreenController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController routeNameController = TextEditingController();
  final TextEditingController parentController = TextEditingController();

  
  Future<void> addScreen({
    required String title,
    required String routeName,
    String? parent,
  }) async {
    try {
      // Reference to the screens collection
      final screensCollection =
          FirebaseFirestore.instance.collection('screens');

      // Add a new screen document
      await screensCollection.add({
        'title': title,
        'routeName': routeName,
        'parent': parent, // Null if it's a top-level screen
      });

    } catch (e) {
      // print('Error adding screen: $e');
    }
  }
}
