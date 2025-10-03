import 'package:flutter/material.dart';

import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';

InkWell imageSection(EntityInformationsController controller) {
  return InkWell(
    onTap: () {
      controller.pickImage();
    },
    child: Container(
      height: 120,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(style: BorderStyle.solid, color: Colors.grey),
      ),
      child: controller.imageBytes == null && controller.logoUrl.value.isEmpty
          ? const Center(
              child: FittedBox(
                child: Text(
                  'No image selected',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          : controller.imageBytes != null
          ? Image.memory(controller.imageBytes!, fit: BoxFit.contain)
          : Image.network(controller.logoUrl.value, fit: BoxFit.contain),
    ),
  );
}
