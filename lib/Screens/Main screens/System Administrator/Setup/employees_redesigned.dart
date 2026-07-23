import 'dart:math' as math;

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controllers/Main screen controllers/employees_controller.dart';
import '../../../../Models/employees/employees_model.dart';
import '../../../../Widgets/attachments/attachment_screen.dart';
import '../../../../Widgets/main screen widgets/employees_widgets/address/address_section.dart'
    as address_section;
import '../../../../Widgets/main screen widgets/employees_widgets/balances_section.dart'
    as balances_section;
import '../../../../Widgets/main screen widgets/employees_widgets/bank_accounts/bank_accounts_section.dart'
    as bank_section;
import '../../../../Widgets/main screen widgets/employees_widgets/contacts_and_relatives_dialog.dart';
import '../../../../Widgets/main screen widgets/employees_widgets/emails/email_section.dart'
    as email_section;
import '../../../../Widgets/main screen widgets/employees_widgets/health_card/health_card_section.dart'
    as health_section;
import '../../../../Widgets/main screen widgets/employees_widgets/leaves/leaves_dialog.dart';
import '../../../../Widgets/main screen widgets/employees_widgets/loan_and_advances/loan_and_advances_section.dart'
    as loan_section;
import '../../../../Widgets/main screen widgets/employees_widgets/nationality/nationality_section.dart'
    as nationality_section;
import '../../../../Widgets/main screen widgets/employees_widgets/payroll_elements/payroll_elements_section.dart'
    as payroll_element_section;
import '../../../../Widgets/main screen widgets/employees_widgets/phone/phone_section.dart'
    as phone_section;
import '../../../../Widgets/main screen widgets/lists_widgets/values_section_in_list_of_values.dart';
import '../../../../Widgets/menu_dialog.dart';
import '../../../../Widgets/my_text_field.dart';
import '../../../../consts.dart';
import 'countries.dart';
import 'legislation.dart';
import 'payroll.dart';

const _page = Color(0xFFF5F8FB);
const _surface = Colors.white;
const _surfaceSoft = Color(0xFFF8FAFC);
const _line = Color(0xFFDCE6EE);
const _text = Color(0xFF203044);
const _muted = Color(0xFF718196);
const _primary = Color(0xFF005F95);
const _primarySoft = Color(0xFFE8F3F9);
const _secondary = Color(0xFF9AB0BF);
const _green = Color(0xFF26945B);
const _red = Color(0xFFD95555);
const _redSoft = Color(0xFFFFEEEE);
const _orange = Color(0xFFC67A16);
const _purple = Color(0xFF7357B7);

/// A comparison version of the employees screen.
///
/// The original screen remains unchanged and available from `/employees`.
class EmployeesRedesigned extends StatelessWidget {
  const EmployeesRedesigned({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _page,
      body: GetX<EmployeesController>(
        init: EmployeesController(),
        builder: (controller) {
          final isLoading = controller.isScreenLoding.value;
          final employees = controller.allEmployees.toList(growable: false);
          final selectedType = controller.initTypePickersValue.value;
          final deletingEmployeeId = controller.deletingEmployeeId.value;
          final buttonLoadingStates = Map<String, bool>.from(
            controller.buttonLoadingStates,
          );
          return LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _EmployeesHeader(
                      controller: controller,
                      constraints: constraints,
                      employeeCount: employees.length,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 9),
                    _EmployeeFilters(
                      controller: controller,
                      isLoading: isLoading,
                      selectedType: selectedType,
                    ),
                    const SizedBox(height: 9),
                    Expanded(
                      child: _EmployeesResults(
                        controller: controller,
                        constraints: constraints,
                        employees: employees,
                        isLoading: isLoading,
                        deletingEmployeeId: deletingEmployeeId,
                        buttonLoadingStates: buttonLoadingStates,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _EmployeesHeader extends StatelessWidget {
  const _EmployeesHeader({
    required this.controller,
    required this.constraints,
    required this.employeeCount,
    required this.isLoading,
  });

  final EmployeesController controller;
  final BoxConstraints constraints;
  final int employeeCount;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _line),
      ),
      child: LayoutBuilder(
        builder: (context, box) {
          final compact = box.maxWidth < 700;
          final title = Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _primarySoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.badge_outlined,
                  color: _primary,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Employees',
                      style: TextStyle(
                        color: _text,
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'People, employment records and payroll information',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: _muted, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          );
          final actions = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _HeaderAction(
                label: 'Refresh',
                icon: Icons.refresh_rounded,
                busy: isLoading,
                onPressed: isLoading
                    ? null
                    : () => controller.getAllEmployees(),
              ),
              const SizedBox(width: 7),
              _HeaderAction(
                label: 'New Employee',
                icon: Icons.person_add_alt_1_rounded,
                filled: true,
                onPressed: () {
                  controller.clearValues();
                  _openEmployeeWorkspace(controller, constraints);
                },
              ),
            ],
          );
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                title,
                const SizedBox(height: 11),
                Align(alignment: Alignment.centerRight, child: actions),
              ],
            );
          }
          return Row(
            children: [
              Expanded(child: title),
              _CountBadge(count: employeeCount),
              const SizedBox(width: 12),
              actions,
            ],
          );
        },
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: _surfaceSoft,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: _line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.groups_2_outlined, color: _secondary, size: 16),
          const SizedBox(width: 7),
          Text(
            '$count RECORD${count == 1 ? '' : 'S'}',
            style: const TextStyle(
              color: _muted,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.filled = false,
    this.busy = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool filled;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: filled
          ? FilledButton.icon(
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              icon: Icon(icon, size: 16),
              label: Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: _primary,
                backgroundColor: _primarySoft,
                side: const BorderSide(color: Color(0xFFBED8E7)),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              icon: busy
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: _primary,
                      ),
                    )
                  : Icon(icon, size: 16),
              label: Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
    );
  }
}

class _EmployeeFilters extends StatelessWidget {
  const _EmployeeFilters({
    required this.controller,
    required this.isLoading,
    required this.selectedType,
  });

