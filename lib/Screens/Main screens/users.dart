import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/Main screen controllers/users_controller.dart';
import '../../Widgets/Auth screens widgets/register widgets/add_new_user_and_view.dart';
import '../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../consts.dart';

class Users extends StatelessWidget {
  Users({super.key});

  final UsersController usersController = Get.put(UsersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
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
            padding: const EdgeInsets.only(
                left: 14,
                right: 14,
                bottom:
                    10), //EdgeInsets.symmetric(horizontal: 14, vertical: 0),
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
                      usersController: usersController),
                  Expanded(
                    child: SingleChildScrollView(
                      child: SizedBox(
                          width: constraints.maxWidth,
                          child: Obx(() =>
                              usersController.isScreenLoding.value == false &&
                                      usersController.allUsers.isNotEmpty
                                  ? tableOfUsers(
                                      constraints: constraints,
                                      context: context)
                                  : usersController.isScreenLoding.value ==
                                              false &&
                                          usersController.allUsers.isEmpty
                                      ? const Center(
                                          child: Text('No Element'),
                                        )
                                      : const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircularProgressIndicator(),
                                          ),
                                        ))),
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
                    if (usersController.sortByEmailType.value == true) {
                      usersController.sortByEmailType.value = false;
                      usersController.getAllUsers('email');
                    } else {
                      usersController.sortByEmailType.value = true;
                      usersController.getAllUsers('email');
                    }
                  },
                  icon: usersController.sortByEmailType.value == true
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
                    if (usersController.sortByAddedDateType.value == true) {
                      usersController.sortByAddedDateType.value = false;
                      usersController.getAllUsers('added_date');
                    } else {
                      usersController.sortByAddedDateType.value = true;
                      usersController.getAllUsers('added_date');
                    }
                  },
                  icon: usersController.sortByAddedDateType.value == true
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
                    if (usersController.sortByExpiryDateType.value == true) {
                      usersController.sortByExpiryDateType.value = false;
                      usersController.getAllUsers('expiry_date');
                    } else {
                      usersController.sortByExpiryDateType.value = true;
                      usersController.getAllUsers('expiry_date');
                    }
                  },
                  icon: usersController.sortByExpiryDateType.value == true
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
        '${userData['email']}',
        style: regTextStyle,
      )),
      DataCell(
        Text(
          userData['added_date'] != null
              ? usersController.textToDate(userData['added_date']) //
              : 'N/A',
          style: regTextStyle,
        ),
      ),
      DataCell(
        Text(
          userData['expiry_date'] != null
              ? usersController.textToDate(userData['expiry_date'])
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
                        usersController: usersController,
                        constraints: constraints,
                        context: context,
                        email: usersController.email,
                        name: usersController.name,
                        userExpiryDate: userData['expiry_date'],
                        showActiveStatus: true),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: ElevatedButton(
                          onPressed: usersController.sigupgInProcess.value
                              ? null
                              : () {
                                  usersController.updateUserDetails(uid);
                                  if (usersController.sigupgInProcess.value ==
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
                          child: usersController.sigupgInProcess.value == false
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
          child: const Text('View'))),
    ]);
  }
}
