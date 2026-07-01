class EmailModel {
  String? id;
  String? email;
  String? type;
  String? typeId;
  bool useForPayslips;

  EmailModel({
    this.id,
    this.email,
    this.type,
    this.typeId,
    this.useForPayslips = false,
  });

  EmailModel.fromJson(Map<String, dynamic> json)
    : useForPayslips = json['use_for_payslips'] == true {
    id = json.containsKey('_id') ? json['_id'] ?? '' : '';
    email = json.containsKey('email') ? json['email'] ?? '' : '';
    type = json.containsKey('type_name') ? json['type_name'] ?? '' : '';
    typeId = json.containsKey('type') ? json['type'] ?? '' : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['email'] = email;
    data['type'] = type;
    data['type_id'] = typeId;
    data['use_for_payslips'] = useForPayslips;
    return data;
  }
}
