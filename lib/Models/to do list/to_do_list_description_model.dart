class ToDoListDescriptionModel {
  String? id;
  String? toDoListId;
  String? userId;
  String? userName;
  String? type;
  String? description;
  String? companyId;
  bool? isThisUserTheCurrentUser;
  DateTime? createdAt;
  DateTime? updatedAt;

  ToDoListDescriptionModel({
    this.toDoListId,
    this.id,
    this.userId,
    this.type,
    this.description,
    this.companyId,
    this.createdAt,
    this.updatedAt,
    this.isThisUserTheCurrentUser,
  });

  ToDoListDescriptionModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id'] ?? '' : '';
    toDoListId = json.containsKey('to_do_list_id')
        ? json['to_do_list_id'] ?? ''
        : '';
    userId = json.containsKey('user_id') ? json['user_id'] ?? '' : '';
    userName = json.containsKey('user_name') ? json['user_name'] ?? '' : '';
    type = json.containsKey('type') ? json['type'] ?? '' : '';
    description = json.containsKey('description')
        ? json['description'] ?? ''
        : '';
    companyId = json.containsKey('company_id') ? json['company_id'] ?? '' : '';
    createdAt = json.containsKey('createdAt')
        ? DateTime.tryParse(json['createdAt'])
        : null;
    updatedAt = json.containsKey('updatedAt')
        ? DateTime.tryParse(json['updatedAt'])
        : null;
    isThisUserTheCurrentUser = json.containsKey('isThisUserTheCurrentUser')
        ? json['isThisUserTheCurrentUser'] ?? false
        : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['to_do_list_id'] = toDoListId;
    data['user_id'] = userId;
    data['type'] = type;
    data['description'] = description;
    data['company_id'] = companyId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
