import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/Main screen controllers/add_new_screen_controller.dart';

class AddNewScreen extends StatelessWidget {
  AddNewScreen({super.key});

  final AddNewScreenController addNewScreenController = Get.put(AddNewScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: addNewScreenController.titleController,
              decoration: const InputDecoration(labelText: 'Screen Title'),
            ),
            TextField(
              controller: addNewScreenController.routeNameController,
              decoration: const InputDecoration(labelText: 'Route Name'),
            ),
            TextField(
              controller: addNewScreenController.parentController,
              decoration:
                  const InputDecoration(labelText: 'Parent Screen (optional)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final title = addNewScreenController.titleController.text.trim();
                final routeName = addNewScreenController.routeNameController.text.trim();
                final parent = addNewScreenController.parentController.text.trim().isEmpty
                    ? null
                    : addNewScreenController.parentController.text.trim();

                if (title.isNotEmpty && routeName.isNotEmpty) {
                  await addNewScreenController.addScreen(
                    title: title,
                    routeName: routeName,
                    parent: parent,
                  );
                  Get.back(); // Navigate back after adding
                } else {
                  Get.snackbar('Error', 'Title and Route Name are required.');
                }
              },
              child: const Text('Add Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
