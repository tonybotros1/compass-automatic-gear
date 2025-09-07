class City {
  final String id;
  final String name;
  final String code;
  final bool available;
  final DateTime createdAt;
  final DateTime updatedAt;

  City({
    required this.id,
    required this.name,
    required this.code,
    required this.available,
    required this.createdAt,
    required this.updatedAt,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'],
      available: json['available'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
