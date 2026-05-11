class JobItemsSummaryTable {
  double? vat;
  String? invoiceNumber;
  DateTime? issueDate;
  String? itemCode;
  String? itemName;
  int? quantity;
  double? price;
  double? total;
  double? net;

  JobItemsSummaryTable({
    this.vat,
    this.invoiceNumber,
    this.issueDate,
    this.itemCode,
    this.itemName,
    this.quantity,
    this.price,
    this.total,
    this.net,
  });

  double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  JobItemsSummaryTable.fromJson(Map<String, dynamic> json) {
    vat = _toDouble(json['vat']);
    invoiceNumber = json.containsKey('invoice_number')
        ? json['invoice_number'] ?? ''
        : "";
    issueDate = json.containsKey('issue_date')
        ? json['issue_date'] != null
              ? DateTime.tryParse(json['issue_date'])
              : null
        : null;
    itemCode = json.containsKey('item_code') ? json['item_code'] ?? '' : '';
    itemName = json.containsKey('item_name') ? json['item_name'] ?? '' : '';
    quantity = _toInt(json['quantity']);
    price = _toDouble(json['price']);
    total = _toDouble(json['total']);
    net = _toDouble(json['net']);
  }
}
