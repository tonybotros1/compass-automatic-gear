import 'address_model.dart';
import 'email_model.dart';
import 'employee_account_banks_model.dart';
import 'employee_assignments_balances_model.dart';
import 'employee_health_card_model.dart';
import 'nationality_model.dart';
import 'employee_loan_and_advances_model.dart';
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
  List<EmployeeHealthCardModel>? healthCardsList;
  List<EmployeePayrollElementsModel>? payrollsList;
  List<EmployeeLoanAndAdvancesModel>? loanAndAdvancesList;
  List<EmployeeAssignmentsBalancesModel>? balances;

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

  static String? _stringFromJson(dynamic value) => value?.toString();

  static DateTime? _dateFromJson(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  static List<T> _listFromJson<T>(
    Map<String, dynamic> json,
    String key,
    T Function(Map<String, dynamic>) parser,
  ) {
    final value = json[key];
    if (value is! List) return <T>[];
    return value
        .whereType<Map>()
        .map((entry) => parser(Map<String, dynamic>.from(entry)))
        .toList();
  }

  factory EmployeesModel.fromJson(Map<String, dynamic> json) {
    final model = EmployeesModel();

    if (json.containsKey('_id')) model.id = _stringFromJson(json['_id']);
    if (json.containsKey('company_id')) {
      model.companyId = _stringFromJson(json['company_id']);
    }
    if (json.containsKey('full_name')) {
      model.fullName = _stringFromJson(json['full_name']);
    }
    if (json.containsKey('payroll')) {
      model.payroll = _stringFromJson(json['payroll']);
    }
    if (json.containsKey('country_of_birth')) {
      model.countryOfBirth = _stringFromJson(json['country_of_birth']);
    }
    if (json.containsKey('place_of_birth')) {
      model.placeOfBirth = _stringFromJson(json['place_of_birth']);
    }

    if (json.containsKey('date_of_birth') && json['date_of_birth'] != null) {
      model.dateOfBirth = _dateFromJson(json['date_of_birth']);
    }

    if (json.containsKey('gender')) {
      model.gender = _stringFromJson(json['gender']);
    }
    if (json.containsKey('martial_status')) {
      model.martialStatus = _stringFromJson(json['martial_status']);
    }
    if (json.containsKey('person_type')) {
      model.personType = _stringFromJson(json['person_type']);
    }
    if (json.containsKey('legislation')) {
      model.legislation = _stringFromJson(json['legislation']);
    }
    if (json.containsKey('employer')) {
      model.employer = _stringFromJson(json['employer']);
    }
    if (json.containsKey('department')) {
      model.department = _stringFromJson(json['department']);
    }
    if (json.containsKey('job_title')) {
      model.jobTitle = _stringFromJson(json['job_title']);
    }
    if (json.containsKey('location')) {
      model.location = _stringFromJson(json['location']);
    }

    if (json.containsKey('hire_date') && json['hire_date'] != null) {
      model.hireDate = _dateFromJson(json['hire_date']);
    }

    if (json.containsKey('end_date') && json['end_date'] != null) {
      model.endDate = _dateFromJson(json['end_date']);
    }

    if (json.containsKey('reporting_manager')) {
      model.reportingManager = _stringFromJson(json['reporting_manager']);
    }

    if (json.containsKey('createdAt') && json['createdAt'] != null) {
      model.createdAt = _dateFromJson(json['createdAt']);
    }

    if (json.containsKey('updatedAt') && json['updatedAt'] != null) {
      model.updatedAt = _dateFromJson(json['updatedAt']);
    }

    if (json.containsKey('people_counter')) {
      model.peopleCounter = _stringFromJson(json['people_counter']);
    }
    if (json.containsKey('person_image_url')) {
      model.personImageUrl = _stringFromJson(json['person_image_url']);
    }
    if (json.containsKey('person_image_public_id')) {
      model.personImagePublicId = _stringFromJson(
        json['person_image_public_id'],
      );
    }

    /// Lists
    model.addressesList = _listFromJson(
      json,
      'addresses_list',
      EmployeeAddressModel.fromJson,
    );
    model.balances = _listFromJson(
      json,
      'assignment_balances',
      EmployeeAssignmentsBalancesModel.fromJson,
    );
    model.nationalitiesList = _listFromJson(
      json,
      'nationalities_list',
      NationalityModel.fromJson,
    );
    model.phoneList = _listFromJson(json, 'phone_list', PhoneModel.fromJson);
    model.emailList = _listFromJson(json, 'email_list', EmailModel.fromJson);
    model.payrollsList = _listFromJson(
      json,
      'payrolls_details',
      EmployeePayrollElementsModel.fromJson,
    );
    model.loanAndAdvancesList = _listFromJson(
      json,
      'loan_and_advances_details',
      EmployeeLoanAndAdvancesModel.fromJson,
    );
    model.bankAccountsList = _listFromJson(
      json,
      'bank_accounts_list',
      EmployeeAccountBanksModel.fromJson,
    );
    model.healthCardsList = json.containsKey('health_cards_list')
        ? _listFromJson(
            json,
            'health_cards_list',
            EmployeeHealthCardModel.fromJson,
          )
        : _listFromJson(
            json,
            'health_card_list',
            EmployeeHealthCardModel.fromJson,
          );

    /// Names
    if (json.containsKey('gender_name')) {
      model.genderName = _stringFromJson(json['gender_name']);
    }
    if (json.containsKey('legislation_name')) {
      model.legislationName = _stringFromJson(json['legislation_name']);
    }
    if (json.containsKey('employer_name')) {
      model.employerName = _stringFromJson(json['employer_name']);
    }
    if (json.containsKey('payroll_name')) {
      model.payrollName = _stringFromJson(json['payroll_name']);
    }
    if (json.containsKey('department_name')) {
      model.departmentName = _stringFromJson(json['department_name']);
    }
    if (json.containsKey('job_title_name')) {
      model.jobTitleName = _stringFromJson(json['job_title_name']);
    }
    if (json.containsKey('location_name')) {
      model.locationName = _stringFromJson(json['location_name']);
    }
    if (json.containsKey('martial_status_name')) {
      model.martialStatusName = _stringFromJson(json['martial_status_name']);
    }
    if (json.containsKey('country_of_birth_name')) {
      model.countryOfBirthName = _stringFromJson(json['country_of_birth_name']);
    }
    if (json.containsKey('country_name')) {
      model.countryName = _stringFromJson(json['country_name']);
    }
    if (json.containsKey('reporting_manager_name')) {
      model.reportingManagerName = _stringFromJson(
        json['reporting_manager_name'],
      );
    }

    return model;
  }
}
