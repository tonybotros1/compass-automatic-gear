// class ConverterModel {
//   String? id;
//   DateTime? date;
//   String? converterNumber;
//   String? name;
//   String? description;
//   String? status;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   double? total;
//   double? vat;
//   double? net;

//   ConverterModel({
//     this.id,
//     this.date,
//     this.converterNumber,
//     this.name,
//     this.description,
//     this.status,
//     this.createdAt,
//     this.updatedAt,
//   });

//   ConverterModel.fromJson(Map<String, dynamic> json) {
//     id = json.containsKey('_id') ? json['_id'] ?? '' : '';
//     date = json.containsKey('date') ? DateTime.tryParse(json['date']) : null;
//     converterNumber = json.containsKey('converter_number')
//         ? json['converter_number'] ?? ''
//         : '';
//     total = json.containsKey('total') ? json['total'] ?? 0 : 0;
//     vat = json.containsKey('vat') ? json['vat'] ?? 0 : 0;
//     net = json.containsKey('net') ? json['net'] ?? 0 : 0;
//     name = json.containsKey('name') ? json['name'] ?? '' : '';
//     description = json.containsKey('description')
//         ? json['description'] ?? ''
//         : '';
//     status = json.containsKey('status') ? json['status'] ?? '' : '';
//     createdAt = json.containsKey('createdAt')
//         ? DateTime.tryParse(json['createdAt'])
//         : null;
//     createdAt = json.containsKey('updatedAt')
//         ? DateTime.tryParse(json['updatedAt'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['date'] = date;
//     data['converter_number'] = converterNumber;
//     data['name'] = name;
//     data['description'] = description;
//     return data;
//   }
// }

class ConverterModel {
  String? id;
  DateTime? date;
  String? name;
  String? description;
  String? status;
  String? companyId;
  String? converterNumber;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Issues>? issues;
  double? total;

  ConverterModel({
    this.id,
    this.date,
    this.name,
    this.description,
    this.status,
    this.companyId,
    this.converterNumber,
    this.createdAt,
    this.updatedAt,
    this.total,
    this.issues,
  });

  ConverterModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    date = json.containsKey('date') ? DateTime.tryParse(json['date']) : null;
    name = json.containsKey('name') ? json['name'] ?? '' : '';
    description = json.containsKey('description')
        ? json['description'] ?? ''
        : '';
    status = json['status'];
    converterNumber = json.containsKey('converter_number')
        ? json['converter_number'] ?? ''
        : '';
    createdAt = json.containsKey('createdAt')
        ? DateTime.tryParse(json['createdAt'])
        : null;
    createdAt = json.containsKey('updatedAt')
        ? DateTime.tryParse(json['updatedAt'])
        : null;
    total = json.containsKey('totals') ? json['totals'] ?? 0 : 0;
    if (json['issues'] != null) {
      issues = <Issues>[];
      json['issues'].forEach((v) {
        issues!.add(Issues.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['date'] = date;
    data['name'] = name;
    data['description'] = description;
    data['status'] = status;
    data['company_id'] = companyId;
    data['converter_number'] = converterNumber;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (issues != null) {
      data['issues'] = issues!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Issues {
  String? id;
  String? issuingNumber;
  DateTime? date;
  String? itemName;
  String? itemCode;
  String? status;
  int? quantity;
  double? price;
  double? total;

  Issues({
    this.id,
    this.issuingNumber,
    this.date,
    this.itemName,
    this.itemCode,
    this.quantity,
    this.price,
    this.total,
    this.status,
  });

  Issues.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    issuingNumber = json.containsKey('issuing_number')
        ? json['issuing_number'] ?? ''
        : '';
    date = json.containsKey('date') ? DateTime.tryParse(json['date']) : null;
    itemName = json.containsKey('item_name') ? json['item_name'] ?? '' : '';
    itemCode = json.containsKey('item_code') ? json['item_code'] ?? '' : '';
    quantity = json.containsKey('quantity') ? json['quantity'] ?? 0 : 0;
    price = json.containsKey('price') ? json['price'] ?? 0 : 0;
    total = json.containsKey('total') ? json['total'] ?? 0 : 0;
    status = json.containsKey('status') ? json['status'] ?? '' : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['issuing_number'] = issuingNumber;
    data['date'] = date;
    data['item_name'] = itemName;
    data['item_code'] = itemCode;
    data['quantity'] = quantity;
    data['price'] = price;
    data['total'] = total;
    return data;
  }
}
