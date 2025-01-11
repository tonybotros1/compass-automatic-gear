import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  RxMap allRoles = RxMap({});
  RxList roleIDFromList = RxList([]);


  final menu = <RegisterMenuModel>[
    RegisterMenuModel(title: 'Company Details', isPressed: true),
    RegisterMenuModel(title: 'Contact Details', isPressed: false),
    RegisterMenuModel(title: 'Responsibilities', isPressed: false),
  ];

  @override
  void onInit() {
    getResponsibilities();

    super.onInit();
  }

  // this function is to remove a menu from the list
  removeMenuFromList(index) {
    roleIDFromList.removeAt(index);
  }

   String getRoleName(String menuID) {
    // Find the entry with the matching key
    final matchingEntry = allRoles.entries.firstWhere(
      (entry) => entry.key == menuID,
      orElse: () =>
          const MapEntry('', 'Unknown'), // Handle cases where no match is found
    );
    final menuName =
        matchingEntry.value.replaceAll(RegExp(r'\s*\(.*?\)'), '').trim();

    return menuName;
  }


// this function is to get Responsibilities
  getResponsibilities() async {
    var roles = await FirebaseFirestore.instance
        .collection('sys-roles')
        .where('is_shown_for_users', isEqualTo: true)
        .get();
    for (var role in roles.docs) {
      allRoles[role.id] =  role.data()['role_name'];
    }
  }

// this function is to select an image for logo
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

  Widget buildRightContent(int index, controller) {
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