  final EmployeesController controller;
  final bool isLoading;
  final int selectedType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, box) {
              final columns = box.maxWidth >= 1300
                  ? 5
                  : box.maxWidth >= 850
                  ? 3
                  : box.maxWidth >= 540
                  ? 2
                  : 1;
              const gap = 9.0;
              final width = (box.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: 9,
                children: [
                  SizedBox(
                    width: width,
                    child: myTextFormFieldWithBorder(
                      width: double.infinity,
                      labelText: 'Employee Name',
                      controller: controller.employeeNameFilter,
                      onFieldSubmitted: (_) => controller.filterSearch(),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _filterMenu(
                      label: 'Employer',
                      controller: controller.employerFilter,
                      onOpen: controller.getallJobEmployers,
                      onClear: () {
                        controller.employerIdFilter.value = '';
                        controller.employerFilter.clear();
                      },
                      onSelected: (value) {
                        controller.employerIdFilter.value = value['_id'];
                        controller.employerFilter.text = value['name'];
                      },
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _filterMenu(
                      label: 'Department',
                      controller: controller.departmentFilter,
                      onOpen: controller.getAllJobDepartments,
                      onClear: () {
                        controller.departmentIdFilter.value = '';
                        controller.departmentFilter.clear();
                      },
                      onSelected: (value) {
                        controller.departmentIdFilter.value = value['_id'];
                        controller.departmentFilter.text = value['name'];
                      },
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _filterMenu(
                      label: 'Job Title',
                      controller: controller.jobTitleFilter,
                      onOpen: controller.getallJobTitle,
                      onClear: () {
                        controller.jobTitleIdFilter.value = '';
                        controller.jobTitleFilter.clear();
                      },
                      onSelected: (value) {
                        controller.jobTitleIdFilter.value = value['_id'];
                        controller.jobTitleFilter.text = value['name'];
                      },
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: _filterMenu(
                      label: 'Location',
                      controller: controller.locationFilter,
                      onOpen: controller.getallJobLocations,
                      onClear: () {
                        controller.locationIdFilter.value = '';
                        controller.locationFilter.clear();
                      },
                      onSelected: (value) {
                        controller.locationIdFilter.value = value['_id'];
                        controller.locationFilter.text = value['name'];
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, box) {
              final typeFilters = SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _TypeChip(1, 'All', controller, selectedType),
                    const SizedBox(width: 5),
                    _TypeChip(2, 'Employee', controller, selectedType),
                    const SizedBox(width: 5),
                    _TypeChip(3, 'Applicant', controller, selectedType),
                    const SizedBox(width: 5),
                    _TypeChip(4, 'Ex-Employee', controller, selectedType),
                    const SizedBox(width: 5),
                    _TypeChip(5, 'Ex-Applicant', controller, selectedType),
                  ],
                ),
              );
              final actions = Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _CompactAction(
                    label: 'Clear',
                    icon: Icons.cleaning_services_outlined,
                    color: _secondary,
                    onPressed: isLoading
                        ? null
                        : () async {
                            controller.clearAllFilters();
                            await controller.filterSearch();
                          },
                  ),
                  const SizedBox(width: 7),
                  _CompactAction(
                    label: 'Find',
                    icon: Icons.search_rounded,
                    color: _primary,
                    filled: true,
                    busy: isLoading,
                    onPressed: isLoading
                        ? null
                        : () => controller.filterSearch(),
                  ),
                ],
              );
              if (box.maxWidth < 760) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    typeFilters,
                    const SizedBox(height: 9),
                    Align(alignment: Alignment.centerRight, child: actions),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: typeFilters),
                  const SizedBox(width: 12),
                  actions,
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget _filterMenu({
  required String label,
  required TextEditingController controller,
  required Future<Map<String, dynamic>> Function() onOpen,
  required VoidCallback onClear,
  required void Function(dynamic value) onSelected,
}) {
  return MenuWithValues(
    labelText: label,
    headerLqabel: '${label}s',
    dialogWidth: 620,
    width: double.infinity,
    controller: controller,
    displayKeys: const ['name'],
    displaySelectedKeys: const ['name'],
    onOpen: onOpen,
    onDelete: onClear,
    onSelected: onSelected,
  );
}

class _TypeChip extends StatelessWidget {
  const _TypeChip(this.value, this.label, this.controller, this.selectedType);

  final int value;
  final String label;
  final EmployeesController controller;
  final int selectedType;

  @override
  Widget build(BuildContext context) {
    final selected = selectedType == value;
    return InkWell(
      onTap: () => controller.onChooseForTypePicker(value),
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 11),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? _primary : _surfaceSoft,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? _primary : _line),
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            color: selected ? Colors.white : _muted,
            fontSize: 8.5,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _CompactAction extends StatelessWidget {
  const _CompactAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.filled = false,
    this.busy = false,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;
  final bool filled;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: filled ? Colors.white : color,
          backgroundColor: filled ? color : color.withValues(alpha: .09),
          side: BorderSide(color: color.withValues(alpha: filled ? 1 : .28)),
          padding: const EdgeInsets.symmetric(horizontal: 11),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: busy
            ? SizedBox(
                width: 13,
                height: 13,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: filled ? Colors.white : color,
                ),
              )
            : Icon(icon, size: 15),
        label: Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _EmployeesResults extends StatelessWidget {
  const _EmployeesResults({
    required this.controller,
    required this.constraints,
    required this.employees,
    required this.isLoading,
    required this.deletingEmployeeId,
    required this.buttonLoadingStates,
  });

  final EmployeesController controller;
  final BoxConstraints constraints;
  final List<EmployeesModel> employees;
  final bool isLoading;
  final String deletingEmployeeId;
  final Map<String, bool> buttonLoadingStates;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _line),
      ),
      child: LayoutBuilder(
        builder: (context, box) {
          if (isLoading && employees.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: _primary),
            );
          }
          if (employees.isEmpty) {
            return const _EmptyEmployees();
          }
          if (box.maxWidth < 820) {
            return ListView.separated(
              padding: const EdgeInsets.all(9),
              itemCount: employees.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) => _EmployeeCard(
                employee: employees[index],
                controller: controller,
                constraints: constraints,
                deletingEmployeeId: deletingEmployeeId,
                buttonLoadingStates: buttonLoadingStates,
              ),
            );
          }
          final rows = math.max(1, ((box.maxHeight - 104) / 64).floor());
          return PaginatedDataTable2(
            minWidth: 980,
            horizontalMargin: 12,
            columnSpacing: 10,
            headingRowHeight: 42,
            dataRowHeight: 62,
            rowsPerPage: rows,
            showFirstLastButtons: true,
            showCheckboxColumn: false,
            headingRowColor: const WidgetStatePropertyAll(Color(0xFFF1F5F8)),
            columns: const [
              DataColumn2(label: _TableLabel('EMPLOYEE'), size: ColumnSize.L),
              DataColumn2(label: _TableLabel('TYPE'), size: ColumnSize.S),
              DataColumn2(label: _TableLabel('EMPLOYER'), size: ColumnSize.M),
              DataColumn2(label: _TableLabel('DEPARTMENT'), size: ColumnSize.M),
              DataColumn2(label: _TableLabel('JOB TITLE'), size: ColumnSize.M),
              DataColumn2(label: _TableLabel('LOCATION'), size: ColumnSize.S),
              DataColumn2(label: _TableLabel('ACTIONS'), fixedWidth: 100),
            ],
            source: _EmployeeSource(
              employees: employees,
              controller: controller,
              constraints: constraints,
              deletingEmployeeId: deletingEmployeeId,
              buttonLoadingStates: buttonLoadingStates,
            ),
          );
        },
      ),
    );
  }
}

