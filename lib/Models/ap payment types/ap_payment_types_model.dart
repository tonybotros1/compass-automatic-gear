class APPaymentTypesModel {
  String? id;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;

  APPaymentTypesModel({this.id, this.type, this.createdAt, this.updatedAt});

  APPaymentTypesModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id'] ?? '' : '';
    type = json.containsKey('type') ? json['type'] ?? '' : '';
    createdAt = json.containsKey('createdAt')
        ? DateTime.parse(json['createdAt'])
        : null;
    updatedAt = DateTime.parse(json['updatedAt']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['type'] = type;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
