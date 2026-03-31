import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/attachments/attachments_model.dart';
import '../../consts.dart';
import '../../helpers.dart';

class AttachmentController extends GetxController {
  RxList<AttachmentsModel> attachesList = RxList<AttachmentsModel>([]);
  String backendUrl = backendTestURI;
  String screenName = '';
  String documentId = '';
  RxBool addingNewValue = RxBool(false);
  TextEditingController name = TextEditingController();
  Rx<Uint8List?> fileBytes = Rx<Uint8List?>(null);
  RxString fileType = RxString('');
  RxString fileName = RxString('');
  AttachmentController({required this.screenName, required this.documentId});

  @override
  void onInit() async {
    getAllAttachments();
    super.onInit();
  }

  Future<void> getAllAttachments() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/attachment/get_all_attachment');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "screen_name": screenName,
          "document_id": documentId,
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List att = decoded['results'];
        attachesList.assignAll(
          att.map((employee) => AttachmentsModel.fromJson(employee)),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllAttachments();
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

  Future<void> addAttachments() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/attachment/add_new_attachment');
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll({'Authorization': 'Bearer $accessToken'});
      request.fields['screen_name'] = screenName;
      request.fields['document_id'] = documentId;
      request.fields['name'] = name.text;
      if (fileBytes.value != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'attachment',
            fileBytes.value!,
            filename: fileName.value,
          ),
        );
      }
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        String attURL = decoded['attach_url'];
        String name = decoded['name'];
        String id = decoded['_id'];
        attachesList.add(AttachmentsModel(id: id, name: name, file: attURL));
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addAttachments();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
      Get.back();
    } catch (e) {
      Get.back();
    }
  }
}
