class Country {
  final String id;
  final String name;
  final String code;
  final String callingCode;
  final String currencyName;
  final String currencyCode;
  final String flag;
  final double vat;
  final bool status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Country({
    required this.id,
    required this.name,
    required this.code,
    required this.flag,
    required this.currencyName,
    required this.currencyCode,
    required this.callingCode,
    required this.vat,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      flag: json['flag'] ?? '',
      callingCode: json['calling_code'] ?? '',
      code: json['code'] ?? '',
      currencyCode: json['currency_code'] ?? '',
      currencyName: json['currency_name'] ?? '',
      vat: json['vat'] ?? 0,
      status: json['status'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
