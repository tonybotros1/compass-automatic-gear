import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controllers/Main screen controllers/users_controller.dart';
import '../../../../Models/users/users_model.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../../../Widgets/Auth screens widgets/register widgets/users_dialog.dart';
import '../../../../Widgets/main screen widgets/auto_size_box.dart';
import '../../../../consts.dart';

class Users extends StatelessWidget {
  const Users({super.key});

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
                  GetX<UsersController>(
                    init: UsersController(),
                    builder: (controller) {
                      return searchBar(
                        onChanged: (_) {
                          controller.filterCards();
                        },
                        onPressedForClearSearch: () {
                          controller.search.value.clear();
                          controller.filterCards();
                        },
                        search: controller.search,
                        constraints: constraints,
                        context: context,
                        title: 'Search for users by email',
                        button: newUserButton(context, constraints, controller),
                      );
                    },
                  ),
                  Expanded(
                    child: GetX<UsersController>(
                      builder: (controller) {
                        if (controller.isScreenLoding.value) {
                          return Center(child: loadingProcess);
                        }
                        if (controller.allUsers.isEmpty) {
                          return const Center(child: Text('No Element'));
                        }
                        return SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SizedBox(
                            width: constraints.maxWidth,
                            child: tableOfUsers(
                              constraints: constraints,
                              context: context,
                              controller: controller,
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
    BuildContext context,
    BoxConstraints constraints,
    UsersController controller,
  ) {
    return ElevatedButton(
      onPressed: () {
        controller.selectedMenu.value = 1;
        controller.showPrimaryText.value = false;
        controller.name.clear();
        controller.pass.clear();
        controller.email.clear();
        controller.primaryBranchIndex.value = -1;
        controller.isAdmin.value = false;
        controller.selectedRoles.updateAll((key, value) => [value[0], false]);
        controller.selectedBranches.updateAll(
          (key, value) => [value[0], false],
        );
        usersDialog(
          userExpiryDate: '',
          canEdit: true,
          controller: controller,
          constraints: constraints,
          context: context,
          onPressed: controller.sigupgInProcess.value
              ? null
              : () {
                  controller.register();
                },
        );
      },
      style: newButtonStyle,
      child: const Text('New User'),
    );
  }

  Widget tableOfUsers({
    required BoxConstraints constraints,
    required BuildContext context,
    required UsersController controller,
  }) {
    return DataTable(
      dataRowMaxHeight: 40,
      dataRowMinHeight: 30,
      columnSpacing: 5,
      showBottomBorder: true,
      horizontalMargin: horizontalMarginForTable,
      dataTextStyle: regTextStyle,
      headingTextStyle: fontStyleForTableHeader,
      sortColumnIndex: controller.sortColumnIndex.value,
      sortAscending: controller.isAscending.value,
      headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
      columns: [
        DataColumn(
          label: AutoSizedText(text: 'Name', constraints: constraints),
          onSort: controller.onSort,
        ),
        DataColumn(
          label: AutoSizedText(text: 'Email', constraints: constraints),
          onSort: controller.onSort,
        ),
        DataColumn(
          label: AutoSizedText(constraints: constraints, text: 'Added Date'),
          onSort: controller.onSort,
        ),
        DataColumn(
          label: AutoSizedText(constraints: constraints, text: 'Expiry Date'),
          onSort: controller.onSort,
        ),
        const DataColumn(label: Text('')),
      ],
      rows:
          controller.filteredUsers.isEmpty &&
              controller.search.value.text.isEmpty
          ? controller.allUsers.map((user) {
              final userId = user.id;
              return dataRowForTheTable(
                user,
                context,
                constraints,
                userId,
                controller,
              );
            }).toList()
          : controller.filteredUsers.map((user) {
              final userId = user.id;
              return dataRowForTheTable(
                user,
                context,
                constraints,
                userId,
                controller,
              );
            }).toList(),
    );
  }

  DataRow dataRowForTheTable(
    UsersModel userData,
    BuildContext context,
    BoxConstraints constraints,
    String uid,
    UsersController controller,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(userData.userName)),
        DataCell(Text(userData.email)),
        DataCell(Text(textToDate(userData.createdAt))),
        DataCell(Text(textToDate(userData.expiryDate))),
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              activeInActiveSection(userData, uid, controller),
              Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: editSection(
                  context,
                  userData,
                  constraints,
                  uid,
                  controller,
                ),
              ),
              deleteSection(context, uid, controller),
            ],
          ),
        ),
      ],
    );
  }

  ElevatedButton activeInActiveSection(
    UsersModel userData,
    String userId,
    UsersController controller,
  ) {
    return ElevatedButton(
      style: userData.status == false ? inActiveButtonStyle : activeButtonStyle,
      onPressed: () {
        bool status;
        if (userData.status == false) {
          status = true;
        } else {
          status = false;
        }
        controller.changeUserStatus(userId, status);
      },
      child: userData.status == true
          ? const Text('Active')
          : const Text('Inactive'),
    );
  }

  ElevatedButton deleteSection(
    BuildContext context,
    String uid,
    UsersController controller,
  ) {
    return ElevatedButton(
      style: deleteButtonStyle,
      onPressed: () {
        alertDialog(
          context: context,
          content: 'The user will be deleted permanently',
          onPressed: () {
            controller.deleteUser(uid);
          },
        );
      },
      child: const Text('Delete'),
    );
  }

  ElevatedButton editSection(
    BuildContext context,
    UsersModel userData,
    BoxConstraints constraints,
    String uid,
    UsersController controller,
  ) {
    return ElevatedButton(
      style: editButtonStyle,
      onPressed: () {
        controller.showPrimaryText.value = false;
        controller.selectedMenu.value = 1;
        controller.pass.clear();
        controller.email.text = userData.email;
        controller.name.text = userData.userName;
        controller.isAdmin.value = userData.isAdmin;
        // Sync roles & branches
        controller.syncSelection(controller.selectedRoles, userData.roles);

        controller.syncSelection(
          controller.selectedBranches,
          userData.branches,
        );
        controller.primaryBranchIndex.value = controller.getPrimaryBranchIndex(
          controller.selectedBranches,
          userData.primaryBranch,
        );

        usersDialog(
          userExpiryDate: userData.expiryDate,
          canEdit: false,
          controller: controller,
          constraints: constraints,
          context: context,
          onPressed: controller.sigupgInProcess.value
              ? null
              : () {
                  controller.updateUserDetails(uid);
                },
        );
      },
      child: const Text('Edit'),
    );
  }
}
