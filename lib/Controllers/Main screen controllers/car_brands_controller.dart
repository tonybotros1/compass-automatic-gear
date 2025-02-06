import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:html' as html;

import '../../consts.dart';

class CarBrandsController extends GetxController {
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  final RxList<DocumentSnapshot> allBrands = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> allModels = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredBrands = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredModels = RxList<DocumentSnapshot>([]);
  TextEditingController brandName = TextEditingController();
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  Uint8List? imageBytes;
  RxString logoUrl = RxString('');

  @override
  void onInit() {
    getCarBrands();
    search.value.addListener(() {
      filterBrands();
    });
    super.onInit();
  }

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allBrands.sort((counter1, counter2) {
        final String? value1 = counter1.get('code');
        final String? value2 = counter2.get('code');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allBrands.sort((counter1, counter2) {
        final String? value1 = counter1.get('name');
        final String? value2 = counter2.get('name');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 3) {
      allBrands.sort((counter1, counter2) {
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

  void onSortForModels(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allModels.sort((screen1, screen2) {
        final String? value1 = screen1.get('code');
        final String? value2 = screen2.get('code');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
      allModels.sort((screen1, screen2) {
        final String? value1 = screen1.get('name');
        final String? value2 = screen2.get('name');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allModels.sort((screen1, screen2) {
        final String? value1 = screen1.get('added_date');
        final String? value2 = screen2.get('added_date');

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

  getCarBrands() {
    try {
      FirebaseFirestore.instance
          .collection('all_brands')
          .snapshots()
          .listen((brands) {
        allBrands.assignAll(brands.docs);
        isScreenLoding.value = false;
      });
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  String formatPhrase(String phrase) {
    return phrase.replaceAll(' ', '_');
  }

// this function is to add new brand
  addNewbrand() async {
    try {
      addingNewValue.value = true;
      if (imageBytes != null && imageBytes!.isNotEmpty) {
        final Reference storageRef = FirebaseStorage.instance.ref().child(
            'brands_logos/${formatPhrase(brandName.text)}_${DateTime.now()}.png');
        final UploadTask uploadTask = storageRef.putData(
          imageBytes!,
          SettableMetadata(contentType: 'image/png'),
        );

        await uploadTask.then((p0) async {
          logoUrl.value = await storageRef.getDownloadURL();
        });
      }

      FirebaseFirestore.instance.collection('all_brands').add({
        'name': brandName.text,
        'logo': logoUrl.value,
        'added_date': DateTime.now().toString(),
      });
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  deletebrand(brandId) async {
    try {
      Get.back();
      await FirebaseFirestore.instance
          .collection('all_brands')
          .doc(brandId)
          .delete();
    } catch (e) {
      //
    }
  }

  // this function is to select an image for logo
  pickImage() async {
    try {
      html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((event) {
        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          final file = files.first;
          final reader = html.FileReader();

          reader.readAsArrayBuffer(file);
          reader.onLoadEnd.listen((event) async {
            if (reader.result != null) {
              imageBytes = reader.result as Uint8List;
              update();
            }
          });
        }
      });
    } catch (e) {
      //
    }
  }

  void filterBrands() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredBrands.clear();
    } else {
      filteredBrands.assignAll(
        allBrands.where((brand) {
          return brand['name'].toString().toLowerCase().contains(query.value) ||
              textToDate(brand['added_date'])
                  .toString()
                  .toLowerCase()
                  .contains(query.value);
        }).toList(),
      );
    }
  }
}
