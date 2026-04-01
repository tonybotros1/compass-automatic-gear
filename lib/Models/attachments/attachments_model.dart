class AttachmentsModel {
  String? id;
  String? name;
  String? fileURL;
  String? code;
  DateTime? startDate;
  DateTime? endDate;
  String? note;
  String? number;
  String? attachmentTypeName;
  String? attachmentTypeId;
  String? fileName;

  AttachmentsModel({
    this.id,
    this.name,
    this.fileURL,
    this.attachmentTypeName,
    this.attachmentTypeId,
    this.code,
    this.endDate,
    this.fileName,
    this.note,
    this.number,
    this.startDate,
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
    fileURL = json.containsKey('attach_url') ? json['attach_url'] ?? "" : "";
    fileName = json.containsKey('file_name') ? json['file_name'] ?? "" : "";
    note = json.containsKey('note') ? json['note'] ?? "" : "";
    number = json.containsKey('number') ? json['number'] ?? "" : "";
    attachmentTypeName = json.containsKey('attachment_type_name')
        ? json['attachment_type_name'] ?? ""
        : "";
    attachmentTypeId = json.containsKey('attachment_type')
        ? json['attachment_type'] ?? ""
        : "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['attach_url'] = fileURL;

    return data;
  }
}
