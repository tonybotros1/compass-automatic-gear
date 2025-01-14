import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts.dart';

class UsersController extends GetxController {
  late TextEditingController email = TextEditingController();
  late TextEditingController name = TextEditingController();
  late TextEditingController pass = TextEditingController();
  final FocusNode focusNode = FocusNode();
  RxBool obscureText = RxBool(true);
  RxBool sigupgInProcess = RxBool(false);
  var selectedDate = DateTime.now().obs;
  RxString theDate = RxString('');
  // RxList sysRoles = RxList([]);
  List<String> areaName = [];
  RxBool isLoading = RxBool(false);
  RxMap selectedRoles = RxMap({});
  RxBool isScreenLoding = RxBool(true);
  final RxList<DocumentSnapshot> allUsers = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredUsers = RxList<DocumentSnapshot>([]);
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool userStatus = RxBool(true);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);

  @override
  void onInit()  {
     getRoles();
     getAllUsers();
    // getUserStatus('OXugS6xlxhdk5mq48uPwpZilA672');
    search.value.addListener(() {
      filterCards();
    });
    super.onInit();
  }

// this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allUsers.sort((user1, user2) {
        final String? value1 = user1.get('user_name');
        final String? value2 = user2.get('user_name');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allUsers.sort((user1, user2) {
        final String? value1 = user1.get('email');
        final String? value2 = user2.get('email');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allUsers.sort((user1, user2) {
        final String? value1 = user1.get('added_date');
        final String? value2 = user2.get('added_date');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 3) {
      allUsers.sort((user1, user2) {
        final String? value1 = user1.get('expiry_date');
        final String? value2 = user2.get('expiry_date');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    }
    sortColumnIndex.value = columnIndex;
    isAscending.value = ascending;
  }

  int compareString(bool ascending, String value1, String value2) {
    int comparison = value1.compareTo(value2);
    return ascending ? comparison : -comparison; // Reverse if descending
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

// this function is to add new user
  // register() async {
  //   try {
  //     if (email.text.isEmpty || pass.text.isEmpty) {
  //       throw Exception('Please fill all fields');
  //     }
  //     sigupgInProcess.value = true;
  //     UserCredential userCredential =
  //         await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: email.text,
  //       password: pass.text,
  //     );
  //     User? user = userCredential.user;
  //     String? token;
  //     String? uid;
  //     if (user != null) {
  //       token = await FirebaseMessaging.instance.getToken();
  //       uid = user.uid;
  //     }
  //     FirebaseFirestore.instance.collection('sys-users').add({
  //       "user_name": name.text,
  //       "email": email.text,
  //       "user_id": uid,
  //       "users_tokens": [token],
  //       "expiry_date": '${selectedDate.value}',
  //       "roles": selectedRoles.entries
  //           .where((entry) => entry.value[1] == true)
  //           .map((entry) => entry.value[0])
  //           .toList(),
  //       "added_date": DateTime.now().toString(),
  //       "status": true
  //     });
  //     sigupgInProcess.value = false;
  //     showSnackBar('Done', 'New user added successfully');
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       sigupgInProcess.value = false;
  //       showSnackBar('warning', 'The password provided is too weak');
  //     } else if (e.code == 'email-already-in-use') {
  //       sigupgInProcess.value = false;

  //       showSnackBar('warning', 'The account already exists for that email');
  //     }
  //   } catch (e) {
  //     sigupgInProcess.value = false;
  //     showSnackBar('warning', e.toString());
  //   }
  // }

  register() async {
    try {
      if (name.text.isEmpty ||
          email.text.isEmpty ||
          pass.text.isEmpty ||
          selectedRoles.isEmpty) {
        showSnackBar('Note', 'Please fill all fields');

        throw Exception('Please fill all fields');
      }
      sigupgInProcess.value = true;

      // Hash the password using SHA-256
      var bytes = utf8.encode(pass.text); // Convert password to bytes
      var digest = sha256.convert(bytes); // Hash the password
      String hashedPassword = digest.toString();

      // Check if the email already exists in Firestore
      var userDataSnapshot = await FirebaseFirestore.instance
          .collection('sys-users')
          .where('email', isEqualTo: email.text) // Check for existing email
          .get();

      if (userDataSnapshot.docs.isNotEmpty) {
        sigupgInProcess.value = false;
        showSnackBar(
            'Email already in use', 'This email is already registered');
        return;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final companyId = prefs.getString('companyId');
      if (companyId == null || companyId.isEmpty) return;

      // Save the user details in Firestore with an auto-generated document ID
      await FirebaseFirestore.instance.collection('sys-users').add({
        "user_name": name.text,
        "email": email.text,
        "password": hashedPassword, // Store hashed password
        "roles": selectedRoles.entries
            .where((entry) => entry.value[1] == true)
            .map((entry) => entry.value[0])
            .toList(),
        "expiry_date": '${selectedDate.value}',
        "added_date": DateTime.now().toString(),
        "status": true,
        "company_id": companyId,
      });

      sigupgInProcess.value = false;
      Get.back();
      showSnackBar('Done', 'New user added successfully');
    } catch (e) {
      sigupgInProcess.value = false;
      showSnackBar('warning', e.toString());
    }
  }

  // this function is to update user details
  updateUserDetails(String userId) async {
    try {
      sigupgInProcess.value = true;
      // Prepare the update data
      Map<String, dynamic> updateData = {
        'roles': selectedRoles.entries
            .where((entry) =>
                entry.value is List &&
                entry.value[1] == true) // Check the role status
            .map((entry) => entry.value[0]) // Extract the role name
            .toList(),
        'expiry_date': '${selectedDate.value}',
        'status': userStatus.value,
        'user_name': name.text,
        'email': email.text,
      };

      // Add the hashed password only if pass.text is not empty
      if (pass.text.isNotEmpty) {
        // Hash the password
        var bytes = utf8.encode(pass.text); // Convert password to bytes
        var digest = sha256.convert(bytes); // Hash the password
        String hashedPassword = digest.toString();

        // Add the hashed password to the update data
        updateData['password'] = hashedPassword;
      }

      // Update the Firestore document
      await FirebaseFirestore.instance
          .collection('sys-users') // Replace with your collection name
          .doc(userId) // The document ID you want to update
          .update(updateData);

      sigupgInProcess.value = false;
      Get.back();

      // Success message
      showSnackBar('Success', 'User details updated successfully');
    } catch (e) {
      // Handle errors
      sigupgInProcess.value = false;

      showSnackBar('Error', 'Failed to update user details: $e');
    }
  }

// this function is to delete user from the DB
  deleteUser(userID) async {
    await FirebaseFirestore.instance
        .collection('sys-users')
        .doc(userID)
        .delete();
  }

  // this function is to get roles from DB
  getRoles() async {
    try {
      isLoading.value = true;
      // Fetch roles from the 'sys-roles' collection
      FirebaseFirestore.instance
          .collection('sys-roles')
          .where('is_shown_for_users', isEqualTo: true)
          .snapshots()
          .listen((roles) {
        for (var role in roles.docs) {
          selectedRoles.addAll({
            role.data()['role_name']: [role.id, false]
          });
        }
      });

      // // Map documents to a list of roles
      // var roles = rolesSnapshot.docs.map((doc) {
      //   return {
      //     ...doc.data(),
      //     'id': doc.id,
      //   };
      // }).toList();
      // // sysRoles.assignAll(roles);
      // for (var role in roles) {
      //   selectedRoles.addAll({
      //     role['role_name']: [role['id'], false]
      //   });
      // }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print('$e fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff');
      return [];
    }
  }

  // this function is to get all users in the system
  getAllUsers() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final companyId = prefs.getString('companyId');
      if (companyId == null || companyId.isEmpty) return;
      FirebaseFirestore.instance
          .collection('sys-users')
          .where('company_id', isEqualTo: companyId)
          .snapshots()
          .listen((event) {
        allUsers.assignAll(event.docs);
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
      //
    }
  }
}
