import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../Models/register_menu_model.dart';
import '../../Screens/Auth Screens/register_screen.dart';

class RegisterScreenController extends GetxController {
  RxInt selectedMenu = RxInt(0);
  TextEditingController companyName = TextEditingController();
  TextEditingController typeOfBusiness = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController city = TextEditingController();
  Uint8List? imageBytes;

  final menu = <RegisterMenuModel>[
    RegisterMenuModel(title: 'Company Details', isPressed: true),
    RegisterMenuModel(title: 'Contact Details', isPressed: false),
    RegisterMenuModel(title: 'Responsibilities', isPressed: false),
  ];

  pickImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imageBytes = await image.readAsBytes();
    }
    update();
  }

  selectFromLeftMenu(i) {
    selectedMenu.value = i;
    for (int index = 0; index < menu.length; index++) {
      menu[index].isPressed = (index == i);
    }
    update();
  }

  goToNextMenu() {
    selectedMenu.value += 1;
    selectFromLeftMenu(selectedMenu.value);
    update();
  }

  Widget buildRightContent(int index, constraints, controller) {
    switch (index) {
      case 0:
        return companyDetails(controller: controller);
      case 1:
        return contactDetails(controller: controller);
      case 2:
        return responsibilities(controller: controller);

      default:
        return const Text('4');
    }
  }
}
