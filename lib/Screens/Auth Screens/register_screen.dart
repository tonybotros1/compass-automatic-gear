import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
          color: const Color(0xffEFF3EA), // Background color of the footer
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '© ${DateTime.now().year} DataHub AI. All rights reserved.',
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      leftSideMenu(),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(35, 30, 35, 30),
                          decoration: BoxDecoration(
                            color: const Color(0xffEFF3EA),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: GetBuilder<RegisterScreenController>(
                              builder: (controller) {
                            return controller.buildRightContent(
                                controller.selectedMenu.value,
                                controller,
                                constraints);
                          }),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }));
  }
}

Widget responsibilities({
  required RegisterScreenController controller,
}) {
  return AnimatedContainer(
    height: 230,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
    child: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: controller.formKeyForThirdMenu,
                child: dropDownValues(
                  listValues: controller.allRoles.values
                      .map((value) => value.toString())
                      .toList(),
                  onSelected: (suggestion) {
                    controller.allRoles.entries.where((entry) {
                      return entry.value == suggestion.toString();
                    }).forEach((entry) {
                      if (!controller.roleIDFromList.contains(entry.key)) {
                        controller.roleIDFromList.add(entry.key);
                      }
                    });
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion.toString()),
                    );
                  },
                  labelText: 'Responsibilities',
                  hintText: 'select responsibility ',
                  menus: controller.allRoles,
                  validate: true,
                ),
              ),
            ),
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
                  onPressed: () {
                    if (controller.roleIDFromList.isEmpty &&
                        !controller.formKeyForThirdMenu.currentState!
                            .validate()) {}
                    if (controller.userName.text.isNotEmpty &&
                        controller.companyName.text.isNotEmpty &&
                        controller.industry.text.isNotEmpty &&
                        controller.password.text.isNotEmpty &&
                        controller.phoneNumber.text.isNotEmpty &&
                        controller.email.text.isNotEmpty &&
                        controller.address.text.isNotEmpty &&
                        controller.country.text.isNotEmpty &&
                        controller.city.text.isNotEmpty &&
                        controller.imageBytes!.isNotEmpty) {
                      controller.update();

                      controller.addNewCompany();
                    } else {
                      showSnackBar('Note', 'Please fill all fields');
                    }
                  },
                  child: controller.addingProcess.value == false
                      ? const Text('Save')
                      : const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                ),
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

