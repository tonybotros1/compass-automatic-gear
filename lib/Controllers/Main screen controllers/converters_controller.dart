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
  RxDouble allConvertersVATS = RxDouble(0.0);
  RxDouble allConvertersTotals = RxDouble(0.0);
  RxDouble allConvertersNET = RxDouble(0.0);
  final RxList<ConverterModel> allConverters = RxList<ConverterModel>([]);
  final ScrollController scrollControllerFotTable1 = ScrollController();
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxString curreentConverterId = RxString('');
  String backendUrl = backendTestURI;

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
      Uri addingJobUrl = Uri.parse('$backendUrl/converters/add_new_converter');

      if (curreentConverterId.isEmpty) {
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

  void clearValues() {
    curreentConverterId.value = '';
    converterName.clear();
    converterNumber.clear();
    date.text = textToDate(DateTime.now());
    status.value = '';
    description.clear();
  }
}
