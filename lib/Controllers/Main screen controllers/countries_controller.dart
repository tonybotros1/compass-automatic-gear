import 'dart:convert';
import 'dart:typed_data';
import 'package:datahubai/Models/countries/cities_model.dart';
import 'package:datahubai/helpers.dart';
import 'package:datahubai/web_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/countries/countries_model.dart';
import '../../consts.dart';
import 'main_screen_contro.dart';
import 'package:http/http.dart' as http;
import 'webSocket_controller.dart';

class CountriesController extends GetxController {
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  TextEditingController countryCode = TextEditingController();
  TextEditingController cityCode = TextEditingController();
  TextEditingController countryName = TextEditingController();
  TextEditingController cityName = TextEditingController();
  TextEditingController countryCallingCode = TextEditingController();
  TextEditingController currencyName = TextEditingController();
  TextEditingController currencyCode = TextEditingController();
  TextEditingController vat = TextEditingController();
  RxBool isScreenLoding = RxBool(false);
  final RxList<Country> allCountries = RxList<Country>([]);
  final RxList<Country> filteredCountries = RxList<Country>([]);
  final RxList<City> allCities = RxList<City>([]);
  final RxList<City> filteredCities = RxList<City>([]);
  RxString queryForCities = RxString('');
  Rx<TextEditingController> searchForCities = TextEditingController().obs;
  RxBool loadingcities = RxBool(false);
  final GlobalKey<FormState> formKeyForAddingNewvalue = GlobalKey<FormState>();

  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxBool addingNewCityValue = RxBool(false);
  RxString countryIdToWorkWith = RxString('');
  RxBool flagSelectedError = RxBool(false);
  Rx<Uint8List> imageBytes = Uint8List(0).obs;
  RxString flagUrl = RxString('');
  String backendUrl = backendTestURI;
  WebSocketService ws = Get.find<WebSocketService>();

  @override
  void onInit() {
    connectWebSocket();
    getAllCountries();

    super.onInit();
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  void connectWebSocket() {
    ws.events.listen((message) {
      switch (message["type"]) {
        case "country_added":
          final newBrand = Country.fromJson(message["data"]);
          allCountries.add(newBrand);
          break;

        case "country_updated":
          final updated = Country.fromJson(message["data"]);
          final index = allCountries.indexWhere((b) => b.id == updated.id);
          if (index != -1) {
            allCountries[index] = updated;
          }
          break;

        case "country_deleted":
          final deletedId = message["data"]["_id"];
          allCountries.removeWhere((b) => b.id == deletedId);
          break;

        case "city_added":
          final newModel = City.fromJson(message["data"]);
          allCities.add(newModel);
          break;

        case "city_updated":
          final updated = City.fromJson(message["data"]);
          final index = allCities.indexWhere((m) => m.id == updated.id);
          if (index != -1) {
            allCities[index] = updated;
          }
          break;

        case "city_deleted":
          final deletedId = message["data"]["_id"];
          allCities.removeWhere((m) => m.id == deletedId);
          break;
      }
    });
  }

  // ===================================== Countries Section =============================================

  Future<void> getAllCountries() async {
    try {
      isScreenLoding.value = true;
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
        allCountries.assignAll(
          jsonDate.map((country) => Country.fromJson(country)).toList(),
        );
        isScreenLoding.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllCountries();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        isScreenLoding.value = false;
        logout();
      } else {
        isScreenLoding.value = false;
      }
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  Future<void> addNewCountry() async {
    try {
      addingNewValue.value = true;
      var url = Uri.parse('$backendUrl/countries/add_new_country');
      var request = http.MultipartRequest('POST', url);
      request.fields["name"] = countryName.text;
      request.fields["code"] = countryCode.text;
      request.fields["calling_code"] = countryCallingCode.text;
      request.fields["currency_name"] = currencyName.text;
      request.fields["currency_code"] = currencyCode.text;
      request.fields["vat"] = vat.text;
      request.fields["currency_code"] = currencyCode.text;
      if (imageBytes.value.isNotEmpty) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'flag',
            imageBytes.value,
            filename: "flag_${countryName.text}.png",
          ),
        );
      }

      final response = await request.send();
      if (response.statusCode == 200) {
        addingNewValue.value = false;
        Get.back();
        showSnackBar('Done', 'New Country added successfully');
      } else {
        addingNewValue.value = false;
        Get.back();
        showSnackBar('Alert', 'Something went wrong please try again');
      }
    } catch (e) {
      addingNewValue.value = false;
      Get.back();
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  Future<void> changeCountryStatus(String countryId, bool status) async {
    try {
      var url = Uri.parse(
        '$backendUrl/countries/change_country_status/$countryId',
      );
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": status}),
      );
      if (response.statusCode == 200) {
        // return jsonDecode(response.body);
      } else {
        throw Exception("Failed to update status: ${response.body}");
      }
    } catch (e) {
      // print(e);
    }
  }

