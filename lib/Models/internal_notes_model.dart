class InternalNotesModel {
  String? fileName;
  String? type;
  String? note;
  String? userId;
  DateTime? time;

  InternalNotesModel(
      {this.fileName, this.type, this.note, this.userId, this.time});

  InternalNotesModel.fromJson(Map<String, dynamic> json) {
    fileName = json['file_name'];
    type = json['type'];
    note = json['note'];
    userId = json['user_id'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['file_name'] = fileName;
    data['type'] = type;
    data['note'] = note;
    data['user_id'] = userId;
    data['time'] = time;
    return data;
  }
}
