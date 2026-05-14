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
  void onInit() {
    super.onInit();
    getAllAttachments();
  }

  @override
  void onClose() {
    name.dispose();
    type.dispose();
    number.dispose();
    startDate.dispose();
    endDate.dispose();
    fileNameWhenSelectFile.dispose();
    note.dispose();
    search.value.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<Map<String, dynamic>> getAttachmentTypes() async {
    return await helper.getAllListValues('ATTACHMENT_TYPES');
  }

  Future<void> getAllAttachments() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      final refreshToken = await secureStorage.read(key: "refreshToken") ?? '';
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

  String _responseErrorMessage(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      final detail = decoded['detail'];
      if (detail is String && detail.trim().isNotEmpty) return detail;
    } catch (_) {
      //
    }
    return 'Something went wrong please try again';
  }

  String? _optionalIsoDate(TextEditingController controller, String label) {
    final rawDate = controller.text.trim();
    if (rawDate.isEmpty) return null;

    final isoDate = convertDateToIson(rawDate);
    if (isoDate == null) {
      showSnackBar('Alert', '$label is invalid');
    }
    return isoDate;
  }

  Future<void> addAttachments() async {
    if (addingNewAttachment.value) return;

    final startDateValue = _optionalIsoDate(startDate, 'Start date');
    if (startDate.text.trim().isNotEmpty && startDateValue == null) return;

    final endDateValue = _optionalIsoDate(endDate, 'End date');
    if (endDate.text.trim().isNotEmpty && endDateValue == null) return;

    final validAttachments = selectedAttachments
        .where(
          (attachment) =>
              attachment.fileBytes != null &&
              (attachment.fileName?.trim().isNotEmpty ?? false),
        )
        .toList();
    if (validAttachments.length != selectedAttachments.length ||
        validAttachments.isEmpty) {
      showSnackBar('Alert', 'Please select valid attachment files');
      return;
    }

    try {
      addingNewAttachment.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      final refreshToken = await secureStorage.read(key: "refreshToken") ?? '';
      Uri url = Uri.parse('$backendUrl/attachment/add_new_attachment');
      final request = http.MultipartRequest('POST', url);
      request.headers.addAll({'Authorization': 'Bearer $accessToken'});
      request.fields['code'] = code;
      request.fields['document_id'] = documentId;
      request.fields['name'] = name.text;

      if (startDateValue != null) request.fields['start_date'] = startDateValue;
      if (endDateValue != null) request.fields['end_date'] = endDateValue;
      request.fields['note'] = note.text;
      request.fields['number'] = number.text;
      if (typeId.value.isNotEmpty) {
        request.fields['attachment_type'] = typeId.value;
      }
      for (final attachment in validAttachments) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'attachments',
            attachment.fileBytes!,
            filename: attachment.fileName,
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
        filterAttachments();
        Get.back();
        return;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          addingNewAttachment.value = false;
          await addAttachments();
          return;
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
          return;
        }
      } else if (response.statusCode == 401) {
        logout();
        return;
      } else {
        showSnackBar('Alert', _responseErrorMessage(response));
      }
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
    } finally {
      addingNewAttachment.value = false;
    }
  }

  Future<void> deleteAttachment(String id) async {
    if (id.isEmpty) return;

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';
      final refreshToken = await secureStorage.read(key: "refreshToken") ?? '';
      Uri url = Uri.parse('$backendUrl/attachment/delete_attachment/$id');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        attachesList.removeWhere((att) => att.id == id);
        filterAttachments();
        Get.back();
        return;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteAttachment(id);
          return;
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
          return;
        }
      } else if (response.statusCode == 401) {
        logout();
        return;
      } else {
        showSnackBar('Alert', _responseErrorMessage(response));
      }
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
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
