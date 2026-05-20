import 'package:datahubai/Models/employees/employees_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EmployeesModel', () {
    test('initializes missing nested lists independently', () {
      final employee = EmployeesModel.fromJson({
        '_id': 'employee-id',
        'full_name': 'Test Employee',
      });

      expect(employee.addressesList, isEmpty);
      expect(employee.nationalitiesList, isEmpty);
      expect(employee.phoneList, isEmpty);
      expect(employee.emailList, isEmpty);
      expect(employee.payrollsList, isEmpty);
      expect(employee.bankAccountsList, isEmpty);
      expect(employee.healthCardsList, isEmpty);
    });

    test('keeps email list when payroll and bank account lists are absent', () {
      final employee = EmployeesModel.fromJson({
        '_id': 'employee-id',
        'email_list': [
          {
            'id': 'email-id',
            'email': 'employee@example.com',
            'type': 'type-id',
            'type_name': 'Work',
          },
        ],
      });

      expect(employee.emailList, hasLength(1));
      expect(employee.emailList!.single.email, 'employee@example.com');
      expect(employee.payrollsList, isEmpty);
      expect(employee.bankAccountsList, isEmpty);
      expect(employee.healthCardsList, isEmpty);
    });

    test('parses employee health card list', () {
      final employee = EmployeesModel.fromJson({
        '_id': 'employee-id',
        'health_cards_list': [
          {
            '_id': 'health-card-id',
            'health_card_type': 'type-id',
            'health_card_type_value': 'Basic',
            'health_card_holder': 'holder-id',
            'health_card_holder_value': 'Employee',
            'card_number': 'HC-123',
            'insurance_company': 'company-id',
            'insurance_company_value': 'Insurance Co',
            'issue_date': '2026-01-01T00:00:00.000',
            'expiry_date': '2026-12-31T00:00:00.000',
            'cost': 1200,
            'employee_contribution': 250,
          },
        ],
      });

      expect(employee.healthCardsList, hasLength(1));
      expect(employee.healthCardsList!.single.healthCardType, 'Basic');
      expect(employee.healthCardsList!.single.cardNumber, 'HC-123');
      expect(employee.healthCardsList!.single.cost, 1200);
    });
  });
}
