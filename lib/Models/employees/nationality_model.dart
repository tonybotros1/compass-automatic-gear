class NationalityModel {
  String? id;
  String? nationality;
  String? startDate;
  String? endDate;
  String? employeeId;
  String? nationalityName;

  NationalityModel({
    this.id,
    this.nationality,
    this.startDate,
    this.endDate,
    this.employeeId,
    this.nationalityName,
  });

  NationalityModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id'] ?? '' : '';
    nationality = json.containsKey('nationality')
        ? json['nationality'] ?? ''
        : '';
    startDate = json.containsKey('start_date') ? json['start_date'] ?? '' : '';
    endDate = json.containsKey('end_date') ? json['end_date'] ?? '' : '';
    employeeId = json.containsKey('employee_id')
        ? json['employee_id'] ?? ''
        : '';
    nationalityName = json.containsKey('nationality_name')
        ? json['nationality_name'] ?? ''
        : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['nationality'] = nationality;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['employee_id'] = employeeId;
    data['nationality_name'] = nationalityName;
    return data;
  }
}
