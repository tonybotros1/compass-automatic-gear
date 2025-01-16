import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/users_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/add_new_user_and_view.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../consts.dart';

class Users extends StatelessWidget {
  Users({super.key});

  final UsersController usersController = Get.put(UsersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: screenPadding,
            child: Container(
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  searchBar(
                    constraints: constraints,
                    context: context,
                    controller: usersController,
                    title: 'Search for users by email',
                    button: newUserButton(context, constraints),
                  ),
                  Expanded(
                    child: Obx(
                      () {
                        if (usersController.isScreenLoding.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (usersController.allUsers.isEmpty) {
                          return const Center(
                            child: Text('No Element'),
                          );
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis
                              .vertical, // Allow horizontal scrolling for table
                          child: SizedBox(
                            width: constraints.maxWidth,
                            child: tableOfUsers(
                              constraints: constraints,
                              context: context,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  ElevatedButton newUserButton(
      BuildContext context, BoxConstraints constraints) {
    return ElevatedButton(
      onPressed: () {
        usersController.name.clear();
        usersController.pass.clear();
        usersController.email.clear();
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
                  controller: usersController,
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
                                },
                          style: saveButtonStyle,
                          child: usersController.sigupgInProcess.value == false
                              ? const Text(
                                  'Save',
                                  style: TextStyle(color: Colors.white),
                                )
                              : const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                        ),
                      )),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: cancelButtonStyle,
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
      style: newButtonStyle,
      child: const Text('New User'),
    );
  }

  Widget tableOfUsers({required constraints, required context}) {
    return DataTable(
      dataRowMaxHeight: 40,
      dataRowMinHeight: 30,
      columnSpacing: 5,
      showBottomBorder: true,
      dataTextStyle: regTextStyle,
      headingTextStyle: fontStyleForTableHeader,
      sortColumnIndex: usersController.sortColumnIndex.value,
      sortAscending: usersController.isAscending.value,
      headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
      columns: [
        DataColumn(
          label: AutoSizedText(
            text: 'Name',
            constraints: constraints,
          ),
          onSort: usersController.onSort,
        ),
        DataColumn(
          label: AutoSizedText(
            text: 'Email',
            constraints: constraints,
          ),
          onSort: usersController.onSort,
        ),
        DataColumn(
          label: AutoSizedText(
            constraints: constraints,
            text: 'Added Date',
          ),
          onSort: usersController.onSort,
        ),
        DataColumn(
          label: AutoSizedText(
            constraints: constraints,
            text: 'Expiry Date',
          ),
          onSort: usersController.onSort,
        ),
        DataColumn(
          headingRowAlignment: MainAxisAlignment.center,
          label: AutoSizedText(
            constraints: constraints,
            text: 'Action',
          ),
        ),
      ],
      rows: usersController.filteredUsers.isEmpty &&
              usersController.search.value.text.isEmpty
          ? usersController.allUsers.map((user) {
              final userData = user.data() as Map<String, dynamic>;
              final userId = user.id;
              return dataRowForTheTable(userData, context, constraints, userId);
            }).toList()
          : usersController.filteredUsers.map((user) {
              final userData = user.data() as Map<String, dynamic>;
              final userId = user.id;
              return dataRowForTheTable(userData, context, constraints, userId);
            }).toList(),
    );
  }

  DataRow dataRowForTheTable(
      Map<String, dynamic> userData, context, constraints, uid) {
    return DataRow(cells: [
      DataCell(Text(
        '${userData['user_name']}',
      )),
      DataCell(Text(
        '${userData['email']}',
      )),
      DataCell(
        Text(
          userData['added_date'] != null
              ? usersController.textToDate(userData['added_date']) //
              : 'N/A',
        ),
      ),
      DataCell(
        Text(
          userData['expiry_date'] != null
              ? usersController.textToDate(userData['expiry_date'])
              : 'N/A',
        ),
      ),
      DataCell(Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: viewSection(
                  context, userData, constraints, uid, usersController),
            ),
            ElevatedButton(
                style: deleteButtonStyle,
                onPressed: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: const Text("Alert"),
                        content:
                            const Text("The user will be deleted permanently"),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            isDefaultAction: true,
                            child: const Text("OK"),
                            onPressed: () async {
                              await usersController.deleteUser(uid);

                              Get.back();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Delete'))
          ],
        ),
      )),
    ]);
  }

  ElevatedButton viewSection(context, Map<String, dynamic> userData,
      constraints, uid, usersController) {
    return ElevatedButton(
        style: viewButtonStyle,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                usersController.email.text = userData['email'];
                usersController.name.text = userData['user_name'];
                usersController.userStatus.value = userData['status'];
                for (var roleId in userData['roles']) {
                  usersController.selectedRoles.forEach((key, value) {
                    if (value[0] == roleId) {
                      usersController.selectedRoles.update(
                        key,
                        (value) => [value[0], true],
                      );
                    }
                  });
                }

                // Reset roles not in userData['roles'] to false
                usersController.selectedRoles.forEach((key, value) {
                  if (!userData['roles'].contains(value[0])) {
                    usersController.selectedRoles.update(
                      key,
                      (value) => [value[0], false],
                    );
                  }
                });

                return AlertDialog(
                  actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
                  content: addNewUserAndView(
                      status: usersController.userStatus,
                      controller: usersController,
                      constraints: constraints,
                      context: context,
                      email: usersController.email,
                      name: usersController.name,
                      userExpiryDate: userData['expiry_date'],
                      showActiveStatus: true),
                  actions: [
                    Obx(
                      () => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: ElevatedButton(
                          onPressed:
                              usersController.sigupgInProcess.value == true
                                  ? null
                                  : () {
                                      usersController.updateUserDetails(uid);
                                    },
                          style: saveButtonStyle,
                          child: usersController.sigupgInProcess.value == false
                              ? const Text(
                                  'Save',
                                  style: TextStyle(color: Colors.white),
                                )
                              : const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: cancelButtonStyle,
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
        child: const Text('View'));
  }
}
