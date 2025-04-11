import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:datahubai/consts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_screen_contro.dart';

class BanksAndOthersController extends GetxController {
  Rx<TextEditingController> accountName = TextEditingController().obs;
  Rx<TextEditingController> accountNumber = TextEditingController().obs;
  Rx<TextEditingController> currency = TextEditingController().obs;
  // Rx<TextEditingController> currencyRate = TextEditingController().obs;
  Rx<TextEditingController> accountType = TextEditingController().obs;
  RxString currencyId = RxString('');
  RxString accountTypeId = RxString('');
  RxString countryId = RxString('');
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  final RxList<DocumentSnapshot> allBanks = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredBanks = RxList<DocumentSnapshot>([]);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxString companyId = RxString('');
  final RxMap<String, String> currencyNames = <String, String>{}.obs;
  RxMap allCurrencies = RxMap({});
  RxMap allAccountTypes = RxMap({});

  @override
  void onInit() async {
    await getCompanyId();
    getAllBanks();
    getCurrencies();
    getAccountTypes();
    search.value.addListener(() {
      filterBanks();
    });
    super.onInit();
  }

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allBanks.sort((bank1, bank2) {
        final String? value1 = bank1['account_name'];
        final String? value2 = bank2['account_name'];

        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allBanks.sort((bank1, bank2) {
        final String? value1 = bank1['account_number'];
        final String? value2 = bank2['account_number'];

        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 4) {
      allBanks.sort((bank1, bank2) {
        final String? value1 = bank1['added_date'];
        final String? value2 = bank2['added_date'];

        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allBanks.sort((bank1, bank2) {
        final String value1 =
            currencyNames[bank1['country_id']]?.toString().toLowerCase() ?? '';
        final String value2 =
            currencyNames[bank2['country_id']]?.toString().toLowerCase() ?? '';

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 3) {
      allBanks.sort((bank1, bank2) {
        final String value1 =
            getdataName(bank1['account_type'], allAccountTypes)
                .toString()
                .toLowerCase();
        final String value2 =
            getdataName(bank2['account_type'], allAccountTypes)
                .toString()
                .toLowerCase();

        return compareString(ascending, value1, value2);
      });
    }

    sortColumnIndex.value = columnIndex;
    isAscending.value = ascending;
  }

  int compareString(bool ascending, String value1, String value2) {
    int comparison = value1.compareTo(value2);
    return ascending ? comparison : -comparison;
  }

  clearValues() {
    accountName.value.clear();
    accountNumber.value.clear();
    currency.value.clear();
    accountType.value.clear();
    currencyId.value = '';
    accountTypeId.value = '';
    countryId.value = '';
  }

  loadValues(Map data) {
    accountName.value.text = data['account_name'];
    accountNumber.value.text = data['account_number'];
    currency.value.text = currencyNames[data['country_id']]!;
    currencyId.value = data['currency'];
    countryId.value = data['country_id'];
    accountType.value.text = getdataName(data['account_type'], allAccountTypes);
    accountTypeId.value = data['account_type'];
  }

  getCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId.value = prefs.getString('companyId')!;
  }

  getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  getAllBanks() {
    try {
      FirebaseFirestore.instance
          .collection('all_banks')
          .where('company_id', isEqualTo: companyId.value)
          .snapshots()
          .listen((banks) {
        allBanks.assignAll(List<DocumentSnapshot>.from(banks.docs));
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  getCurrencies() {
    FirebaseFirestore.instance
        .collection('currencies')
        .snapshots()
        .listen((currency) {
      // allCurrencies.value = {for (var doc in currency.docs) doc.id: doc.data()};
      for (var element in currency.docs) {
        allCurrencies[element.id] = element.data();
        getCurrencyName(element.data()['country_id']);
      }
    });
  }

  // this function is to get colors
  getAccountTypes() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'ACCOUNTS_TYPES')
        .get();

    var typeId = typeDoc.docs.first.id;

    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typeId)
        .collection('values')
        .where('available', isEqualTo: true)
        .snapshots()
        .listen((account) {
      allAccountTypes.value = {
        for (var doc in account.docs) doc.id: doc.data()
      };
    });
  }

  getCurrencyName(countryId) async {
    if (currencyNames.containsKey(countryId)) {
      return currencyNames[countryId]!;
    }

    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('get_currency_name');

      // Call the function with the required parameter.
      final HttpsCallableResult result = await callable.call(countryId);
      final data = result.data;
      if (data != null) {
        currencyNames[countryId] = data;
        return data;
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  addNewBank() {
    try {
      addingNewValue.value = true;
      FirebaseFirestore.instance.collection('all_banks').add({
        'account_name': accountName.value.text,
        'account_number': accountNumber.value.text,
        'currency': currencyId.value,
        'account_type': accountTypeId.value,
        'added_date': DateTime.now().toString(),
        'company_id': companyId.value,
        'country_id': countryId.value
      });
      addingNewValue.value = false;
      Get.back();
      showSnackBar('Done', 'Added Successfully');
    } catch (e) {
      addingNewValue.value = false;
      showSnackBar('Failed', 'Please try again');
    }
  }

  editBank(bankId) {
    try {
      FirebaseFirestore.instance.collection('all_banks').doc(bankId).update({
        'account_name': accountName.value.text,
        'account_number': accountNumber.value.text,
        'currency': currencyId.value,
        'account_type': accountTypeId.value,
        'country_id': countryId.value
      });
      Get.back();
      showSnackBar('Done', 'Edited Successfully');
    } catch (e) {
      showSnackBar('Failed', 'Please try again');
    }
  }

  deleteBank(bankId) {
    try {
      FirebaseFirestore.instance.collection('all_banks').doc(bankId).delete();
      Get.back();
      showSnackBar('Done', 'Deleted Successfully');
    } catch (e) {
      showSnackBar('Failed', 'Please try again');
    }
  }

  String getdataName(String id, Map allData, {title = 'name'}) {
    try {
      final data = allData.entries.firstWhere(
        (data) => data.key == id,
      );
      return data.value[title];
    } catch (e) {
      return '';
    }
  }

  // this function is to filter the search results for web
  void filterBanks() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredBanks.clear();
    } else {
      filteredBanks.assignAll(
        allBanks.where((bank) {
          return bank['account_name']
                  .toString()
                  .toLowerCase()
                  .contains(query) ||
              bank['account_number'].toString().toLowerCase().contains(query) ||
              currencyNames[bank['country_id']]
                  .toString()
                  .toLowerCase()
                  .contains(query) ||
              getdataName(bank['account_type'], allAccountTypes)
                  .toString()
                  .toLowerCase()
                  .contains(query) ||
              textToDate(bank['added_date'])
                  .toString()
                  .toLowerCase()
                  .contains(query);
        }).toList(),
      );
    }
  }
}
