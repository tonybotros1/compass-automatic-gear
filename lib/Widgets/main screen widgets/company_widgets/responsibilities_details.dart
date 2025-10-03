import 'package:datahubai/Widgets/drop_down_menu3.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/company_controller.dart';
import '../../../Models/companies/company_model.dart';

Container responsibilities({required CompanyController controller}) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: containerDecor,
    child: GetX<CompanyController>(
      builder: (context) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomDropdown(
                    hintText: 'Responsibilities',
                    items: controller.allRoles.isEmpty
                        ? {}
                        : controller.allRoles,
                    showedSelectedName: 'role_name',

                    onChanged: (key, value) {
                      final selectedRole = MainUserRoles(
                        sId: key,
                        roleName: value["role_name"],
                      );
                      if (!controller.roleIDFromList.any(
                        (role) => role.sId == selectedRole.sId,
                      )) {
                        controller.roleIDFromList.add(selectedRole);
                      }
                    },
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
            const SizedBox(height: 5),
            if (controller.roleIDFromList.isNotEmpty)
              ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(
                        controller.roleIDFromList.length,
                        (i) {
                          final roleName =
                              controller.roleIDFromList[i].roleName ?? '';
                          return Row(
                            spacing: 2,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xff415E72),
                                  // const Color.fromARGB(
                                  //   255,
                                  //   160,
                                  //   176,
                                  //   212,
                                  // ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  roleName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  controller.removeMenuFromList(i);
                                },
                                child: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.redAccent,
                                  size: 16,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
          ],
        );
      },
    ),
  );
}
