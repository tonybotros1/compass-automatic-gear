import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/Auth screen controllers/register_screen_controller.dart';
import '../../Widgets/Auth screens widgets/register widgets/add_new_user_and_view.dart';
import '../../Widgets/Auth screens widgets/register widgets/search_bar.dart';
import '../../consts.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final RegisterController registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'User management',
          style: GoogleFonts.mooli(
              decoration: TextDecoration.underline,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700]),
        ),
      ),
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Obx(
            () => registerController.allUsers.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
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
                                child: tableOfUsers(
                                    constraints: constraints,
                                    context: context)),
                          ],
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(
                    color: mainColor,
                  )),
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
            label: Text(
              'Email',
              style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          DataColumn(
            label: Text(
              'Added Date',
              style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          DataColumn(
            label: Text(
              'Expiry Date',
              style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          DataColumn(
            label: Text(
              '   Action',
              style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ],
        rows: registerController.filteredUsers.isEmpty
            ? registerController.allUsers.map((user) {
                final userData = user.data() as Map<String, dynamic>;

                return dataRowForTheTable(userData, context, constraints);
              }).toList()
            : registerController.filteredUsers.map((user) {
                final userData = user.data() as Map<String, dynamic>;

                return dataRowForTheTable(userData, context, constraints);
              }).toList());
  }

  DataRow dataRowForTheTable(
      Map<String, dynamic> userData, context, constraints) {
    return DataRow(cells: [
      DataCell(Text('${userData['email']}')),
      DataCell(
        Text(
          userData['added_date'] != null
              ? userData['added_date'].substring(0, 10) //
              : 'N/A',
        ),
      ),
      DataCell(
        Text(
          userData['expiry_date'] != null
              ? userData['expiry_date'].substring(0, 10)
              : 'N/A',
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
                        userExpiryDate: userData['expiry_date']),
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
          child: const Text('View'))),
    ]);
  }
}
