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
                        InkWell(
                          onTap: () {
                            controller.selectCustomer();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            height: 100,
                            width: 180,
                            decoration: BoxDecoration(
                                color: controller.isCustomerSelected.isFalse
                                    ? Colors.white54
                                    : Colors.blue[200],
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: controller.isCustomerSelected.isTrue
                                        ? Colors.blue
                                        : Colors.grey,
                                    width: 2)),
                            child: Stack(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.asset(
                                      'assets/customer.png',
                                      width: 70,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Customer',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        Text('.................')
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: Colors.blue)),
                                      child: Center(
                                        child:
                                            controller.isCustomerSelected.isTrue
                                                ? Container(
                                                    width: 10,
                                                    height: 10,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.blue),
                                                  )
                                                : SizedBox(),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            controller.selectVendor();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            height: 100,
                            width: 180,
                            decoration: BoxDecoration(
                                color: controller.isVendorSelected.isFalse
                                    ? Colors.white54
                                    : Colors.blue[200],
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: controller.isVendorSelected.isTrue
                                        ? Colors.blue
                                        : Colors.grey,
                                    width: 2)),
                            child: Stack(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.asset(
                                      'assets/vendor.png',
                                      width: 70,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Vendor',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        Text('.................')
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: Colors.blue)),
                                      child: Center(
                                        child:
                                            controller.isVendorSelected.isTrue
                                                ? Container(
                                                    width: 10,
                                                    height: 10,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.blue),
                                                  )
                                                : SizedBox(),
                                      ),
                                    ))
                              ],
                            ),
                          ),
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
                        Container(
                          height: 50,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: Colors.red.shade200, width: 2)),
                          child: Row(
                            children: [
                              CupertinoCheckbox(
                                  value: controller.isCompanySelected.value,
                                  onChanged: (value) {
                                    controller
                                        .selectCompantOrIndividual('company');
                                  }),
                              Text(
                                'Company',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: Colors.purple.shade200, width: 2)),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CupertinoCheckbox(
                                  value: controller.isIndividualSelected.value,
                                  onChanged: (value) {
                                    controller.selectCompantOrIndividual(
                                        'individual');
                                  }),
                              Text(
                                'Individual',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              ),
                            ],
                          ),
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
                  if (controller.isCompanySelected.isTrue) {
                    controller.goToNextMenu();
                  }
                  if (controller.isIndividualSelected.isTrue) {
                    controller.goToNextMenu();
                  }
                },
                child: const Text('Next')))
      ],
    ),
  );
}
