import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../consts.dart';
import '../../helpers.dart';

class DataMigrationController extends GetxController {
  Rx<Uint8List> fileBytes = Uint8List(0).obs;

  RxString fileType = RxString('');
  RxString fileName = RxString('');
  String backendUrl = backendTestURI;
  RxBool uploadingFile = RxBool(false);
  RxString screenName = RxString('');
  RxBool deleteEveryThing = RxBool(false);

  RxMap screens = RxMap({
    '1': {'name': 'Job Cards'},
    '2': {'name': 'Job Cards Invoice Items'},
    '3': {'name': 'AR Receipts'},
    '4': {'name': 'AR Receipts Items'},
    '5': {'name': 'AP Invoices'},
    '6': {'name': 'Receving'},
  });

  Future<void> uploadFile() async {
    try {
      uploadingFile.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/data_migration/get_file');
      var request = http.MultipartRequest('POST', url);
      request.fields['screen_name'] = screenName.value;
      request.fields['delete_every_thing'] = deleteEveryThing.value.toString();
      if (fileType.value.isNotEmpty) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            fileBytes.value,
            filename: fileName.value,
          ),
        );
      }
      request.headers.addAll({
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'multipart/form-data',
      });
      var response = await request.send();

      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await uploadFile();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      uploadingFile.value = false;
    } catch (e) {
      uploadingFile.value = false;
    }
  }
}
