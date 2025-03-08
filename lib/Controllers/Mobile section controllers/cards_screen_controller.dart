import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardsScreenController extends GetxController {
  TextEditingController customerName = TextEditingController();
  TextEditingController brand = TextEditingController();
  TextEditingController model = TextEditingController();
  TextEditingController year = TextEditingController();
  TextEditingController vin = TextEditingController();
  TextEditingController mileage = TextEditingController();
  final RxList<DocumentSnapshot> allCarCards = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> newCarCards = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> doneCarCards = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredCarCards =
      RxList<DocumentSnapshot>([]);
  Rx<TextEditingController> search = TextEditingController().obs;
  RxString query = RxString('');
  final RxBool loading = RxBool(false);
  final RxInt numberOfNewCars = RxInt(0);
  final RxInt numberOfDoneCars = RxInt(0);
  RxString customerId = RxString('');
  RxString brandId = RxString('');
  RxString modelId = RxString('');
  RxString companyId = RxString('');
  RxString userId = RxString('');
  RxMap allCustomers = RxMap({});
  RxMap allBrands = RxMap({});
  RxMap allModels = RxMap({});
  @override
  void onInit() async {
    await getUserAndCompanyId();
    getAllCustomers();
    getAllCards();
    getCarBrands();

    super.onInit();
  }

// this function is to get user and company id:
  getUserAndCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId.value = (prefs.getString('userId'))!;
    companyId.value = prefs.getString('companyId')!;
  }

// this function is to get the data name from id
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

  getAllCards() {
    try {
      loading.value = true;

      FirebaseFirestore.instance
          .collection('job_cards')
          .where('company_id', isEqualTo: companyId.value)
          .orderBy('added_date', descending: true)
          .snapshots()
          .listen((event) {
        allCarCards.assignAll(event.docs); // Assign all cards first

        // Clear the lists before refilling
        newCarCards.clear();
        doneCarCards.clear();

        for (var element in event.docs) {
          var data = element.data();
          if (data['label'] == 'Draft') {
            newCarCards.add(element);
          } else {
            doneCarCards.add(element);
          }
        }

        numberOfNewCars.value = newCarCards.length;
        numberOfDoneCars.value = doneCarCards.length;

        loading.value = false;
      }, onError: (e) {
        loading.value = false;
      });
    } catch (e) {
      loading.value = false;
    }
  }

  // Function to filter the list based on search criteria
  void filterResults(String query) {
    query = query.toLowerCase();

    // Use where() to filter the list based on multiple fields
    List<DocumentSnapshot> filteredResults =
        allCarCards.where((documentSnapshot) {
      final data = documentSnapshot.data() as Map<String, dynamic>?;

      final customerName = data?['customer_name'] ?? '';
      final carBrand = data?['car_brand'] ?? '';
      final carModel = data?['car_model'] ?? '';
      final platNumber = data?['plate_number'] ?? '';
      final date = data?['date'] ?? '';

      // Check if any of the fields start with the query
      return customerName.toString().toLowerCase().contains(query) ||
          carBrand.toString().toLowerCase().contains(query) ||
          carModel.toString().toLowerCase().contains(query) ||
          platNumber.toString().toLowerCase().contains(query) ||
          date.toString().toLowerCase().contains(query);
    }).toList();

    // Update the list with the filtered results
    filteredCarCards.assignAll(filteredResults);
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

  getCarBrands() {
    try {
      FirebaseFirestore.instance
          .collection('all_brands')
          .snapshots()
          .listen((brands) {
        allBrands.value = {for (var doc in brands.docs) doc.id: doc.data()};
      });
    } catch (e) {
      //
    }
  }

  getModelsByCarBrand(brandId) {
    try {
      FirebaseFirestore.instance
          .collection('all_brands')
          .doc(brandId)
          .collection('values')
          .snapshots()
          .listen((models) {
        allModels.value = {for (var doc in models.docs) doc.id: doc.data()};
      });
    } catch (e) {
      //
    }
  }

  Future<String> getModelName(String brandId, String modelId) async {
    try {
      var cities = await FirebaseFirestore.instance
          .collection('all_brands')
          .doc(brandId)
          .collection('values')
          .doc(modelId)
          .get();

      if (cities.exists) {
        return cities.data()!['name'];
      } else {
        return '';
      }
    } catch (e) {
      return ''; // Return empty string on error
    }
  }
}
