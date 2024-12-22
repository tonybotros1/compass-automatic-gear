import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../consts.dart';
import 'expiry_date_and_active_status.dart';
import 'my_text_form_field.dart';

Widget addNewUserAndView(
    {required BoxConstraints constraints,
    required BuildContext context,
    required registerController,
    TextEditingController? email,
    userExpiryDate,
    status,
    activeStatus}) {
  return SizedBox(
    width: constraints.maxWidth / 2.5,
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
          expiryDateAndActiveStatus(
              activeStatus: activeStatus,
              registerController: registerController,
              context: context,
              constraints: constraints,
              date: userExpiryDate),
          Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15)),
              child: Obx(
                () => registerController.isLoading.value == false
                    ? ListView.builder(
                        itemCount: registerController.selectedRoles.length,
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          return ListTile(
                              leading: Obx(
                                () => Checkbox(
                                    activeColor: Colors.blue,
                                    value: registerController
                                        .selectedRoles.values
                                        .elementAt(i)[1],
                                    onChanged: (selected) {
                                      var key = registerController
                                          .selectedRoles.keys
                                          .elementAt(i); // Get the key
                                      registerController.selectedRoles[key] = [
                                        registerController.selectedRoles[key]![
                                            0], 
                                        selected!, 
                                      ];
                                    }),
                              ),
                              title: Text(
                                  '${registerController.selectedRoles.keys.elementAt(i)}'));
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
