class ToDoListModel {
  String? id;
  String? number;
  DateTime? date;
  DateTime? dueDate;
  String? createdBy;
  String? createdById;
  String? assignedTo;
  String? assignedToId;
  String? status;
  int? unreadNotes;
  DateTime? createdAt;
  DateTime? updatedAt;

  ToDoListModel({
    this.id,
    this.number,
    this.date,
    this.dueDate,
    this.createdBy,
    this.assignedTo,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  ToDoListModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id'] ?? '' : '';
    number = json.containsKey('number') ? json['number'] ?? '' : '';
    date = json.containsKey('date') ? DateTime.tryParse(json['date']) : null;
    dueDate = json.containsKey('due_date')
        ? DateTime.tryParse(json['due_date'])
        : null;
    createdById = json.containsKey('created_by')
        ? json['created_by'] ?? ''
        : '';
    createdBy = json.containsKey('created_by_name')
        ? json['created_by_name'] ?? ''
        : '';
    assignedToId = json.containsKey('assigned_to')
        ? json['assigned_to'] ?? ''
        : '';
    assignedTo = json.containsKey('assigned_to_name')
        ? json['assigned_to_name'] ?? ''
        : '';
    unreadNotes = json.containsKey('unread_notes_count')
        ? json['unread_notes_count'] ?? 0
        : 0;
    status = json.containsKey('status') ? json['status'] ?? '' : '';
    createdAt = json.containsKey('createdAt')
        ? DateTime.tryParse(json['createdAt'])
        : null;
    updatedAt = json.containsKey('updatedAt')
        ? DateTime.tryParse(json['updatedAt'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['number'] = number;
    data['date'] = date;
    data['due_date'] = dueDate;
    data['created_by'] = createdBy;
    data['assigned_to'] = assignedTo;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
