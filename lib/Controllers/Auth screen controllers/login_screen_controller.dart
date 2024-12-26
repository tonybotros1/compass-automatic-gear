import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreenController extends GetxController {
  late TextEditingController email = TextEditingController();
  late TextEditingController pass = TextEditingController();
  final FocusNode focusNode = FocusNode(); // To keep track of focus

  late String currentUserToken = '';
  late String userId;
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

  // this function to save the token for the user device in DB:
  saveToken(userId) async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('sys-users')
          .where('user_id', isEqualTo: userId)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        // Get the document ID of the first document (assuming there's only one match)
        String documentId = userSnapshot.docs.first.id;
        // print('Document ID: $documentId');
        var userData = userSnapshot.docs.first.data() as Map<String, dynamic>;
        var tokens = userData['users_tokens'];

        currentUserToken = (await FirebaseMessaging.instance.getToken())!;

        if (!tokens.contains(currentUserToken)) {
          tokens.add(currentUserToken);
          FirebaseFirestore.instance
              .collection('sys-users')
              .doc(documentId)
              .update({'users_tokens': tokens});
        }
      }
    } catch (e) {
      sigingInProcess.value = false;
    }
  }

  saveTokenInSharedPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('deviceToken', currentUserToken);
    await prefs.setString('userId', userId);
    // final String? action = prefs.getString('devideToken');
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
  void singIn() async {
    try {
      sigingInProcess.value = true;

      var userDataSnapshot = await FirebaseFirestore.instance
          .collection('sys-users')
          .where('email', isEqualTo: email.text)
          .get();
      List userData = userDataSnapshot.docs.map((doc) {
        return {...doc.data()};
      }).toList();

      var isExpire = userData[0]['expiry_date'];
      if (isDateTodayOrOlder(isExpire)) {
        showSnackBar('Login failed', 'Your session has been expired');
        sigingInProcess.value = false;
      } else {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text,
          password: pass.text,
        );
        User? user = userCredential.user;

        // Get the user ID
        userId = user!.uid;
        await saveToken(userId);
        await saveTokenInSharedPref();
        sigingInProcess.value = false;
        showSnackBar('Login Success', 'Welcome');
        Get.offAllNamed('/mainScreen');
        sigingInProcess.value = false;
      }
    } on FirebaseAuthException catch (e) {
      sigingInProcess.value = false;

      if (e.code == 'invalid-email') {
        showSnackBar('Wrong Email', 'This Email is not registed');
      } else if (e.code == 'invalid-credential') {
        showSnackBar('Wrong Email or Password',
            'Please recheck your Email and Password then try again');
      } else {
        showSnackBar('Unexpected Error', 'Please try again');
      }
    }
  }
}
