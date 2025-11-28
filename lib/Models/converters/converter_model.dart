class ConverterModel {
  String? id;
  DateTime? date;
  String? converterNumber;
  String? name;
  String? description;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  double? total;
  double? vat;
  double? net;

  ConverterModel({
    this.id,
    this.date,
    this.converterNumber,
    this.name,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  ConverterModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id'] ?? '' : '';
    date = json.containsKey('date') ? DateTime.tryParse(json['date']) : null;
    converterNumber = json.containsKey('converter_number')
        ? json['converter_number'] ?? ''
        : '';
    total = json.containsKey('total') ? json['total'] ?? 0 : 0;
    vat = json.containsKey('vat') ? json['vat'] ?? 0 : 0;
    net = json.containsKey('net') ? json['net'] ?? 0 : 0;
    name = json.containsKey('name') ? json['name'] ?? '' : '';
    description = json.containsKey('description')
        ? json['description'] ?? ''
        : '';
    status = json.containsKey('status') ? json['status'] ?? '' : '';
    createdAt = json.containsKey('createdAt')
        ? DateTime.tryParse(json['createdAt'])
        : null;
    createdAt = json.containsKey('updatedAt')
        ? DateTime.tryParse(json['updatedAt'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['converter_number'] = converterNumber;
    data['name'] = name;
    data['description'] = description;
    return data;
  }
}
