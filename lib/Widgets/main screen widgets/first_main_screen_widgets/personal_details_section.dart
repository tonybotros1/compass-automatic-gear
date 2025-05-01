  import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/main_screen_contro.dart';
import '../../../consts.dart';
import '../../../main.dart';
import '../../overlay_button.dart';

SmartInfoOverlay personalDetailsSection(BuildContext context,MainScreenController mainScreenController) {
    return SmartInfoOverlay(
      backgroundColor: Colors.blue.shade200,
      triggerBuilder: (showOverlay) => InkWell(
        onTap: showOverlay,
        child: CircleAvatar(
          backgroundColor: mainColor,
          radius: 25,
          child: Center(
            child: Text(
              mainScreenController
                  .getFirstCharacter(mainScreenController.userName.value),
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ),
      overlayContent: (dismiss) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(mainScreenController.userEmail.value,
              style: const TextStyle(color: Colors.white)),
          const SizedBox(
            height: 25,
          ),
          CircleAvatar(
            backgroundColor: mainColor,
            radius: 35,
            child: Text(
              mainScreenController
                  .getFirstCharacter(mainScreenController.userName.value),
              style: const TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
          FittedBox(
            child: Text(
              'Hi, ${mainScreenController.userName.value}!',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.blue.shade400,
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    mainScreenController.companyName.value,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      const Text(
                        'Joining Date:',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        textToDate(mainScreenController.userJoiningDate.value),
                        style: TextStyle(
                          color: Colors.grey.shade800,
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
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        textToDate(mainScreenController.userExpiryDate.value),
                        style: TextStyle(
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        style: logoutButtonStyle,
                        onPressed: () async {
                          dismiss();
                          alertDialog(
                              context: context,
                              content: "Are you sure you want to logout?",
                              onPressed: () async {
                                await globalPrefs?.remove('userId');
                                await globalPrefs?.remove('companyId');
                                await globalPrefs?.remove('userEmail');
                                Get.offAllNamed('/');
                              });
                        },
                        child: const Text('Logout')),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      maxWidth: 400,
      horizontalEdgeMargin: 12,
      verticalOffset: 8,
    );
  }