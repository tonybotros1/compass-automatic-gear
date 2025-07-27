import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/main_screen_contro.dart';
import '../../../consts.dart';
import '../../../main.dart';
import '../../overlay_button.dart';

SmartInfoOverlay personalDetailsSection(
    BuildContext context, MainScreenController mainScreenController) {
  return SmartInfoOverlay(
    backgroundColor: Colors.blue.shade200,
    triggerBuilder: (showOverlay) => InkWell(
      onTap: showOverlay,
      child: CircleAvatar(
        backgroundColor: mainColor,
        radius: 25.r,
        child: Center(
          child: Text(
            mainScreenController
                .getFirstCharacter(mainScreenController.userName.value),
            style: TextStyle(fontSize: 20.sp, color: Colors.white),
          ),
        ),
      ),
    ),
    overlayContent: (dismiss) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(mainScreenController.userEmail.value,
            style: TextStyle(color: Colors.white, fontSize: 18.sp)),
        SizedBox(
          height: 25.h,
        ),
        CircleAvatar(
          backgroundColor: mainColor,
          radius: 35.r,
          child: Text(
            mainScreenController
                .getFirstCharacter(mainScreenController.userName.value),
            style: TextStyle(fontSize: 30.sp, color: Colors.white),
          ),
        ),
        FittedBox(
          child: Text(
            'Hi, ${mainScreenController.userName.value}!',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30.sp),
          ),
        ),
        SizedBox(
          height: 30.h,
        ),
        Container(
          padding: EdgeInsets.all(16.w),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.blue.shade400,
              borderRadius: BorderRadius.circular(15.r)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  mainScreenController.companyName.value,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Row(
                  children: [
                    Text(
                      'Joining Date:',
                      style: TextStyle(color: Colors.white, fontSize: 18.sp),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      textToDate(mainScreenController.userJoiningDate.value),
                      style: TextStyle(
                          color: Colors.grey.shade800, fontSize: 18.sp),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Row(
                  children: [
                    Text(
                      'Expiry Date:',
                      style: TextStyle(color: Colors.white, fontSize: 18.sp),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      textToDate(mainScreenController.userExpiryDate.value),
                      style: TextStyle(
                          color: Colors.grey.shade800, fontSize: 18.sp),
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
                      child: Text(
                        'Logout',
                        style: TextStyle(fontSize: 18.sp),
                      )),
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
