import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
  void onInit() async {
    await getRoles();
    await getAllUsers();
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
        final String? value1 = user1.get('email');
        final String? value2 = user2.get('email');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allUsers.sort((user1, user2) {
        final String? value1 = user1.get('added_date');
        final String? value2 = user2.get('added_date');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
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
        "user_name": name.text,
        "email": email.text,
        "user_id": uid,
        "users_tokens": [token],
        "expiry_date": '${selectedDate.value}',
        "roles": selectedRoles.entries
            .where((entry) => entry.value[1] == true)
            .map((entry) => entry.value[0])
            .toList(),
        "added_date": DateTime.now().toString(),
        "status": true
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
      sigupgInProcess.value = false;
      showSnackBar('warning', e.toString());
    }
  }

  // this function is to update user details
  updateUserDetails(userId) async {
    try {
      var updatedRoles = selectedRoles.entries
          .where((entry) =>
              entry.value is List &&
              entry.value[1] == true) // Check if the second element is true
          .map((entry) => entry.value[0]) // Extract the ID (first element)
          .toList();
      // Reference the document by its ID
      await FirebaseFirestore.instance
          .collection('sys-users') // Replace with your collection name
          .doc(userId) // The document ID you want to update
          .update({
        'roles': updatedRoles,
        'expiry_date': '${selectedDate.value}',
        'status': userStatus.value,
        'user_name': name.text,
      }); // Pass the updated data as a map
    } catch (e) {
//
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
          ...doc.data(),
          'id': doc.id,
        };
      }).toList();
      // sysRoles.assignAll(roles);
      for (var role in roles) {
        selectedRoles.addAll({
          role['role_name']: [role['id'], false]
        });
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;

      return [];
    }
  }

  // this function is to get all users in the system
  getAllUsers() {
    try {
      FirebaseFirestore.instance
          .collection('sys-users')
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
