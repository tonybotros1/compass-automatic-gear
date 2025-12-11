import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Models/job cards/job_card_model.dart';
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
  Future<Map<String, dynamic>> getCountries() async {
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
        Map<String, dynamic> map = {
          for (var country in jsonDate) country['_id']: country,
        };
        return map;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getCountries();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
        return {};
      } else if (response.statusCode == 401) {
        logout();
        return {};
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  // this function is to ger all cities of selected country for drop down menu
  Future<Map<String, dynamic>> getCitiesValues(String countryId) async {
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
        Map<String, dynamic> map = {
          for (var city in jsonData) city['_id']: city,
        };
        return map;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getCitiesValues(countryId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        return {};
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  // this function is to ger all roles for drop down menu
  Future<Map<String, dynamic>> getAllRoles() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendUrl/responsibilities/get_roles_based_on_status',
      );
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $accessToken"},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List<dynamic> jsonData = decoded["roles"];
        Map<String, dynamic> map = {
          for (var role in jsonData) role['_id']: role,
        };
        return map;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllRoles();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
        return {};
      } else if (response.statusCode == 401) {
        logout();
        return {};
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  // this function is to get all list values by code for drop down menu
  Future<Map<String, dynamic>> getAllListValues(String code) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendUrl/list_of_values/get_list_values_by_code?code=$code',
      );
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $accessToken"},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List<dynamic> jsonData = decoded["values"];
        Map<String, dynamic> map = {
          for (var role in jsonData) role['_id']: role,
        };
        return map;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllListValues(code);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
        return {};
      } else if (response.statusCode == 401) {
        logout();
        return {};
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  // this function is to get all list values by code for drop down menu
  Future<Map<String, dynamic>> getAllEmployeesByDepartment(
    String department,
  ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendUrl/employees/get_employees_by_department?department=$department',
      );
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $accessToken"},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List<dynamic> jsonData = decoded["employees"];
        Map<String, dynamic> map = {
          for (var role in jsonData) role['_id']: role,
        };
        return map;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllEmployeesByDepartment(department);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
        return {};
      } else if (response.statusCode == 401) {
        logout();
        return {};
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, dynamic>> getListDetails(String code) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendUrl/list_of_values/get_list_details_by_code?code=$code',
      );
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $accessToken"},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        Map<String, dynamic> jsonData = decoded["list_details"];
        return jsonData;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getListDetails(code);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
        return {};
      } else if (response.statusCode == 401) {
        logout();
        return {};
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, dynamic>> getCarBrands() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      final response = await http.get(
        Uri.parse('$backendTestURI/brands/get_all_brands_by_status'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        List<dynamic> jsonData = decoded['brands'];
        Map<String, dynamic> map = {
          for (var brand in jsonData) brand['_id']: brand,
        };
        return map;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getCarBrands();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
        return {};
      } else if (response.statusCode == 401) {
        logout();
        return {};
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, dynamic>> getModelsValues(String brandId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendTestURI/brands/get_models_by_status/$brandId',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        List<dynamic> jsonData = decode['models'];
        Map<String, dynamic> map = {
          for (var model in jsonData) model['_id']: model,
        };
        return map;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getModelsValues(brandId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        return {};
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, dynamic>> getSalesMan() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendTestURI/salesman/get_all_salesman');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        List<dynamic> jsonData = decode['salesman'];
        Map<String, dynamic> map = {
          for (var model in jsonData) model['_id']: model,
        };
        return map;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getSalesMan();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
        return {};
      } else if (response.statusCode == 401) {
        logout();
        return {};
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, dynamic>> getCurrencies() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendTestURI/currencies/get_all_currencies_for_drop_down_menu',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        List<dynamic> jsonData = decode['currencies'];
        Map<String, dynamic> map = {
          for (var model in jsonData) model['_id']: model,
        };
        return map;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getCurrencies();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
        return {};
      } else if (response.statusCode == 401) {
        logout();
        return {};
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, dynamic>> getCurrentCompanyDetails() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendTestURI/companies/get_current_company_details',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        final jsonData = decode['company_details'];
        return jsonData ?? {};
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getCurrentCompanyDetails();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {
        return {};
      }
      return {};
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, dynamic>> getBrunches() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendTestURI/branches/get_all_branches_by_status',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        List<dynamic> jsonData = decode['branches'];
        Map<String, dynamic> map = {
          for (var model in jsonData) model['_id']: model,
        };
        return map;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getBrunches();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
        return {};
      } else if (response.statusCode == 401) {
        logout();
        return {};
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, dynamic>> getCustomers() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendTestURI/entity_information/get_all_customers',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        List<dynamic> jsonData = decode['customers'];
        Map<String, dynamic> map = {
          for (var model in jsonData) model['_id']: model,
        };
        return map;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getCustomers();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
        return {};
      } else if (response.statusCode == 401) {
        logout();
        return {};
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, dynamic>> getVendors() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendTestURI/entity_information/get_all_vendors');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        List<dynamic> jsonData = decode['vendors'];
        Map<String, dynamic> map = {
          for (var model in jsonData) model['_id']: model,
        };
        return map;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getVendors();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
        return {};
      } else if (response.statusCode == 401) {
        logout();
        return {};
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future getSysUsers() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendTestURI/users/get_all_users');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        List<dynamic> jsonData = decode['users'];

        // keep only _id, name, and email
        Map<String, dynamic> map = {
          for (var model in jsonData)
            model['_id']: {
              'user_name': model['user_name'],
              'email': model['email'],
              "status": model["status"],
            },
        };
        return map;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getSysUsers();
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

  Future<Map<String, dynamic>> getInvoiceItems() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendTestURI/invoice_items/get_all_invoice_items',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        List<dynamic> jsonData = decode['invoice_items'];
        Map<String, dynamic> map = {
          for (var model in jsonData) model['_id']: model,
        };
        return map;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getInvoiceItems();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
        return {};
      } else if (response.statusCode == 401) {
        logout();
        return {};
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future getJobCardStatus(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendTestURI/job_cards/get_job_card_status/$id');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final status = decoded['data'];
        return status;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getJobCardStatus(id);
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

  Future getReceivingStatus(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendTestURI/receiving/get_receiving_status/$id');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final status = decoded['data'];
        return status;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getReceivingStatus(id);
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

  Future getQuotationCardStatus(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendTestURI/quotation_cards/get_quotation_card_status/$id',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final status = decoded['data'];
        return status;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getQuotationCardStatus(id);
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

  Future getConverterStatus(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendTestURI/converters/get_converter_status/$id',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final status = decoded['data'];
        return status;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getConverterStatus(id);
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

  Future getIssuingStatus(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendTestURI/issue_items/get_issuing_status/$id');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final status = decoded['data'];
        return status;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getIssuingStatus(id);
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

  Future getJobNumberForQuotationCard(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendTestURI/quotation_cards/get_job_number_for_quotation/$id',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final number = decoded['job_number'];
        return number;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getJobNumberForQuotationCard(id);
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

  Future<Map<String, dynamic>> getAllTechnicians() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendTestURI/technicians/get_all_technicians');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        List<dynamic> jsonData = decode['technicians'];
        Map<String, dynamic> map = {
          for (var model in jsonData) model['_id']: model,
        };
        return map;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllTechnicians();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
        return {};
      } else if (response.statusCode == 401) {
        logout();
        return {};
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future<Map<String, dynamic>> getAllBanksAndOthers() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendTestURI/banks_and_others/get_all_banks');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        List<dynamic> jsonData = decode['banks'];
        Map<String, dynamic> map = {
          for (var model in jsonData) model['_id']: model,
        };
        return map;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllBanksAndOthers();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
        return {};
      } else if (response.statusCode == 401) {
        logout();
        return {};
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future<double> getCustomerOutstanding(String customerId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendTestURI/job_cards/get_customer_outstanding/$customerId',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        double outstanding = decode['outstanding'];

        return outstanding;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getCustomerOutstanding(customerId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
        return 0;
      } else if (response.statusCode == 401) {
        logout();
        return 0;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  Future<double> getVendorOutstanding(String vendorId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendTestURI/ap_invoices/get_vendor_outstanding/$vendorId',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        double outstanding = decode['outstanding'];

        return outstanding;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getVendorOutstanding(vendorId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
        return 0;
      } else if (response.statusCode == 401) {
        logout();
        return 0;
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  Future getARREceiptStatus(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendTestURI/ar_receipts/get_ar_receipt_status/$id',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final status = decoded['data'];
        return status;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getARREceiptStatus(id);
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

  Future getAPPaymentStatus(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendTestURI/ap_payments/get_ap_payment_status/$id',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final status = decoded['data'];
        return status;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAPPaymentStatus(id);
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

  Future<Map<String, dynamic>> getAllAPPaymentTypes() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendTestURI/ap_payment_types/get_all_ap_payment_types',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        List<dynamic> jsonData = decode['types'];
        Map<String, dynamic> map = {
          for (var model in jsonData) model['_id']: model,
        };
        return map;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllAPPaymentTypes();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
        return {};
      } else if (response.statusCode == 401) {
        logout();
        return {};
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future getAPInvoiceStatus(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendTestURI/ap_invoices/get_ap_invoice_status/$id',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final status = decoded['data'];
        return status;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAPInvoiceStatus(id);
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

  Future<List<JobCardModel>> getAllJobCards() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendTestURI/job_cards/get_all_job_cards');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        List<dynamic> jsonData = decode['all_jobs'];
        List<JobCardModel> listOfJobs = [];
        listOfJobs.assignAll(jsonData.map((job) => JobCardModel.fromJson(job)));
        return listOfJobs;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getAllJobCards();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
        return [];
      } else if (response.statusCode == 401) {
        logout();
        return [];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
