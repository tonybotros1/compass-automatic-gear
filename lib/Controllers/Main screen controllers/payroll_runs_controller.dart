import 'dart:convert';
import 'dart:typed_data';

import 'package:datahubai/Models/payroll%20runs/payroll_runs_details_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;

import '../../Models/payroll runs/payroll_runs_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';

class PayrollRunsController extends GetxController {
  final GlobalKey<FormState> payrollRunFormKey = GlobalKey<FormState>();
  RxBool isScreenLoding = RxBool(false);
  RxList<PayrollRunsModel> allPayrollRuns = RxList<PayrollRunsModel>([]);
  RxBool addingNewValue = RxBool(false);
  RxBool rollingBack = RxBool(false);
  RxBool printingPayslip = RxBool(false);
  RxBool exportingBankFile = RxBool(false);
  RxMap companyDetails = RxMap({});
  TextEditingController payrollName = TextEditingController();
  TextEditingController periodName = TextEditingController();
  TextEditingController employeeName = TextEditingController();
  TextEditingController elementName = TextEditingController();
  RxString payrollNameId = RxString('');
  RxString periodNameId = RxString('');
  RxString employeeId = RxString('');
  RxString elementId = RxString('');
  RxList<PayrollRunsEmployeeModel> payrollRunsEmployeeList =
      RxList<PayrollRunsEmployeeModel>();
  RxList<PayrollRunsEmployeeModel> filteredPayrollRunsEmployeeList =
      RxList<PayrollRunsEmployeeModel>();
  Rxn<PayrollRunDetailsModel> selectedPayrollRunDetails =
      Rxn<PayrollRunDetailsModel>();
  Rxn<PayrollRunsEmployeeModel> selectedPayrollRunEmployee =
      Rxn<PayrollRunsEmployeeModel>();

  RxList<PayrollRunsEmployeeElementsModel> payrollRunsEmployeeElementsList =
      RxList<PayrollRunsEmployeeElementsModel>();
  RxList<PayrollRunsEmployeeElementsModel>
  filteredPayrollRunsEmployeeElementsList =
      RxList<PayrollRunsEmployeeElementsModel>();
  RxList<PayrollRunsEmployeeElementsModel>
  payrollRunsEmployeeElementsInformationList =
      RxList<PayrollRunsEmployeeElementsModel>();

  RxString emploeeQuery = RxString('');
  Rx<TextEditingController> employeeSearch = TextEditingController().obs;

  RxString elementQuery = RxString('');
  Rx<TextEditingController> elementSearch = TextEditingController().obs;

  @override
  void onInit() {
    getAllPayrollRuns();
    getCompanyDetails();
    super.onInit();
  }

  @override
  void onClose() {
    payrollName.dispose();
    periodName.dispose();
    employeeName.dispose();
    elementName.dispose();
    employeeSearch.value.dispose();
    elementSearch.value.dispose();
    super.onClose();
  }

  bool _validatePayrollRun() {
    if (!(payrollRunFormKey.currentState?.validate() ?? false)) return false;
    if (payrollNameId.value.trim().isEmpty) {
      alertMessage(context: Get.context!, content: 'Please select payroll');
      return false;
    }
    if (periodNameId.value.trim().isEmpty) {
      alertMessage(context: Get.context!, content: 'Please select period');
      return false;
    }
    return true;
  }

  void clearPayrollRunValues() {
    payrollRunFormKey.currentState?.reset();
    payrollName.clear();
    periodName.clear();
    employeeName.clear();
    elementName.clear();
    payrollNameId.value = '';
    periodNameId.value = '';
    employeeId.value = '';
    elementId.value = '';
  }

  void clearPayrollDependentValues() {
    periodName.clear();
    employeeName.clear();
    periodNameId.value = '';
    employeeId.value = '';
  }

  void clearElementSelection() {
    elementName.clear();
    elementId.value = '';
  }

  void clearPayrollRunDetails() {
    employeeSearch.value.clear();
    elementSearch.value.clear();
    emploeeQuery.value = '';
    elementQuery.value = '';
    payrollRunsEmployeeList.clear();
    filteredPayrollRunsEmployeeList.clear();
    selectedPayrollRunDetails.value = null;
    selectedPayrollRunEmployee.value = null;
    payrollRunsEmployeeElementsList.clear();
    filteredPayrollRunsEmployeeElementsList.clear();
    payrollRunsEmployeeElementsInformationList.clear();
  }

