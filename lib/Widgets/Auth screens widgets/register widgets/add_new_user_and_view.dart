import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/users_controller.dart';
import '../../../consts.dart';
import 'expiry_date_and_active_status.dart';
import 'my_text_form_field.dart';

Widget addNewUserAndView(
    {required BoxConstraints constraints,
    required BuildContext context,
    required UsersController controller,
   required bool canEdit,
    userExpiryDate,
  }) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      myTextFormField(
        constraints: constraints,
        obscureText: false,
        controller:controller.name,
        labelText: 'User Name',
        hintText: 'Enter your name',
        keyboardType: TextInputType.name,
        validate: true,
      ),
      myTextFormField(
        constraints: constraints,
        obscureText: false,
        controller: controller.email,
        labelText: 'Email',
        hintText: 'Enter your email',
        keyboardType: TextInputType.emailAddress,
        validate: true,
        canEdit: canEdit,
      ),
      Obx(() => myTextFormField(
            constraints: constraints,
            icon: IconButton(
                onPressed: () {
                  controller.changeObscureTextValue();
                },
                icon: Icon(controller.obscureText.value
                    ? Icons.remove_red_eye_outlined
                    : Icons.visibility_off)),
            obscureText: controller.obscureText.value,
            controller: controller.pass,
            labelText: 'Password',
            hintText: 'Enter your password',
            validate: true,
          )),
      expiryDateAndActiveStatus(
          controller: controller,
          context: context,
          constraints: constraints,
          date: userExpiryDate),
      Expanded(
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(15)),
            child: Obx(
              () => controller.isLoading.value == false
                  ? ListView.builder(
                      itemCount: controller.selectedRoles.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return ListTile(
                            leading: Obx(
                              () => Checkbox(
                                  activeColor: Colors.blue,
                                  value: controller.selectedRoles.values
                                      .elementAt(i)[1],
                                  onChanged: (selected) {
                                    var key = controller.selectedRoles.keys
                                        .elementAt(i); // Get the key
                                    controller.selectedRoles[key] = [
                                      controller.selectedRoles[key]![0],
                                      selected!,
                                    ];
                                  }),
                            ),
                            title: Text(
                                '${controller.selectedRoles.keys.elementAt(i)}'));
                      })
                  : CircularProgressIndicator(
                      color: mainColor,
                    ),
            )),
      ),
    ],
  );
}
