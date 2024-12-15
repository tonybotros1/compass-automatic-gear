import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../Controllers/Auth screen controllers/register_screen_controller.dart';
import '../../consts.dart';
import 'package:msh_checkbox/msh_checkbox.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final RegisterController registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: KeyboardListener(
        autofocus: true,
        focusNode: registerController.focusNode,
        onKeyEvent: (KeyEvent event) {
          // if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            registerController.register();
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              child: Row(
                mainAxisAlignment: constraints.maxWidth > 774
                    ? MainAxisAlignment.spaceAround
                    : MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  constraints.maxWidth > 1000
                      ? SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 50),
                            constraints: BoxConstraints(
                                maxHeight: constraints.maxHeight,
                                maxWidth: constraints.maxWidth / 1.9),
                            child: Obx(
                              () => registerController.allUsers.isNotEmpty
                                  ? DataTable(
                                      columns: const [
                                          DataColumn(
                                              label: Text(
                                            "Email",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          )),
                                          DataColumn(
                                              label: Text("Added Date",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text("Expiry Date",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          DataColumn(
                                              label: Text("   Action",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                        ],
                                      rows: registerController.allUsers
                                          .map((user) {
                                        final userData =
                                            user.data() as Map<String, dynamic>;

                                        return DataRow(cells: [
                                          DataCell(
                                              Text('${userData['email']}')),
                                          DataCell(
                                            Text(
                                              userData['added_date'] != null
                                                  ? userData['added_date']
                                                      .substring(0, 10) //
                                                  : 'N/A',
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              userData['expiry_date'] != null
                                                  ? userData['expiry_date']
                                                      .substring(0, 10)
                                                  : 'N/A',
                                            ),
                                          ),
                                          DataCell(TextButton(
                                              onPressed: () {},
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                    color: mainColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))),
                                        ]);
                                      }).toList())
                                  : Center(
                                      child: CircularProgressIndicator(
                                      color: mainColor,
                                    )),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    constraints:
                        BoxConstraints(maxHeight: constraints.maxHeight),
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
                                      registerController
                                          .changeObscureTextValue();
                                    },
                                    icon: Icon(
                                        registerController.obscureText.value
                                            ? Icons.remove_red_eye_outlined
                                            : Icons.visibility_off)),
                                obscureText:
                                    registerController.obscureText.value,
                                controller: registerController.pass,
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                validate: true,
                              )),
                          Obx(
                            () => expiryDate(
                                context: context, constraints: constraints),
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
                                () => registerController.isLoading.value ==
                                        false
                                    ? ListView.builder(
                                        itemCount:
                                            registerController.sysRoles.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, i) {
                                          registerController.isSelected
                                              .add(false);
                                          return ListTile(
                                              leading: Obx(
                                                () => MSHCheckbox(
                                                  size: 25,
                                                  value: registerController
                                                      .isSelected[i],
                                                  // isDisabled: false,
                                                  colorConfig: MSHColorConfig
                                                      .fromCheckedUncheckedDisabled(
                                                    checkedColor: Colors.blue,
                                                    uncheckedColor: Colors.grey,
                                                    disabledColor:
                                                        Colors.grey.shade400,
                                                  ),
                                                  style:
                                                      MSHCheckboxStyle.stroke,
                                                  onChanged: (selected) {
                                                    registerController
                                                            .isSelected[i] =
                                                        selected;
                                                    registerController
                                                        .selectedRoles
                                                        .add(registerController
                                                                .sysRoles[i]
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
                          Obx(() => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: ElevatedButton(
                                  onPressed:
                                      registerController.sigupgInProcess.value
                                          ? null
                                          : () {
                                              registerController.register();
                                            },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: mainColor,
                                  ),
                                  child: registerController
                                              .sigupgInProcess.value ==
                                          false
                                      ? const Text(
                                          'Add user',
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
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget expiryDate({required BuildContext context, required constraints}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
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
            "Expiry Date: ",
            style: fontStyle,
          ),
          subtitle: Text(registerController
              .formatDate(registerController.selectedDate.value)),
          trailing: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: mainColor,
            ),
            onPressed: () => registerController.selectDateContext(context),
            child: const FittedBox(
                child: Text(
              'Select Date',
              style: TextStyle(color: Colors.white),
            )),
          ),
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

Padding dropDownValues({
  required String labelText,
  required String hintText,
  required TextEditingController controller,
  required List<String> list,
  required String selectedValue,
  // required bool validate,
}) {
  return Padding(
      padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
      child: TypeAheadField<Object?>(
        builder: (context, textEditingController, focusNode) {
          return TextField(
            controller: textEditingController,
            focusNode: focusNode,
            decoration: InputDecoration(
              iconColor: Colors.grey.shade700,
              suffixIcon: Icon(
                Icons.arrow_downward_rounded,
                color: Colors.grey.shade700,
              ),
              hintText: hintText,
              labelText: labelText,
              hintStyle: const TextStyle(color: Colors.grey),
              labelStyle: TextStyle(color: Colors.grey.shade700),
            ),
          );
        },
        suggestionsCallback: (pattern) async {
          return list
              .where(
                  (item) => item.toLowerCase().contains(pattern.toLowerCase()))
              .toList();
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion.toString()),
          );
        },
        onSelected: (suggestion) {
          controller.text = suggestion.toString();
        },
        // validator: validate != false
        //     ? (value) {
        //         if (value!.isEmpty) {
        //           return 'Please Enter $labelText';
        //         }
        //         return null;
        //       }
        //     : null,
        emptyBuilder: (context) => const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('No items found'),
        ),
      ));
}
