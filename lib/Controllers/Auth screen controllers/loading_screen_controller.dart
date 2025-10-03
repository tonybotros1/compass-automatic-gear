import 'dart:convert';
import 'package:datahubai/helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../../consts.dart';

class LoadingScreenController extends GetxController {
  String backendUrl = backendTestURI;
  final secureStorage = const FlutterSecureStorage();
  Helpers helper = Helpers();
  RxBool needRefresh = RxBool(false);

  @override
  void onInit() async {
    super.onInit();
    await checkLogStatus();
  }

  Future<bool> isUserValid(String userId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendUrl/auth/is_user_valid/$userId');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["valid"] == true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await isUserValid(userId);
        } else if (refreshed == RefreshResult.invalidToken) {
          return false;
        } else if (refreshed == RefreshResult.networkError) {
          needRefresh.value = true;
        }
        return false;
      } else if (response.statusCode == 401) {
        return false;
      } else if (response.statusCode == 500) {
        needRefresh.value = true;
        return false;
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
      // checkLogStatus();
      needRefresh.value = true;
    }
  }
}