class _TableLabel extends StatelessWidget {
  const _TableLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: _muted,
        fontSize: 9,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _EmployeeSource extends DataTableSource {
  _EmployeeSource({
    required this.employees,
    required this.controller,
    required this.constraints,
    required this.deletingEmployeeId,
    required this.buttonLoadingStates,
  });

  final List<EmployeesModel> employees;
  final EmployeesController controller;
  final BoxConstraints constraints;
  final String deletingEmployeeId;
  final Map<String, bool> buttonLoadingStates;

  @override
  DataRow? getRow(int index) {
    if (index >= employees.length) return null;
    final employee = employees[index];
    final type = _personType(controller, employee);
    return DataRow.byIndex(
      index: index,
      color: WidgetStatePropertyAll(
        index.isOdd ? const Color(0xFFFBFCFD) : Colors.white,
      ),
      cells: [
        DataCell(_EmployeeIdentity(employee: employee)),
        DataCell(_PersonTypeBadge(type)),
        DataCell(_CellText(employee.employerName)),
        DataCell(_CellText(employee.departmentName)),
        DataCell(_CellText(employee.jobTitleName, strong: true)),
        DataCell(_CellText(employee.locationName)),
        DataCell(
          _EmployeeActions(
            employee: employee,
            controller: controller,
            constraints: constraints,
            loading: buttonLoadingStates[employee.id ?? ''] ?? false,
            deleting: deletingEmployeeId == (employee.id ?? ''),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => employees.length;

  @override
  int get selectedRowCount => 0;
}

class _EmployeeIdentity extends StatelessWidget {
  const _EmployeeIdentity({required this.employee});

  final EmployeesModel employee;

  @override
  Widget build(BuildContext context) {
    final name = employee.fullName?.trim() ?? '';
    final image = employee.personImageUrl?.trim() ?? '';
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _primarySoft,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: const Color(0xFFC5DDE9)),
          ),
          child: image.isNotEmpty
              ? Image.network(
                  image,
                  fit: BoxFit.cover,
                  width: 40,
                  height: 40,
                  errorBuilder: (_, _, _) => _EmployeeInitial(name: name),
                )
              : _EmployeeInitial(name: name),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.isEmpty ? 'Unnamed Employee' : name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _text,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                employee.peopleCounter?.trim().isNotEmpty == true
                    ? 'ID ${employee.peopleCounter}'
                    : 'Employee record',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: _muted, fontSize: 9),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmployeeInitial extends StatelessWidget {
  const _EmployeeInitial({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name.isEmpty ? '?' : name.characters.first.toUpperCase(),
      style: const TextStyle(
        color: _primary,
        fontSize: 15,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _CellText extends StatelessWidget {
  const _CellText(this.value, {this.strong = false});

  final String? value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final text = value?.trim() ?? '';
    return Text(
      text.isEmpty ? '—' : text,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: text.isEmpty ? const Color(0xFFA5B0BA) : _text,
        fontSize: 10,
        fontWeight: strong ? FontWeight.w800 : FontWeight.w600,
      ),
    );
  }
}

String _personType(EmployeesController controller, EmployeesModel employee) {
  return controller.getPersonType(
    employee.hireDate?.toString() ?? '',
    employee.endDate?.toString() ?? '',
  );
}

class _PersonTypeBadge extends StatelessWidget {
  const _PersonTypeBadge(this.type);

  final String type;

  @override
  Widget build(BuildContext context) {
    final color = switch (type) {
      'Employee' => _green,
      'Applicant' => _orange,
      'Ex-Employee' => _secondary,
      _ => _purple,
    };
    return Container(
      height: 25,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: color.withValues(alpha: .25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            type.isEmpty ? 'UNKNOWN' : type.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 8,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmployeeActions extends StatelessWidget {
  const _EmployeeActions({
    required this.employee,
    required this.controller,
    required this.constraints,
    required this.loading,
    required this.deleting,
  });

  final EmployeesModel employee;
  final EmployeesController controller;
  final BoxConstraints constraints;
  final bool loading;
  final bool deleting;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _RowAction(
          tooltip: 'Edit employee',
          icon: Icons.edit_outlined,
          color: _primary,
          background: _primarySoft,
          busy: loading,
          onTap: loading || deleting
              ? null
              : () => _loadAndOpenEmployee(
                  context,
                  controller,
                  employee,
                  constraints,
                ),
        ),
        const SizedBox(width: 6),
        _RowAction(
          tooltip: 'Delete employee',
          icon: Icons.delete_outline_rounded,
          color: _red,
          background: _redSoft,
          busy: deleting,
          onTap: loading || deleting
              ? null
              : () => _confirmDeleteEmployee(context, controller, employee),
        ),
      ],
    );
  }
}

class _RowAction extends StatelessWidget {
  const _RowAction({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.background,
    required this.onTap,
    this.busy = false,
  });

  final String tooltip;
  final IconData icon;
  final Color color;
  final Color background;
  final VoidCallback? onTap;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: onTap == null ? const Color(0xFFF1F4F6) : background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: onTap == null ? _line : color.withValues(alpha: .20),
            ),
          ),
          child: busy
              ? SizedBox(
                  width: 13,
                  height: 13,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: color,
                  ),
                )
              : Icon(
                  icon,
                  color: onTap == null ? const Color(0xFFAFBAC3) : color,
                  size: 16,
                ),
        ),
      ),
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  const _EmployeeCard({
    required this.employee,
    required this.controller,
    required this.constraints,
    required this.deletingEmployeeId,
    required this.buttonLoadingStates,
  });

  final EmployeesModel employee;
  final EmployeesController controller;
  final BoxConstraints constraints;
  final String deletingEmployeeId;
  final Map<String, bool> buttonLoadingStates;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: _EmployeeIdentity(employee: employee)),
              _PersonTypeBadge(_personType(controller, employee)),
            ],
          ),
          const Divider(color: _line, height: 22),
          Wrap(
            spacing: 18,
            runSpacing: 10,
            children: [
              _MobileDetail('EMPLOYER', employee.employerName),
              _MobileDetail('DEPARTMENT', employee.departmentName),
              _MobileDetail('JOB TITLE', employee.jobTitleName),
              _MobileDetail('LOCATION', employee.locationName),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: _EmployeeActions(
              employee: employee,
              controller: controller,
              constraints: constraints,
              loading: buttonLoadingStates[employee.id ?? ''] ?? false,
              deleting: deletingEmployeeId == (employee.id ?? ''),
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileDetail extends StatelessWidget {
  const _MobileDetail(this.label, this.value);

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final text = value?.trim() ?? '';
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _muted,
              fontSize: 8,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text.isEmpty ? '—' : text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _text, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _EmptyEmployees extends StatelessWidget {
  const _EmptyEmployees();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_search_rounded, color: Color(0xFFA7B4BF), size: 42),
          SizedBox(height: 10),
          Text(
            'No employees match the selected filters',
            textAlign: TextAlign.center,
            style: TextStyle(color: _muted, fontSize: 10.5),
          ),
        ],
      ),
    );
  }
}

