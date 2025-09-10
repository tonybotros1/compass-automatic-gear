import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'consts.dart';

enum RefreshResult {
  success,
  invalidToken, // Refresh token expired/invalid → logout
  networkError, // No internet / timeout
  serverError, // Backend error (500, etc.)
}

class Helpers {
  String backendUrl = backendTestURI;
  final secureStorage = const FlutterSecureStorage();

  bool _isRefreshing = false;
  Completer<RefreshResult>? _refreshCompleter;

  Future<RefreshResult> refreshAccessToken(String refreshToken) async {
    // If a refresh is already in progress → wait for its result
    if (_isRefreshing && _refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer();

    try {
      final url = Uri.parse('$backendUrl/auth/refresh_token');
      final request = http.MultipartRequest('POST', url)
        ..fields['token'] = refreshToken;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final newAccessToken = decoded['access_token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', newAccessToken);

        _refreshCompleter!.complete(RefreshResult.success);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        _refreshCompleter!.complete(RefreshResult.invalidToken);
      } else {
        _refreshCompleter!.complete(RefreshResult.serverError);
      }
    } catch (e) {
      _refreshCompleter!.complete(RefreshResult.networkError);
    } finally {
      _isRefreshing = false;
    }

    return _refreshCompleter!.future;
  }
}
