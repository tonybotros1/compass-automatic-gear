class RoleModel {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isShownForUsers;
  final String menu;
  final String menuId;
  final String menuCode;

  RoleModel({
    required this.id,
    required this.name,
    required this.menuId,
    required this.menu,
    required this.menuCode,
    required this.isShownForUsers,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['_id'] ?? '',
      name: json['role_name'] ?? '',
      isShownForUsers: json['is_shown_for_users'] ?? '',
      menuId: json["menu_id"] ?? '',
      menu: json['menu_name'] ?? '',
      menuCode: json['code'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['role_name'] = name;
    data['menu_id'] = menuId;
    data['menu_name'] = menu;
    data['menu_code'] = menuCode;
    data['is_shown_for_users'] = isShownForUsers;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
