import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobCardController extends GetxController {
  TextEditingController jobCardCounter = TextEditingController();
  TextEditingController plateNumber = TextEditingController();
  TextEditingController carCode = TextEditingController();
  TextEditingController carBrand = TextEditingController();
  TextEditingController carModel = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController year = TextEditingController();
  TextEditingController vin = TextEditingController();
  TextEditingController color = TextEditingController();
  TextEditingController customerName = TextEditingController();
  TextEditingController customerPhoneNumber = TextEditingController();
  TextEditingController customerCreditNumber = TextEditingController(text: '0');
  TextEditingController customerOutstanding = TextEditingController(text: '0');
  TextEditingController customerSaleMan = TextEditingController();
  TextEditingController customerBranch = TextEditingController();
  TextEditingController customerCurrency = TextEditingController();
  TextEditingController customerCurrencyRate = TextEditingController(text: '0');
  Rx<TextEditingController> mileageIn = TextEditingController(text: '0').obs;
  Rx<TextEditingController> mileageOut = TextEditingController(text: '0').obs;
  Rx<TextEditingController> inOutDiff = TextEditingController(text: '0').obs;
  RxString carBrandId = RxString('');
  RxString carModelId = RxString('');
  RxString countryId = RxString('');
  RxString colorId = RxString('');
  RxString cityId = RxString('');
  RxString customerId = RxString('');
  RxString customerSaleManId = RxString('');
  RxString customerBranchId = RxString('');
  RxString customerCurrencyId = RxString('');
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  final RxList<DocumentSnapshot> allJobCards = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredJobCards =
      RxList<DocumentSnapshot>([]);

  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxString companyId = RxString('');
  RxMap allCountries = RxMap({});
  RxMap filterdCitiesByCountry = RxMap({});
  RxMap allCities = RxMap({});
  RxMap allColors = RxMap({});
  RxMap allBranches = RxMap({});
  RxMap allCurrencies = RxMap({});

  RxMap allBrands = RxMap({});
  RxMap filterdModelsByBrands = RxMap({});
  RxMap allModels = RxMap({});
  RxMap allCustomers = RxMap({});
  RxMap salesManMap = RxMap({});
  RxBool isCashSelected = RxBool(false);
  RxBool isCreditSelected = RxBool(false);
  RxString payType = RxString('');
  @override
  void onInit() async {
    super.onInit();
    await getCompanyId();
    await getCurrentJobCardCounterNumber();
    getSalesMan();
    getBranches();
    getBranches();
    getCurrencies();
    getAllCustomers();
    getColors();
    getCarsModelsAndBrands();
    getCountriesAndCities();
    getAllJobCards();
  }


  
  void selectCashOrCredit(String selected, bool value) {
    bool isCash = selected == 'cash';

    isCashSelected.value = isCash ? value : false;
    isCreditSelected.value = isCash ? false : value;
    payType.value = isCash ? 'Cash' : 'Credit';
  }

  getCurrencies() {
    FirebaseFirestore.instance
        .collection('currencies')
        .snapshots()
        .listen((branches) {
      allCurrencies.value = {for (var doc in branches.docs) doc.id: doc.data()};
    });
  }

  getBranches() {
    FirebaseFirestore.instance
        .collection('branches')
        .snapshots()
        .listen((branches) {
      allBranches.value = {for (var doc in branches.docs) doc.id: doc.data()};
    });
  }

// this function is to get all sales man in the system
  getSalesMan() {
    FirebaseFirestore.instance
        .collection('sales_man')
        .snapshots()
        .listen((saleMan) {
      salesManMap.value = {for (var doc in saleMan.docs) doc.id: doc.data()};
    });
  }

  getCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId.value = prefs.getString('companyId')!;
  }

  inOutDiffCalculating() {
    inOutDiff.value.text =
        (int.parse(mileageOut.value.text) - int.parse(mileageIn.value.text))
            .toString();
  }

