import 'address_model.dart';

class EmployeesModel {
  String? id;
  String? companyId;
  String? fullName;
  String? countryOfBirth;
  String? placeOfBirth;
  DateTime? dateOfBirth;
  String? gender;
  String? martialStatus;
  String? personType;
  String? status;
  String? employer;
  String? department;
  String? jobTitle;
  String? location;
  DateTime? hireDate;
  DateTime? endDate;
  String? reportingManager;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? peopleCounter;
  String? personImageUrl;
  String? personImagePublicId;
  List<EmployeeAddressModel>? addressesList;
  String? statusName;
  String? genderName;
  String? employerName;
  String? departmentName;
  String? jobTitleName;
  String? locationName;
  String? martialStatusName;
  String? countryName;
  String? reportingManagerName;
  String? countryOfBirthName;

  EmployeesModel({
    this.id,
    this.companyId,
    this.fullName,
    this.countryOfBirth,
    this.placeOfBirth,
    this.dateOfBirth,
    this.gender,
    this.martialStatus,
    this.personType,
    this.status,
    this.employer,
    this.department,
    this.jobTitle,
    this.location,
    this.hireDate,
    this.endDate,
    this.reportingManager,
    this.createdAt,
    this.updatedAt,
    this.peopleCounter,
    this.personImageUrl,
    this.personImagePublicId,
    this.addressesList,
    this.statusName,
    this.genderName,
    this.employerName,
    this.departmentName,
    this.jobTitleName,
    this.locationName,
    this.martialStatusName,
    this.countryName,
    this.reportingManagerName,
    this.countryOfBirthName,
  });

  EmployeesModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    companyId = json['company_id'];
    fullName = json['full_name'];
    countryOfBirth = json['country_of_birth'];
    placeOfBirth = json['place_of_birth'];
    dateOfBirth = json.containsKey('date_of_birth')
        ? DateTime.tryParse(json['date_of_birth'])
        : null;
    gender = json['gender'];
    martialStatus = json['martial_status'];
    personType = json['person_type'];
    status = json['status'];
    employer = json['employer'];
    department = json['department'];
    jobTitle = json['job_title'];
    location = json['location'];
    hireDate = json.containsKey('hire_date')
        ? DateTime.tryParse(json['hire_date'])
        : null;
    endDate = json.containsKey('end_date')
        ? DateTime.tryParse(json['end_date'])
        : null;
    reportingManager = json['reporting_manager'];
    peopleCounter = json['people_counter'];
    personImageUrl = json['person_image_url'];
    personImagePublicId = json['person_image_public_id'];
    if (json['addresses_list'] != null) {
      addressesList = <EmployeeAddressModel>[];
      json['addresses_list'].forEach((v) {
        addressesList!.add(EmployeeAddressModel.fromJson(v));
      });
    }
    statusName = json['status_name'];
    genderName = json['gender_name'];
    employerName = json['employer_name'];
    departmentName = json['department_name'];
    jobTitleName = json['job_title_name'];
    locationName = json['location_name'];
    martialStatusName = json['martial_status_name'];
    countryName = json['country_name'];
    reportingManagerName = json['reporting_manager_name'];
    countryOfBirthName = json['country_of_birth_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['company_id'] = companyId;
    data['full_name'] = fullName;
    data['country_of_birth'] = countryOfBirth;
    data['place_of_birth'] = placeOfBirth;
    data['date_of_birth'] = dateOfBirth;
    data['gender'] = gender;
    data['martial_status'] = martialStatus;
    data['person_type'] = personType;
    data['status'] = status;
    data['employer'] = employer;
    data['department'] = department;
    data['job_title'] = jobTitle;
    data['location'] = location;
    data['hire_date'] = hireDate;
    data['end_date'] = endDate;
    data['reporting_manager'] = reportingManager;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['people_counter'] = peopleCounter;
    data['person_image_url'] = personImageUrl;
    data['person_image_public_id'] = personImagePublicId;
    if (addressesList != null) {
      data['addresses_list'] = addressesList!.map((v) => v.toJson()).toList();
    }
    data['status_name'] = statusName;
    data['gender_name'] = genderName;
    data['employer_name'] = employerName;
    data['department_name'] = departmentName;
    data['job_title_name'] = jobTitleName;
    data['location_name'] = locationName;
    data['martial_status_name'] = martialStatusName;
    data['country_name'] = countryName;
    data['reporting_manager_name'] = reportingManagerName;
    data['country_of_birth_name'] = countryOfBirthName;
    return data;
  }
}
