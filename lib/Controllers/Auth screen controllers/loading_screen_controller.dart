import 'package:get/get.dart';
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

// this function is to know if the user logedin or not
  Future<void> checkLogStatus() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String? userId = prefs.getString('userId');
      if (userId == null || userId.isEmpty) {
        // Navigate to login screen if not logged in.
        Get.offAllNamed('/loginScreen');
      } else {
        // Navigate to main screen if logged in.
        Get.offAllNamed('/mainScreen');
      }
    } catch (e) {
      // Handle unexpected errors (e.g., navigation to login screen).
      Get.offAllNamed('/loginScreen');
    }
  }
}
