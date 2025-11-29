import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/converters/converter_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';

class ConvertersController extends GetxController {
  TextEditingController converterNumberFilter = TextEditingController();
  TextEditingController converterNumber = TextEditingController();
  TextEditingController converterNameFilter = TextEditingController();
  TextEditingController converterDescriptionFilter = TextEditingController();
  TextEditingController converterName = TextEditingController();
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController statusFilter = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController description = TextEditingController();
  RxString status = RxString('');
  RxBool addingNewValue = RxBool(false);
  RxBool isYearSelected = RxBool(false);
  RxBool isMonthSelected = RxBool(false);
  RxBool isDaySelected = RxBool(false);
  RxBool isTodaySelected = RxBool(false);
  RxBool isAllSelected = RxBool(false);
  RxBool isThisMonthSelected = RxBool(false);
  RxBool isThisYearSelected = RxBool(false);
  RxBool isScreenLoding = RxBool(false);
  RxInt numberOfConverters = RxInt(0);
  // RxDouble allConvertersVATS = RxDouble(0.0);
  RxDouble allConvertersTotals = RxDouble(0.0);
  // RxDouble allConvertersNET = RxDouble(0.0);
  final RxList<ConverterModel> allConverters = RxList<ConverterModel>([]);
  final ScrollController scrollControllerFotTable1 = ScrollController();
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxString curreentConverterId = RxString('');
  String backendUrl = backendTestURI;
  RxList<Issues> issues = RxList<Issues>([]);
  RxDouble finalItemsTotal = RxDouble(0.0);

