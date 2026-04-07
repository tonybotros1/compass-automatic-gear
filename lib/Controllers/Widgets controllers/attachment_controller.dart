import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/attachments/attachments_model.dart';
import '../../Models/attachments/selected_attachments_model.dart';
import '../../consts.dart';
import '../../helpers.dart';

class AttachmentController extends GetxController {
  RxList<AttachmentsModel> attachesList = RxList<AttachmentsModel>([]);
  RxList<AttachmentsModel> filteredAttachesList = RxList<AttachmentsModel>([]);
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
  Rx<TextEditingController> search = TextEditingController().obs;
  // TextEditingController attachmentCode = TextEditingController();
  Rx<Uint8List?> fileBytes = Rx<Uint8List?>(null);
  RxString fileType = RxString('');
  RxString fileName = RxString('');
  RxList<SelectedAttachmentsModel> selectedAttachments =
      RxList<SelectedAttachmentsModel>([]);
  AttachmentController({required this.code, required this.documentId});
  RxBool addingNewAttachment = RxBool(false);
  RxString query = RxString('');
  final formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();
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
        filterAttachments();
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
      // print(e);
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
      request.fields['code'] = code;
      request.fields['document_id'] = documentId;
      request.fields['name'] = name.text;

      if (startDate.text.isNotEmpty) {
        request.fields['start_date'] = convertDateToIson(
          startDate.text,
        ).toString();
      }

      if (endDate.text.isNotEmpty) {
        request.fields['end_date'] = convertDateToIson(endDate.text).toString();
      }
      request.fields['note'] = note.text;
      request.fields['number'] = number.text;
      request.fields['attachment_type'] = typeId.value;
      for (int i = 0; i < selectedAttachments.length; i++) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'attachments',
            selectedAttachments[i].fileBytes!,
            filename: selectedAttachments[i].fileName,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        AttachmentsModel newAttachment = AttachmentsModel.fromJson(
          decoded['result'],
        );
        attachesList.add(newAttachment);
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

  void filterAttachments() {
    query.value = search.value.text.toLowerCase();

    if (query.value.isEmpty) {
      filteredAttachesList.clear();
      return;
    }
    filteredAttachesList.assignAll(
      attachesList.where((attach) {
        return attach.name.toString().toLowerCase().contains(query.value) ||
            attach.attachmentTypeName.toString().toLowerCase().contains(
              query.value,
            ) ||
            attach.number.toString().toLowerCase().contains(query.value) ||
            attach.note.toString().toLowerCase().contains(query.value) ||
            textToDate(attach.startDate).toLowerCase().contains(query.value) ||
            textToDate(attach.endDate).toLowerCase().contains(query.value);
      }).toList(),
    );
  }
}
