import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding/decoding

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
  RxBool isLoading = RxBool(false);
  RxMap selectedRoles = RxMap({});
  RxBool isScreenLoding = RxBool(true);
  final RxList<DocumentSnapshot> allUsers = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredUsers = RxList<DocumentSnapshot>([]);
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;

  // value = true:
  // For dates: From the most recent to the oldest.
  // For numbers: From the highest to the lowest.
  // For strings: In reverse alphabetical order (Z to A).
  //
  // value = false:
  // For dates: From the oldest to the most recent.
  // For numbers: From the lowest to the highest.
  // For strings: In alphabetical order (A to Z).
  RxBool sortByEmailType = RxBool(false);
  RxBool sortByAddedDateType = RxBool(false);
  RxBool sortByExpiryDateType = RxBool(false);

  @override
  void onInit() async {
    await getRoles();
    await getAllUsers('');
    // getUserStatus('OXugS6xlxhdk5mq48uPwpZilA672');
    search.value.addListener(() {
      filterCards();
    });
    super.onInit();
  }

  // this function is to filter the search results for web
  void filterCards() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredUsers.clear();
    } else {
      filteredUsers.assignAll(
        allUsers.where((user) {
          return user['email'].toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
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

  // function to convert text to date and make the format dd-mm-yyyy
  textToDate(inputDate) {
    if (inputDate is String) {
      DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(inputDate);
      String formattedDate = DateFormat("dd-MM-yyyy").format(parsedDate);

      return formattedDate;
    } else if (inputDate is DateTime) {
      String formattedDate = DateFormat("dd-MM-yyyy").format(inputDate);

      return formattedDate;
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

// this function is to add new user
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
        "roles": selectedRoles.entries
            .where((entry) => entry.value == true)
            .map((entry) => entry.key),
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

  // this function is to update user details
  updateUserDetails(userId) async {
    try {
      // Reference the document by its ID
      await FirebaseFirestore.instance
          .collection('sys-users') // Replace with your collection name
          .doc(userId) // The document ID you want to update
          .update({
        'roles': selectedRoles.entries
            .where((entry) => entry.value == true)
            .map((entry) => entry.key),
        'expiry_date': '${selectedDate.value}'
      }); // Pass the updated data as a map

      print('Document updated successfully.');
    } catch (e) {
      print('Error updating document: $e');
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
      for (var role in roles) {
        selectedRoles.addAll({role['role_name']: false});
      }

      isLoading.value = false;
    } catch (e) {
      return [];
    }
  }

  // this function is to get all users in the system
  getAllUsers(sortBy) {
    if (sortBy == 'email') {
      try {
        sortByAddedDateType.value = false;
        sortByExpiryDateType.value = false;
        FirebaseFirestore.instance
            .collection('sys-users')
            .orderBy(sortBy, descending: sortByEmailType.value)
            .snapshots()
            .listen((event) {
          allUsers.assignAll(event.docs);
        });
        isScreenLoding.value = false;
      } catch (e) {
        //
      }
    } else if (sortBy == 'added_date') {
      try {
        sortByEmailType.value = false;
        sortByExpiryDateType.value = false;
        FirebaseFirestore.instance
            .collection('sys-users')
            .orderBy(sortBy, descending: sortByAddedDateType.value)
            .snapshots()
            .listen((event) {
          allUsers.assignAll(event.docs);
        });
        isScreenLoding.value = false;
      } catch (e) {
        //
      }
    } else if (sortBy == 'expiry_date') {
      try {
        sortByEmailType.value = false;
        sortByAddedDateType.value = false;
        FirebaseFirestore.instance
            .collection('sys-users')
            .orderBy(sortBy, descending: sortByExpiryDateType.value)
            .snapshots()
            .listen((event) {
          allUsers.assignAll(event.docs);
        });
        isScreenLoding.value = false;
      } catch (e) {
        //
      }
    } else {
      try {
        sortByEmailType.value = false;
        sortByAddedDateType.value = false;
        sortByExpiryDateType.value = false;

        FirebaseFirestore.instance
            .collection('sys-users')
            .snapshots()
            .listen((event) {
          allUsers.assignAll(event.docs);
        });
        isScreenLoding.value = false;
      } catch (e) {
        //
      }
    }
  }

  // get user status
  Future<void> getUserStatus(uid) async {
    var flaskUrl = Uri.parse('http://127.0.0.1:5000/getUserData');
    try {
      // Prepare the request headers and body
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json"
      };
      final body = jsonEncode({'uid': uid});

      var response = await http.post(
        flaskUrl,
        headers: headers,
        body: body,
      );
      print(response.statusCode);

      // Handle the response
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('User Status: ${data['status']}'); // Output the user status
      } else {
        final error = jsonDecode(response.body);
        print('Error: ${error['error']}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }
}