  void selectPayrollRunEmployee(PayrollRunsEmployeeModel employee) {
    selectedPayrollRunEmployee.value = employee;
    elementSearch.value.clear();
    elementQuery.value = '';
    filteredPayrollRunsEmployeeElementsList.clear();
    payrollRunsEmployeeElementsList.assignAll(
      employee.runEmployeeDetails ?? [],
    );
    payrollRunsEmployeeElementsInformationList.assignAll(
      employee.runEmployeeInformation ?? [],
    );
  }

  Future<Map<String, dynamic>> getAllPayrlls() async {
    return await helper.getPayrolls();
  }

  Future<void> getCompanyDetails() async {
    companyDetails.assignAll(await helper.getCurrentCompanyDetails());
  }

  Future<Map<String, dynamic>> getAllPayrollElements() async {
    return await helper.getAllPayrollElements();
  }

  Future<Map<String, dynamic>> getPayrollPeriods() async {
    if (payrollNameId.value.isEmpty) return {};
    return await helper.getPayrollPeriods(payrollNameId.value);
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  // Future<Map<String, dynamic>> getPayrollPeriods() async {
  //   try {
  //     final SharedPreferences prefs = await SharedPreferences.getInstance();
  //     var accessToken = '${prefs.getString('accessToken')}';
  //     final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
  //     var url = Uri.parse(
  //       '$backendTestURI/payroll_runs/get_payroll_periods_for_lov/${payrollNameId.value}',
  //     );
  //     final response = await http.get(
  //       url,
  //       headers: {'Authorization': 'Bearer $accessToken'},
  //     );
  //     if (response.statusCode == 200) {
  //       final decode = jsonDecode(response.body);
  //       List<dynamic> jsonData = decode['all_periods'];
  //       Map<String, dynamic> map = {
  //         for (var model in jsonData) model['_id']: model,
  //       };
  //       return map;
  //     } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
  //       final refreshed = await helper.refreshAccessToken(refreshToken);
  //       if (refreshed == RefreshResult.success) {
  //         return await getPayrollPeriods();
  //       } else if (refreshed == RefreshResult.invalidToken) {
  //         logout();
  //       }
  //       return {};
  //     } else if (response.statusCode == 401) {
  //       logout();
  //       return {};
  //     } else {
  //       return {};
  //     }
  //   } catch (e) {
  //     return {};
  //   }
  // }

  Future<Map<String, dynamic>> getAllEmployeesForSelectedPayroll() async {
    try {
      if (payrollNameId.value.isEmpty) return {};

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse(
        '$backendTestURI/payroll_runs/get_all_employees_for_payroll_runs_lov/${payrollNameId.value}',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        List<dynamic> jsonData = decode['all_employees'];
        Map<String, dynamic> map = {
          for (var model in jsonData) model['_id']: model,
        };
        return map;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getAllEmployeesForSelectedPayroll();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
        return {};
      } else if (response.statusCode == 401) {
        logout();
        return {};
      } else {
        return {};
      }
    } catch (e) {
      return {};
    }
  }

  Future<void> getAllPayrollRuns() async {
    try {
      isScreenLoding.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendTestURI/payroll_runs/get_all_payroll_runs');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List branches = decoded['payroll_runs'];
        allPayrollRuns.assignAll(
          branches.map((run) => PayrollRunsModel.fromJson(run)),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getAllPayrollRuns();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      isScreenLoding.value = false;
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  Future<bool> getPayrollRunsDetails(String id) async {
    try {
      if (id.isEmpty) return false;

      isScreenLoding.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendTestURI/payroll_runs/get_payroll_runs_details/$id',
      );
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        PayrollRunDetailsModel details = PayrollRunDetailsModel.fromJson(
          decoded['payroll_runs_details'],
        );
        selectedPayrollRunDetails.value = details;
        payrollRunsEmployeeList.assignAll(details.employeesDetails ?? []);
        isScreenLoding.value = false;
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await getPayrollRunsDetails(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      isScreenLoding.value = false;
      return false;
    } catch (e) {
      isScreenLoding.value = false;
      return false;
    }
  }

  Future<PayrollRunDetailsModel?> prepareBankExportDetails(String id) async {
    try {
      if (id.isEmpty) return null;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendTestURI/payroll_runs/prepare_bank_export/$id',
      );
      final response = await http.patch(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final details = PayrollRunDetailsModel.fromJson(
          decoded['payroll_runs_details'],
        );
        selectedPayrollRunDetails.value = details;
        payrollRunsEmployeeList.assignAll(details.employeesDetails ?? []);
        _syncPayrollRunList(details);
        return details;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await prepareBankExportDetails(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  void _syncPayrollRunList(PayrollRunDetailsModel details) {
    final id = details.id ?? '';
    if (id.isEmpty) return;

    final index = allPayrollRuns.indexWhere((run) => run.id == id);
    if (index == -1) return;

    allPayrollRuns[index] = PayrollRunsModel(
      id: details.id,
      runNumber: details.runNumber,
      payrollName: details.payrollName,
      periodName: details.periodName,
      description: details.description,
      paymentNumber: details.paymentNumber,
    );
  }

  Future<void> payrollRun() async {
    try {
      if (!_validatePayrollRun()) return;

      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendTestURI/payroll_runs/payroll_run');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "payroll_id": payrollNameId.value,
          "period_id": periodNameId.value,
          "employee_id": employeeId.value,
          "element_id": elementId.value,
        }),
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        PayrollRunsModel addedRun = PayrollRunsModel.fromJson(
          decoded['added_run'],
        );
        allPayrollRuns.insert(0, addedRun);
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await payrollRun();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      // Get.back();
      addingNewValue.value = false;
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  Future<bool> payrollRollback(String runId) async {
    try {
      if (runId.isEmpty) return false;

      rollingBack.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendTestURI/payroll_runs/rollback_payroll_run/$runId',
      );
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        allPayrollRuns.removeWhere((i) => i.id == runId);
        rollingBack.value = false;
        return true;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          return await payrollRollback(runId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      rollingBack.value = false;
      return false;
    } catch (e) {
      alertMessage(
        context: Get.context!,
        content: "Coud not rollback please try again later",
      );
      rollingBack.value = false;
      return false;
    }
  }

  void filterPayrollEmployees() {
    emploeeQuery.value = employeeSearch.value.text.toLowerCase();
    if (emploeeQuery.value.isEmpty) {
      filteredPayrollRunsEmployeeList.clear();
    } else {
      filteredPayrollRunsEmployeeList.assignAll(
        payrollRunsEmployeeList.where((employee) {
          return employee.employeeName.toString().toLowerCase().contains(
            emploeeQuery.value,
          );
        }).toList(),
      );
    }
  }

  void filterPayrollEmployeesElements() {
    elementQuery.value = elementSearch.value.text.toLowerCase();
    if (elementQuery.value.isEmpty) {
      filteredPayrollRunsEmployeeElementsList.clear();
    } else {
      filteredPayrollRunsEmployeeElementsList.assignAll(
        payrollRunsEmployeeElementsList.where((employee) {
          return employee.elementName.toString().toLowerCase().contains(
            elementQuery.value,
          );
        }).toList(),
      );
    }
  }

  Future<void> exportBankPaymentFile() async {
    try {
      final run = selectedPayrollRunDetails.value;
      if (run == null) {
        alertMessage(
          context: Get.context!,
          content: 'Please open payroll run details first',
        );
        return;
      }

      final currentPayableEmployees = (run.employeesDetails ?? [])
          .where((employee) => (employee.netSalary ?? 0) > 0)
          .toList();
      if (currentPayableEmployees.isEmpty) {
        alertMessage(
          context: Get.context!,
          content: 'No positive net salary found to export',
        );
        return;
      }

      exportingBankFile.value = true;
      final preparedRun = await prepareBankExportDetails(run.id ?? '');
      if (preparedRun == null) {
        exportingBankFile.value = false;
        alertMessage(
          context: Get.context!,
          content: 'Could not prepare bank export please try again later',
        );
        return;
      }

      final employees = preparedRun.employeesDetails ?? [];
      final payableEmployees = employees
          .where((employee) => (employee.netSalary ?? 0) > 0)
          .toList();

      if (companyDetails.isEmpty) await getCompanyDetails();

      final csvContent = _buildBankPaymentCsv(preparedRun, payableEmployees);
      final fileName = _bankExportFileName(preparedRun);
      _downloadTextFile(csvContent, fileName, 'text/csv;charset=utf-8');
      final missingBankCount = payableEmployees
          .where((employee) => !_hasBankDetails(employee))
          .length;
      final message = missingBankCount == 0
          ? 'Bank export created'
          : 'Bank export created with $missingBankCount missing bank detail rows';
      showSnackBar('Done', message);
      exportingBankFile.value = false;
    } catch (e) {
      exportingBankFile.value = false;
      alertMessage(
        context: Get.context!,
        content: 'Could not export bank payment file please try again later',
      );
    }
  }

  Future<void> printPayslip(PayrollRunsEmployeeModel employee) async {
    try {
      if (selectedPayrollRunDetails.value == null) {
        alertMessage(
          context: Get.context!,
          content: 'Please open payroll run details first',
        );
        return;
      }

      printingPayslip.value = true;
      selectedPayrollRunEmployee.value = employee;
      if (companyDetails.isEmpty) await getCompanyDetails();
      final pdfData = await generatePayslipPdf(employee);
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfData,
      );
      printingPayslip.value = false;
    } catch (e) {
      printingPayslip.value = false;
      alertMessage(
        context: Get.context!,
        content: 'Could not generate payslip please try again later',
      );
    }
  }

  Future<Uint8List> generatePayslipPdf(
    PayrollRunsEmployeeModel employee,
  ) async {
    final run = selectedPayrollRunDetails.value;
    final pdf = pw.Document();
    final payrollElements = employee.runEmployeeDetails ?? [];
    final informationElements = employee.runEmployeeInformation ?? [];
    final periodStartDate = textToDate(run?.periodStartDate);
    final periodEndDate = textToDate(run?.periodEndDate);
    final periodDates = periodStartDate.isNotEmpty && periodEndDate.isNotEmpty
        ? '$periodStartDate - $periodEndDate'
        : _cleanText(run?.periodName);
    final currencyCode = _cleanText(
      companyDetails['currency_code']?.toString(),
      fallback: 'AED',
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        footer: (context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            ),
          );
        },
        build: (context) {
          return [
            _payslipHeader(run, employee, periodDates),
            pw.SizedBox(height: 18),
            _summarySection(employee, currencyCode),
            pw.SizedBox(height: 18),
            _sectionTitle('Payroll Elements'),
            _payrollElementsTable(payrollElements, currencyCode),
            if (informationElements.isNotEmpty) ...[
              pw.SizedBox(height: 18),
              _sectionTitle('Information'),
              _informationElementsTable(informationElements),
            ],
            pw.SizedBox(height: 28),
            _signatureSection(),
          ];
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _payslipHeader(
    PayrollRunDetailsModel? run,
    PayrollRunsEmployeeModel employee,
    String periodDates,
  ) {
    final companyName = _cleanText(
      companyDetails['company_name']?.toString(),
      fallback: 'Company',
    );

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  companyName,
                  style: const pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  'Generated on ${format.format(DateTime.now())}',
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
            ),
            pw.Text(
              'PAYSLIP',
              style: const pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blueGrey800,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 18),
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
            color: PdfColors.grey100,
          ),
          child: pw.Wrap(
            spacing: 18,
            runSpacing: 8,
            children: [
              _headerField('Employee', employee.employeeName),
              _headerField('Employee No.', employee.employeeNumber),
              _headerField('Payroll', run?.payrollName),
              _headerField('Period', run?.periodName),
              _headerField('Period Dates', periodDates),
              _headerField('Run No.', run?.runNumber),
              _headerField('Payment No.', run?.paymentNumber),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _headerField(String label, String? value) {
    return pw.SizedBox(
      width: 150,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(
              fontSize: 8,
              color: PdfColors.grey700,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Text(_cleanText(value), style: const pw.TextStyle(fontSize: 9)),
        ],
      ),
    );
  }

  pw.Widget _summarySection(
    PayrollRunsEmployeeModel employee,
    String currencyCode,
  ) {
    return pw.Row(
      children: [
        _summaryBox(
          'Total Payments',
          '${_formatAmount(employee.totalPayments)} $currencyCode',
          PdfColors.green700,
        ),
        pw.SizedBox(width: 8),
        _summaryBox(
          'Total Deductions',
          '${_formatAmount(employee.totalDeductions)} $currencyCode',
          PdfColors.red700,
        ),
        pw.SizedBox(width: 8),
        _summaryBox(
          'Net Salary',
          '${_formatAmount(employee.netSalary)} $currencyCode',
          PdfColors.blue700,
        ),
      ],
    );
  }

  pw.Widget _summaryBox(String label, String value, PdfColor color) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: color, width: 0.7),
          borderRadius: pw.BorderRadius.circular(4),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label,
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget _sectionTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Text(
        title,
        style: const pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  pw.Widget _payrollElementsTable(
    List<PayrollRunsEmployeeElementsModel> elements,
    String currencyCode,
  ) {
    final data = elements.isEmpty
        ? [
            ['No payroll elements', '', '', '', ''],
          ]
        : elements.map((element) {
            return [
              _cleanText(element.elementName),
              _cleanText(element.elementType),
              _formatOptionalNumber(element.number),
              '${_formatAmount(element.payment)} $currencyCode',
              '${_formatAmount(element.deduction)} $currencyCode',
            ];
          }).toList();

    return pw.TableHelper.fromTextArray(
      headers: ['Element', 'Type', 'Number', 'Payment', 'Deduction'],
      data: data,
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
      headerStyle: const pw.TextStyle(
        color: PdfColors.white,
        fontWeight: pw.FontWeight.bold,
        fontSize: 9,
      ),
      cellStyle: const pw.TextStyle(fontSize: 8),
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      cellAlignments: {
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
      },
    );
  }

  pw.Widget _informationElementsTable(
    List<PayrollRunsEmployeeElementsModel> elements,
  ) {
    return pw.TableHelper.fromTextArray(
      headers: ['Element', 'Number', 'Value'],
      data: elements.map((element) {
        return [
          _cleanText(element.elementName),
          _formatOptionalNumber(element.number),
          _formatOptionalNumber(element.information),
        ];
      }).toList(),
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
      headerStyle: const pw.TextStyle(
        color: PdfColors.white,
        fontWeight: pw.FontWeight.bold,
        fontSize: 9,
      ),
      cellStyle: const pw.TextStyle(fontSize: 8),
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      cellAlignments: {
        1: pw.Alignment.centerRight,
        2: pw.Alignment.centerRight,
      },
    );
  }

  pw.Widget _signatureSection() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        _signatureLine('Prepared By'),
        _signatureLine('Employee Signature'),
      ],
    );
  }

  pw.Widget _signatureLine(String label) {
    return pw.SizedBox(
      width: 190,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(height: 0.5, color: PdfColors.grey600),
          pw.SizedBox(height: 5),
          pw.Text(label, style: const pw.TextStyle(fontSize: 8)),
        ],
      ),
    );
  }

  String _buildBankPaymentCsv(
    PayrollRunDetailsModel run,
    List<PayrollRunsEmployeeModel> employees,
  ) {
    final currencyCode = _cleanText(
      companyDetails['currency_code']?.toString(),
      fallback: 'AED',
    );
    final headers = [
      'Run Number',
      'Payment Number',
      'Payroll',
      'Period',
      'Period Start',
      'Period End',
      'Employee Number',
      'Employee Name',
      'Bank Name',
      'Account Number',
      'IBAN',
      'SWIFT Code',
      'Currency',
      'Net Salary',
      'Status',
    ];
    final rows = employees.map((employee) {
      return [
        run.runNumber,
        run.paymentNumber,
        run.payrollName,
        run.periodName,
        textToDate(run.periodStartDate),
        textToDate(run.periodEndDate),
        employee.employeeNumber,
        employee.employeeName,
        employee.bankName,
        employee.accountNumber,
        employee.iban,
        employee.swiftCode,
        currencyCode,
        _formatBankAmount(employee.netSalary),
        _hasBankDetails(employee) ? 'Ready' : 'Missing bank details',
      ];
    });

    return [_csvRow(headers), ...rows.map(_csvRow)].join('\r\n');
  }

  String _csvRow(Iterable<dynamic> values) {
    return values.map((value) => _csvValue(value?.toString() ?? '')).join(',');
  }

  String _csvValue(String value) {
    final escaped = value.replaceAll('"', '""');
    return '"$escaped"';
  }

  bool _hasBankDetails(PayrollRunsEmployeeModel employee) {
    final hasBankName = (employee.bankName ?? '').trim().isNotEmpty;
    final hasAccount = (employee.accountNumber ?? '').trim().isNotEmpty;
    final hasIban = (employee.iban ?? '').trim().isNotEmpty;
    return hasBankName && (hasAccount || hasIban);
  }

  void _downloadTextFile(String content, String fileName, String mimeType) {
    final blob = html.Blob([utf8.encode(content)], mimeType);
    final objectUrl = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: objectUrl)
      ..setAttribute('download', fileName)
      ..click();
    html.Url.revokeObjectUrl(objectUrl);
  }

  String _bankExportFileName(PayrollRunDetailsModel run) {
    final runNumber = _safeFileNamePart(run.runNumber, fallback: 'payroll-run');
    final periodName = _safeFileNamePart(run.periodName, fallback: 'period');
    return 'bank_export_${runNumber}_$periodName.csv';
  }

  String _safeFileNamePart(String? value, {required String fallback}) {
    final clean = (value ?? '').trim().replaceAll(
      RegExp(r'[^A-Za-z0-9]+'),
      '_',
    );
    return clean.isEmpty ? fallback : clean;
  }

  String _cleanText(String? value, {String fallback = '-'}) {
    if (value == null || value.trim().isEmpty) return fallback;
    return value;
  }

  String _formatAmount(num? value) {
    return priceFormat.format((value ?? 0).toDouble());
  }

  String _formatBankAmount(num? value) {
    return (value ?? 0).toDouble().toStringAsFixed(2);
  }

  String _formatOptionalNumber(num? value) {
    if (value == null || value == 0) return '';
    return priceFormat.format(value.toDouble());
  }
}
