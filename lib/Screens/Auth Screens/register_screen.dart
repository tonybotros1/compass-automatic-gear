import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Controllers/Auth screen controllers/register_screen_controller.dart';
import '../../Widgets/main screen widgets/drop_down_menu.dart';
import '../../Widgets/my_text_field.dart';
import '../../consts.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          color: Colors.grey[200], // Background color of the footer
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '© ${DateTime.now().year} Compass Automatic Gear. All rights reserved.',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                    width: constraints.maxWidth / 2,
                    // height: constraints.maxHeight / 4,
                    child: FittedBox(
                      child: Text(
                        'It only takes 2 minutes',
                        style: GoogleFonts.nunito(color: Colors.grey.shade500),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      leftSideMenu(),
                      const SizedBox(
                        width: 10,
                      ),
                      rightSide(constraints)
                    ],
                  ),
                )
              ],
            ),
          );
        }));
  }

  Expanded rightSide(BoxConstraints constraints) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(35, 30, 35, 30),
        decoration: BoxDecoration(
          color: const Color(0xffEFF3EA),
          borderRadius: BorderRadius.circular(5),
        ),
        child: GetBuilder<RegisterScreenController>(builder: (controller) {
          return controller.buildRightContent(
            controller.selectedMenu.value,
            constraints,
          );
        }),
      ),
    );
  }
}

Widget responsibilities({
  required controller,
}) {
  return AnimatedContainer(
    height: 300,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
    child: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            dropDownValues(
                labelText: 'Responsibilities',
                hintText: 'select responsibility ',
                menus: controller.allRoles,
                validate: true,
                ids: controller.roleIDFromList),
            ListView(
              shrinkWrap: true,
              children: [
                GetX<RegisterScreenController>(builder: (controller) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                      spacing: 10, // Horizontal spacing between items
                      runSpacing: 10, // Vertical spacing between rows
                      children:
                          List.generate(controller.roleIDFromList.length, (i) {
                        return Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color(0xffA6AEBF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                controller
                                    .getRoleName(controller.roleIDFromList[i]),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  controller.removeMenuFromList(i);
                                },
                                child: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
        Positioned(
            bottom: 0,
            left: 0,
            child: Row(
              children: [
                ElevatedButton(
                    style: saveButtonStyle,
                    onPressed: () {},
                    child: const Text('Save')),
                const SizedBox(width: 10),
                ElevatedButton(
                    style: cancelButtonStyle,
                    onPressed: () {},
                    child: const Text('Cancel')),
              ],
            ))
      ],
    ),
  );
}

Widget contactDetails({
  required controller,
}) {
  return AnimatedContainer(
    height: 300,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
    child: Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: myTextFormField2(
                labelText: 'Name',
                hintText: 'Enter your name here',
                controller: controller.userName,
                validate: true,
                obscureText: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: myTextFormField2(
                labelText: 'Phone Number',
                hintText: 'Enter your phone number here',
                controller: controller.phoneNumber,
                validate: true,
                obscureText: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: myTextFormField2(
                labelText: 'Email',
                hintText: 'Enter a valid email here',
                controller: controller.email,
                validate: true,
                obscureText: false,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: myTextFormField2(
                      labelText: 'Address',
                      hintText: 'Enter your company address',
                      controller: controller.address,
                      validate: true,
                      obscureText: false,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: myTextFormField2(
                      labelText: 'City',
                      hintText: 'Enter your city',
                      controller: controller.city,
                      validate: true,
                      obscureText: false,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: myTextFormField2(
                      labelText: 'Country',
                      hintText: 'Enter your country',
                      controller: controller.country,
                      validate: true,
                      obscureText: false,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Positioned(
            bottom: 0,
            left: 0,
            child: Row(
              children: [
                ElevatedButton(
                    style: nextButtonStyle,
                    onPressed: () {
                      controller.goToNextMenu();
                    },
                    child: const Text('Next')),
                const SizedBox(width: 10),
                ElevatedButton(
                    style: cancelButtonStyle,
                    onPressed: () {
                      Get.offAllNamed('/');
                    },
                    child: const Text('Cancel')),
              ],
            ))
      ],
    ),
  );
}

Widget companyDetails({
  required controller,
}) {
  return AnimatedContainer(
    height: 300,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
    child: Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: myTextFormField2(
                labelText: 'Company Name',
                hintText: 'Enter your company name here',
                controller: controller.companyName,
                validate: true,
                obscureText: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: myTextFormField2(
                labelText: 'Type Of Business',
                hintText: 'Enter type of business',
                controller: controller.typeOfBusiness,
                validate: true,
                obscureText: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                      style: selectButtonStyle,
                      onPressed: () {
                        controller.pickImage();
                      },
                      child: const Text('Select Logo')),
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            style: BorderStyle.solid, color: Colors.grey)),
                    child: controller.imageBytes == null
                        ? const Center(
                            child: FittedBox(
                                child: Text(
                              'No image selected',
                              style: TextStyle(color: Colors.grey),
                            )),
                          )
                        : Image.memory(controller.imageBytes,
                            fit: BoxFit.cover),
                  )
                ],
              ),
            ),
          ],
        ),
        Positioned(
            bottom: 0,
            left: 0,
            child: Row(
              children: [
                ElevatedButton(
                    style: nextButtonStyle,
                    onPressed: () {
                      controller.goToNextMenu();
                    },
                    child: const Text('Next')),
                const SizedBox(width: 10),
                ElevatedButton(
                    style: cancelButtonStyle,
                    onPressed: () {
                      Get.offAllNamed('/');
                    },
                    child: const Text('Cancel')),
              ],
            ))
      ],
    ),
  );
}

Widget leftSideMenu() {
  return GetBuilder<RegisterScreenController>(
      init: RegisterScreenController(),
      builder: (controller) {
        return Container(
          width: 320,
          height: 360,
          padding: const EdgeInsets.fromLTRB(35, 30, 0, 30),
          decoration: BoxDecoration(
            color: const Color(0xffEFF3EA),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: controller.menu.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    controller.selectFromLeftMenu(i);
                  },
                  child: Row(
                    children: [
                      Text(
                        '${i + 1}',
                        style: TextStyle(
                          color: controller.menu[i].isPressed == false
                              ? Colors.grey.shade700
                              : Colors.blue,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width: 2,
                          height:
                              controller.menu[i].isPressed == true ? 100 : 70,
                          color: controller.menu[i].isPressed == false
                              ? Colors.grey.shade300
                              : Colors.blue,
                        ),
                      ),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        style: TextStyle(
                          color: controller.menu[i].isPressed == false
                              ? Colors.grey.shade700
                              : Colors.blue,
                          fontSize: controller.menu[i].isPressed == true
                              ? 18
                              : 16, // Font size change
                          fontWeight: controller.menu[i].isPressed == true
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        child: FittedBox(child: Text(controller.menu[i].title)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      });
}
