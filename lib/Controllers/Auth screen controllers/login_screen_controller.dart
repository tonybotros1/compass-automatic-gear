import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import '../../consts.dart'; // For password hashing

class LoginScreenController extends GetxController {
  late TextEditingController email = TextEditingController();
  late TextEditingController pass = TextEditingController();
  final FocusNode focusNode = FocusNode(); // To keep track of focus
  final GlobalKey<FormState> formKeyForlogin = GlobalKey<FormState>();

  late String currentUserToken = '';
  RxBool obscureText = RxBool(true);
  RxBool sigingInProcess = RxBool(false);

  var width = Get.width;
  var height = Get.height;

  var isPermissionGranted = false.obs; // حالة الإذن

// this function is to change the obscureText value:
  void changeObscureTextValue() {
    if (obscureText.value == true) {
      obscureText.value = false;
    } else {
      obscureText.value = true;
    }
  }

  saveUserIdAndCompanyIdInSharedPref(userId, companyId, userEmail) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('companyId', companyId);
    await prefs.setString('userEmail', userEmail);
  }

// this functon is to check if the date of the user has been expired or not
  bool isDateTodayOrOlder(String selectedDate) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd"); // Fix typo in year format
    DateTime dateTime = dateFormat.parse(selectedDate);

    final DateTime today = DateTime.now();
    final DateTime todayOnly = DateTime(today.year, today.month, today.day);

    // Compare if the selected date is before or equal to today
    return dateTime.isBefore(todayOnly) || dateTime.isAtSameMomentAs(todayOnly);
  }

// this function is to sigin in
  // void singIn() async {
  //   try {
  //     sigingInProcess.value = true;

  //     var userDataSnapshot = await FirebaseFirestore.instance
  //         .collection('sys-users')
  //         .where('email', isEqualTo: email.text)
  //         .get();
  //     List userData = userDataSnapshot.docs.map((doc) {
  //       return {...doc.data()};
  //     }).toList();

  //     var isExpire = userData[0]['expiry_date'];
  //     var userActiveStatus = userData[0]['status'];
  //     if (userActiveStatus == false || isDateTodayOrOlder(isExpire)) {
  //       showSnackBar('Login failed', 'Your session has been expired');
  //       sigingInProcess.value = false;
  //     } else {
  //       UserCredential userCredential =
  //           await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: email.text,
  //         password: pass.text,
  //       );
  //       User? user = userCredential.user;

  //       // Get the user ID
  //       userId = user!.uid;
  //       await saveToken(userId);
  //       await saveTokenInSharedPref();
  //       sigingInProcess.value = false;
  //       showSnackBar('Login Success', 'Welcome');
  //       Get.offAllNamed('/mainScreen');
  //       sigingInProcess.value = false;
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     sigingInProcess.value = false;

  //     if (e.code == 'invalid-email') {
  //       showSnackBar('Wrong Email', 'This Email is not registed');
  //     } else if (e.code == 'invalid-credential') {
  //       showSnackBar('Wrong Email or Password',
  //           'Please recheck your Email and Password then try again');
  //     } else {
  //       showSnackBar('Unexpected Error', 'Please try again');
  //     }
  //   }
  // }
  singIn() async {
    try {
      sigingInProcess.value = true;

      // Fetch user data from Firestore by email
      var userDataSnapshot = await FirebaseFirestore.instance
          .collection('sys-users')
          .where('email', isEqualTo: email.text) // Search by email
          .get();

      // Check if the email exists
      if (userDataSnapshot.docs.isEmpty) {
        sigingInProcess.value = false;
        showSnackBar('Login failed', 'This email is not registered');
        return;
      }
      // check for company status
      var userData = userDataSnapshot.docs.first.data();
      var companyId = userData['company_id'];
      var company = await FirebaseFirestore.instance
          .collection('companies')
          .doc(companyId)
          .get();

      if (!company.exists) {
        sigingInProcess.value = false;

        showSnackBar('Login failed', 'No company found');
        return;
      }
      bool companyStatus = company.data()!['status'];

      if (companyStatus == false) {
        sigingInProcess.value = false;

        showSnackBar('Login failed', 'Your session has been expired');
        return;
      }

      var storedHashedPassword = userData['password']; // Stored hashed password
      var isExpire = userData['expiry_date'];
      var userActiveStatus = userData['status'];

      // Check if the user's session has expired or if the account is inactive
      if (userActiveStatus == false || isDateTodayOrOlder(isExpire)) {
        sigingInProcess.value = false;
        showSnackBar('Login failed', 'Your session has expired');
        return;
      }

      // Hash the entered password
      var bytes = utf8.encode(pass.text); // Convert entered password to bytes
      var digest = sha256.convert(bytes); // Hash the entered password
      String hashedPassword = digest.toString();

      // Compare the entered hashed password with the stored password hash
      if (hashedPassword == storedHashedPassword) {
        // Password is correct, proceed with login
        // await saveToken(userId);
        await saveUserIdAndCompanyIdInSharedPref(
            userDataSnapshot.docs.first.id,
            userDataSnapshot.docs.first.data()['company_id'],
            userDataSnapshot.docs.first.data()['email']);

        sigingInProcess.value = false;
        showSnackBar('Login Success', 'Welcome');
        Get.offAllNamed('/mainScreen');
      } else {
        sigingInProcess.value = false;
        showSnackBar(
            'Wrong Email or Password', 'Please recheck your credentials');
      }
    } catch (e) {
      sigingInProcess.value = false;
      showSnackBar('Unexpected Error', 'Please try again');
    }
  }

  // Log out and clear user session
  Future<void> logOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId'); // Clear userId
    Get.offAllNamed('/loginScreen'); // Navigate to login screen
  }
}
