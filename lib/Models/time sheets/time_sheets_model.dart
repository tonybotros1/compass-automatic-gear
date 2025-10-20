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
    id = json['_id'];
    if (json['active_periods'] != null) {
      activePeriods = <ActivePeriods>[];
      json['active_periods'].forEach((v) {
        activePeriods!.add(ActivePeriods.fromJson(v));
      });
    }
    companyId = json['company_id'];
    employeeId = json['employee_id'];
    endDate = DateTime.tryParse(json['end_date']);
    jobId = json['job_id'];
    startDate = DateTime.tryParse(json['start_date']);
    taskId = json['task_id'];
    employeeName = json['employee_name'];
    taskArName = json['task_ar_name'];
    taskEnName = json['task_en_name'];
    brandName = json['brand_name'];
    modelName = json['model_name'];
    plateNumber = json['plate_number'];
    color = json['color'];
    logo = json['logo'];
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
    from =DateTime.tryParse (json['from']);
    to = DateTime.tryParse(json['to']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['from'] = from;
    data['to'] = to;
    return data;
  }
}
