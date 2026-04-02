class AttachmentsModel {
  String? id;
  String? name;
  String? code;
  DateTime? startDate;
  DateTime? endDate;
  String? note;
  String? number;
  String? attachmentTypeName;
  String? attachmentTypeId;
  List<Attachments>? attachments;

  AttachmentsModel({
    this.id,
    this.name,
    this.attachmentTypeName,
    this.attachmentTypeId,
    this.code,
    this.endDate,
    this.note,
    this.number,
    this.startDate,
    this.attachments,
  });

  AttachmentsModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id'] ?? "" : "";
    name = json.containsKey('name') ? json['name'] ?? "" : "";

    code = json.containsKey('code') ? json['code'] ?? "" : "";
    startDate = json.containsKey('start_date')
        ? DateTime.tryParse(json['start_date'])
        : null;
    endDate = json.containsKey('end_date')
        ? DateTime.tryParse(json['end_date'])
        : null;
    note = json.containsKey('note') ? json['note'] ?? "" : "";
    number = json.containsKey('number') ? json['number'] ?? "" : "";
    attachmentTypeName = json.containsKey('attachment_type_name')
        ? json['attachment_type_name'] ?? ""
        : "";
    attachmentTypeId = json.containsKey('attachment_type')
        ? json['attachment_type'] ?? ""
        : "";
    if (json['attachments'] != null) {
      attachments = <Attachments>[];
      json['attachments'].forEach((v) {
        attachments!.add(Attachments.fromJson(v));
      });
    }
  }
}

class Attachments {
  String? attachUrl;
  String? attachPublicId;
  String? fileName;

  Attachments({this.attachUrl, this.attachPublicId, this.fileName});

  Attachments.fromJson(Map<String, dynamic> json) {
    attachUrl = json['attach_url'];
    attachPublicId = json['attach_public_id'];
    fileName = json['file_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attach_url'] = attachUrl;
    data['attach_public_id'] = attachPublicId;
    data['file_name'] = fileName;
    return data;
  }
}
