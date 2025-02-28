import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahubai/main.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  // Wrapper to handle async logic.
  void _initialize() async {
    await checkLogStatus();
  }

  bool isDateTodayOrOlder(String selectedDate) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd"); // Fix typo in year format
    DateTime dateTime = dateFormat.parse(selectedDate);

    final DateTime today = DateTime.now();
    final DateTime todayOnly = DateTime(today.year, today.month, today.day);

    // Compare if the selected date is before or equal to today
    return dateTime.isBefore(todayOnly) || dateTime.isAtSameMomentAs(todayOnly);
  }

  Future<bool> checkForExpiryDate(userId) async {
    try {
      var user = await FirebaseFirestore.instance
          .collection('sys-users')
          .doc(userId)
          .get();
      if (user.exists) {
        return !isDateTodayOrOlder(user.data()!['expiry_date']);
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

// this function is to know if the user logedin or not
  Future<void> checkLogStatus() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String? userId = prefs.getString('userId');
      if (userId == null || userId.isEmpty) {
        // Navigate to login screen if not logged in.
        Get.offAllNamed('/loginScreen');
      } else {
        checkForExpiryDate(userId).then((value) async {
          if (value) {
            Get.offAllNamed('/mainScreen');
          } else {
            await globalPrefs?.remove('userId');
            await globalPrefs?.remove('companyId');
            await globalPrefs?.remove('userEmail');
            Get.offAllNamed('/loginScreen');
          }
        });
      }
    } catch (e) {
      // Handle unexpected errors (e.g., navigation to login screen).
      Get.offAllNamed('/loginScreen');
    }
  }
}
