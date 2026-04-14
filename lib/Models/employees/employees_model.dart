import 'address_model.dart';
import 'email_model.dart';
import 'employee_account_banks_model.dart';
import 'nationality_model.dart';
import 'payroll_elements_model.dart';
import 'phone_model.dart';

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
  String? legislation;
  String? payrollName;
  String? payroll;
  String? legislationName;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? peopleCounter;
  String? personImageUrl;
  String? personImagePublicId;

  List<EmployeeAddressModel>? addressesList;
  List<NationalityModel>? nationalitiesList;
  List<PhoneModel>? phoneList;
  List<EmailModel>? emailList;
  List<EmployeeAccountBanksModel>? bankAccountsList;
  List<EmployeePayrollElementsModel>? payrollsList;

  String? genderName;
  String? employerName;
  String? departmentName;
  String? jobTitleName;
  String? locationName;
  String? martialStatusName;
  String? countryOfBirthName;
  String? countryName;
  String? reportingManagerName;

  EmployeesModel();

  factory EmployeesModel.fromJson(Map<String, dynamic> json) {
    final model = EmployeesModel();

    if (json.containsKey('_id')) model.id = json['_id'];
    if (json.containsKey('company_id')) model.companyId = json['company_id'];
    if (json.containsKey('full_name')) model.fullName = json['full_name'];
    if (json.containsKey('payroll')) model.payroll = json['payroll'];
    if (json.containsKey('country_of_birth')) {
      model.countryOfBirth = json['country_of_birth'];
    }
    if (json.containsKey('place_of_birth')) {
      model.placeOfBirth = json['place_of_birth'];
    }

    if (json.containsKey('date_of_birth') && json['date_of_birth'] != null) {
      model.dateOfBirth = DateTime.tryParse(json['date_of_birth']);
    }

    if (json.containsKey('gender')) model.gender = json['gender'];
    if (json.containsKey('martial_status')) {
      model.martialStatus = json['martial_status'];
    }
    if (json.containsKey('person_type')) model.personType = json['person_type'];
    if (json.containsKey('legislation')) {
      model.legislation = json['legislation'];
    }
    if (json.containsKey('status')) model.status = json['status'];
    if (json.containsKey('employer')) model.employer = json['employer'];
    if (json.containsKey('department')) model.department = json['department'];
    if (json.containsKey('job_title')) model.jobTitle = json['job_title'];
    if (json.containsKey('location')) model.location = json['location'];

    if (json.containsKey('hire_date') && json['hire_date'] != null) {
      model.hireDate = DateTime.tryParse(json['hire_date']);
    }

    if (json.containsKey('end_date') && json['end_date'] != null) {
      model.endDate = DateTime.tryParse(json['end_date']);
    }

    if (json.containsKey('reporting_manager')) {
      model.reportingManager = json['reporting_manager'];
    }

    if (json.containsKey('createdAt') && json['createdAt'] != null) {
      model.createdAt = DateTime.tryParse(json['createdAt']);
    }

    if (json.containsKey('updatedAt') && json['updatedAt'] != null) {
      model.updatedAt = DateTime.tryParse(json['updatedAt']);
    }

    if (json.containsKey('people_counter')) {
      model.peopleCounter = json['people_counter'];
    }
    if (json.containsKey('person_image_url')) {
      model.personImageUrl = json['person_image_url'];
    }
    if (json.containsKey('person_image_public_id')) {
      model.personImagePublicId = json['person_image_public_id'];
    }

    /// Lists
    if (json.containsKey('addresses_list') && json['addresses_list'] != null) {
      model.addressesList = (json['addresses_list'] as List)
          .map((e) => EmployeeAddressModel.fromJson(e))
          .toList();
    } else {
      model.addressesList = [];
    }

    if (json.containsKey('nationalities_list') &&
        json['nationalities_list'] != null) {
      model.nationalitiesList = (json['nationalities_list'] as List)
          .map((e) => NationalityModel.fromJson(e))
          .toList();
    } else {
      model.nationalitiesList = [];
    }

    if (json.containsKey('phone_list') && json['phone_list'] != null) {
      model.phoneList = (json['phone_list'] as List)
          .map((e) => PhoneModel.fromJson(e))
          .toList();
    } else {
      model.phoneList = [];
    }

    if (json.containsKey('email_list') && json['email_list'] != null) {
      model.emailList = (json['email_list'] as List)
          .map((e) => EmailModel.fromJson(e))
          .toList();
    } else {
      model.emailList = [];
    }

    if (json.containsKey('payrolls_details') &&
        json['payrolls_details'] != null) {
      model.payrollsList = (json['payrolls_details'] as List)
          .map((e) => EmployeePayrollElementsModel.fromJson(e))
          .toList();
    } else {
      model.emailList = [];
    }
    if (json.containsKey('bank_accounts_list') &&
        json['bank_accounts_list'] != null) {
      model.bankAccountsList = (json['bank_accounts_list'] as List)
          .map((e) => EmployeeAccountBanksModel.fromJson(e))
          .toList();
    } else {
      model.emailList = [];
    }

    /// Names
    if (json.containsKey('gender_name')) model.genderName = json['gender_name'];
    if (json.containsKey('legislation_name')) {
      model.legislationName = json['legislation_name'];
    }
    if (json.containsKey('employer_name')) {
      model.employerName = json['employer_name'];
    }
    if (json.containsKey('payroll_name')) {
      model.payrollName = json['payroll_name'];
    }
    if (json.containsKey('department_name')) {
      model.departmentName = json['department_name'];
    }
    if (json.containsKey('job_title_name')) {
      model.jobTitleName = json['job_title_name'];
    }
    if (json.containsKey('location_name')) {
      model.locationName = json['location_name'];
    }
    if (json.containsKey('martial_status_name')) {
      model.martialStatusName = json['martial_status_name'];
    }
    if (json.containsKey('country_of_birth_name')) {
      model.countryOfBirthName = json['country_of_birth_name'];
    }
    if (json.containsKey('country_name')) {
      model.countryName = json['country_name'];
    }
    if (json.containsKey('reporting_manager_name')) {
      model.reportingManagerName = json['reporting_manager_name'];
    }

    return model;
  }
}
