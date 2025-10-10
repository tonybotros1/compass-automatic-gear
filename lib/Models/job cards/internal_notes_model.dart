class InternalNotesModel {
  String? id;
  String? jobCardId;
  String? companyId;
  String? userId;
  String? userName;
  String? type;
  String? note;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? fileName;
  String? notePublicId;
  bool? isThisUserIsTheCurrentUser;

  InternalNotesModel({
    this.jobCardId,
    this.companyId,
    this.userId,
    this.userName,
    this.type,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.fileName,
    this.notePublicId,
    this.id,
    this.isThisUserIsTheCurrentUser,
  });

  InternalNotesModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? '';
    jobCardId = json['job_card_id'] ?? '';
    companyId = json['company_id'] ?? '';
    userId = json['user_id'] ?? '';
    userName = json['user_name'] ?? '';
    type = json['type'] ?? '';
    note = json['note'] ?? '';
    createdAt = DateTime.tryParse(json['createdAt']);
    updatedAt = DateTime.tryParse(json['updatedAt']);
    fileName = json['file_name'] ?? '';
    notePublicId = json['note_public_id'] ?? '';
    isThisUserIsTheCurrentUser =
        json['is_this_user_is_the_current_user'] ?? false;
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['_id'] = id;
  //   data['job_card_id'] = jobCardId;
  //   data['company_id'] = companyId;
  //   data['user_id'] = userId;
  //   data['type'] = type;
  //   data['note'] = note;
  //   data['createdAt'] = createdAt;
  //   data['updatedAt'] = updatedAt;
  //   data['file_name'] = fileName;
  //   data['note_public_id'] = notePublicId;
  //   return data;
  // }
}
