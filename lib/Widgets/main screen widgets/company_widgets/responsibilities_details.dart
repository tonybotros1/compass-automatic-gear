import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/company_controller.dart';

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
                  child: CustomDropdown(
                hintText: 'Responsibilities',
                items: controller.allRoles.isEmpty ? {} : controller.allRoles,
                itemBuilder: (context, key, value) {
                  return ListTile(
                    title: Text(value['role_name']),
                  );
                },
                onChanged: (key, value) {
                  if (!controller.roleIDFromList.contains(key)) {
                    controller.roleIDFromList.add(key);
                  }
                },
              )),
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
