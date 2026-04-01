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
  String code = '';
  String documentId = '';
  TextEditingController name = TextEditingController();
  TextEditingController type = TextEditingController();
  RxString typeId = RxString('');
  TextEditingController number = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  TextEditingController fileNameWhenSelectFile = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController attachmentCode = TextEditingController();
  Rx<Uint8List?> fileBytes = Rx<Uint8List?>(null);
  RxString fileType = RxString('');
  RxString fileName = RxString('');
  AttachmentController({required this.code, required this.documentId});
  RxBool addingNewAttachment = RxBool(false);

  @override
  void onInit() async {
    getAllAttachments();
    super.onInit();
  }

  Future<Map<String, dynamic>> getAttachmentTypes() async {
    return await helper.getAllListValues('ATTACHMENT_TYPES');
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
        body: jsonEncode({"code": code, "document_id": documentId}),
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
      addingNewAttachment.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/attachment/add_new_attachment');
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll({'Authorization': 'Bearer $accessToken'});
      request.fields['code'] = attachmentCode.text;
      request.fields['document_id'] = documentId;
      request.fields['name'] = name.text;

      request.fields['start_date'] = convertDateToIson(
        startDate.text,
      ).toString();
      request.fields['end_date'] = convertDateToIson(endDate.text).toString();
      request.fields['note'] = note.text;
      request.fields['number'] = number.text;
      request.fields['attachment_type'] = typeId.value;
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
        String code = decoded['code'];
        DateTime startDate = decoded['start_date'];
        DateTime endDate = decoded['end_date'];
        String note = decoded['note'];
        String number = decoded['number'];
        String attachmentType = decoded['attachment_type_name'];
        String attachmentTypeId = decoded['attachment_type'];
        String fileName = decoded['file_name'];

        String id = decoded['_id'];
        attachesList.add(
          AttachmentsModel(
            id: id,
            name: name,
            fileURL: attURL,
            code: code,
            startDate: startDate,
            endDate: endDate,
            note: note,
            number: number,
            attachmentTypeName: attachmentType,
            attachmentTypeId: attachmentTypeId,
            fileName: fileName,
          ),
        );
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
      addingNewAttachment.value = false;
      Get.back();
    } catch (e) {
      addingNewAttachment.value = false;

      Get.back();
    }
  }

  Future<void> deleteattachmenth(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/attachment/delete_attachment/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        attachesList.removeWhere((att) => att.id == id);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteattachmenth(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      Get.back();
    } catch (e) {
      //
    }
  }
}
