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
    });
  });
}