  @override
  void onInit() async {
    //
    super.onInit();
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  Future getCurrentConverterStatus(String id) async {
    return await helper.getConverterStatus(id);
  }

  Future<void> addNewConverter() async {
    try {
      if (curreentConverterId.isNotEmpty) {
        Map converterStatus = await getCurrentConverterStatus(
          curreentConverterId.value,
        );
        String status1 = converterStatus.containsKey('status')
            ? converterStatus['status']
            : null;
        if (status1 != 'New' && status1 != '') {
          showSnackBar('Alert', 'Only new converters can be edited');
          return;
        }
      }
      addingNewValue.value = true;
      Map<String, dynamic> newData = {
        'status': status.value,
        // 'date': convertDateToIson(date.text),
        'name': converterName.text,
        'description': description.text,
      };

      final rawDate = date.value.text.trim();
      if (rawDate.isNotEmpty) {
        try {
          newData['date'] = convertDateToIson(rawDate);
        } catch (e) {
          showSnackBar('Alert', 'Please enter valid converter date');
        }
      } else {
        newData['date'] = null;
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';

      if (curreentConverterId.isEmpty) {
        Uri addingJobUrl = Uri.parse(
          '$backendUrl/converters/add_new_converter',
        );

        showSnackBar('Adding', 'Please Wait');
        newData['status'] = 'New';
        final response = await http.post(
          addingJobUrl,
          headers: {
            'Authorization': 'Bearer $accessToken',
            "Content-Type": "application/json",
          },
          body: jsonEncode(newData),
        );
        if (response.statusCode == 200) {
          status.value = 'New';
          final decoded = jsonDecode(response.body);
          converterNumber.text = decoded['converter_number'] ?? '';
          curreentConverterId.value = decoded['converter_id'] ?? '';
          showSnackBar('Done', 'Converter Added Successfully');
        } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
          final refreshed = await helper.refreshAccessToken(refreshToken);
          if (refreshed == RefreshResult.success) {
            await addNewConverter();
          } else if (refreshed == RefreshResult.invalidToken) {
            logout();
          }
        } else if (response.statusCode == 401) {
          logout();
        }
      } else {
        Uri updatingJobUrl = Uri.parse(
          '$backendUrl/converters/update_converter/${curreentConverterId.value}',
        );
        final response = await http.patch(
          updatingJobUrl,
          headers: {
            'Authorization': 'Bearer $accessToken',
            "Content-Type": "application/json",
          },
          body: jsonEncode(newData),
        );
        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body);
          ConverterModel conv = ConverterModel.fromJson(
            decoded['updated_converter'],
          );
          int index = allConverters.indexWhere(
            (converter) => converter.id == conv.id,
          );
          if (index != -1) {
            allConverters[index] = conv;
          }
          showSnackBar('Done', 'Updated Successfully');
        } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
          final refreshed = await helper.refreshAccessToken(refreshToken);
          if (refreshed == RefreshResult.success) {
            await addNewConverter();
          } else if (refreshed == RefreshResult.invalidToken) {
            logout();
          }
        } else if (response.statusCode == 401) {
          logout();
        }
      }
      addingNewValue.value = false;
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
      addingNewValue.value = false;
    }
  }

  Future<void> deleteConverterCard(String id) async {
    try {
      Map converterStatus = await getCurrentConverterStatus(id);
      String status1 = converterStatus.containsKey('status')
          ? converterStatus['status']
          : null;
      if (status1 != 'New' && status1 != '') {
        showSnackBar('Alert', 'Only new converters can be deleted');
        return;
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/converters/delete_converter/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        String deletedJobId = decoded['converter_id'];
        allConverters.removeWhere((job) => job.id == deletedJobId);
        numberOfConverters.value -= 1;
        Get.close(2);
        showSnackBar('Success', 'Converter deleted successfully');
      } else if (response.statusCode == 400 || response.statusCode == 404) {
        final decoded =
            jsonDecode(response.body) ?? 'Failed to delete job card';
        String error = decoded['detail'];
        showSnackBar('Alert', error);
      } else if (response.statusCode == 403) {
        final decoded = jsonDecode(response.body);
        String error = decoded['detail'] ?? 'Only New Job Cards Allowed';
        showSnackBar('Alert', error);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteConverterCard(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 500) {
        final decoded = jsonDecode(response.body);
        final error =
            decoded['detail'] ?? 'Server error while deleting job card';
        showSnackBar('Server Error', error);
      } else if (response.statusCode == 401) {
        logout();
      }
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  void editPostedStatus() async {
    if (curreentConverterId.isNotEmpty) {
      Map converterStatus = await getCurrentConverterStatus(
        curreentConverterId.value,
      );
      String status1 = converterStatus.containsKey('status')
          ? converterStatus['status']
          : null;
      if (status1 != 'New' && status1 != '') {
        showSnackBar('Alert', 'Only new converters can be edited');
        return;
      } else {
        status.value = 'Posted';
      }
    } else {
      showSnackBar('Alert', 'Please save the converter first');
    }
  }

  void clearValues() {
    curreentConverterId.value = '';
    converterName.clear();
    converterNumber.clear();
    date.text = textToDate(DateTime.now());
    status.value = '';
    finalItemsTotal.value = 0;
    issues.clear();
    description.clear();
  }

  void loadValues(ConverterModel data) {
    curreentConverterId.value = data.id ?? '';
    converterName.text = data.name ?? '';
    converterNumber.text = data.converterNumber ?? '';
    date.text = textToDate(data.date);
    status.value = data.status ?? '';
    description.text = data.description ?? '';
    finalItemsTotal.value = data.total ?? 0;
    issues.assignAll(data.issues ?? []);
  }

  void filterSearch() async {
    Map<String, dynamic> body = {};
    if (converterNumberFilter.text.isNotEmpty) {
      body["converter_number"] = converterNumberFilter.text;
    }
    if (converterNameFilter.text.isNotEmpty) {
      body["converter_name"] = converterNameFilter.text;
    }
    if (converterDescriptionFilter.text.isNotEmpty) {
      body["description"] = converterDescriptionFilter.text;
    }

    if (statusFilter.value.text.isNotEmpty) {
      body["status"] = statusFilter.value.text;
    }
    if (isTodaySelected.isTrue) {
      body["today"] = true;
    }
    if (isThisMonthSelected.isTrue) {
      body["this_month"] = true;
    }
    if (isThisYearSelected.isTrue) {
      body["this_year"] = true;
    }
    if (fromDate.value.text.isNotEmpty) {
      body["from_date"] = convertDateToIson(fromDate.value.text);
    }
    if (toDate.value.text.isNotEmpty) {
      body["to_date"] = convertDateToIson(toDate.value.text);
    }
    if (body.isNotEmpty) {
      await searchEngine(body);
    } else {
      await searchEngine({"all": true});
    }
  }

  Future<void> searchEngine(Map<String, dynamic> body) async {
    try {
      isScreenLoding.value = true;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/converters/search_engine_for_converters',
      );
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List converters = decoded['converters'];
        Map grandTotals = decoded['grand_totals'];
        allConvertersTotals.value = grandTotals['grand_total'];
        allConverters.assignAll(
          converters.map((job) => ConverterModel.fromJson(job)),
        );
        numberOfConverters.value = allConverters.length;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await searchEngine(body);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }

      isScreenLoding.value = false;
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  void clearAllFilters() {
    converterDescriptionFilter.clear();
    converterNameFilter.clear();
    converterNumberFilter.clear();
    statusFilter.clear();
    fromDate.clear();
    toDate.clear();
    isAllSelected.value = false;
    isTodaySelected.value = false;
    isThisMonthSelected.value = false;
    isThisYearSelected.value = false;
  }
}
