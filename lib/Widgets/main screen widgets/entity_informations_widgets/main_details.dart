import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/entity_informations_controller.dart';
import '../../../consts.dart';
import '../../my_text_field.dart';
import 'image_section.dart';

Widget mainDetails({required EntityInformationsController controller}) {
  return AnimatedContainer(
    height: 400,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
    child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    myTextFormField2(
                      icon: Icon(
                        Icons.person,
                        color: Colors.grey,
                      ),
                      obscureText: false,
                      controller: controller.contactName,
                      labelText: 'Name',
                      hintText: 'Enter Contact Name',
                      validate: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'What are you?      ',
                          style: TextStyle(fontSize: 25, color: Colors.black54),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            myBox(
                                title: 'Customer',
                                controller: controller,
                                onTap: () {
                                  // controller.selectCustomer();
                                },
                                type: controller.isCustomerSelected.value,
                                primaryColor: Colors.blue,
                                secondaryyColor: Colors.blue.shade200),
                            SizedBox(
                              width: 50,
                            ),
                            myBox(
                                title: 'Vendor',
                                controller: controller,
                                onTap: () {
                                  // controller.selectVendor();
                                },
                                type: controller.isVendorSelected.value,
                                primaryColor: Colors.blue,
                                secondaryyColor: Colors.blue.shade200),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                      child: Divider(
                        indent: 50,
                        endIndent: 50,
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Select your status',
                          style: TextStyle(fontSize: 25, color: Colors.black54),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            myBox(
                                title: 'Company',
                                primaryColor: Colors.red,
                                secondaryyColor: Colors.red.shade200,
                                controller: controller,
                                onTap: () {
                                  // controller
                                      // .selectCompantOrIndividual('company');
                                },
                                type: controller.isCompanySelected.value),
                            SizedBox(
                              width: 50,
                              child: Center(
                                child: Text(
                                  'Or',
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ),
                            ),
                            myBox(
                              title: 'Individual',
                              controller: controller,
                              onTap: () {
                                // controller
                                //     .selectCompantOrIndividual('individual');
                              },
                              type: controller.isIndividualSelected.value,
                              primaryColor: Colors.red,
                              secondaryyColor: Colors.red.shade200,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GetBuilder<EntityInformationsController>(
                    builder: (controller) {
                  return imageSection(controller);
                }),
              ),
            ],
          ),
        ),
        Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
                style: nextButtonStyle,
                onPressed: () {
                  controller.goToNextMenu();
                },
                child: const Text('Next')))
      ],
    ),
  );
}

InkWell myBox({
  required String title,
  required EntityInformationsController controller,
  required void Function()? onTap,
  required bool type,
  required Color primaryColor,
  required Color secondaryyColor,
}) {
  return InkWell(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: 60,
      width: 100,
      decoration: BoxDecoration(
          color: type == false ? Colors.white54 : secondaryyColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
              color: type == true ? primaryColor : Colors.grey, width: 2)),
      child: Stack(
        children: [
          Center(
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: type == false ? Colors.black54 : Colors.black),
            ),
          ),
          Positioned(
              top: 5,
              right: 5,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue)),
                child: Center(
                  child: type == true
                      ? Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blue),
                        )
                      : SizedBox(),
                ),
              ))
        ],
      ),
    ),
  );
}