Future<void> _loadAndOpenEmployee(
  BuildContext context,
  EmployeesController controller,
  EmployeesModel employee,
  BoxConstraints constraints,
) async {
  final id = employee.id ?? '';
  if (id.isEmpty) return;
  controller.setButtonLoading(id, true);
  try {
    final loaded = await controller.loadValues(id);
    if (!loaded || !context.mounted) return;
    _openEmployeeWorkspace(controller, constraints);
  } finally {
    controller.setButtonLoading(id, false);
  }
}

Future<void> _confirmDeleteEmployee(
  BuildContext context,
  EmployeesController controller,
  EmployeesModel employee,
) async {
  final id = employee.id ?? '';
  if (id.isEmpty) return;
  final confirmed =
      await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text(
            'Delete employee?',
            style: TextStyle(
              color: _text,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Text(
            '${employee.fullName?.trim().isNotEmpty == true ? employee.fullName : 'This employee'} and all related employee records will be permanently deleted.',
            style: const TextStyle(color: _muted, height: 1.5, fontSize: 10.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('CANCEL'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: FilledButton.styleFrom(backgroundColor: _red),
              icon: const Icon(Icons.delete_outline_rounded, size: 16),
              label: const Text('DELETE'),
            ),
          ],
        ),
      ) ??
      false;
  if (confirmed) await controller.deleteEmployee(id);
}

Future<dynamic> _openEmployeeWorkspace(
  EmployeesController controller,
  BoxConstraints screenConstraints,
) {
  final isNewEmployee = controller.currentEmployeeId.value.isEmpty;
  return Get.dialog(
    barrierDismissible: false,
    Dialog(
      insetPadding: const EdgeInsets.all(8),
      backgroundColor: _page,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: math.min(Get.width - 16, isNewEmployee ? 1280 : 1500),
        height: math.min(Get.height - 16, 930),
        child: isNewEmployee
            ? _NewEmployeeForm(
                controller: controller,
                screenConstraints: screenConstraints,
              )
            : DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    _EmployeeWorkspaceHeader(
                      controller: controller,
                      screenConstraints: screenConstraints,
                    ),
                    Container(
                      height: 46,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(bottom: BorderSide(color: _line)),
                      ),
                      child: const TabBar(
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        labelColor: _primary,
                        unselectedLabelColor: _muted,
                        indicatorColor: _primary,
                        dividerColor: Colors.transparent,
                        labelStyle: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                        tabs: [
                          Tab(
                            child: _TabLabel(
                              icon: Icons.person_outline_rounded,
                              label: 'PROFILE & EMPLOYMENT',
                            ),
                          ),
                          Tab(
                            child: _TabLabel(
                              icon: Icons.folder_copy_outlined,
                              label: 'CONTACT & RECORDS',
                            ),
                          ),
                          Tab(
                            child: _TabLabel(
                              icon: Icons.payments_outlined,
                              label: 'PAYROLL & BENEFITS',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _ProfileEmploymentTab(controller: controller),
                          const _EmployeeRecordsTab(),
                          const _CompensationTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    ),
  );
}

class _NewEmployeeForm extends StatelessWidget {
  const _NewEmployeeForm({
    required this.controller,
    required this.screenConstraints,
  });

  final EmployeesController controller;
  final BoxConstraints screenConstraints;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _NewEmployeeHeader(controller: controller),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, box) {
                final personal = Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _NewEmployeePhotoStrip(controller: controller),
                    const SizedBox(height: 12),
                    _EditorSection(
                      title: 'Personal Information',
                      subtitle: 'Identity and personal details',
                      icon: Icons.person_outline_rounded,
                      child: _PersonalFields(controller: controller),
                    ),
                  ],
                );
                final employment = _EditorSection(
                  title: 'Employment Information',
                  subtitle: 'Assignment, payroll and employment dates',
                  icon: Icons.business_center_outlined,
                  child: _EmploymentFields(controller: controller),
                );
                if (box.maxWidth < 980) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      personal,
                      const SizedBox(height: 12),
                      employment,
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: personal),
                    const SizedBox(width: 14),
                    Expanded(child: employment),
                  ],
                );
              },
            ),
          ),
        ),
        _NewEmployeeFooter(
          controller: controller,
          screenConstraints: screenConstraints,
        ),
      ],
    );
  }
}

class _NewEmployeeHeader extends StatelessWidget {
  const _NewEmployeeHeader({required this.controller});

  final EmployeesController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(bottom: BorderSide(color: _line)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _primary,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.person_add_alt_1_rounded,
              color: Colors.white,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedBuilder(
                  animation: controller.employeeName,
                  builder: (context, _) {
                    final name = controller.employeeName.text.trim();
                    return Text(
                      name.isEmpty ? 'Add New Employee' : name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: _text,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 3),
                const Text(
                  'Complete the profile and employment details, then create the employee record.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: _muted, fontSize: 9.5),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: _primarySoft,
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Text(
              'NEW RECORD',
              style: TextStyle(
                color: _primary,
                fontSize: 8,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Close',
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close_rounded, color: _muted),
          ),
        ],
      ),
    );
  }
}

class _NewEmployeePhotoStrip extends StatelessWidget {
  const _NewEmployeePhotoStrip({required this.controller});

