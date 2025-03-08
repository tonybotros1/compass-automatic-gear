import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardsScreenController extends GetxController {
  final RxList<DocumentSnapshot> carCards = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredCarCards =
      RxList<DocumentSnapshot>([]);
  Rx<TextEditingController> search = TextEditingController().obs;
  RxString query = RxString('');
  final RxBool loading = RxBool(false);
  final RxInt numberOfCars = RxInt(0);
  RxString companyId = RxString('');
  RxString userId = RxString('');

  @override
  void onInit() async {
    await getUserAndCompanyId();
    getAllCards();
    search.value.addListener(() {
      filterCards();
    });
    super.onInit();
  }

// this function is to get user and company id:
  getUserAndCompanyId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId.value = (prefs.getString('userId'))!;
    companyId.value = prefs.getString('companyId')!;
  }

// this function is to get the works from firebase
  getAllCards() {
    try {
      loading.value = true;
      FirebaseFirestore.instance
          .collection('job_cards')
          .where('company_id', isEqualTo: companyId.value)
          .orderBy('added_date', descending: true)
          .snapshots()
          .listen((event) {
        carCards.assignAll(event.docs);
        numberOfCars.value = carCards.length;
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
    List<DocumentSnapshot> filteredResults = carCards.where((documentSnapshot) {
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

  // this function is to filter the search results for web
  void filterCards() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredCarCards.clear();
    } else {
      filteredCarCards.assignAll(
        carCards.where((car) {
          return car['customer_name']
                  .toString()
                  .toLowerCase()
                  .contains(query) ||
              car['car_brand'].toString().toLowerCase().contains(query) ||
              car['car_model'].toString().toLowerCase().contains(query) ||
              car['plate_number'].toString().toLowerCase().contains(query) ||
              car['date'].toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
  }
}
