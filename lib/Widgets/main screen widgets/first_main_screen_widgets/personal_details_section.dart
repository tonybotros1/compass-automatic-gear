import 'package:datahubai/Widgets/my_text_field.dart';
import 'package:datahubai/Widgets/text_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/Main screen controllers/main_screen_contro.dart';
import '../../../consts.dart';
import '../../overlay_button.dart';

SmartInfoOverlay personalDetailsSection(
  BuildContext context,
  MainScreenController mainScreenController,
) {
  return SmartInfoOverlay(
    backgroundColor: Colors.blue.shade200,
    triggerBuilder: (showOverlay) => InkWell(
      onTap: showOverlay,
      child: CircleAvatar(
        backgroundColor: mainColor,
        radius: 25,
        child: Center(
          child: Text(
            mainScreenController.getFirstCharacter(
              mainScreenController.userName.value,
            ),
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    ),
    overlayContent: (dismiss) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          mainScreenController.userEmail.value,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 25),
        CircleAvatar(
          backgroundColor: mainColor,
          radius: 30,
          child: Text(
            mainScreenController.getFirstCharacter(
              mainScreenController.userName.value,
            ),
            style: const TextStyle(fontSize: 25, color: Colors.white),
          ),
        ),
        FittedBox(
          child: Text(
            'Hi, ${mainScreenController.userName.value}!',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blue.shade400,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  mainScreenController.companyName.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  children: [
                    const Text(
                      'Joining Date:',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      textToDate(mainScreenController.userJoiningDate.value),
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    const Text(
                      'Expiry Date:',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      textToDate(mainScreenController.userExpiryDate.value),
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: logoutButtonStyle,
                      onPressed: () async {
                        dismiss();
                        Get.dialog(
                          barrierDismissible: false,
                          Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: SizedBox(
                              height: 350,
                              width: 600,
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                      ),
                                      color: mainColor,
                                    ),
                                    child: Row(
                                      spacing: 10,
                                      children: [
                                        Text(
                                          "🎫 Change Password",
                                          style:
                                              fontStyleForScreenNameUsedInButtons,
                                        ),
                                        const Spacer(),
                                        GetX<MainScreenController>(
                                          builder: (controller) =>
                                              ClickableHoverText(
                                                onTap: () {
                                                  controller.changePassword();
                                                },
                                                text:
                                                    controller
                                                            .changingPassword
                                                            .value ==
                                                        false
                                                    ? 'Save'
                                                    : "•••",
                                              ),
                                        ),
                                        separator(),
                                        closeIcon(),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: SingleChildScrollView(
                                        child: GetBuilder<MainScreenController>(
                                          builder: (controller) {
                                            return Column(
                                              spacing: 20,
                                              children: [
                                                myTextFormFieldWithBorder(
                                                  labelText: 'Old Password',
                                                  controller:
                                                      controller.oldPass,
                                                ),
                                                myTextFormFieldWithBorder(
                                                  labelText: 'New Password',
                                                  controller:
                                                      controller.newPass,
                                                ),
                                                myTextFormFieldWithBorder(
                                                  labelText: 'Confirm Password',
                                                  controller:
                                                      controller.confirmPass,
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Change Password',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: logoutButtonStyle,
                      onPressed: () async {
                        dismiss();
                        alertDialog(
                          context: context,
                          content: "Are you sure you want to logout?",
                          onPressed: () async {
                            logout();
                          },
                        );
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
    maxWidth: 450,
    horizontalEdgeMargin: 12,
    verticalOffset: 8,
  );
}
