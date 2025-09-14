import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
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

  // this function is to get all countries for drop down menu
  Future getCountries(RxMap map) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendUrl/countries/get_countries');

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List<dynamic> jsonDate = decoded["countries"];
        map.value = {for (var country in jsonDate) country['_id']: country};
        return map;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getCountries(map);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  // this function is to ger all cities of selected country for drop down menu
  Future getCitiesValues(RxMap map, String countryId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendUrl/countries/get_cities/$countryId');
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $accessToken"},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List<dynamic> jsonData = decoded["cities"];
        map.value = {for (var city in jsonData) city['_id']: city};
        return map;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getCitiesValues(map, countryId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  // this function is to ger all roles for drop down menu
   Future getAllRoles(RxMap map) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendUrl/responsibilities/get_roles_based_on_status');
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $accessToken"},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List<dynamic> jsonData = decoded["roles"];
        map.value = {for (var role in jsonData) role['_id']: role};
        return map;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllRoles(map);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }
}