  Future<void> deleteCountry(String countryId) async {
    try {
      var url = Uri.parse('$backendUrl/countries/delete_country/$countryId');
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        Get.back();
        showSnackBar('Done', 'Country deleted successfully');
      } else {
        Get.back();

        showSnackBar('Alert', 'Something went wrong please try again');
      }
    } catch (e) {
      Get.back();

      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  Future<void> editCountry(String countryId) async {
    try {
      addingNewValue.value = true;
      var url = Uri.parse('$backendUrl/countries/update_country/$countryId');
      final request = http.MultipartRequest('PATCH', url);
      request.fields["name"] = countryName.text;
      request.fields["code"] = countryCode.text;
      request.fields["calling_code"] = countryCallingCode.text;
      request.fields["currency_name"] = currencyName.text;
      request.fields["currency_code"] = currencyCode.text;
      request.fields["vat"] = vat.text;
      request.fields["currency_code"] = currencyCode.text;
      if (imageBytes.value.isNotEmpty) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'flag',
            imageBytes.value,
            filename: "flag_${countryName.text}.png",
          ),
        );
      }
      final response = await request.send();
      if (response.statusCode == 200) {
        addingNewValue.value = false;
        Get.back();
        showSnackBar('Done', 'Country updated successfully');
      } else {
        addingNewValue.value = false;
        Get.back();
        showSnackBar('Alert', 'Something went wrong please try again');
      }
    } catch (e) {
      addingNewValue.value = false;
      Get.back();
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  // ===================================== Cities Section =============================================

  Future<void> getCitiesValues(String countryId) async {
    try {
      loadingcities.value = true;
      allCities.clear();
      filteredCities.clear();
      var url = Uri.parse('$backendUrl/countries/get_cities/$countryId');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List<dynamic> jsonData = decoded["cities"];
        allCities.assignAll(jsonData.map((city) => City.fromJson(city)));
        loadingcities.value = false;
      } else {
        loadingcities.value = false;
      }
    } catch (e) {
      loadingcities.value = false;
    }
  }

  Future<void> addNewCity(String countryId) async {
    try {
      addingNewCityValue.value = true;
      var url = Uri.parse('$backendUrl/countries/add_new_city/$countryId');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": cityName.text, "code": cityCode.text}),
      );
      if (response.statusCode == 200) {
        addingNewCityValue.value = false;
        Get.back();
        showSnackBar('Done', 'City added successfully');
      } else {
        addingNewCityValue.value = false;
        Get.back();
        showSnackBar('Alert', 'Something went wrong please try again');
      }
    } catch (e) {
      addingNewCityValue.value = false;
      Get.back();
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  Future<void> changeCityStatus(String cityId, bool status) async {
    try {
      var url = Uri.parse('$backendUrl/countries/change_city_status/$cityId');
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": status}),
      );
      if (response.statusCode == 200) {
        // return jsonDecode(response.body);
      } else {
        throw Exception("Failed to update status: ${response.body}");
      }
    } catch (e) {
      // print(e);
    }
  }

  Future<void> editCity(String cityId) async {
    try {
      addingNewCityValue.value = true;
      var url = Uri.parse('$backendUrl/countries/update_city/$cityId');
      final response = await http.patch(
        url,
        body: {"name": cityName.text, "code": cityCode.text},
      );
      if (response.statusCode == 200) {
        addingNewCityValue.value = false;
        Get.back();
        showSnackBar('Done', 'City updated successfully');
      } else {
        addingNewCityValue.value = false;
        Get.back();
        showSnackBar('Alert', 'Something went wrong please try again');
      }
    } catch (e) {
      addingNewCityValue.value = false;
      Get.back();
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  Future<void> deleteCity(String cityID) async {
    try {
      var url = Uri.parse('$backendUrl/countries/delete_city/$cityID');
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        Get.back();
        showSnackBar('Done', 'City deleted successfully');
      } else {
        Get.back();
        showSnackBar('Alert', 'Something went wrong please try again');
      }
    } catch (e) {
      Get.back();
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allCountries.sort((counter1, counter2) {
        final String value1 = counter1.code;
        final String value2 = counter2.code;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allCountries.sort((counter1, counter2) {
        final String value1 = counter1.name;
        final String value2 = counter2.name;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 4) {
      allCountries.sort((counter1, counter2) {
        final String value1 = counter1.createdAt.toString();
        final String value2 = counter2.createdAt.toString();

        return compareString(ascending, value1, value2);
      });
    }
    sortColumnIndex.value = columnIndex;
    isAscending.value = ascending;
  }

  void onSortForCities(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allCities.sort((screen1, screen2) {
        final String value1 = screen1.code;
        final String value2 = screen2.code;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allCities.sort((screen1, screen2) {
        final String value1 = screen1.name;
        final String value2 = screen2.name;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allCities.sort((screen1, screen2) {
        final String value1 = screen1.createdAt.toString();
        final String value2 = screen2.createdAt.toString();

        return compareString(ascending, value1, value2);
      });
    }
    sortColumnIndex.value = columnIndex;
    isAscending.value = ascending;
  }

  int compareString(bool ascending, String value1, String value2) {
    int comparison = value1.compareTo(value2);
    return ascending ? comparison : -comparison; // Reverse if descending
  }

  // this function is to filter the search results for web
  void filterCountries() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredCountries.clear();
    } else {
      filteredCountries.assignAll(
        allCountries.where((country) {
          return country.code.toString().toLowerCase().contains(query) ||
              country.name.toString().toLowerCase().contains(query) ||
              textToDate(
                country.createdAt,
              ).toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
  }

  // this function is to filter the search results for web
  void filterCities() {
    queryForCities.value = searchForCities.value.text.toLowerCase();
    if (queryForCities.value.isEmpty) {
      filteredCities.clear();
    } else {
      filteredCities.assignAll(
        allCities.where((city) {
          return city.code.toString().toLowerCase().contains(
                queryForCities.value,
              ) ||
              city.name.toLowerCase().contains(queryForCities.value) ||
              textToDate(
                city.createdAt,
              ).toString().toLowerCase().contains(queryForCities.value);
        }).toList(),
      );
    }
  }

  // this function is to select an image for logo
  Future<void> pickImage() async {
    final imagePicker = ImagePickerService();
    imagePicker.pickImage(imageBytes, flagSelectedError);
  }
}
