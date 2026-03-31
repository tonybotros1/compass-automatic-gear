class EmailModel {
  String? id;
  String? email;
  String? type;
  String? typeId;

  EmailModel({this.id, this.email, this.type, this.typeId});

  EmailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    type = json['type'];
    typeId = json['type_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['type'] = type;
    data['type_id'] = typeId;
    return data;
  }
}
