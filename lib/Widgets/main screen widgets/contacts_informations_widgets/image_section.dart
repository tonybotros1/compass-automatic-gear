
import 'package:flutter/material.dart';

import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';

InkWell imageSection(EntityInformationsController controller) {
  return InkWell(
                  onTap: () {
                    controller.pickImage();
                  },
                  child: Container(
                    height: 150,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          style: BorderStyle.solid, color: Colors.grey),
                    ),
                    child: controller.imageBytes == null
                        ? const Center(
                            child: FittedBox(
                              child: Text(
                                'No image selected',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          )
                        : Image.memory(
                            controller.imageBytes!,
                            fit: BoxFit.fitHeight,
                          ),
                  ),
                );
}