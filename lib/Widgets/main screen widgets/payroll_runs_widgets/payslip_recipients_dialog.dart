import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/Main screen controllers/payroll_runs_controller.dart';
import '../../../Models/payroll runs/payroll_runs_details_model.dart';
import '../../../consts.dart';

Future<dynamic> payslipRecipientsDialog({
  required PayrollRunsController controller,
}) {
  return Get.dialog(
    barrierDismissible: false,
    _PayslipRecipientsDialog(controller: controller),
  );
}

class _PayslipRecipientsDialog extends StatefulWidget {
  const _PayslipRecipientsDialog({required this.controller});

  final PayrollRunsController controller;

  @override
  State<_PayslipRecipientsDialog> createState() =>
      _PayslipRecipientsDialogState();
}

class _PayslipRecipientsDialogState extends State<_PayslipRecipientsDialog> {
  late final List<PayrollRunsEmployeeModel> employees;
  late Set<String> selectedEmployeeIds;

  @override
  void initState() {
    super.initState();
    employees = List<PayrollRunsEmployeeModel>.from(
      widget.controller.payrollRunsEmployeeList,
    );
    selectedEmployeeIds = employees
        .map((employee) => employee.employeeId ?? '')
        .where((employeeId) => employeeId.isNotEmpty)
        .toSet();
  }

  bool get allSelected =>
      employees.isNotEmpty && selectedEmployeeIds.length == employees.length;

  void toggleAll() {
    setState(() {
      if (allSelected) {
        selectedEmployeeIds.clear();
      } else {
        selectedEmployeeIds = employees
            .map((employee) => employee.employeeId ?? '')
            .where((employeeId) => employeeId.isNotEmpty)
            .toSet();
      }
    });
  }

  void toggleEmployee(String employeeId) {
    setState(() {
      if (!selectedEmployeeIds.add(employeeId)) {
        selectedEmployeeIds.remove(employeeId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final run = widget.controller.selectedPayrollRunDetails.value;
    final selectedEmployees = employees
        .where((employee) => selectedEmployeeIds.contains(employee.employeeId))
        .toList();

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 720),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.forward_to_inbox_rounded,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email Payslips',
                        style: fontStyleForScreenNameUsedInButtons,
                      ),
                      Text(
                        '${run?.payrollName ?? ''} • ${run?.periodName ?? ''}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  closeIcon(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Choose recipients',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${selectedEmployees.length} of '
                          '${employees.length} employees selected',
                          style: TextStyle(
                            color: Colors.blueGrey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: employees.isEmpty ? null : toggleAll,
                    icon: Icon(
                      allSelected
                          ? Icons.deselect_rounded
                          : Icons.select_all_rounded,
                      size: 18,
                    ),
                    label: Text(allSelected ? 'Clear All' : 'Select All'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: mainColor,
                      side: BorderSide(color: mainColor),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.blueGrey.shade100),
            Expanded(
              child: employees.isEmpty
                  ? const Center(child: Text('No employees found'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: employees.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final employee = employees[index];
                        final employeeId = employee.employeeId ?? '';
                        final email = employee.employeeEmail?.trim() ?? '';
                        final selected = selectedEmployeeIds.contains(
                          employeeId,
                        );

                        return Material(
                          color: selected
                              ? mainColor.withValues(alpha: 0.06)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: employeeId.isEmpty
                                ? null
                                : () => toggleEmployee(employeeId),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: selected
                                      ? mainColor.withValues(alpha: 0.45)
                                      : Colors.blueGrey.shade100,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: selected,
                                    activeColor: mainColor,
                                    onChanged: employeeId.isEmpty
                                        ? null
                                        : (_) => toggleEmployee(employeeId),
                                  ),
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: mainColor.withValues(
                                      alpha: 0.12,
                                    ),
                                    child: Text(
                                      _employeeInitials(employee.employeeName),
                                      style: TextStyle(
                                        color: mainColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          employee.employeeName ?? 'Employee',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        if ((employee.employeeNumber ?? '')
                                            .isNotEmpty)
                                          Text(
                                            employee.employeeNumber!,
                                            style: TextStyle(
                                              color: Colors.blueGrey.shade500,
                                              fontSize: 11,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    flex: 4,
                                    child: Row(
                                      children: [
                                        Icon(
                                          email.isEmpty
                                              ? Icons.warning_amber_rounded
                                              : Icons.alternate_email_rounded,
                                          size: 17,
                                          color: email.isEmpty
                                              ? Colors.orange
                                              : Colors.blueGrey.shade600,
                                        ),
                                        const SizedBox(width: 7),
                                        Expanded(
                                          child: Text(
                                            email.isEmpty
                                                ? 'No payslip email selected'
                                                : email,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: email.isEmpty
                                                  ? Colors.orange.shade800
                                                  : Colors.blueGrey.shade700,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.blueGrey,
                    size: 18,
                  ),
                  const SizedBox(width: 7),
                  const Expanded(
                    child: Text(
                      'Employees without a selected payslip email will be skipped.',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 11),
                    ),
                  ),
                  TextButton(onPressed: Get.back, child: const Text('Cancel')),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                    ),
                    onPressed: selectedEmployees.isEmpty
                        ? null
                        : () {
                            final runId = run?.id ?? '';
                            Get.back();
                            widget.controller.emailPayslips(
                              runId,
                              selectedEmployees: selectedEmployees,
                            );
                          },
                    icon: const Icon(Icons.send_rounded, size: 18),
                    label: Text(
                      'Send ${selectedEmployees.length} '
                      '${selectedEmployees.length == 1 ? 'Payslip' : 'Payslips'}',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _employeeInitials(String? name) {
  final words = (name ?? '')
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .take(2)
      .toList();
  if (words.isEmpty) return 'E';
  return words.map((word) => word[0].toUpperCase()).join();
}