// this function is to get industries
  getColors() async {
    var typeDoc = await FirebaseFirestore.instance
        .collection('all_lists')
        .where('code', isEqualTo: 'COLORS')
        .get();

    var typrId = typeDoc.docs.first.id;

    FirebaseFirestore.instance
        .collection('all_lists')
        .doc(typrId)
        .collection('values')
        .where('available', isEqualTo: true)
        .snapshots()
        .listen((colors) {
      allColors.value = {for (var doc in colors.docs) doc.id: doc.data()};
    });
  }

  getAllCustomers() {
    try {
      FirebaseFirestore.instance
          .collection('entity_informations')
          .where('entity_code', arrayContains: 'Customer')
          .snapshots()
          .listen((customers) {
        allCustomers.value = {
          for (var doc in customers.docs) doc.id: doc.data()
        };
      });
    } catch (e) {
      //
    }
  }

  getCurrentJobCardCounterNumber() async {
    try {
      var jcnId = '';
      var jcnDoc = await FirebaseFirestore.instance
          .collection('counters')
          .where('code', isEqualTo: 'JCN')
          .where('company_id', isEqualTo: companyId.value)
          .get();

      if (jcnDoc.docs.isEmpty) {
        var newCounter =
            await FirebaseFirestore.instance.collection('counters').add({
          'code': 'JCN',
          'description': 'Job Card Number',
          'prefix': '',
          'value': 0,
          'added_date': DateTime.now().toString(),
          'company_id': companyId.value,
          'status': true,
        });
        jcnId = newCounter.id;
      } else {
        jcnId = jcnDoc.docs.first.id;
      }
      FirebaseFirestore.instance
          .collection('counters')
          .doc(jcnId)
          .snapshots()
          .listen((jcnCounter) {
        jobCardCounter.text = (jcnCounter.data()!['value'] ?? '').toString();
      });
    } catch (e) {
      //
    }
  }

  getCountriesAndCities() async {
    try {
      QuerySnapshot<Map<String, dynamic>> countries = await FirebaseFirestore
          .instance
          .collection('all_lists')
          .where('code', isEqualTo: 'COUNTRIES')
          .get();
      QuerySnapshot<Map<String, dynamic>> cities = await FirebaseFirestore
          .instance
          .collection('all_lists')
          .where('code', isEqualTo: 'CITIES')
          .get();

      var countriesId = countries.docs.first.id;
      var citiesId = cities.docs.first.id;

      FirebaseFirestore.instance
          .collection('all_lists')
          .doc(countriesId)
          .collection('values')
          .where('available', isEqualTo: true)
          .snapshots()
          .listen((countries) {
        allCountries.value = {
          for (var doc in countries.docs) doc.id: doc.data()
        };
      });

      FirebaseFirestore.instance
          .collection('all_lists')
          .doc(citiesId)
          .collection('values')
          .where('available', isEqualTo: true)
          .snapshots()
          .listen((cities) {
        allCities.value = {for (var doc in cities.docs) doc.id: doc.data()};
      });
    } catch (e) {
      // print(e);
    }
  }

  getCarsModelsAndBrands() async {
    try {
      QuerySnapshot<Map<String, dynamic>> brands = await FirebaseFirestore
          .instance
          .collection('all_lists')
          .where('code', isEqualTo: 'CAR_BRANDS')
          .get();
      QuerySnapshot<Map<String, dynamic>> models = await FirebaseFirestore
          .instance
          .collection('all_lists')
          .where('code', isEqualTo: 'CAR_MODELS')
          .get();

      var brandsId = brands.docs.first.id;
      var modelsId = models.docs.first.id;

      FirebaseFirestore.instance
          .collection('all_lists')
          .doc(brandsId)
          .collection('values')
          .where('available', isEqualTo: true)
          .snapshots()
          .listen((models) {
        allBrands.value = {for (var doc in models.docs) doc.id: doc.data()};
      });

      FirebaseFirestore.instance
          .collection('all_lists')
          .doc(modelsId)
          .collection('values')
          .where('available', isEqualTo: true)
          .snapshots()
          .listen((brands) {
        allModels.value = {for (var doc in brands.docs) doc.id: doc.data()};
      });
    } catch (e) {
      // print(e);
    }
  }

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allJobCards.sort((counter1, counter2) {
        final String? value1 = counter1.get('code');
        final String? value2 = counter2.get('code');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allJobCards.sort((counter1, counter2) {
        final String? value1 = counter1.get('name');
        final String? value2 = counter2.get('name');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allJobCards.sort((counter1, counter2) {
        final String? value1 = counter1.get('added_date');
        final String? value2 = counter2.get('added_date');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    }
    sortColumnIndex.value = columnIndex;
    isAscending.value = ascending;
  }

  int compareString(bool ascending, String value1, String value2) {
    int comparison = value1.compareTo(value2);
    return ascending ? comparison : -comparison; // Reverse if descending
  }

  getAllJobCards() {
    try {
      FirebaseFirestore.instance
          .collection('job_cards')
          .snapshots()
          .listen((jobCards) {
        allJobCards.assignAll(jobCards.docs);
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  String? getSaleManName(String saleManId) {
    try {
      final salesMan = salesManMap.entries.firstWhere(
        (saleMan) => saleMan.key == saleManId,
      );
      return salesMan.value['name'];
    } catch (e) {
      return '';
    }
  }

  void onSelectForBrandsAndModels(String selectedId) {
    filterdModelsByBrands.assignAll(
      Map.fromEntries(
        allModels.entries.where((entry) {
          return entry.value['restricted_by']
              .toString()
              .toLowerCase()
              .contains(selectedId.toLowerCase());
        }),
      ),
    );
  }

  void onSelectForCountryAndCity(String selectedId) {
    filterdCitiesByCountry.clear();
    filterdCitiesByCountry.addAll(
      Map.fromEntries(
        allCities.entries.where((entry) {
          return entry.value['restricted_by']
              .toString()
              .toLowerCase()
              .contains(selectedId.toLowerCase());
        }),
      ),
    );
  }

  void onSelectForCustomers(String selectedId) {
    var currentUserDetails = allCustomers.entries.firstWhere((entry) {
      return entry.key
          .toString()
          .toLowerCase()
          .contains(selectedId.toLowerCase());
    });

    customerPhoneNumber.text =
        (currentUserDetails.value['entity_phone'] as List)
            .map((phoneData) => phoneData['number'])
            .join('/');
    customerCreditNumber.text =
        (currentUserDetails.value['credit_limit'] ?? '0').toString();
    customerSaleManId.value = currentUserDetails.value['sales_man'];
    customerSaleMan.text =
        getSaleManName(currentUserDetails.value['sales_man'])!;
  }
}
