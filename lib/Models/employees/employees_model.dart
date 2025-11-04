class EmployeesModel {
  String? id;
  String? name;
  String? gender;
  String? nationality;
  DateTime? dateOfBirth;
  String? martialStatus;
  String? nationalIdOrPassportNumber;
  String? email;
  String? phone;
  String? address;
  String? emergencyContactName;
  String? emergencyContactNumber;
  String? jobTitle;
  DateTime? hireDate;
  DateTime? endDate;
  String? jobDescription;
  String? status;
  List<String>? department;
  String? companyId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? employeeNumber;
  String? genderType;
  String? nationalityName;
  String? martialStatusType;
  String? statusType;

  EmployeesModel({
    this.id,
    this.name,
    this.gender,
    this.nationality,
    this.dateOfBirth,
    this.martialStatus,
    this.nationalIdOrPassportNumber,
    this.email,
    this.phone,
    this.address,
    this.emergencyContactName,
    this.emergencyContactNumber,
    this.jobTitle,
    this.hireDate,
    this.endDate,
    this.jobDescription,
    this.status,
    this.department,
    this.companyId,
    this.createdAt,
    this.updatedAt,
    this.employeeNumber,
    this.genderType,
    this.nationalityName,
    this.martialStatusType,
    this.statusType,
  });

  EmployeesModel.fromJson(Map<String, dynamic> json) {
    id = json.containsKey('_id') ? json['_id'] : null;
    name = json.containsKey('name') ? json['name'] : null;
    gender = json.containsKey('gender') ? json['gender'] : null;
    nationality = json.containsKey('nationality') ? json['nationality'] : null;

    dateOfBirth = json.containsKey('date_of_birth') && json['date_of_birth'] != null
        ? DateTime.tryParse(json['date_of_birth'].toString())
        : null;

    martialStatus = json.containsKey('martial_status') ? json['martial_status'] : null;
    nationalIdOrPassportNumber = json.containsKey('national_id_or_passport_number')
        ? json['national_id_or_passport_number']
        : null;
    email = json.containsKey('email') ? json['email'] : null;
    phone = json.containsKey('phone') ? json['phone'] : null;
    address = json.containsKey('address') ? json['address'] : null;
    emergencyContactName =
        json.containsKey('emergency_contact_name') ? json['emergency_contact_name'] : null;
    emergencyContactNumber =
        json.containsKey('emergency_contact_number') ? json['emergency_contact_number'] : null;
    jobTitle = json.containsKey('job_title') ? json['job_title'] : null;

    hireDate = json.containsKey('hire_date') && json['hire_date'] != null
        ? DateTime.tryParse(json['hire_date'].toString())
        : null;

    endDate = json.containsKey('end_date') && json['end_date'] != null
        ? DateTime.tryParse(json['end_date'].toString())
        : null;

    jobDescription = json.containsKey('job_description') ? json['job_description'] : null;
    status = json.containsKey('status') ? json['status'] : null;

    if (json.containsKey('department') && json['department'] is List) {
      department = List<String>.from(json['department']);
    } else {
      department = [];
    }

    companyId = json.containsKey('company_id') ? json['company_id'] : null;

    createdAt = json.containsKey('createdAt') && json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'].toString())
        : null;

    updatedAt = json.containsKey('updatedAt') && json['updatedAt'] != null
        ? DateTime.tryParse(json['updatedAt'].toString())
        : null;

    employeeNumber = json.containsKey('employee_number') ? json['employee_number'] : null;
    genderType = json.containsKey('gender_type') ? json['gender_type'] : null;
    nationalityName = json.containsKey('nationality_name') ? json['nationality_name'] : null;
    martialStatusType =
        json.containsKey('martial_status_type') ? json['martial_status_type'] : null;
    statusType = json.containsKey('status_type') ? json['status_type'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['gender'] = gender;
    data['nationality'] = nationality;
    data['date_of_birth'] = dateOfBirth?.toIso8601String();
    data['martial_status'] = martialStatus;
    data['national_id_or_passport_number'] = nationalIdOrPassportNumber;
    data['email'] = email;
    data['phone'] = phone;
    data['address'] = address;
    data['emergency_contact_name'] = emergencyContactName;
    data['emergency_contact_number'] = emergencyContactNumber;
    data['job_title'] = jobTitle;
    data['hire_date'] = hireDate?.toIso8601String();
    data['end_date'] = endDate?.toIso8601String();
    data['job_description'] = jobDescription;
    data['status'] = status;
    data['department'] = department ?? [];
    data['company_id'] = companyId;
    data['createdAt'] = createdAt?.toIso8601String();
    data['updatedAt'] = updatedAt?.toIso8601String();
    data['employee_number'] = employeeNumber;
    data['gender_type'] = genderType;
    data['nationality_name'] = nationalityName;
    data['martial_status_type'] = martialStatusType;
    data['status_type'] = statusType;
    return data;
  }
}
