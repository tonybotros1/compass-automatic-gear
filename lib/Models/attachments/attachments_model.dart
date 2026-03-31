class AttachmentsModel {
  String? id;
  String? name;
  String? file;

  AttachmentsModel({this.id, this.name, this.file});

  AttachmentsModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id'] ?? "" : "";
    name = json.containsKey('name') ? json['name'] ?? "" : "";
    file = json.containsKey('attach_url') ? json['attach_url'] ?? "" : "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['attach_url'] = file;

    return data;
  }
}
