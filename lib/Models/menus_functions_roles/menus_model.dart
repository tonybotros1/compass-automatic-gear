class MenuModel {
  final String id;
  final String name;
  final String routeName;
  final String code;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List children;

  MenuModel({
    required this.id,
    required this.name,
    required this.routeName,
    required this.code,
    required this.createdAt,
    required this.updatedAt,
    required this.children,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      routeName: json['route_name'] ?? '',
      code: json['code'] ?? '',
      children: json["children"],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map toMap() {
    return {
      id: {
        name: name,
        routeName: routeName,
        code: code,
        children: children,
        createdAt: createdAt,
        updatedAt: updatedAt,
      },
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['route_name'] = routeName;
    data['children'] = children;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
