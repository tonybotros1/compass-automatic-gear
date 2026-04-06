class PhoneModel {
  String? id;
  String? type;
  String? phone;
  String? employeeId;
  String? typeName;

  PhoneModel({this.id, this.type, this.phone, this.employeeId, this.typeName});

  PhoneModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id'] ?? '' : '';
    type = json.containsKey('type') ? json['type'] ?? '' : '';
    phone = json.containsKey('phone') ? json['phone'] ?? '' : '';
    employeeId = json.containsKey('employee_id')
        ? json['employee_id'] ?? ''
        : '';
    typeName = json.containsKey('type_name') ? json['type_name'] ?? '' : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['type'] = type;
    data['phone'] = phone;
    data['employee_id'] = employeeId;
    data['type_name'] = typeName;
    return data;
  }
}
