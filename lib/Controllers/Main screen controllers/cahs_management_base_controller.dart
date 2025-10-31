import 'package:datahubai/Models/ar%20receipts%20and%20ap%20payments/customer_invoices_model.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'main_screen_contro.dart';

class CashManagementBaseController extends GetxController {
  TextEditingController note = TextEditingController();
  TextEditingController outstanding = TextEditingController();
  TextEditingController chequeNumber = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController chequeDate = TextEditingController();
  TextEditingController account = TextEditingController();
  TextEditingController currency = TextEditingController();
  TextEditingController rate = TextEditingController();

  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);

  RxBool isChequeSelected = RxBool(false);
  RxString accountId = RxString('');
  RxString bankId = RxString('');
  RxString status = RxString('');
  RxString paymentStatus = RxString('');

  RxBool loadingInvoices = RxBool(false);
  RxMap allBanks = RxMap({});
  var editingIndex = (-1).obs;
  final ScrollController scrollController = ScrollController();
  final ScrollController scrollController2 = ScrollController();
  var buttonLoadingStates = <String, bool>{}.obs;
  // Filters
  Rx<TextEditingController> receiptCounterFilter = TextEditingController().obs;
  Rx<TextEditingController> chequeNumberFilter = TextEditingController().obs;
  Rx<TextEditingController> customerNameFilter = TextEditingController().obs;
  RxString customerNameFilterId = RxString('');
  Rx<TextEditingController> receiptTypeFilter = TextEditingController().obs;
  RxString receiptTypeFilterId = RxString('');
  Rx<TextEditingController> accountFilter = TextEditingController().obs;
  RxString accountFilterId = RxString('');
  Rx<TextEditingController> bankNameFilter = TextEditingController().obs;
  RxString bankNameFilterId = RxString('');
  Rx<TextEditingController> statusFilter = TextEditingController().obs;
  Rx<TextEditingController> fromDate = TextEditingController().obs;
  Rx<TextEditingController> toDate = TextEditingController().obs;
  RxBool isYearSelected = RxBool(false);
  RxBool isMonthSelected = RxBool(false);
  RxBool isDaySelected = RxBool(false);
  RxBool isTodaySelected = RxBool(false);
  RxBool isAllSelected = RxBool(false);
  RxBool isThisMonthSelected = RxBool(false);
  RxBool isThisYearSelected = RxBool(false);
  TextEditingController paymentType = TextEditingController();
  TextEditingController receiptType = TextEditingController();
  RxString paymentTypeId = RxString('');
  RxString receiptTypeId = RxString('');
  RxBool isAllPaymentsSelected = RxBool(false);
  RxList availablePayments = RxList([]);
  RxList<CustomerInvoicesModel> availableReceipts =
      RxList<CustomerInvoicesModel>([]);
  RxList selectedAvailablePayments = RxList([]);
  RxList<CustomerInvoicesModel> selectedAvailableReceipts =
      RxList<CustomerInvoicesModel>([]);
  RxDouble calculatedAmountForAllSelectedReceipts = RxDouble(0.0);
  RxBool isReceiptModified = RxBool(false);
  RxBool isReceiptInvoicesModified = RxBool(false);
  RxBool isPaymentModified = RxBool(false);
  Future<Map<String, dynamic>> getReceiptsAndPaymentsTypes() async {
    return await helper.getAllListValues('RECEIPT_TYPES');
  }

  Future<Map<String, dynamic>> getAllAccounts() async {
    return await helper.getAllBanksAndOthers();
  }

  Future<Map<String, dynamic>> getBanks() async {
    return await helper.getAllListValues('BANKS');
  }

  // ======================================================================================================================
  // function to manage loading button
  void setButtonLoading(String menuId, bool isLoading) {
    buttonLoadingStates[menuId] = isLoading;
    buttonLoadingStates.refresh(); // Notify listeners
  }

  /// Call this to enter edit mode on a row
  void startEditing(int idx) {
    editingIndex.value = idx;
  }

  Future<void> selectDateContext(
    BuildContext context,
    TextEditingController date,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      date.text = textToDate(picked.toString());
    }
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  // ============================================================================================== //

  void removeFilters() {
    isAllSelected.value = false;
    isTodaySelected.value = false;
    isThisMonthSelected.value = false;
    isThisYearSelected.value = false;
  }

  void selectAllPayments(bool select) {
    isAllPaymentsSelected.value = select;

    final newList = availablePayments
        .map((r) => {...r, 'is_selected': select})
        .toList();
    availablePayments.assignAll(newList);
  }

  void selectPayment(int index, bool isSelected) {
    // rebuild a new Map object
    final updated = {...availablePayments[index], 'is_selected': isSelected};

    // reassign into the RxList — that triggers the update
    availablePayments[index] = updated;
  }

  void finishEditingForPayments(String newValue, int idx) {
    // Update the data source
    selectedAvailablePayments[idx]['payment_amount'] = newValue;
    selectedAvailablePayments[idx]['outstanding_amount'] =
        (double.parse(
                  selectedAvailablePayments[idx]['invoice_amount'] ?? '0.0',
                ) -
                double.parse(newValue))
            .toString();
    // Exit edit mode
    // calculateAmountForSelectedReceipts();
    editingIndex.value = -1;
  }

  void removeSelectedPayment(String number) {
    // 1) Un‐select it in the main list
    final availIdx = availablePayments.indexWhere(
      (r) => r['reference_number'] == number,
    );
    if (availIdx != -1) {
      final updated = {...availablePayments[availIdx], 'is_selected': false};
      availablePayments[availIdx] = updated;
    }

    // 2) Remove from the selected list
    selectedAvailablePayments.removeWhere(
      (r) => r['reference_number'] == number,
    );

    // 3) Recalculate totals, etc.
    // calculateAmountForSelectedReceipts();
  }
  // ============================================================================================== //

  void selectAllJobReceipts(bool select) {
    for (var val in availableReceipts) {
      val.isSelected = select;
    }
    availableReceipts.refresh();
  }

  void calculateAmountForSelectedReceipts() {
    calculatedAmountForAllSelectedReceipts.value = 0.0;
    for (var element in selectedAvailableReceipts.where((ite)=>ite.isDeleted != true)) {
      calculatedAmountForAllSelectedReceipts.value += element.receiptAmount;
    }
  }

  void selectJobReceipt(String id, bool isSelected) {
    final receipt = availableReceipts.firstWhereOrNull((vl) => vl.jobId == id);
    if (receipt != null) {
      receipt.isSelected = isSelected;
      availableReceipts.refresh();
    }
  }

  /// Call this when editing is done (Enter pressed)
  void finishEditingForReceipts(String newValue, int idx) {
    // Update the data source
    selectedAvailableReceipts[idx].receiptAmount =
        double.tryParse(newValue) ?? 0;
    selectedAvailableReceipts[idx].outstandingAmount =
        selectedAvailableReceipts[idx].invoiceAmount -
        selectedAvailableReceipts[idx].receiptAmount;
    // Exit edit mode
    calculateAmountForSelectedReceipts();
    selectedAvailableReceipts[idx].isModified = true;
    isReceiptInvoicesModified.value = true;
    editingIndex.value = -1;
  }

  void removeSelectedReceipt(String id) {
    if (status.value != 'New' && status.value != '') {
      showSnackBar('Alert', 'Only new receipts allowed');
      return;
    }
    // Use local variables to avoid multiple list scans

    // 1) Update in availableReceipts (single pass)
    final availIdx = availableReceipts.indexWhere((r) => r.jobId == id);
    if (availIdx != -1) {
      final r = availableReceipts[availIdx];
      r
        ..isSelected = false
        ..isModified = true
        ..isDeleted = true;
    }

    // 2) Update in selectedAvailableReceipts (single pass)
    final selIdx = selectedAvailableReceipts.indexWhere((s) => s.jobId == id);
    if (selIdx != -1) {
      final r = selectedAvailableReceipts[selIdx];
      r
        ..isDeleted = true
        ..isModified = true
        ..isSelected = false;
    }

    // 3) Trigger recalculations and reactive updates
    calculateAmountForSelectedReceipts();
    availableReceipts.refresh();
    isReceiptInvoicesModified.value = true;
    selectedAvailableReceipts.refresh();
  }
}