  final EmployeesController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: _line),
      ),
      child: Row(
        children: [
          Obx(() {
            final network = controller.employeeImage.value.trim();
            return GetBuilder<EmployeesController>(
              builder: (_) {
                final memory = controller.imageBytes;
                return InkWell(
                  onTap: controller.pickImage,
                  borderRadius: BorderRadius.circular(11),
                  child: Container(
                    width: 94,
                    height: 94,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: _primarySoft,
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(color: const Color(0xFFC6DDE9)),
                    ),
                    child: memory != null
                        ? Image.memory(memory, fit: BoxFit.cover)
                        : network.isNotEmpty
                        ? Image.network(
                            network,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const _ImagePlaceholder(),
                          )
                        : const _ImagePlaceholder(compact: true),
                  ),
                );
              },
            );
          }),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Employee Photo',
                  style: TextStyle(
                    color: _text,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Add a clear profile photo to make the employee easier to identify.',
                  style: TextStyle(color: _muted, height: 1.4, fontSize: 8.5),
                ),
                const SizedBox(height: 9),
                SizedBox(
                  height: 31,
                  child: OutlinedButton.icon(
                    onPressed: controller.pickImage,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _primary,
                      backgroundColor: _primarySoft,
                      side: const BorderSide(color: Color(0xFFC3DDEB)),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.add_a_photo_outlined, size: 14),
                    label: const Text(
                      'CHOOSE PHOTO',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NewEmployeeFooter extends StatelessWidget {
  const _NewEmployeeFooter({
    required this.controller,
    required this.screenConstraints,
  });

  final EmployeesController controller;
  final BoxConstraints screenConstraints;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _line)),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: _secondary, size: 16),
          const SizedBox(width: 7),
          const Expanded(
            child: Text(
              'Legislation and Payroll are required. Records and benefits become available after creation.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: _muted, fontSize: 8.5),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 35,
            child: TextButton(
              onPressed: () => Get.back(),
              style: TextButton.styleFrom(foregroundColor: _muted),
              child: const Text(
                'CANCEL',
                style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w900),
              ),
            ),
          ),
          const SizedBox(width: 7),
          Obx(
            () => SizedBox(
              height: 35,
              child: FilledButton.icon(
                onPressed: controller.addingNewValue.value
                    ? null
                    : () => _createEmployeeAndOpenWorkspace(
                        controller,
                        screenConstraints,
                      ),
                style: FilledButton.styleFrom(
                  backgroundColor: _primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: _secondary,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: controller.addingNewValue.value
                    ? const SizedBox(
                        width: 13,
                        height: 13,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.person_add_alt_1_rounded, size: 15),
                label: Text(
                  controller.addingNewValue.value
                      ? 'CREATING...'
                      : 'CREATE EMPLOYEE',
                  style: const TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _createEmployeeAndOpenWorkspace(
  EmployeesController controller,
  BoxConstraints screenConstraints,
) async {
  await controller.addNewEmployee();
  if (controller.currentEmployeeId.value.isEmpty) return;
  Get.back();
  await Future<void>.delayed(Duration.zero);
  _openEmployeeWorkspace(controller, screenConstraints);
}

class _EmployeeWorkspaceHeader extends StatelessWidget {
  const _EmployeeWorkspaceHeader({
    required this.controller,
    required this.screenConstraints,
  });

  final EmployeesController controller;
  final BoxConstraints screenConstraints;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: _primary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: LayoutBuilder(
        builder: (context, box) {
          final compact = box.maxWidth < 1050;
          final identity = Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .14),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.assignment_ind_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedBuilder(
                      animation: controller.employeeName,
                      builder: (context, _) {
                        final name = controller.employeeName.text.trim();
                        return Text(
                          name.isEmpty
                              ? controller.currentEmployeeId.value.isEmpty
                                    ? 'New Employee'
                                    : 'Employee Record'
                              : name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 3),
                    AnimatedBuilder(
                      animation: Listenable.merge([
                        controller.hireDate,
                        controller.endDate,
                      ]),
                      builder: (context, _) => Text(
                        controller.getPersonType(
                          controller.hireDate.text,
                          controller.endDate.text,
                        ),
                        style: const TextStyle(
                          color: Color(0xFFD9EAF3),
                          fontSize: 9.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
          final actions = Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.end,
            children: [
              _WorkspaceAction(
                label: 'Leaves',
                icon: Icons.event_available_outlined,
                onPressed: () => _openLeaves(controller, screenConstraints),
              ),
              _WorkspaceAction(
                label: 'Contacts',
                icon: Icons.contact_phone_outlined,
                onPressed: () => _openContacts(controller, screenConstraints),
              ),
              _WorkspaceAction(
                label: 'Documents',
                icon: Icons.attach_file_rounded,
                onPressed: () => _openDocuments(controller),
              ),
              Obx(
                () => _WorkspaceAction(
                  label: controller.addingNewValue.value ? 'Saving' : 'Save',
                  icon: Icons.save_outlined,
                  primary: true,
                  busy: controller.addingNewValue.value,
                  onPressed: controller.addingNewValue.value
                      ? null
                      : () => controller.addNewEmployee(),
                ),
              ),
              _WorkspaceAction(
                label: 'Close',
                icon: Icons.close_rounded,
                onPressed: () => Get.back(),
              ),
            ],
          );
          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                identity,
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: _PeriodPicker(controller: controller),
                ),
                const SizedBox(height: 8),
                Align(alignment: Alignment.centerRight, child: actions),
              ],
            );
          }
          return Row(
            children: [
              Expanded(child: identity),
              _PeriodPicker(controller: controller),
              const SizedBox(width: 10),
              actions,
            ],
          );
        },
      ),
    );
  }
}

class _PeriodPicker extends StatelessWidget {
  const _PeriodPicker({required this.controller});

  final EmployeesController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 155,
      child: MenuWithValues(
        hideClearButton: true,
        dialogWidth: 600,
        width: 155,
        controller: controller.periodFilter,
        displayKeys: const ['period_name'],
        displaySelectedKeys: const ['period_name'],
        data: controller.generatePeriodsFromString(
          convertDateToIson(controller.hireDate.text).toString(),
        ),
        onSelected: (value) async {
          await controller.filterEmployeePayrollElementsByPeriod(
            value['period_name'],
          );
          await controller.getEmployeeBalances(value['period_name']);
        },
      ),
    );
  }
}

class _WorkspaceAction extends StatelessWidget {
  const _WorkspaceAction({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.primary = false,
    this.busy = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool primary;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: primary ? _primary : Colors.white,
          backgroundColor: primary
              ? Colors.white
              : Colors.white.withValues(alpha: .10),
          side: BorderSide(
            color: primary ? Colors.white : Colors.white.withValues(alpha: .32),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: busy
            ? const SizedBox(
                width: 13,
                height: 13,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _primary,
                ),
              )
            : Icon(icon, size: 15),
        label: Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _ProfileEmploymentTab extends StatelessWidget {
  const _ProfileEmploymentTab({required this.controller});

  final EmployeesController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, box) {
              final image = _EmployeeImageCard(controller: controller);
              final personal = _EditorSection(
                title: 'Personal Information',
                subtitle: 'Identity and personal details',
                icon: Icons.person_outline_rounded,
                child: _PersonalFields(controller: controller),
              );
              if (box.maxWidth < 850) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [image, const SizedBox(height: 12), personal],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 230, child: image),
                  const SizedBox(width: 12),
                  Expanded(child: personal),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          _EditorSection(
            title: 'Employment Information',
            subtitle: 'Assignment, reporting line and contract dates',
            icon: Icons.business_center_outlined,
            child: _EmploymentFields(controller: controller),
          ),
        ],
      ),
    );
  }
}

