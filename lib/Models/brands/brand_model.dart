class Brand {
  final String id;
  String? name;
  String? logo;
  bool? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  Brand({
    required this.id,
    this.name,
    this.logo,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      logo: json['logo'] ?? '',
      status: json['status'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
