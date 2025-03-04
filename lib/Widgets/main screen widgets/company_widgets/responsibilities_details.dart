import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/company_controller.dart';
import '../drop_down_menu.dart';

Container responsibilities({
  required CompanyController controller,
}) {
  return Container(
    padding: EdgeInsets.all(20),
    decoration: containerDecor,
    child: GetX<CompanyController>(builder: (context) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: dropDownValues(
                  listValues: controller.allRoles.values
                      .map((value) => value.toString())
                      .toList(),
                  onSelected: (suggestion) {
                    controller.allRoles.entries.where((entry) {
                      return entry.value == suggestion.toString();
                    }).forEach((entry) {
                      if (!controller.roleIDFromList.contains(entry.key)) {
                        controller.roleIDFromList.add(entry.key);
                      }
                    });
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion.toString()),
                    );
                  },
                  labelText: 'Responsibilities',
                  hintText: 'Select responsibility',
                  menus: controller.allRoles.isEmpty ? {} : controller.allRoles,
                  validate: true,
                ),
              ),
              Expanded(child: SizedBox())
            ],
          ),
          SizedBox(
            height: 5,
          ),
          if (controller.roleIDFromList.isNotEmpty)
            ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      controller.roleIDFromList.length,
                      (i) {
                        final roleName = controller
                            .getRoleName(controller.roleIDFromList[i] ?? 0);
                        return Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 160, 176, 212),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                roleName,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  controller.removeMenuFromList(i);
                                },
                                child: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
        ],
      );
    }),
  );
}
