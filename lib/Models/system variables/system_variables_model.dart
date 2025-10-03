class SystemVariablesModel {
  String? id;
  DateTime? createdAt;
  String? code;
  DateTime? updatedAt;
  String? value;

  SystemVariablesModel({
    this.id,
    this.createdAt,
    this.code,
    this.updatedAt,
    this.value,
  });

  SystemVariablesModel.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString() ?? '';
    createdAt = json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'].toString())
        : null;
    code = json['code']?.toString() ?? '';
    updatedAt = json['updatedAt'] != null
        ? DateTime.tryParse(json['updatedAt'].toString())
        : null;
    value = json['value']?.toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['createdAt'] = createdAt;
    data['code'] = code;
    data['updatedAt'] = updatedAt;
    data['value'] = value;
    return data;
  }
}
