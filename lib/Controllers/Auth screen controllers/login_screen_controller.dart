import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../consts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  String backendUrl = backendTestURI;
  final secureStorage = const FlutterSecureStorage();

  // this function is to change the obscureText value:
  void changeObscureTextValue() {
    if (obscureText.value == true) {
      obscureText.value = false;
    } else {
      obscureText.value = true;
    }
  }

  Future<void> saveInformation(
    String userId,
    String companyId,
    String userEmail,
    String accessToken,
    String refreshToken,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('companyId', companyId);
    await prefs.setString('userEmail', userEmail);
    await prefs.setString('accessToken', accessToken);
    await secureStorage.write(key: "refreshToken", value: refreshToken);
  }

  Future<void> singIn() async {
    try {
      sigingInProcess.value = true;

      var url = Uri.parse('$backendUrl/auth/login');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"email": email.text.toLowerCase(), "password": pass.text},
      );
      var responseData = jsonDecode(response.body);
      if (response.statusCode == 401) {
        sigingInProcess.value = false;
        showSnackBar('Alert', responseData['detail']);
      } else if (response.statusCode == 404) {
        sigingInProcess.value = false;
        showSnackBar('Alert', responseData['detail']);
      } else if (response.statusCode == 403) {
        sigingInProcess.value = false;
        showSnackBar('Alert', responseData['detail']);
      } else if (response.statusCode == 200) {
        String userId = responseData['user_id'];
        String userEmail = responseData['email'];
        String companyId = responseData['company_id'];
        String accessToken = responseData['access_token'];
        String refreshToken = responseData['refresh_token'];

        await saveInformation(
          userId,
          companyId,
          userEmail,
          accessToken,
          refreshToken,
        );
        sigingInProcess.value = false;
        showSnackBar('Login Success', 'Welcome');
        if (kIsWeb) {
          Get.offAllNamed('/mainScreen');
        } else {
          Get.offAllNamed('/mainScreenForMobile');
        }
      } else {
        sigingInProcess.value = false;
        showSnackBar('Unexpected Error', 'Please try again');
      }
    } catch (e) {
      sigingInProcess.value = false;
      showSnackBar('Unexpected Error', 'Please try again');
    }
  }
}
