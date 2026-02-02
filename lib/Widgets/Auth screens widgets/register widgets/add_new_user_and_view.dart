import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/users_controller.dart';
import '../../../consts.dart';
import 'expiry_date_and_active_status.dart';
import 'my_text_form_field.dart';

Widget addNewUserAndView({
  required BoxConstraints constraints,
  required BuildContext context,
  required UsersController controller,
  required bool canEdit,
  userExpiryDate,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 10,
    children: [
      myTextFormField(
        constraints: constraints,
        obscureText: false,
        controller: controller.name,
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
      Obx(
        () => myTextFormField(
          constraints: constraints,
          icon: IconButton(
            onPressed: () {
              controller.changeObscureTextValue();
            },
            icon: Icon(
              controller.obscureText.value
                  ? Icons.remove_red_eye_outlined
                  : Icons.visibility_off,
            ),
          ),
          obscureText: controller.obscureText.value,
          controller: controller.pass,
          labelText: 'Password',
          hintText: 'Enter your password',
          validate: true,
        ),
      ),
      Row(
        children: [
          Expanded(
            child: expiryDateAndActiveStatus(
              controller: controller,
              context: context,
              constraints: constraints,
              date: userExpiryDate.toString(),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade600),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                GetX<UsersController>(
                  builder: (controller) {
                    return CupertinoCheckbox(
                      value: controller.isAdmin.value,
                      onChanged: (v) {
                        controller.isAdmin.value = v!;
                      },
                    );
                  },
                ),
                Text(
                  'Admin',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomSlidingSegmentedControl<int>(
            initialValue: 1,
            children: const {1: Text('ROLES'), 2: Text('BRANCHES')},
            decoration: BoxDecoration(
              color: CupertinoColors.lightBackgroundGray,
              borderRadius: BorderRadius.circular(8),
            ),
            thumbDecoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(1),
                  blurRadius: 4.0,
                  spreadRadius: 1.0,
                  offset: const Offset(0.0, 2.0),
                ),
              ],
            ),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInToLinear,
            onValueChanged: (v) {
              // controller.selectedMenu.value = v;
              controller.selectFromTab(v);
            },
          ),
          Obx(
            () => controller.showPrimaryText.isTrue
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade600),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'Primary ?',
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),

      Expanded(
        child: GetX<UsersController>(
          builder: (controller) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              switchInCurve: Curves.bounceIn,
              switchOutCurve: Curves.bounceInOut,
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: controller.buildContent(controller.selectedMenu.value),
            );
          },
        ),
      ),
      // rolesSection(controller),
    ],
  );
}

Widget rolesSection({Key? key}) {
  return GetBuilder<UsersController>(
    key: key,
    builder: (controller) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Obx(
          () => controller.isLoading.value == false
              ? ListView.builder(
                  itemCount: controller.selectedRoles.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      leading: Obx(
                        () => Checkbox(
                          activeColor: Colors.blue,
                          value: controller.selectedRoles.values.elementAt(
                            i,
                          )[1],
                          onChanged: (selected) {
                            var key = controller.selectedRoles.keys.elementAt(
                              i,
                            ); // Get the key
                            controller.selectedRoles[key] = [
                              controller.selectedRoles[key]![0],
                              selected!,
                            ];
                          },
                        ),
                      ),
                      title: Text(
                        '${controller.selectedRoles.keys.elementAt(i)}',
                      ),
                    );
                  },
                )
              : loadingProcess,
        ),
      );
    },
  );
}

Widget branchesSection({Key? key}) {
  return GetBuilder<UsersController>(
    key: key,
    builder: (controller) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Obx(
          () => controller.isLoading.value == false
              ? ListView.builder(
                  itemCount: controller.selectedBranches.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      trailing: Obx(
                        () => RadioGroup(
                          groupValue: controller.primaryBranchIndex.value,
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectPrimaryBranch(value);
                            }
                          },
                          child: Radio<int>(
                            value: i, // unique value for this tile
                            activeColor: mainColor,
                          ),
                        ),
                      ),
                      leading: Obx(
                        () => Checkbox(
                          activeColor: Colors.blue,
                          value: controller.selectedBranches.values.elementAt(
                            i,
                          )[1],
                          onChanged: (selected) {
                            var key = controller.selectedBranches.keys
                                .elementAt(i);
                            controller.selectedBranches[key] = [
                              controller.selectedBranches[key]![0],
                              selected!,
                            ];
                            if (!selected &&
                                controller.primaryBranchIndex.value == i) {
                              controller.primaryBranchIndex.value = -1;
                            }
                          },
                        ),
                      ),
                      title: Text(
                        controller.selectedBranches.keys.elementAt(i),
                      ),
                    );
                  },
                )
              : loadingProcess,
        ),
      );
    },
  );
}
