 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msh_checkbox/msh_checkbox.dart';

import '../../../Screens/Auth Screens/login_screen.dart';
import '../../../consts.dart';
import 'expiry_date_and_active_status.dart';

Widget addNewUserAndView({
    required BoxConstraints constraints,
    required BuildContext context,
    required registerController,
    TextEditingController? email,
    userExpiryDate,
    status,
    activeStatus
  }) {
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
              controller: email ?? registerController.email,
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
            // Obx(
            //   () => 
              expiryDateAndActiveStatus(
                activeStatus: activeStatus,
                registerController:registerController,
                  context: context,
                  constraints: constraints,
                  date: userExpiryDate),
            // ),
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
                            return ListTile(
                                leading: Obx(
                                  () => MSHCheckbox(
                                    size: 25,
                                    value: registerController
                                        .selectedRoles.values
                                        .elementAt(i),
                                    colorConfig: MSHColorConfig
                                        .fromCheckedUncheckedDisabled(
                                      checkedColor: Colors.blue,
                                      uncheckedColor: Colors.grey,
                                      disabledColor: Colors.grey.shade400,
                                    ),
                                    style: MSHCheckboxStyle.stroke,
                                    onChanged: (selected) {
                                      registerController.selectedRoles[
                                          registerController.selectedRoles.keys
                                              .elementAt(i)] = selected;
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