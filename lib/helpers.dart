import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'consts.dart';

class Helpers {
  String backendUrl = backendTestURI;
  final secureStorage = const FlutterSecureStorage();

  Future<bool> refreshAccessToken(String refreshToken) async {
    try {
      var url = Uri.parse('$backendUrl/auth/refresh_token');
      var request = http.MultipartRequest('POST', url);
      request.fields['token'] = refreshToken;

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(responseData.body);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', decoded['access_token']);
        await secureStorage.write(key: "refreshToken", value: refreshToken);

        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
