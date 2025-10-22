class EmployeePerformanceModel {
  String? id;
  String? name;
  int? totalAmount;
  int? totalTasks;
  int? points;
  List<CompletedSheetsInfos>? completedSheetsInfos;
  double? amt;
  int? totalWorkedHours;
  int? totalWorkedMinutes;
  int? totalWorkedSeconds;
  String? timeString;

  EmployeePerformanceModel({
    this.id,
    this.name,
    this.totalAmount,
    this.totalTasks,
    this.points,
    this.completedSheetsInfos,
    this.amt,
    this.totalWorkedHours,
    this.totalWorkedMinutes,
    this.totalWorkedSeconds,
    this.timeString,
  });

  EmployeePerformanceModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id']?.toString() : null;
    name = json.containsKey('name') ? json['name']?.toString() : null;
    totalAmount = json.containsKey('total_amount') ? json['total_amount'] as int? : null;
    totalTasks = json.containsKey('total_tasks') ? json['total_tasks'] as int? : null;
    points = json.containsKey('points') ? json['points'] as int? : null;

    if (json.containsKey('completed_sheets_infos') && json['completed_sheets_infos'] is List) {
      completedSheetsInfos = (json['completed_sheets_infos'] as List)
          .map((v) => CompletedSheetsInfos.fromJson(v))
          .toList();
    }

    amt = json.containsKey('AMT') ? (json['AMT'] is num ? json['AMT'].toDouble() : null) : null;
    totalWorkedHours = json.containsKey('total_worked_hours') ? json['total_worked_hours'] as int? : null;
    totalWorkedMinutes = json.containsKey('total_worked_minutes') ? json['total_worked_minutes'] as int? : null;
    totalWorkedSeconds = json.containsKey('total_worked_seconds') ? json['total_worked_seconds'] as int? : null;
    timeString = json.containsKey('time_string') ? json['time_string']?.toString() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['total_amount'] = totalAmount;
    data['total_tasks'] = totalTasks;
    data['points'] = points;
    if (completedSheetsInfos != null) {
      data['completed_sheets_infos'] = completedSheetsInfos!.map((v) => v.toJson()).toList();
    }
    data['AMT'] = amt;
    data['total_worked_hours'] = totalWorkedHours;
    data['total_worked_minutes'] = totalWorkedMinutes;
    data['total_worked_seconds'] = totalWorkedSeconds;
    data['time_string'] = timeString;
    return data;
  }
}

class CompletedSheetsInfos {
  String? id;
  String? brandName;
  String? modelName;
  DateTime? startDate;
  DateTime? endDate;
  String? nameEn;
  String? nameAr;
  int? points;
  int? minutes;
  int? seconds;

  CompletedSheetsInfos({
    this.id,
    this.brandName,
    this.modelName,
    this.startDate,
    this.endDate,
    this.nameEn,
    this.nameAr,
    this.points,
    this.minutes,
    this.seconds,
  });

  CompletedSheetsInfos.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id']?.toString() : null;
    brandName = json.containsKey('brand_name') ? json['brand_name']?.toString() : null;
    modelName = json.containsKey('model_name') ? json['model_name']?.toString() : null;

    if (json.containsKey('start_date') && json['start_date'] != null) {
      startDate = DateTime.tryParse(json['start_date'].toString());
    }
    if (json.containsKey('end_date') && json['end_date'] != null) {
      endDate = DateTime.tryParse(json['end_date'].toString());
    }

    nameEn = json.containsKey('name_en') ? json['name_en']?.toString() : null;
    nameAr = json.containsKey('name_ar') ? json['name_ar']?.toString() : null;
    points = json.containsKey('points') ? json['points'] as int? : null;
    minutes = json.containsKey('minutes') ? json['minutes'] as int? : null;
    seconds = json.containsKey('seconds') ? json['seconds'] as int? : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['brand_name'] = brandName;
    data['model_name'] = modelName;
    data['start_date'] = startDate?.toIso8601String();
    data['end_date'] = endDate?.toIso8601String();
    data['name_en'] = nameEn;
    data['name_ar'] = nameAr;
    data['points'] = points;
    data['minutes'] = minutes;
    data['seconds'] = seconds;
    return data;
  }
}
