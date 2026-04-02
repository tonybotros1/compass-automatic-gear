import 'dart:typed_data';

class SelectedAttachmentsModel {
  Uint8List? fileBytes;
  String? fileType;
  String? fileName;

  SelectedAttachmentsModel({this.fileBytes, this.fileType, this.fileName});
}