class _EmployeeImageCard extends StatelessWidget {
  const _EmployeeImageCard({required this.controller});

  final EmployeesController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: _line),
      ),
      child: Column(
        children: [
          Obx(() {
            final network = controller.employeeImage.value.trim();
            return GetBuilder<EmployeesController>(
              builder: (_) {
                final memory = controller.imageBytes;
                return InkWell(
                  onTap: controller.pickImage,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 185,
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: _primarySoft,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFC6DDE9)),
                    ),
                    child: memory != null
                        ? Image.memory(memory, fit: BoxFit.cover)
                        : network.isNotEmpty
                        ? Image.network(
                            network,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const _ImagePlaceholder(),
                          )
                        : const _ImagePlaceholder(),
                  ),
                );
              },
            );
          }),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 33,
            child: OutlinedButton.icon(
              onPressed: controller.pickImage,
              style: OutlinedButton.styleFrom(
                foregroundColor: _primary,
                backgroundColor: _primarySoft,
                side: const BorderSide(color: Color(0xFFC3DDEB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.add_a_photo_outlined, size: 15),
              label: const Text(
                'CHOOSE PHOTO',
                style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Click the image to upload or replace the employee photo.',
            textAlign: TextAlign.center,
            style: TextStyle(color: _muted, height: 1.4, fontSize: 8.5),
          ),
        ],
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.person_outline_rounded,
          color: _secondary,
          size: compact ? 37 : 58,
        ),
        SizedBox(height: compact ? 3 : 8),
        if (!compact)
          const Text(
            'No photo selected',
            style: TextStyle(color: _muted, fontSize: 9.5),
          ),
      ],
    );
  }
}

class _EditorSection extends StatelessWidget {
  const _EditorSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: _line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            decoration: const BoxDecoration(
              color: _surfaceSoft,
              border: Border(bottom: BorderSide(color: _line)),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _primarySoft,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(icon, color: _primary, size: 17),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: _text,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(color: _muted, fontSize: 8.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(13), child: child),
        ],
      ),
    );
  }
}

class _PersonalFields extends StatelessWidget {
  const _PersonalFields({required this.controller});

  final EmployeesController controller;

  @override
  Widget build(BuildContext context) {
    return _ResponsiveEditorGrid(
      children: [
        myTextFormFieldWithBorder(
          labelText: 'Full Name',
          controller: controller.employeeName,
          width: double.infinity,
        ),
        _LookupWithAdd(
          tooltip: 'Manage countries',
          onAdd: () =>
              _openSetupScreen(title: 'Countries', child: const Countries()),
          child: MenuWithValues(
            labelText: 'Country of Birth',
            headerLqabel: 'Countries',
            dialogWidth: 620,
            width: double.infinity,
            controller: controller.employeeCountryOfBirth,
            displayKeys: const ['name'],
            displaySelectedKeys: const ['name'],
            onOpen: controller.getCountries,
            onDelete: () {
              controller.employeeCountryOfBirth.clear();
              controller.employeeCountryOfBirthId.value = '';
            },
            onSelected: (value) {
              controller.employeeCountryOfBirth.text = value['name'];
              controller.employeeCountryOfBirthId.value = value['_id'];
            },
          ),
        ),
        myTextFormFieldWithBorder(
          labelText: 'Place of Birth',
          controller: controller.employeePlaceOfBirth,
          width: double.infinity,
        ),
        myTextFormFieldWithBorder(
          labelText: 'Date of Birth',
          controller: controller.employeeDateOfBirth,
          width: double.infinity,
          isDate: true,
          suffixIcon: IconButton(
            onPressed: () =>
                selectDateContext(context, controller.employeeDateOfBirth),
            icon: const Icon(Icons.calendar_month_outlined, size: 18),
          ),
          onFieldSubmitted: (_) => normalizeDate(
            controller.employeeDateOfBirth.text,
            controller.employeeDateOfBirth,
          ),
        ),
        _LookupWithAdd(
          tooltip: 'Manage gender values',
          onAdd: () => _openListValueManager(
            controller,
            code: 'GENDER',
            title: 'Gender',
          ),
          child: MenuWithValues(
            labelText: 'Gender',
            headerLqabel: 'Gender',
            dialogWidth: 620,
            width: double.infinity,
            controller: controller.employeeGender,
            displayKeys: const ['name'],
            displaySelectedKeys: const ['name'],
            onOpen: controller.getGenders,
            onDelete: () {
              controller.employeeGender.clear();
              controller.employeeGenderId.value = '';
            },
            onSelected: (value) {
              controller.employeeGender.text = value['name'];
              controller.employeeGenderId.value = value['_id'];
            },
          ),
        ),
        _LookupWithAdd(
          tooltip: 'Manage marital status values',
          onAdd: () => _openListValueManager(
            controller,
            code: 'MARITAL_STATUS',
            title: 'Marital Status',
          ),
          child: MenuWithValues(
            labelText: 'Marital Status',
            headerLqabel: 'Marital Status',
            dialogWidth: 620,
            width: double.infinity,
            controller: controller.employeeMaritalStatus,
            displayKeys: const ['name'],
            displaySelectedKeys: const ['name'],
            onOpen: controller.getMaritalStatus,
            onDelete: () {
              controller.employeeMaritalStatus.clear();
              controller.employeeMaritalStatusId.value = '';
            },
            onSelected: (value) {
              controller.employeeMaritalStatus.text = value['name'];
              controller.employeeMaritalStatusId.value = value['_id'];
            },
          ),
        ),
        _LookupWithAdd(
          tooltip: 'Manage legislations',
          onAdd: () => _openSetupScreen(
            title: 'Legislations',
            child: const Legislation(),
          ),
          child: MenuWithValues(
            labelText: 'Legislation *',
            headerLqabel: 'Legislations',
            dialogWidth: 620,
            width: double.infinity,
            controller: controller.employeeLegislation,
            displayKeys: const ['name'],
            displaySelectedKeys: const ['name'],
            onOpen: controller.getAllLegislations,
            onDelete: () {
              controller.employeeLegislation.clear();
              controller.employeeLegislationId.value = '';
            },
            onSelected: (value) {
              controller.employeeLegislation.text = value['name'];
              controller.employeeLegislationId.value = value['_id'];
            },
          ),
        ),
      ],
    );
  }
}

