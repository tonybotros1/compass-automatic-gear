class CarTradingPurchaseAgreementModel {
  String? id;
  final String? agreementNumber;
  final DateTime? agreementDate;
  final String? sellerName;
  final String? sellerID;
  final String? sellerPhone;
  final String? sellerEmail;
  final String? buyerName;
  final String? buyerID;
  final String? buyerPhone;
  final String? buyerEmail;
  final String? note;
  final double? amount;
  final double? aownpayment;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  bool added = false;
  bool modified = false;
  bool deleted = false;

  CarTradingPurchaseAgreementModel({
    this.id,
    this.agreementNumber,
    this.agreementDate,
    this.sellerName,
    this.sellerID,
    this.sellerEmail,
    this.sellerPhone,
    this.buyerEmail,
    this.buyerID,
    this.buyerName,
    this.buyerPhone,
    this.note,
    this.amount,
    this.aownpayment,
    this.modified = false,
    this.deleted = false,
    this.createdAt,
    this.updatedAt,
    this.added = false,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "_id": id,
      "agreement_number": agreementNumber,
      "agreement_date": agreementDate,
      "seller_name": sellerName,
      "seller_id": sellerID,
      "seller_phone": sellerPhone,
      "seller_email": sellerEmail,
      "buyer_name": buyerName,
      "buyer_id": buyerID,
      "buyer_phone": buyerPhone,
      "buyer_email": buyerEmail,
      "note": note,
      "amount": amount,
      "downpayment": aownpayment,
      "deleted": deleted,
      "modified": modified,
    };
  }

  /// Helper to parse doubles safely
  static double? _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    if (value is String && value.trim().isNotEmpty) {
      return double.tryParse(value) ?? 0;
    }
    return 0;
  }

  factory CarTradingPurchaseAgreementModel.fromJson(Map<String, dynamic> json) {
    return CarTradingPurchaseAgreementModel(
      id: json['_id'] ?? '',
      agreementNumber: json['agreement_number'] ?? '',
      agreementDate:
          json['agreement_date'] != null && json['agreement_date'] != ''
          ? DateTime.tryParse(json['agreement_date'])
          : null,
      aownpayment: _toDouble(json['agreement_down_payment']),
      amount: _toDouble(json['agreement_amount']),
      sellerName: json.containsKey('seller_name')
          ? json['seller_name'] ?? ''
          : '',
      sellerEmail: json.containsKey('seller_email')
          ? json['seller_email'] ?? ''
          : '',
      sellerID: json['seller_ID'] ?? '',
      note: json.containsKey('note') ? json['note'] ?? '' : '',
      sellerPhone: json['seller_phone'] ?? '',
      buyerEmail: json['buyer_email'] ?? '',
      buyerID: json['buyer_ID'] ?? '',
      buyerName: json['buyer_name'] ?? '',
      buyerPhone: json['buyer_phone'] ?? '',
      createdAt: json['createdAt'] != null && json['createdAt'] != ''
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null && json['updatedAt'] != ''
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }
}
