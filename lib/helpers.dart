import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'consts.dart';

enum RefreshResult {
  success,
  invalidToken, // Refresh token is expired/invalid → logout
  networkError, // No internet / timeout → don't logout
  serverError, // Backend error (e.g. 500) → don't logout
}

class Helpers {
  String backendUrl = backendTestURI;
  final secureStorage = const FlutterSecureStorage();

  Future<RefreshResult> refreshAccessToken(String refreshToken) async {
    try {
      final url = Uri.parse('$backendUrl/auth/refresh_token');
      final request = http.MultipartRequest('POST', url)
        ..fields['token'] = refreshToken;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // ✅ Successfully refreshed
        final decoded = jsonDecode(response.body);
        final newAccessToken = decoded['access_token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', newAccessToken);

        return RefreshResult.success;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        return RefreshResult.invalidToken;
      } else {
        return RefreshResult.serverError;
      }
    } catch (e) {
      return RefreshResult.networkError;
    }
  }
}