class _EmploymentFields extends StatelessWidget {
  const _EmploymentFields({required this.controller});

  final EmployeesController controller;

  @override
  Widget build(BuildContext context) {
    return _ResponsiveEditorGrid(
      children: [
        _LookupWithAdd(
          tooltip: 'Manage employers',
          onAdd: () => _openListValueManager(
            controller,
            code: 'EMPLOYERS',
            title: 'Employers',
          ),
          child: _employmentMenu(
            label: 'Employer',
            controller: controller.jobEmployer,
            onOpen: controller.getallJobEmployers,
            onClear: () {
              controller.jobEmployer.clear();
              controller.jobEmployerId.value = '';
            },
            onSelected: (value) {
              controller.jobEmployer.text = value['name'];
              controller.jobEmployerId.value = value['_id'];
            },
          ),
        ),
        _LookupWithAdd(
          tooltip: 'Manage departments',
          onAdd: () => _openListValueManager(
            controller,
            code: 'DEPARTMENTS',
            title: 'Departments',
          ),
          child: _employmentMenu(
            label: 'Department',
            controller: controller.jobDepartment,
            onOpen: controller.getAllJobDepartments,
            onClear: () {
              controller.jobDepartment.clear();
              controller.jobDepartmentId.value = '';
            },
            onSelected: (value) {
              controller.jobDepartment.text = value['name'];
              controller.jobDepartmentId.value = value['_id'];
            },
          ),
        ),
        _LookupWithAdd(
          tooltip: 'Manage job titles',
          onAdd: () => _openListValueManager(
            controller,
            code: 'JOBS',
            title: 'Job Titles',
          ),
          child: _employmentMenu(
            label: 'Job Title',
            controller: controller.jobTitle,
            onOpen: controller.getallJobTitle,
            onClear: () {
              controller.jobTitle.clear();
              controller.jobTitleId.value = '';
            },
            onSelected: (value) {
              controller.jobTitle.text = value['name'];
              controller.jobTitleId.value = value['_id'];
            },
          ),
        ),
        _LookupWithAdd(
          tooltip: 'Manage locations',
          onAdd: () => _openListValueManager(
            controller,
            code: 'LOCATIONS',
            title: 'Locations',
          ),
          child: _employmentMenu(
            label: 'Location',
            controller: controller.jobLocation,
            onOpen: controller.getallJobLocations,
            onClear: () {
              controller.jobLocation.clear();
              controller.jobLocationId.value = '';
            },
            onSelected: (value) {
              controller.jobLocation.text = value['name'];
              controller.jobLocationId.value = value['_id'];
            },
          ),
        ),
        MenuWithValues(
          labelText: 'Reporting Manager',
          headerLqabel: 'Reporting Managers',
          dialogWidth: 620,
          width: double.infinity,
          controller: controller.reportingManager,
          displayKeys: const ['full_name'],
          displaySelectedKeys: const ['full_name'],
          onOpen: () => controller.getAllReporingManagers(
            controller.currentEmployeeId.value,
            controller.jobEmployerId.value,
          ),
          onDelete: () {
            controller.reportingManager.clear();
            controller.reportingManagerId.value = '';
          },
          onSelected: (value) {
            controller.reportingManager.text = value['full_name'];
            controller.reportingManagerId.value = value['_id'];
          },
        ),
        _LookupWithAdd(
          tooltip: 'Manage payrolls',
          onAdd: () =>
              _openSetupScreen(title: 'Payrolls', child: const Payroll()),
          child: MenuWithValues(
            labelText: 'Payroll *',
            headerLqabel: 'Payrolls',
            dialogWidth: 620,
            width: double.infinity,
            controller: controller.payroll,
            displayKeys: const ['name'],
            displaySelectedKeys: const ['name'],
            onOpen: controller.getAllPayrolls,
            onDelete: () {
              controller.payroll.clear();
              controller.payrollId.value = '';
            },
            onSelected: (value) {
              controller.payroll.text = value['name'];
              controller.payrollId.value = value['_id'];
            },
          ),
        ),
        myTextFormFieldWithBorder(
          labelText: 'Hire Date',
          controller: controller.hireDate,
          width: double.infinity,
          isDate: true,
          suffixIcon: IconButton(
            onPressed: () => selectDateContext(context, controller.hireDate),
            icon: const Icon(Icons.calendar_month_outlined, size: 18),
          ),
          onFieldSubmitted: (_) =>
              normalizeDate(controller.hireDate.text, controller.hireDate),
        ),
        myTextFormFieldWithBorder(
          labelText: 'End Date',
          controller: controller.endDate,
          width: double.infinity,
          isDate: true,
          suffixIcon: IconButton(
            onPressed: () => selectDateContext(context, controller.endDate),
            icon: const Icon(Icons.calendar_month_outlined, size: 18),
          ),
          onFieldSubmitted: (_) =>
              normalizeDate(controller.endDate.text, controller.endDate),
        ),
      ],
    );
  }
}

Widget _employmentMenu({
  required String label,
  required TextEditingController controller,
  required Future<Map<String, dynamic>> Function() onOpen,
  required VoidCallback onClear,
  required void Function(dynamic value) onSelected,
}) {
  return MenuWithValues(
    labelText: label,
    headerLqabel: '${label}s',
    dialogWidth: 620,
    width: double.infinity,
    controller: controller,
    displayKeys: const ['name'],
    displaySelectedKeys: const ['name'],
    onOpen: onOpen,
    onDelete: onClear,
    onSelected: onSelected,
  );
}

class _ResponsiveEditorGrid extends StatelessWidget {
  const _ResponsiveEditorGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        final columns = box.maxWidth >= 1050
            ? 3
            : box.maxWidth >= 500
            ? 2
            : 1;
        const gap = 10.0;
        final width = (box.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: 11,
          children: children
              .map((child) => SizedBox(width: width, child: child))
              .toList(),
        );
      },
    );
  }
}

class _LookupWithAdd extends StatelessWidget {
  const _LookupWithAdd({
    required this.child,
    required this.tooltip,
    required this.onAdd,
  });