Widget contactDetails({
  required RegisterScreenController controller,
}) {
  return AnimatedContainer(
    height: 320,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
    child: Stack(
      children: [
        Form(
          key: controller.formKeyForSecondMenu,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 2.5),
                      child: myTextFormFieldWithBorder(
                        labelText: 'Name',
                        hintText: 'Enter your name here',
                        controller: controller.userName,
                        validate: true,
                        obscureText: false,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 2.5),
                      child: myTextFormFieldWithBorder(
                        labelText: 'Phone Number',
                        hintText: 'Enter your phone number here',
                        controller: controller.phoneNumber,
                        validate: true,
                        obscureText: false,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 2.5),
                      child: myTextFormFieldWithBorder(
                        labelText: 'Email',
                        hintText: 'Enter a valid email here',
                        controller: controller.email,
                        validate: true,
                        obscureText: false,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 2.5),
                        child: myTextFormFieldWithBorder(
                            labelText: 'Password',
                            hintText: 'Enter your password here',
                            controller: controller.password,
                            validate: true,
                            obscureText: controller.obscureText.value,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  controller.changeObscureTextValue();
                                },
                                icon: Icon(controller.obscureText.value
                                    ? Icons.remove_red_eye_outlined
                                    : Icons.visibility_off)))),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 2.5),
                child: myTextFormFieldWithBorder(
                  labelText: 'Address',
                  hintText: 'Enter your company address',
                  controller: controller.address,
                  validate: true,
                  obscureText: false,
                ),
              ),
              GetBuilder<RegisterScreenController>(builder: (controller) {
                return Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 2.5),
                        child: dropDownValues(
                          listValues: controller.allCountries.values
                              .map((value) => value['name'].toString())
                              .toList(),
                          textController: controller.country,
                          labelText: 'Country',
                          hintText: 'Select Country',
                          menus: controller.allCountries,
                          validate: true,
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text('${suggestion['name']}'),
                            );
                          },
                          onSelected: (suggestion) {
                            controller.country.text = suggestion['name'];
                            controller.allCountries.entries.where((entry) {
                              return entry.value['name'] ==
                                  suggestion['name'].toString();
                            }).forEach(
                              (entry) {
                                // controller.onSelect(entry.key);
                                controller.getCitiesByCountryID(entry.key);
                                controller.selectedCountryId.value = entry.key;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 2.5),
                        child: dropDownValues(
                            listValues: controller.allCities.values
                                .map((value) => value['name'].toString())
                                .toList(),
                            suggestionsController: SuggestionsController(),
                            onTapForTypeAheadField:
                                SuggestionsController().refresh,
                            textController: controller.city,
                            labelText: 'City',
                            hintText: 'Select City',
                            menus: controller.allCities.isEmpty
                                ? {}
                                : controller.allCities,
                            validate: true,
                            itemBuilder: (context, suggestion) {
                              return ListTile(
                                title: Text('${suggestion['name']}'),
                              );
                            },
                            onSelected: (suggestion) {
                              controller.city.text = suggestion['name'];
                              controller.allCities.entries
                                  .where((entry) {
                                return entry.value['name'] ==
                                    suggestion['name'].toString();
                              }).forEach((entry) {
                                controller.selectedCityId.value = entry.key;
                              });
                            }),
                      ),
                    ),
                  ],
                );
              })
            ],
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            child: Row(
              children: [
                ElevatedButton(
                    style: nextButtonStyle,
                    onPressed: () {
                      if (!controller.formKeyForSecondMenu.currentState!
                          .validate()) {
                      } else {
                        controller.goToNextMenu();
                      }
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

Widget companyDetails({required RegisterScreenController controller}) {
  return AnimatedContainer(
    height: 230,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
    child: Stack(
      children: [
        Form(
          key: controller.formKeyForFirstMenu,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: myTextFormFieldWithBorder(
                        labelText: 'Company Name',
                        hintText: 'Enter your company name here',
                        controller: controller.companyName,
                        validate: true,
                        obscureText: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: dropDownValues(
                        listValues: controller.industryMap.values
                            .map((value) => value['name'].toString())
                            .toList(),
                        textController: controller.industry,
                        labelText: 'Industry',
                        hintText: 'Enter industry',
                        validate: true,
                        menus: controller.industryMap.isNotEmpty
                            ? controller.industryMap
                            : {},
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text('${suggestion['name']}'),
                          );
                        },
                        onSelected: (suggestion) {
                          controller.industry.text = '${suggestion['name']}';
                          controller.industryMap.entries.where((entry) {
                            return entry.value['name'] ==
                                suggestion['name'].toString();
                          }).forEach((entry) {
                            controller.industryID.value = entry.key;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: InkWell(
                    onTap: () {
                      controller.pickImage();
                    },
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              style: BorderStyle.solid,
                              color: controller.warningForImage.value == false
                                  ? Colors.grey
                                  : Colors.red)),
                      child: controller.imageBytes == null
                          ? const Center(
                              child: FittedBox(
                                  child: Icon(
                                Icons.image,
                                color: Colors.grey,
                                size: 30,
                              )),
                            )
                          : Image.memory(controller.imageBytes!,
                              fit: BoxFit.fitHeight),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            child: Row(
              children: [
                ElevatedButton(
                    style: nextButtonStyle,
                    onPressed: () {
                      if (!controller.formKeyForFirstMenu.currentState!
                              .validate() ||
                          controller.imageBytes == null ||
                          controller.imageBytes!.isEmpty) {
                        // Handle the validation or warning
                        if (!controller.formKeyForFirstMenu.currentState!
                            .validate()) {
                          // Optionally add specific handling for form validation failure
                        }
                        if (controller.imageBytes == null ||
                            controller.imageBytes!.isEmpty) {
                          controller.warningForImage.value = true;
                          controller.update();
                        }
                      } else {
                        controller.warningForImage.value = false;
                        controller.update();
                        controller.goToNextMenu();
                      }
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
          height: 380,
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
