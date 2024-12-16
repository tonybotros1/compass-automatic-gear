import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../Controllers/Auth screen controllers/register_screen_controller.dart';
import '../../consts.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final RegisterController registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          'User management',
          style: GoogleFonts.mooli(
              fontWeight: FontWeight.bold, color: Colors.white),
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
                            searchBar(constraints, context),
                            SizedBox(
                                width: constraints.maxWidth,
                                child: tableOfUsers(constraints: constraints)),
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

  Row searchBar(BoxConstraints constraints, context) {
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
                          // controller: controller,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: iconColor),
                            hintText: 'Search for users',
                          ),
                          style: const TextStyle(color: iconColor),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: () {},
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
                    return AlertDialog(
                      actionsPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      content: addNewUser(constraints, context),
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
                                child: registerController
                                            .sigupgInProcess.value ==
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
                          child:
                              registerController.sigupgInProcess.value == false
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
              onPressed: () {},
              icon: const Icon(
                Icons.refresh,
                color: Colors.grey,
              )),
        )
      ],
    );
  }

  Widget tableOfUsers({required constraints}) {
    return DataTable(
        headingRowColor: WidgetStatePropertyAll(Colors.grey[300]),
        columns: [
          DataColumn(
            label: Text(
              'Email',
              style: TextStyle(
                  color: Colors.grey[700], fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Added Date',
              style: TextStyle(
                  color: Colors.grey[700], fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Expiry Date',
              style: TextStyle(
                  color: Colors.grey[700], fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              '   Action',
              style: TextStyle(
                  color: Colors.grey[700], fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: registerController.allUsers.map((user) {
          final userData = user.data() as Map<String, dynamic>;

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
                onPressed: () {},
                child: const Text('View / Edit'))),
          ]);
        }).toList());
  }

  Widget addNewUser(BoxConstraints constraints, BuildContext context) {
    return SizedBox(
      width: constraints.maxWidth / 2,
      height: constraints.maxHeight,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            myTextFormField(
              constraints: constraints,
              obscureText: false,
              controller: registerController.email,
              labelText: 'Email',
              hintText: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
              validate: true,
            ),
            Obx(() => myTextFormField(
                  constraints: constraints,
                  icon: IconButton(
                      onPressed: () {
                        registerController.changeObscureTextValue();
                      },
                      icon: Icon(registerController.obscureText.value
                          ? Icons.remove_red_eye_outlined
                          : Icons.visibility_off)),
                  obscureText: registerController.obscureText.value,
                  controller: registerController.pass,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  validate: true,
                )),
            Obx(
              () => expiryDate(context: context, constraints: constraints),
            ),
            Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(15)),
                constraints: BoxConstraints(
                    maxHeight: constraints.maxHeight,
                    maxWidth: constraints.maxWidth > 796
                        ? constraints.maxWidth / 3
                        : constraints.maxWidth < 796 &&
                                constraints.maxWidth > 400
                            ? constraints.maxWidth / 2
                            : constraints.maxWidth / 1.5),
                child: Obx(
                  () => registerController.isLoading.value == false
                      ? ListView.builder(
                          itemCount: registerController.sysRoles.length,
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            registerController.isSelected.add(false);
                            return ListTile(
                                leading: Obx(
                                  () => MSHCheckbox(
                                    size: 25,
                                    value: registerController.isSelected[i],
                                    // isDisabled: false,
                                    colorConfig: MSHColorConfig
                                        .fromCheckedUncheckedDisabled(
                                      checkedColor: Colors.blue,
                                      uncheckedColor: Colors.grey,
                                      disabledColor: Colors.grey.shade400,
                                    ),
                                    style: MSHCheckboxStyle.stroke,
                                    onChanged: (selected) {
                                      registerController.isSelected[i] =
                                          selected;
                                      registerController.selectedRoles.add(
                                          registerController.sysRoles[i]
                                              ['role_name']);
                                    },
                                  ),
                                ),
                                title: Text(
                                    '${registerController.sysRoles[i]['role_name']}'));
                          })
                      : CircularProgressIndicator(
                          color: mainColor,
                        ),
                )),
          ],
        ),
      ),
    );
  }

  Widget expiryDate({required BuildContext context, required constraints}) {
    return Container(
      constraints: BoxConstraints(
          maxHeight: constraints.maxHeight > 400
              ? constraints.maxHeight / 3
              : constraints.maxHeight / 1.3,
          maxWidth: constraints.maxWidth > 796
              ? constraints.maxWidth / 3
              : constraints.maxWidth < 796 && constraints.maxWidth > 400
                  ? constraints.maxWidth / 2
                  : constraints.maxWidth / 1.5),
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        title: Text(
          "Expiry Date ",
          style: fontStyle2,
        ),
        subtitle: Row(
          children: [
            Text(registerController
                .formatDate(registerController.selectedDate.value)),
            const SizedBox(
              width: 10,
            ),
            IconButton(
                onPressed: () => registerController.selectDateContext(context),
                icon: const Icon(
                  Icons.calendar_month,
                  color: Colors.blue,
                ))
          ],
        ),
      ),
    );
  }
}

Widget myTextFormField({
  required String labelText,
  required String hintText,
  required controller,
  required validate,
  required obscureText,
  IconButton? icon,
  required constraints,
  keyboardType,
}) {
  return Container(
    constraints: BoxConstraints(
        maxHeight: constraints.maxHeight > 400
            ? constraints.maxHeight / 3
            : constraints.maxHeight / 1.3,
        maxWidth: constraints.maxWidth > 796
            ? constraints.maxWidth / 3
            : constraints.maxWidth < 796 && constraints.maxWidth > 400
                ? constraints.maxWidth / 2
                : constraints.maxWidth / 1.5),
    child: TextFormField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: icon,
        hintStyle: const TextStyle(color: Colors.grey),
        labelText: labelText,
        hintText: hintText,
        labelStyle: TextStyle(color: Colors.grey.shade700),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2.0),
        ),
      ),
      validator: validate != false
          ? (value) {
              if (value!.isEmpty) {
                return 'Please Enter $labelText';
              }
              return null;
            }
          : null,
    ),
  );
}
