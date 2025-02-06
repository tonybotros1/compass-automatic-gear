import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:html' as html;

import '../../consts.dart';

class CarBrandsController extends GetxController {
  RxString query = RxString('');
  RxString queryForModels = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  Rx<TextEditingController> searchForModels = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  final RxList<DocumentSnapshot> allBrands = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> allModels = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredBrands = RxList<DocumentSnapshot>([]);
  final RxList<DocumentSnapshot> filteredModels = RxList<DocumentSnapshot>([]);
  TextEditingController brandName = TextEditingController();
  TextEditingController modelName = TextEditingController();
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool addingNewValue = RxBool(false);
  RxBool addingNewmodelValue = RxBool(false);
  Rx<Uint8List> imageBytes = Uint8List(0).obs;
  RxString logoUrl = RxString('');
  RxString brandIdToWorkWith = RxString('');
  RxBool loadingModels = RxBool(false);
  final GlobalKey<FormState> formKeyForAddingNewvalue = GlobalKey<FormState>();
  RxBool logoSelectedError = RxBool(false);

  @override
  void onInit() {
    getCarBrands();
    search.value.addListener(() {
      filterBrands();
    });
    searchForModels.value.addListener(() {
      filterModels();
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
        final String? value1 = screen1.get('name');
        final String? value2 = screen2.get('name');

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 1) {
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
      if (imageBytes.value.isNotEmpty) {
        final Reference storageRef = FirebaseStorage.instance.ref().child(
            'brands_logos/${formatPhrase(brandName.text)}_${DateTime.now()}.png');
        final UploadTask uploadTask = storageRef.putData(
          imageBytes.value,
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
        'status': true,
      });
      addingNewValue.value = false;
      Get.back();
    } catch (e) {
      addingNewValue.value = false;
    }
  }

  editBrand(brandId) async {
    try {
      addingNewValue.value = true;
      if (imageBytes.value.isNotEmpty) {
        final Reference storageRef = FirebaseStorage.instance.ref().child(
            'brands_logos/${formatPhrase(brandName.text)}_${DateTime.now()}.png');
        final UploadTask uploadTask = storageRef.putData(
          imageBytes.value,
          SettableMetadata(contentType: 'image/png'),
        );

        await uploadTask.then((p0) async {
          logoUrl.value = await storageRef.getDownloadURL();
        });
      }

      FirebaseFirestore.instance.collection('all_brands').doc(brandId).update({
        'name': brandName.text,
        'logo': logoUrl.value,
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

  editActiveOrInActiveStatus(companyId, bool status) async {
    try {
      await FirebaseFirestore.instance
          .collection('all_brands')
          .doc(companyId)
          .update({
        'status': status,
      });
    } catch (e) {
//
    }
  }

  // this function is to select an image for logo
  pickImage() async {
    try {
      logoSelectedError.value = false;
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
              imageBytes.value = reader.result as Uint8List;
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

  void filterModels() {
    queryForModels.value = searchForModels.value.text.toLowerCase();
    if (queryForModels.value.isEmpty) {
      filteredModels.clear();
    } else {
      filteredModels.assignAll(
        allModels.where((model) {
          return model['name']
                  .toString()
                  .toLowerCase()
                  .contains(queryForModels.value) ||
              textToDate(model['added_date'])
                  .toString()
                  .toLowerCase()
                  .contains(queryForModels.value);
        }).toList(),
      );
    }
  }

  getModelsValues(brandId) {
    try {
      loadingModels.value = true;

      FirebaseFirestore.instance
          .collection('all_brands')
          .doc(brandId)
          .collection('values')
          .orderBy('name', descending: false)
          .snapshots()
          .listen((values) {
        allModels.assignAll(values.docs);
        loadingModels.value = false;
      });
    } catch (e) {
      loadingModels.value = false;
    }
  }

  addNewModel(brandId) {
    try {
      addingNewmodelValue.value = true;
      FirebaseFirestore.instance
          .collection('all_brands')
          .doc(brandId)
          .collection('values')
          .add({
        'name': modelName.text,
        'added_date': DateTime.now().toString(),
        'status': true,
      });
      addingNewmodelValue.value = false;
      Get.back();
    } catch (e) {
      addingNewmodelValue.value = false;
    }
  }

  deleteModel(brandId, modelId) {
    try {
      Get.back();
      FirebaseFirestore.instance
          .collection('all_brands')
          .doc(brandId)
          .collection('values')
          .doc(modelId)
          .delete();
    } catch (e) {
      //
    }
  }

  editmodel(brandId, modelId) {
    try {
      FirebaseFirestore.instance
          .collection('all_brands')
          .doc(brandId)
          .collection('values')
          .doc(modelId)
          .update({
        'name': modelName.text,
      });
      Get.back();
    } catch (e) {
      //
    }
  }

  editHideOrUnhide(brandId, modelId, status) async {
    try {
      await FirebaseFirestore.instance
          .collection('all_brands')
          .doc(brandId)
          .collection('values')
          .doc(modelId)
          .update({
        'status': status,
      });
    } catch (e) {
      //
    }
  }
}
