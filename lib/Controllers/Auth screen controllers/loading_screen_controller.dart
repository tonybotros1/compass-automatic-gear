import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../consts.dart';

class LoadingScreenController extends GetxController {
  String backendUrl = backendTestURI;
  final secureStorage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  // Wrapper to handle async logic.
  void _initialize() async {
    await checkLogStatus();
  }

  Future<void> logout() async {
    try {
      final refreshToken = await secureStorage.read(key: "refreshToken");

      var url = Uri.parse('$backendUrl/auth/logout');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"refresh_token": refreshToken},
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        showSnackBar('Done', responseBody['message']);
        await secureStorage.delete(key: "refreshToken");
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove("accessToken");
        await prefs.remove("userEmail");
        await prefs.remove("companyId");
        await prefs.remove("userId");
        Get.offAllNamed('/');
      } else {
        showSnackBar('Alert', 'Can\'t logout');
      }
    } catch (e) {
      showSnackBar('Alert', 'Can\'t logout');
    }
  }

  Future<bool> isUserValid(String userId) async {
    try {
      var url = Uri.parse('$backendUrl/auth/is_user_valid/$userId');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["valid"] == true;
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
        Get.offAllNamed('/loginScreen');
      } else {
        isUserValid(userId).then((value) async {
          if (value) {
            if (kIsWeb) {
              Get.offAllNamed('/mainScreen');
            } else {
              Get.offAllNamed('/mainScreenForMobile');
            }
          } else {
            await logout();
          }
        });
      }
    } catch (e) {
      checkLogStatus();
    }
  }
}
