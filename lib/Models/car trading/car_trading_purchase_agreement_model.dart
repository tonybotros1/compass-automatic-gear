class CarTradingPurchaseAgreementModel {
  String? id;
  final String? tradeId;
  final String? agreementNumber;
  final DateTime? agreementDate;
  final String agreementType;
  final String paymentMethod;
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
    this.tradeId,
    this.agreementNumber,
    this.agreementDate,
    this.agreementType = 'sell',
    this.paymentMethod = '',
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

  bool get isPurchase => agreementType == 'buy';

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "_id": id,
      if (tradeId != null) "trade_id": tradeId,
      "agreement_number": agreementNumber,
      "agreement_date": agreementDate?.toIso8601String(),
      "agreement_type": agreementType,
      "payment_method": paymentMethod,
      "seller_name": sellerName,
      "seller_ID": sellerID,
      "seller_phone": sellerPhone,
      "seller_email": sellerEmail,
      "buyer_name": buyerName,
      "buyer_ID": buyerID,
      "buyer_phone": buyerPhone,
      "buyer_email": buyerEmail,
      "note": note,
      "agreement_amount": amount,
      "agreement_down_payment": aownpayment,
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
      id: json['_id']?.toString() ?? '',
      tradeId: json['trade_id']?.toString() ?? '',
      agreementNumber: json['agreement_number']?.toString() ?? '',
      // Historical records used the sales template before a type was stored.
      agreementType: json['agreement_type'] == 'buy' ? 'buy' : 'sell',
      paymentMethod: json['payment_method']?.toString() ?? '',
      agreementDate:
          json['agreement_date'] != null && json['agreement_date'] != ''
          ? DateTime.tryParse(json['agreement_date'].toString())
          : null,
      aownpayment: _toDouble(
        json['agreement_down_payment'] ?? json['downpayment'],
      ),
      amount: _toDouble(json['agreement_amount'] ?? json['amount']),
      sellerName: json.containsKey('seller_name')
          ? json['seller_name']?.toString() ?? ''
          : '',
      sellerEmail: json.containsKey('seller_email')
          ? json['seller_email']?.toString() ?? ''
          : '',
      sellerID: (json['seller_ID'] ?? json['seller_id'])?.toString() ?? '',
      note: json.containsKey('note') ? json['note']?.toString() ?? '' : '',
      sellerPhone: json['seller_phone']?.toString() ?? '',
      buyerEmail: json['buyer_email']?.toString() ?? '',
      buyerID: (json['buyer_ID'] ?? json['buyer_id'])?.toString() ?? '',
      buyerName: json['buyer_name']?.toString() ?? '',
      buyerPhone: json['buyer_phone']?.toString() ?? '',
      deleted: json['deleted'] == true,
      modified: json['modified'] == true,
      createdAt: json['createdAt'] != null && json['createdAt'] != ''
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null && json['updatedAt'] != ''
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }
}
