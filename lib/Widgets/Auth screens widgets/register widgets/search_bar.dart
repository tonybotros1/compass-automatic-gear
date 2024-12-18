import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../consts.dart';
import 'add_new_user_and_view.dart';

Row searchBar({
  required BoxConstraints constraints,
  required context,
  required registerController,
}) {
  return Row(
    children: [
      Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                // color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.search,
                      color: iconColor,
                    ),
                  ),
                  Expanded(
                    flex: 9,
                    child: SizedBox(
                      width: constraints.maxWidth / 2,
                      child: TextFormField(
                        controller: registerController.search.value,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: iconColor),
                          hintText: 'Search for users by email',
                        ),
                        style: const TextStyle(color: iconColor),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {
                       registerController.search.value.clear();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: iconColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
      const Expanded(flex: 2, child: SizedBox()),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  registerController.email.clear();
                  registerController.pass.clear();
                  registerController.selectedRoles.updateAll(
                    (key, value) => false,
                  );
                  return AlertDialog(
                    actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
                    content: addNewUserAndView(
                      registerController: registerController,
                      constraints: constraints,
                      context: context,
                      userExpiryDate: '',
                      activeStatus:false,
                    ),
                    actions: [
                      Obx(() => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: ElevatedButton(
                              onPressed:
                                  registerController.sigupgInProcess.value
                                      ? null
                                      : () {
                                          registerController.register();
                                          if (registerController
                                                  .sigupgInProcess.value ==
                                              false) {
                                            Get.back();
                                          }
                                        },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: registerController.sigupgInProcess.value ==
                                      false
                                  ? const Text(
                                      'Save',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          )),
                      ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: registerController.sigupgInProcess.value == false
                            ? const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.white),
                              )
                            : const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ],
                  );
                });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            elevation: 5,
          ),
          child: const Text('New User'),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
            onPressed: () {
              registerController.getAllUsers();
            },
            icon: const Icon(
              Icons.refresh,
              color: Colors.grey,
            )),
      )
    ],
  );
}
