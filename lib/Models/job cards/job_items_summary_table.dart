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

  JobItemsSummaryTable.fromJson(Map<String, dynamic> json) {
    vat = json.containsKey('vat') ? json['vat'] : 0;
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
    quantity = json.containsKey('quantity') ? json['quantity'] ?? 0 : 0;
    price = json.containsKey('price') ? json['price'] ?? 0 : 0;
    total = json.containsKey('total') ? json['total'] ?? 0 : 0;
    net = json.containsKey('net') ? json['net'] ?? 0 : 0;
  }
}
