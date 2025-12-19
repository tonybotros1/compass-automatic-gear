class UsersModel {
  final String id;
  final String userName;
  final String email;
  bool status;
  final List<String> roles;
  final List<String> branches;
  final DateTime expiryDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  UsersModel({
    required this.createdAt,
    required this.email,
    required this.expiryDate,
    required this.id,
    required this.roles,
    required this.status,
    required this.updatedAt,
    required this.userName,
    required this.branches
  });

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      id: json['_id'],
      userName: json['user_name'],
      email: json['email'],
      roles: json['roles'].cast<String>(),
      branches: json['branches'].cast<String>(),
      status: json['status'],
      expiryDate: DateTime.parse(json['expiry_date']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