  final Widget child;
  final String tooltip;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: child),
        const SizedBox(width: 6),
        Tooltip(
          message: tooltip,
          child: InkWell(
            onTap: onAdd,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _primarySoft,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFBFD9E8)),
              ),
              child: const Icon(Icons.add_rounded, color: _primary, size: 20),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmployeeRecordsTab extends StatelessWidget {
  const _EmployeeRecordsTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: _line),
        ),
        child: DefaultTabController(
          length: 6,
          child: Column(
            children: [
              const _InnerTabBar(
                tabs: [
                  Tab(
                    child: _TabLabel(
                      icon: Icons.location_on_outlined,
                      label: 'ADDRESSES',
                    ),
                  ),
                  Tab(
                    child: _TabLabel(
                      icon: Icons.flag_outlined,
                      label: 'NATIONALITY',
                    ),
                  ),
                  Tab(
                    child: _TabLabel(
                      icon: Icons.phone_outlined,
                      label: 'PHONES',
                    ),
                  ),
                  Tab(
                    child: _TabLabel(
                      icon: Icons.alternate_email_rounded,
                      label: 'EMAILS',
                    ),
                  ),
                  Tab(
                    child: _TabLabel(
                      icon: Icons.account_balance_outlined,
                      label: 'BANK ACCOUNTS',
                    ),
                  ),
                  Tab(
                    child: _TabLabel(
                      icon: Icons.health_and_safety_outlined,
                      label: 'HEALTH CARDS',
                    ),
                  ),
                ],
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, box) {
                    final constraints = BoxConstraints(
                      maxWidth: box.maxWidth,
                      maxHeight: box.maxHeight,
                    );
                    return TabBarView(
                      children: [
                        address_section.addressSectionFotEmployees(
                          constraints: constraints,
                        ),
                        nationality_section.nationalitySectionFotEmployees(
                          constraints: constraints,
                          context: context,
                        ),
                        phone_section.phoneSectionFotEmployees(constraints),
                        email_section.emailSectionFotEmployees(
                          constraints: constraints,
                          context: context,
                        ),
                        bank_section.bankAccountsSection(
                          constraints: constraints,
                          context: context,
                        ),
                        health_section.healthCardSection(
                          constraints: constraints,
                          context: context,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompensationTab extends StatelessWidget {
  const _CompensationTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: _line),
        ),
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              const _InnerTabBar(
                tabs: [
                  Tab(
                    child: _TabLabel(
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'BALANCES',
                    ),
                  ),
                  Tab(
                    child: _TabLabel(
                      icon: Icons.receipt_long_outlined,
                      label: 'PAYROLL ELEMENTS',
                    ),
                  ),
                  Tab(
                    child: _TabLabel(
                      icon: Icons.savings_outlined,
                      label: 'LOANS & ADVANCES',
                    ),
                  ),
                ],
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, box) {
                    final constraints = BoxConstraints(
                      maxWidth: box.maxWidth,
                      maxHeight: box.maxHeight,
                    );
                    return TabBarView(
                      children: [
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(12),
                          child: balances_section.balancesSection(constraints),
                        ),
                        payroll_element_section.payrollElementsSection(
                          constraints,
                          context,
                          height: box.maxHeight,
                        ),
                        loan_section.loanAndAdvancesSection(
                          constraints,
                          context,
                          height: box.maxHeight,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InnerTabBar extends StatelessWidget {
  const _InnerTabBar({required this.tabs});

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: _surfaceSoft,
        border: Border(bottom: BorderSide(color: _line)),
      ),
      child: TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: _primary,
        unselectedLabelColor: _muted,
        indicatorColor: _primary,
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.w900),
        tabs: tabs,
      ),
    );
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(icon, size: 17), const SizedBox(width: 6), Text(label)],
    );
  }
}

Future<void> _openLeaves(
  EmployeesController controller,
  BoxConstraints constraints,
) async {
  if (controller.currentEmployeeId.value.isEmpty) {
    alertMessage(context: Get.context!, content: 'Please save employee first');
    return;
  }
  controller.leavesSearch.value.clear();
  controller.filteredLeavesList.clear();
  await controller.getAllEmployeeLeave();
  leavesDialog(constraints: constraints, controller: controller);
}

Future<void> _openContacts(
  EmployeesController controller,
  BoxConstraints constraints,
) async {
  if (controller.currentEmployeeId.value.isEmpty) {
    alertMessage(context: Get.context!, content: 'Please save employee first');
    return;
  }
  controller.contactsAndRelativesSearch.value.clear();
  controller.filteredContactsAndRelativesList.clear();
  await controller.getContactAndRelative();
  contactsAndRelativesDialog(
    constraints: constraints,
    controller: controller,
    canEdit: true,
  );
}

void _openDocuments(EmployeesController controller) {
  final id = controller.currentEmployeeId.value;
  if (id.isEmpty) {
    alertMessage(context: Get.context!, content: 'Please save employee first');
    return;
  }
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: AttachmentScreen(code: 'EMPLOYEES_ATTACHMENT', documentId: id),
    ),
  );
}

Future<void> _openListValueManager(
  EmployeesController employeeController, {
  required String code,
  required String title,
}) async {
  try {
    final jsonData = await helper.getListDetails(code);
    final listId = jsonData['_id']?.toString() ?? '';
    final masteredBy = jsonData['mastered_by']?.toString() ?? '';
    if (listId.isEmpty) {
      showSnackBar('Alert', 'The list could not be opened');
      return;
    }
    final controller = employeeController.listOfValuesController;
    controller.valueMap.clear();
    controller.searchForValues.value.clear();
    controller.filterValues();
    controller.listIDToWorkWithNewValue.value = listId;
    await controller.getListValues(listId, masteredBy);
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        insetPadding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: SizedBox(
          height: math.min(Get.height - 24, 780),
          width: math.min(Get.width - 24, 850),
          child: Column(
            children: [
              _SetupDialogHeader(title: title),
              Expanded(child: valuesSection(context: Get.context!)),
            ],
          ),
        ),
      ),
    );
  } catch (_) {
    showSnackBar('Alert', 'The list could not be opened');
  }
}

void _openSetupScreen({required String title, required Widget child}) {
  Get.dialog(
    barrierDismissible: false,
    Dialog(
      insetPadding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: SizedBox(
        height: math.min(Get.height - 24, 850),
        width: math.min(Get.width - 24, 1200),
        child: Column(
          children: [
            _SetupDialogHeader(title: title),
            Expanded(child: child),
          ],
        ),
      ),
    ),
  );
}

class _SetupDialogHeader extends StatelessWidget {
  const _SetupDialogHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: const BoxDecoration(
        color: _primary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: Row(
        children: [
          const Icon(Icons.add_box_outlined, color: Colors.white, size: 19),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
