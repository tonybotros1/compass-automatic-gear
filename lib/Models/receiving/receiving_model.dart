import 'receiving_items_model.dart';

class ReceivingModel {
  String? id;
  DateTime? date;
  String? branch;
  String? referenceNumber;
  String? vendor;
  String? note;
  String? currency;
  String? currencyCode;
  double? rate;
  String? approvedBy;
  String? orderedBy;
  String? purchasedBy;
  double? shipping;
  double? handling;
  double? other;
  double? amount;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? companyId;
  String? receivingNumber;
  List<ReceivingItemsModel>? itemsDetails;
  String? approvedByName;
  String? orderedByName;
  String? purchasedByName;
  String? branchName;
  String? vendorName;
  double? totals;
  double? vats;
  double? net;

  ReceivingModel({
    this.id,
    this.date,
    this.branch,
    this.referenceNumber,
    this.vendor,
    this.note,
    this.currency,
    this.currencyCode,
    this.rate,
    this.approvedBy,
    this.orderedBy,
    this.purchasedBy,
    this.shipping,
    this.handling,
    this.other,
    this.amount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.companyId,
    this.receivingNumber,
    this.itemsDetails,
    this.approvedByName,
    this.orderedByName,
    this.purchasedByName,
    this.branchName,
    this.vendorName,
    this.net,
    this.totals,
    this.vats,
  });

  ReceivingModel.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString();

    // Date fields — safely parse from ISO or Firestore date
    date = json['date'] != null
        ? DateTime.tryParse(json['date'].toString())
        : null;
    createdAt = json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'].toString())
        : null;
    updatedAt = json['updatedAt'] != null
        ? DateTime.tryParse(json['updatedAt'].toString())
        : null;

    branch = json['branch']?.toString();
    referenceNumber = json['reference_number']?.toString();
    vendor = json['vendor']?.toString();
    note = json['note']?.toString();
    currency = json['currency']?.toString();
    currencyCode = json['currency_code']?.toString();

    rate = json['rate'] != null
        ? double.tryParse(json['rate'].toString())
        : null;

    approvedBy = json['approved_by']?.toString();
    orderedBy = json['ordered_by']?.toString();
    purchasedBy = json['purchased_by']?.toString();

    shipping = json['shipping'] != null
        ? double.tryParse(json['shipping'].toString())
        : null;
    handling = json['handling'] != null
        ? double.tryParse(json['handling'].toString())
        : null;
    other = json['other'] != null
        ? double.tryParse(json['other'].toString())
        : null;
    amount = json['amount'] != null
        ? double.tryParse(json['amount'].toString())
        : null;

    status = json['status']?.toString();
    companyId = json['company_id']?.toString();
    receivingNumber = json['receiving_number']?.toString();

    if (json['items_details'] != null && json['items_details'] is List) {
      itemsDetails = (json['items_details'] as List)
          .map((v) => ReceivingItemsModel.fromJson(v))
          .toList();
    }

    approvedByName = json['approved_by_name']?.toString();
    orderedByName = json['ordered_by_name']?.toString();
    purchasedByName = json['purchased_by_name']?.toString();
    branchName = json['branch_name']?.toString();
    vendorName = json['vendor_name']?.toString();
    totals = json["totals"] ?? 0;
    vats = json["vats"] ?? 0;
    net = json["nets"] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['_id'] = id;
    data['date'] = date?.toIso8601String();
    data['branch'] = branch;
    data['reference_number'] = referenceNumber;
    data['vendor'] = vendor;
    data['note'] = note;
    data['currency'] = currency;
    data['rate'] = rate;
    data['approved_by'] = approvedBy;
    data['ordered_by'] = orderedBy;
    data['purchased_by'] = purchasedBy;
    data['shipping'] = shipping;
    data['handling'] = handling;
    data['other'] = other;
    data['amount'] = amount;
    data['status'] = status;
    data['createdAt'] = createdAt?.toIso8601String();
    data['updatedAt'] = updatedAt?.toIso8601String();
    data['company_id'] = companyId;
    data['receiving_number'] = receivingNumber;

    if (itemsDetails != null) {
      data['items_details'] = itemsDetails!.map((v) => v.toJson()).toList();
    }

    data['approved_by_name'] = approvedByName;
    data['ordered_by_name'] = orderedByName;
    data['purchased_by_name'] = purchasedByName;
    data['branch_name'] = branchName;
    data['vendor_name'] = vendorName;

    return data;
  }
}
