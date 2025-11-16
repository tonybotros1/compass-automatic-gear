import 'dart:convert';
import 'package:datahubai/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/company variables/company_variables_model.dart';
import '../../helpers.dart';

class CompanyVariablesController extends GetxController {
  RxString companyLogo = RxString('');
  TextEditingController vatPercentage = TextEditingController();
  TextEditingController incentivePercentage = TextEditingController();
  TextEditingController taxNumber = TextEditingController();
  RxBool updatingVariables = RxBool(false);
  RxBool updatingInspectionReport = RxBool(false);
  double logoSize = 150;
  RxList<String> userRoles = RxList([]);
  RxBool isBreakeAndTireSelected = RxBool(false);
  RxBool isInteriorExteriorSelected = RxBool(false);
  RxBool isUnderVehicleSelected = RxBool(false);
  RxBool isUnderHoodSelected = RxBool(false);
  RxBool isBatteryPerformaceSelected = RxBool(false);
  RxBool isBodyDamageSelected = RxBool(false);
  RxList<String> inspectionReport = RxList<String>([]);

  RxMap<String, String> companyInformation = RxMap({
    'Company Name': '',
    'Industry': '',
  });
  RxMap<String, String> companyVariables = RxMap({
    'Incentive Percentage': '',
    'VAT Percentage': '',
    'TAX Number': '',
  });
  RxMap<String, String> ownerInformation = RxMap({
    'Name': '',
    'Phone Number': '',
    'Email': '',
    'Address': '',
    'Country': '',
    'City': '',
  });
  String backendUrl = backendTestURI;
  CompanyVariablesModel companyVariablesDetails = CompanyVariablesModel();

  @override
  void onInit() async {
    getCompanyVariables();
    super.onInit();
  }

  String removePercent(String? text) {
    if (text == null) {
      return '';
    }
    return text.replaceAll('%', '').trim();
  }

  Future<void> getCompanyVariables() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/company_variables/get_company_variables_and_details',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        companyVariablesDetails = CompanyVariablesModel.fromJson(
          decoded['company_variables'],
        );
        companyLogo.value = companyVariablesDetails.companyLogoUrl ?? '';
        companyInformation['Company Name'] =
            companyVariablesDetails.companyName ?? '';
        companyInformation['Industry'] =
            companyVariablesDetails.industryName ?? '';

        ownerInformation['Name'] = companyVariablesDetails.ownerName ?? '';
        ownerInformation['Phone Number'] =
            companyVariablesDetails.ownerPhone ?? '';
        ownerInformation['Email'] = companyVariablesDetails.ownerEmail ?? '';
        ownerInformation['Address'] =
            companyVariablesDetails.ownerAddress ?? '';
        ownerInformation['Country'] = companyVariablesDetails.countryName ?? '';
        ownerInformation['City'] = companyVariablesDetails.cityName ?? '';

        companyVariables['Incentive Percentage'] =
            companyVariablesDetails.incentivePercentage != null
            ? '${companyVariablesDetails.incentivePercentage! * 100}%'
            : '';
        companyVariables['VAT Percentage'] =
            companyVariablesDetails.vatPercentage != null
            ? '${companyVariablesDetails.vatPercentage! * 100}%'
            : "";
        companyVariables['TAX Number'] =
            companyVariablesDetails.taxNumber ?? '';
        inspectionReport.assignAll(
          companyVariablesDetails.inspectionReport ?? [],
        );
        checkInspectionItems(inspectionReport);

        userRoles.assignAll(
          (companyVariablesDetails.rolesDetails ?? []).map(
            (role) => role.roleName ?? '',
          ),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getCompanyVariables();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
    } catch (e) {
      // print(e);
    }
  }

  Future<void> updateVariables() async {
    try {
      updatingVariables.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/company_variables/update_company_variables',
      );
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'vat_percentage': (double.tryParse(vatPercentage.text) ?? 0) / 100,
          'incentive_percentage':
              (double.tryParse(incentivePercentage.text) ?? 0) / 100,
          'tax_number': taxNumber.text,
        }),
      );
      if (response.statusCode == 200) {
        companyVariables['Incentive Percentage'] =
            '${incentivePercentage.text}%';
        companyVariables['VAT Percentage'] = '${vatPercentage.text}%';
        companyVariables['TAX Number'] = taxNumber.text;
        Get.back();
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateVariables();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      updatingVariables.value = false;
    } catch (e) {
      updatingVariables.value = false;
    }
  }

  Future<void> updateInspectionReport() async {
    try {
      updatingInspectionReport.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/company_variables/update_inspection_report',
      );
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode(inspectionReport),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await updateVariables();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      updatingInspectionReport.value = false;
    } catch (e) {
      updatingInspectionReport.value = false;
    }
  }

  void checkInspectionItems(RxList<String> inspectionReport) {
    final checksMap = {
      'Break And Tire': isBreakeAndTireSelected,
      'Interior / Exterior': isInteriorExteriorSelected,
      'Under Vehicle': isUnderVehicleSelected,
      'Under Hood': isUnderHoodSelected,
      'Battery Performace': isBatteryPerformaceSelected,
      'Body Damage': isBodyDamageSelected,
    };

    checksMap.forEach((key, rxBool) {
      if (inspectionReport.contains(key)) {
        rxBool.value = true;
      }
    });
  }

  void selectForInspectionReport(String insp, bool value) {
    if (insp == "Break And Tire") {
      isBreakeAndTireSelected.value = value;
      if (value) {
        inspectionReport.add("Break And Tire");
      } else {
        inspectionReport.remove("Break And Tire");
      }
    } else if (insp == "Interior / Exterior") {
      isInteriorExteriorSelected.value = value;
      if (value) {
        inspectionReport.add("Interior / Exterior");
      } else {
        inspectionReport.remove("Interior / Exterior");
      }
    } else if (insp == "Under Vehicle") {
      isUnderVehicleSelected.value = value;
      if (value) {
        inspectionReport.add("Under Vehicle");
      } else {
        inspectionReport.remove("Under Vehicle");
      }
    } else if (insp == "Under Hood") {
      isUnderHoodSelected.value = value;
      if (value) {
        inspectionReport.add("Under Hood");
      } else {
        inspectionReport.remove("Under Hood");
      }
    } else if (insp == "Battery Performace") {
      isBatteryPerformaceSelected.value = value;
      if (value) {
        inspectionReport.add("Battery Performace");
      } else {
        inspectionReport.remove("Battery Performace");
      }
    } else if (insp == "Body Damage") {
      isBodyDamageSelected.value = value;
      if (value) {
        inspectionReport.add("Body Damage");
      } else {
        inspectionReport.remove("Body Damage");
      }
    }
  }

  // ===================================================================================================================
}
