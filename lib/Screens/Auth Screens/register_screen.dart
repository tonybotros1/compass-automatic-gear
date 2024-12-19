import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/Auth screen controllers/register_screen_controller.dart';
import '../../Widgets/Auth screens widgets/register widgets/add_new_user_and_view.dart';
import '../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../consts.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final RegisterController registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('User Management', style: fontStyleForAppBar),
            const SizedBox(
              height: 5,
            ),
            Divider(
              color: Colors.grey[700],
            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: SingleChildScrollView(
              child: Container(
                height: null,
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    searchBar(
                        constraints: constraints,
                        context: context,
                        registerController: registerController),
                    SizedBox(
                        width: constraints.maxWidth,
                        child: Obx(() =>
                            registerController.isScreenLoding.value == false
                                ? registerController.allUsers.isNotEmpty
                                    ? tableOfUsers(
                                        constraints: constraints,
                                        context: context)
                                    : const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                : const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('No users'),
                                    ),
                                  ))),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget tableOfUsers({required constraints, required context}) {
    return DataTable(
        headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
        columns: [
          DataColumn(
            label: Row(
              children: [
                Text(
                  'Email',
                  style: fontStyleForTableHeader,
                ),
                IconButton(
                    onPressed: () {
                      if (registerController.sortByEmailType.value == true) {
                        registerController.sortByEmailType.value = false;
                        registerController.getAllUsers('email');
                      } else {
                        registerController.sortByEmailType.value = true;
                        registerController.getAllUsers('email');
                      }
                    },
                    icon: registerController.sortByEmailType.value == true
                        ? iconStyleForTableHeaderDown
                        : iconStyleForTableHeaderUp)
              ],
            ),
          ),
          DataColumn(
            label: Row(
              children: [
                Text(
                  'Added Date',
                  style: fontStyleForTableHeader,
                ),
                IconButton(
                    onPressed: () {
                      if (registerController.sortByAddedDateType.value ==
                          true) {
                        registerController.sortByAddedDateType.value = false;
                        registerController.getAllUsers('added_date');
                      } else {
                        registerController.sortByAddedDateType.value = true;
                        registerController.getAllUsers('added_date');
                      }
                    },
                    icon: registerController.sortByAddedDateType.value == true
                        ? iconStyleForTableHeaderDown
                        : iconStyleForTableHeaderUp)
              ],
            ),
          ),
          DataColumn(
            label: Row(
              children: [
                Text(
                  'Expiry Date',
                  style: fontStyleForTableHeader,
                ),
                IconButton(
                    onPressed: () {
                      if (registerController.sortByExpiryDateType.value ==
                          true) {
                        registerController.sortByExpiryDateType.value = false;
                        registerController.getAllUsers('expiry_date');
                      } else {
                        registerController.sortByExpiryDateType.value = true;
                        registerController.getAllUsers('expiry_date');
                      }
                    },
                    icon: registerController.sortByExpiryDateType.value == true
                        ? iconStyleForTableHeaderDown
                        : iconStyleForTableHeaderUp)
              ],
            ),
          ),
          DataColumn(
            label: Text(
              '   Action',
              style: fontStyleForTableHeader,
            ),
          ),
        ],
        rows: registerController.filteredUsers.isEmpty
            ? registerController.allUsers.map((user) {
                final userData = user.data() as Map<String, dynamic>;
                final userId = user.id;
                return dataRowForTheTable(
                    userData, context, constraints, userId);
              }).toList()
            : registerController.filteredUsers.map((user) {
                final userData = user.data() as Map<String, dynamic>;
                final userId = user.id;

                return dataRowForTheTable(
                    userData, context, constraints, userId);
              }).toList());
  }

  DataRow dataRowForTheTable(
      Map<String, dynamic> userData, context, constraints, uid) {
    return DataRow(cells: [
      DataCell(Text(
        '${userData['email']}',
        style: regTextStyle,
      )),
      DataCell(
        Text(
          userData['added_date'] != null
              ? registerController.textToDate(userData['added_date']) //
              : 'N/A',
          style: regTextStyle,
        ),
      ),
      DataCell(
        Text(
          userData['expiry_date'] != null
              ? registerController.textToDate(userData['expiry_date'])
              : 'N/A',
          style: regTextStyle,
        ),
      ),
      DataCell(ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            elevation: 5,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  registerController.email.text = userData['email'];
                  for (var role in userData['roles']) {
                    registerController.selectedRoles.update(
                      role,
                      (value) => true,
                      ifAbsent: () =>
                          false, // Optional: handle if the key doesn't exist
                    );
                  }
                  // Set the rest of the keys to false
                  registerController.selectedRoles.forEach((key, value) {
                    if (!userData['roles'].contains(key)) {
                      registerController.selectedRoles
                          .update(key, (value) => false);
                    }
                  });
                  return AlertDialog(
                    actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
                    content: addNewUserAndView(
                        registerController: registerController,
                        constraints: constraints,
                        context: context,
                        email: registerController.email,
                        userExpiryDate: userData['expiry_date'],
                        activeStatus: true),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: ElevatedButton(
                          onPressed: registerController.sigupgInProcess.value
                              ? null
                              : () {
                                  registerController.updateUserDetails(uid);
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
                          child:
                              registerController.sigupgInProcess.value == false
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
                      ),
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
          child: const Text('View'))),
    ]);
  }
}
