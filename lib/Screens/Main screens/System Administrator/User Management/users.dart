import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/users_controller.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/users_dialog.dart';
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
                    search: usersController.search,
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
        usersController.selectedRoles.updateAll(
          (key, value) => [value[0], false],
        );
        usersDialog(
            userExpiryDate: '',
            canEdit: true,
            controller: usersController,
            constraints: constraints,
            context: context,
            onPressed: usersController.sigupgInProcess.value
                ? null
                : () {
                    usersController.register();
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
      horizontalMargin: horizontalMarginForTable,
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
        DataColumn(label: Text('')),
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
              ? textToDate(userData['added_date']) //
              : 'N/A',
        ),
      ),
      DataCell(
        Text(
          userData['expiry_date'] != null
              ? textToDate(userData['expiry_date'])
              : 'N/A',
        ),
      ),
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          activeInActiveSection(userData, uid),
          Padding(
            padding: const EdgeInsets.only(right: 5, left: 5),
            child: editSection(
                context, userData, constraints, uid, usersController),
          ),
          deleteSection(context, uid)
        ],
      )),
    ]);
  }

  ElevatedButton activeInActiveSection(
      Map<String, dynamic> userData, String userId) {
    return ElevatedButton(
        style: userData['status'] == false
            ? inActiveButtonStyle
            : activeButtonStyle,
        onPressed: () {
          bool status;
          if (userData['status'] == false) {
            status = true;
          } else {
            status = false;
          }
          usersController.changeUserStatus(userId, status);
        },
        child: userData['status'] == true
            ? const Text('Active')
            : const Text('Inactive'));
  }

  ElevatedButton deleteSection(context, uid) {
    return ElevatedButton(
        style: deleteButtonStyle,
        onPressed: () {
          alertDialog(
              context: context,
              controller: usersController,
              content: 'The user will be deleted permanently',
              onPressed: () {
                usersController.deleteUser(uid);
              });
        },
        child: const Text('Delete'));
  }

  ElevatedButton editSection(context, Map<String, dynamic> userData,
      constraints, uid, UsersController usersController) {
    return ElevatedButton(
        style: editButtonStyle,
        onPressed: () {
          usersController.email.text = userData['email'];
          usersController.name.text = userData['user_name'];
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
          usersDialog(
              userExpiryDate: userData['expiry_date'],
              canEdit: false,
              controller: usersController,
              constraints: constraints,
              context: context,
              onPressed: usersController.sigupgInProcess.value
                  ? null
                  : () {
                      usersController.updateUserDetails(uid);
                    });
        },
        child: const Text('Edit'));
  }
}
