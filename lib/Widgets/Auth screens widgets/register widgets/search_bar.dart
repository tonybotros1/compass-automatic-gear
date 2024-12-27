import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../consts.dart';
import 'add_new_user_and_view.dart';

Row searchBar({
  required BoxConstraints constraints,
  required context,
  required usersController,
}) {
  return Row(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: constraints.maxWidth / 2.5,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            // color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: FittedBox(
                  // flex: 1,
                  child: Icon(
                    Icons.search,
                    color: iconColor,
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: SizedBox(
                  width: constraints.maxWidth / 2,
                  child: TextFormField(
                    controller: usersController.search.value,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: iconColor),
                      hintText: 'Search for users by email',
                    ),
                    style: const TextStyle(color: iconColor),
                  ),
                ),
              ),
              FittedBox(
                child: IconButton(
                  onPressed: () {
                    usersController.search.value.clear();
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
      ),
      const Expanded(flex: 1, child: SizedBox()),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  usersController.email.clear();
                  usersController.pass.clear();
                  usersController.selectedRoles.updateAll(
                    (key, value) => [value[0], false],
                  );
                  return AlertDialog(
                    actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
                    content: addNewUserAndView(
                      usersController: usersController,
                      constraints: constraints,
                      context: context,
                      userExpiryDate: '',
                      showActiveStatus: false,
                    ),
                    actions: [
                      Obx(() => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: ElevatedButton(
                              onPressed: usersController.sigupgInProcess.value
                                  ? null
                                  : () {
                                      usersController.register();
                                      if (usersController
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
                              child:
                                  usersController.sigupgInProcess.value == false
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
                        child: usersController.sigupgInProcess.value == false
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
              usersController.getAllUsers();
            },
            icon: const Icon(
              Icons.refresh,
              color: Colors.grey,
            )),
      )
    ],
  );
}
