class BranchesModel {
  final String id;
  final String name;
  final String code;
  final String countryId;
  final String country;
  final String cityId;
  final String city;
  final String line;
  bool status;
  final DateTime createdAt;
  final DateTime updatedAt;

  BranchesModel({
    required this.id,
    required this.name,
    required this.code,
    required this.countryId,
    required this.country,
    required this.cityId,
    required this.city,
    required this.line,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BranchesModel.fromJson(Map<String, dynamic> json) {
    return BranchesModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      cityId: json['city_id'] ?? '',
      city: json['city'] ?? '',
      countryId: json['country_id'] ?? '',
      country: json['country'] ?? '',
      line: json['line'] ?? '',
      status: json['status'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
