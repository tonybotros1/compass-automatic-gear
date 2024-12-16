import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RegisterController extends GetxController {
  late TextEditingController email = TextEditingController();
  late TextEditingController pass = TextEditingController();
  final FocusNode focusNode = FocusNode();
  RxBool obscureText = RxBool(true);
  RxBool sigupgInProcess = RxBool(false);
  var selectedDate = DateTime.now().obs;
  RxString theDate = RxString('');
  RxList sysRoles = RxList([]);
  List<String> areaName = [];
  RxList<bool> isSelected = RxList([]);
  RxBool isLoading = RxBool(false);
  RxList selectedRoles = RxList([]);
  final RxList<DocumentSnapshot> allUsers = RxList<DocumentSnapshot>([]);

  @override
  void onInit() async {
    await getRoles();
    await getAllUsers();
    super.onInit();
  }

  // Function to format the date
  String formatDate(DateTime date) {
    final formatter = DateFormat('yyyy-MM-dd');
    theDate.value = formatter.format(date);
    return formatter.format(date);
  }

  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  Future<void> selectDateContext(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate.value) {
      selectDate(picked);
    }
  }

  void changeObscureTextValue() {
    if (obscureText.value == true) {
      obscureText.value = false;
    } else {
      obscureText.value = true;
    }
  }

  // this function is to show a snackbae with the state of the login process:
  void showSnackBar(title, body) {
    Get.snackbar(
      title,
      body,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.grey,
      colorText: Colors.white,
    );
  }

  register() async {
    try {
      if (email.text.isEmpty || pass.text.isEmpty) {
        throw Exception('Please fill all fields');
      }
      sigupgInProcess.value = true;
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: pass.text,
      );
      User? user = userCredential.user;
      String? token;
      String? uid;
      if (user != null) {
        token = await FirebaseMessaging.instance.getToken();
        uid = user.uid;
      }
      FirebaseFirestore.instance.collection('sys-users').add({
        "email": email.text,
        "user_id": uid,
        "users_tokens": [token],
        "expiry_date": '${selectedDate.value}',
        "roles": selectedRoles,
        "added_date": DateTime.now().toString()
      });
      sigupgInProcess.value = false;
      showSnackBar('Done', 'New user added successfully');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        sigupgInProcess.value = false;
        showSnackBar('warning', 'The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        sigupgInProcess.value = false;

        showSnackBar('warning', 'The account already exists for that email');
      }
    } catch (e) {
      showSnackBar('warning', e.toString());
    }
  }

  // this function is to get roles from DB
  getRoles() async {
    try {
      isLoading.value = true;
      // Fetch roles from the 'sys-roles' collection
      var rolesSnapshot =
          await FirebaseFirestore.instance.collection('sys-roles').get();

      // Map documents to a list of roles
      var roles = rolesSnapshot.docs.map((doc) {
        return {
          ...doc.data(), // Document data (e.g., name, description)
        };
      }).toList();
      sysRoles.assignAll(roles);
      isLoading.value = false;
    } catch (e) {
      return [];
    }
  }

  // this function is to get all users in the system
  getAllUsers() {
    FirebaseFirestore.instance
        .collection('sys-users')
        .snapshots()
        .listen((event) {
      allUsers.assignAll(event.docs);
    });
  }
}
