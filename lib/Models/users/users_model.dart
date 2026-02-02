class UsersModel {
  final String id;
  final String userName;
  final String email;
  final String primaryBranch;
  bool status;
  final bool isAdmin;
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
    required this.primaryBranch,
    required this.status,
    required this.updatedAt,
    required this.userName,
    required this.branches,
    required this.isAdmin,
  });

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      id: json['_id'],
      userName: json['user_name'],
      email: json['email'],
      roles: json['roles'].cast<String>(),
      primaryBranch: json.containsKey('primary_branch')
          ? json['primary_branch'] ?? ''
          : '',
      isAdmin: json.containsKey('is_admin') ? json['is_admin'] ?? false : false,
      branches: json['branches'].cast<String>(),
      status: json['status'],
      expiryDate: DateTime.parse(json['expiry_date']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
