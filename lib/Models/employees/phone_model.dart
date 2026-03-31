class PhoneModel {
  String? id;
  String? phone;
  String? type;
  String? typeId;

  PhoneModel({this.id, this.phone, this.type, this.typeId});

  PhoneModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    type = json['type'];
    typeId = json['type_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phone'] = phone;
    data['type'] = type;
    data['type_id'] = typeId;
    return data;
  }
}
