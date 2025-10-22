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
  double logoSize = 150;
  RxList<String> userRoles = RxList([]);

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
    if (text == null){
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
      //
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
              (double.tryParse(incentivePercentage.text) ?? 0 )/ 100,
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

  // ===================================================================================================================
}
