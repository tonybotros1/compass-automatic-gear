class CountersModel {
  final String id;
  final String code;
  final String companyId;
  final String description;
  final int length;
  final String prefix;
  final String separator;
  final int value;
  final bool status;
  final DateTime createdAt;
  final DateTime updatedAt;

  CountersModel({
    required this.id,
    required this.code,
    required this.companyId,
    required this.description,
    required this.length,
    required this.prefix,
    required this.separator,
    required this.value,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CountersModel.fromJson(Map<String, dynamic> json) {
    return CountersModel(
      id: json['_id'] ?? '',
      code: json['code'] ?? '',
      companyId: json['company_id'] ?? '',
      description: json['description'] ?? '',
      length: json['length'] ?? 0,
      prefix: json['prefix'] ?? '',
      separator: json['separator'] ?? '',
      value: json['value'] ?? 0,
      status: json['status'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
