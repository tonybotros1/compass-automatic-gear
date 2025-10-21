class TimeSheetsModel {
  String? id;
  List<ActivePeriods>? activePeriods;
  String? companyId;
  String? employeeId;
  DateTime? endDate;
  String? jobId;
  DateTime? startDate;
  String? taskId;
  String? employeeName;
  String? taskArName;
  String? taskEnName;
  String? brandName;
  String? modelName;
  String? plateNumber;
  String? color;
  String? logo;

  TimeSheetsModel({
    this.id,
    this.activePeriods,
    this.companyId,
    this.employeeId,
    this.endDate,
    this.jobId,
    this.startDate,
    this.taskId,
    this.employeeName,
    this.taskArName,
    this.taskEnName,
    this.brandName,
    this.modelName,
    this.plateNumber,
    this.logo,
    this.color,
  });
  TimeSheetsModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id']?.toString() : null;

    if (json.containsKey('active_periods') && json['active_periods'] != null) {
      activePeriods = <ActivePeriods>[];
      for (var v in json['active_periods']) {
        activePeriods!.add(ActivePeriods.fromJson(v));
      }
    } else {
      activePeriods = null;
    }

    companyId = json.containsKey('company_id')
        ? json['company_id']?.toString()
        : null;
    employeeId = json.containsKey('employee_id')
        ? json['employee_id']?.toString()
        : null;
    jobId = json.containsKey('job_id') ? json['job_id']?.toString() : null;
    taskId = json.containsKey('task_id') ? json['task_id']?.toString() : null;

    startDate = (json.containsKey('start_date') && json['start_date'] != null)
        ? DateTime.tryParse(json['start_date'].toString())
        : null;

    endDate = (json.containsKey('end_date') && json['end_date'] != null)
        ? DateTime.tryParse(json['end_date'].toString())
        : null;

    employeeName = json.containsKey('employee_name')
        ? json['employee_name']?.toString()
        : null;
    taskArName = json.containsKey('task_ar_name')
        ? json['task_ar_name']?.toString()
        : null;
    taskEnName = json.containsKey('task_en_name')
        ? json['task_en_name']?.toString()
        : null;
    brandName = json.containsKey('brand_name')
        ? json['brand_name']?.toString()
        : null;
    modelName = json.containsKey('model_name')
        ? json['model_name']?.toString()
        : null;
    plateNumber = json.containsKey('plate_number')
        ? json['plate_number']?.toString()
        : null;
    color = json.containsKey('color') ? json['color']?.toString() : null;
    logo = json.containsKey('logo') ? json['logo']?.toString() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    if (activePeriods != null) {
      data['active_periods'] = activePeriods!.map((v) => v.toJson()).toList();
    }
    data['company_id'] = companyId;
    data['employee_id'] = employeeId;
    data['end_date'] = endDate;
    data['job_id'] = jobId;
    data['start_date'] = startDate;
    data['task_id'] = taskId;
    data['employee_name'] = employeeName;
    data['task_ar_name'] = taskArName;
    data['task_en_name'] = taskEnName;
    data['brand_name'] = brandName;
    data['model_name'] = modelName;
    data['plate_number'] = plateNumber;
    data['color'] = color;
    return data;
  }
}

class ActivePeriods {
  DateTime? from;
  DateTime? to;
  ActivePeriods({this.from, this.to});
  ActivePeriods.fromJson(Map<String, dynamic> json) {
  from = (json.containsKey('from') && json['from'] != null)
      ? DateTime.tryParse(json['from'].toString())
      : null;

  to = (json.containsKey('to') && json['to'] != null)
      ? DateTime.tryParse(json['to'].toString())
      : null;
}


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['from'] = from;
    data['to'] = to;
    return data;
  }
}
