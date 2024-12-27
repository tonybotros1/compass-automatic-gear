import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreenController extends GetxController {
  @override
  void onInit() async {
    await checkLogStatus();
    super.onInit();
  }


// this function is to know if the user logedin or not
  checkLogStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? action = prefs.getString('userId');
    if (action == null || action == '') {
      Get.offAllNamed('/loginScreen');
    } else {
      Get.offAllNamed('/mainScreen');
    }
  }


}
