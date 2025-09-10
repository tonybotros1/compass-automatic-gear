import 'dart:convert';
import 'dart:typed_data';
import 'package:datahubai/web_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../Models/brands/brand_model.dart';
import '../../Models/brands/brand_nodel_model.dart';
import '../../consts.dart';
import 'main_screen_contro.dart';
import 'webSocket_controller.dart';

class CarBrandsController extends GetxController {
  RxString query = RxString('');
  RxString queryForModels = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  Rx<TextEditingController> searchForModels = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(true);
  // final RxList<DocumentSnapshot> allBrands = RxList<DocumentSnapshot>([]);
  final RxList<Brand> allBrands = RxList<Brand>([]);
  // final RxList<DocumentSnapshot> allModels = RxList<DocumentSnapshot>([]);
  final RxList<Model> allModels = RxList<Model>([]);
  // final RxList<DocumentSnapshot> filteredBrands = RxList<DocumentSnapshot>([]);
  final RxList<Brand> filteredBrands = RxList<Brand>([]);
  // final RxList<DocumentSnapshot> filteredModels = RxList<DocumentSnapshot>([]);
  final RxList<Model> filteredModels = RxList<Model>([]);
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
  WebSocketService ws = Get.find<WebSocketService>();

  @override
  void onInit() {
    connectWebSocket();
    getCarBrands();

    super.onInit();
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  void connectWebSocket() {
    ws.events.listen((message) {
      switch (message["type"]) {
        case "brand_created":
          final newBrand = Brand.fromJson(message["data"]);
          allBrands.add(newBrand);
          break;

        case "brand_updated":
          final updated = Brand.fromJson(message["data"]);
          final index = allBrands.indexWhere((b) => b.id == updated.id);
          if (index != -1) {
            allBrands[index] = updated;
          }
          break;

        case "brand_deleted":
          final deletedId = message["data"]["_id"];
          allBrands.removeWhere((b) => b.id == deletedId);
          break;

        case "model_created":
          final newModel = Model.fromJson(message["data"]);
          allModels.add(newModel);
          break;

        case "model_updated":
          final updated = Model.fromJson(message["data"]);
          final index = allModels.indexWhere((m) => m.id == updated.id);
          if (index != -1) {
            allModels[index] = updated;
          }
          break;

        case "model_deleted":
          final deletedId = message["data"]["_id"];
          allModels.removeWhere((m) => m.id == deletedId);
          break;
      }
    });
  }

  // ===================================== Brands Section =============================================

  Future<void> getCarBrands() async {
    try {
      final response = await http.get(
        Uri.parse('$backendTestURI/brands/get_all_brands'),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        // إذا الليست موجودة داخل مفتاح "brands"
        List<dynamic> jsonData = decoded['brands'];

        // تحويل للـ model
        allBrands.assignAll(
          jsonData.map((item) => Brand.fromJson(item)).toList(),
        );
        isScreenLoding.value = false;
      } else {
        isScreenLoding.value = false;
      }
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  Future<void> addNewBrand() async {
    try {
      addingNewValue.value = true;
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$backendTestURI/brands/add_new_brand"),
      );

      // اسم البراند
      request.fields['name'] = brandName.text;

      if (imageBytes.value.isNotEmpty) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'logo',
            imageBytes.value,
            filename: "brand_logo_${brandName.text}.png",
          ),
        );
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        await response.stream.bytesToString();
        addingNewValue.value = false;
        Get.back();
        showSnackBar('Done', 'New brand added successfully');
      } else {
        addingNewValue.value = false;
        Get.back();
        showSnackBar('Alert', 'Something went wrong please try again');
      }
    } catch (e) {
      // print(e);
      addingNewValue.value = false;
      Get.back();
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  Future<void> deleteBrand(String id) async {
    try {
      final response = await http.delete(
        Uri.parse("$backendTestURI/brands/delete_brand/$id"),
      );
      if (response.statusCode == 200) {
        Get.back();
        showSnackBar('Done', 'Brand deleted Successfully');
      } else if (response.statusCode == 404) {
        Get.back();
        showSnackBar('Alert', 'Brand not found');
      } else {
        Get.back();
        showSnackBar('Alert', 'Something went wrong please try again');
      }
    } catch (e) {
      Get.back();
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  Future<void> editActiveOrInActiveStatus(String id, bool status) async {
    try {
      var url = Uri.parse('$backendTestURI/brands/edit_brand_status/$id');
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": status}),
      );

      if (response.statusCode == 200) {
        // return jsonDecode(response.body);
      } else {
        throw Exception("Failed to update status: ${response.body}");
      }
    } catch (e) {
      // print(e);
    }
  }

  Future<void> editBrand(String id) async {
    try {
      addingNewValue.value = true;

      var url = Uri.parse('$backendTestURI/brands/edit_brand/$id');

      final request = http.MultipartRequest('PATCH', url);
      request.fields['name'] = brandName.text;
      if (imageBytes.value.isNotEmpty) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'logo',
            imageBytes.value,
            filename: "brand_logo_${brandName.text}.png",
          ),
        );
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        await response.stream.bytesToString();
        addingNewValue.value = false;
        Get.back();
        showSnackBar('Done', 'Brand updated successfully');
      } else {
        addingNewValue.value = false;
        Get.back();
        showSnackBar('Alert', 'Something went wrong please try again');
      }
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  // ===================================== Models Section =============================================

  Future<void> getModelsValues(String brandId) async {
    try {
      loadingModels.value = true;

      var url = Uri.parse('$backendTestURI/brands/get_models/$brandId');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        List<dynamic> jsonData = decode['models'];

        allModels.assignAll(jsonData.map((model) => Model.fromJson(model)));
        loadingModels.value = false;
      } else {
        loadingModels.value = false;
      }
    } catch (e) {
      loadingModels.value = false;
    }
  }

  Future<void> addNewModel(String brandId) async {
    try {
      addingNewmodelValue.value = true;
      var url = Uri.parse('$backendTestURI/brands/add_new_model/$brandId');
      final response = await http.post(url, body: {"name": modelName.text});

      if (response.statusCode == 200) {
        addingNewmodelValue.value = false;
        Get.back();
      }
    } catch (e) {
      addingNewmodelValue.value = false;
      Get.back();
    }
  }

  Future<void> editActiveOrInActiveStatusForModels(
    String modelId,
    bool status,
  ) async {
    try {
      var url = Uri.parse('$backendTestURI/brands/edit_model_status/$modelId');
      await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": status}),
      );
    } catch (e) {
      //
    }
  }

  Future<void> deleteModel(String modelId) async {
    try {
      var url = Uri.parse('$backendTestURI/brands/delete_model/$modelId');
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        Get.back();
        showSnackBar('Done', 'Model deleted Successfully');
      } else if (response.statusCode == 404) {
        Get.back();
        showSnackBar('Alert', 'Model not found');
      } else {
        Get.back();
        showSnackBar('Alert', 'Something went wrong please try again');
      }
    } catch (e) {
      Get.back();
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  Future<void> editModel(String modelId) async {
    try {
      var url = Uri.parse('$backendTestURI/brands/edit_model/$modelId');

      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": modelName.text}),
      );
      if (response.statusCode == 200) {
        Get.back();
        showSnackBar('Done', 'Model updated Successfully');
      } else {
        Get.back();
        showSnackBar('Alert', 'Something went wrong please try again');
      }
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }
  // // this function is to sort data in table
  // void onSort(int columnIndex, bool ascending) {
  //   if (columnIndex == 0) {
  //     allBrands.sort((counter1, counter2) {
  //       final String? value1 = counter1.get('code');
  //       final String? value2 = counter2.get('code');

  //       // Handle nulls: put nulls at the end
  //       if (value1 == null && value2 == null) return 0;
  //       if (value1 == null) return 1;
  //       if (value2 == null) return -1;

  //       return compareString(ascending, value1, value2);
  //     });
  //   } else if (columnIndex == 1) {
  //     allBrands.sort((counter1, counter2) {
  //       final String? value1 = counter1.get('name');
  //       final String? value2 = counter2.get('name');

  //       // Handle nulls: put nulls at the end
  //       if (value1 == null && value2 == null) return 0;
  //       if (value1 == null) return 1;
  //       if (value2 == null) return -1;

  //       return compareString(ascending, value1, value2);
  //     });
  //   } else if (columnIndex == 3) {
  //     allBrands.sort((counter1, counter2) {
  //       final String? value1 = counter1.get('added_date');
  //       final String? value2 = counter2.get('added_date');

  //       // Handle nulls: put nulls at the end
  //       if (value1 == null && value2 == null) return 0;
  //       if (value1 == null) return 1;
  //       if (value2 == null) return -1;

  //       return compareString(ascending, value1, value2);
  //     });
  //   }
  //   sortColumnIndex.value = columnIndex;
  //   isAscending.value = ascending;
  // }

  // void onSortForModels(int columnIndex, bool ascending) {
  //   if (columnIndex == 0) {
  //     allModels.sort((screen1, screen2) {
  //       final String? value1 = screen1.get('name');
  //       final String? value2 = screen2.get('name');

  //       // Handle nulls: put nulls at the end
  //       if (value1 == null && value2 == null) return 0;
  //       if (value1 == null) return 1;
  //       if (value2 == null) return -1;

  //       return compareString(ascending, value1, value2);
  //     });
  //   } else if (columnIndex == 1) {
  //     allModels.sort((screen1, screen2) {
  //       final String? value1 = screen1.get('added_date');
  //       final String? value2 = screen2.get('added_date');

  //       // Handle nulls: put nulls at the end
  //       if (value1 == null && value2 == null) return 0;
  //       if (value1 == null) return 1;
  //       if (value2 == null) return -1;

  //       return compareString(ascending, value1, value2);
  //     });
  //   }
  //   sortColumnIndex.value = columnIndex;
  //   isAscending.value = ascending;
  // }

  // int compareString(bool ascending, String value1, String value2) {
  //   int comparison = value1.compareTo(value2);
  //   return ascending ? comparison : -comparison; // Reverse if descending
  // }

  // getCarBrands() {
  //   try {
  //     FirebaseFirestore.instance.collection('all_brands').snapshots().listen((
  //       brands,
  //     ) {
  //       allBrands.assignAll(List<DocumentSnapshot>.from(brands.docs));
  //       isScreenLoding.value = false;
  //     });
  //   } catch (e) {
  //     isScreenLoding.value = false;
  //   }
  // }

  String formatPhrase(String phrase) {
    return phrase.replaceAll(' ', '_');
  }

  // // this function is to add new brand
  // addNewbrand() async {
  //   try {
  //     addingNewValue.value = true;
  //     if (imageBytes.value.isNotEmpty) {
  //       final Reference storageRef = FirebaseStorage.instance.ref().child(
  //         'brands_logos/${formatPhrase(brandName.text)}_${DateTime.now()}.png',
  //       );
  //       final UploadTask uploadTask = storageRef.putData(
  //         imageBytes.value,
  //         SettableMetadata(contentType: 'image/png'),
  //       );

  //       await uploadTask.then((p0) async {
  //         logoUrl.value = await storageRef.getDownloadURL();
  //       });
  //     }

  //     FirebaseFirestore.instance.collection('all_brands').add({
  //       'name': brandName.text,
  //       'logo': logoUrl.value,
  //       'added_date': DateTime.now().toString(),
  //       'status': true,
  //     });
  //     addingNewValue.value = false;
  //     Get.back();
  //   } catch (e) {
  //     addingNewValue.value = false;
  //   }
  // }

  // editBrand(brandId) async {
  //   try {
  //     var newData = {'name': brandName.text};
  //     addingNewValue.value = true;
  //     if (imageBytes.value.isNotEmpty) {
  //       final Reference storageRef = FirebaseStorage.instance.ref().child(
  //         'brands_logos/${formatPhrase(brandName.text)}_${DateTime.now()}.png',
  //       );
  //       final UploadTask uploadTask = storageRef.putData(
  //         imageBytes.value,
  //         SettableMetadata(contentType: 'image/png'),
  //       );

  //       await uploadTask.then((p0) async {
  //         logoUrl.value = await storageRef.getDownloadURL();
  //         newData['logo'] = logoUrl.value;
  //       });
  //     }

  //     FirebaseFirestore.instance
  //         .collection('all_brands')
  //         .doc(brandId)
  //         .update(newData);
  //     addingNewValue.value = false;
  //     Get.back();
  //   } catch (e) {
  //     addingNewValue.value = false;
  //   }
  // }

  // deletebrand(brandId) async {
  //   try {
  //     Get.back();
  //     await FirebaseFirestore.instance
  //         .collection('all_brands')
  //         .doc(brandId)
  //         .delete();
  //   } catch (e) {
  //     //
  //   }
  // }

  // editActiveOrInActiveStatus(companyId, bool status) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('all_brands')
  //         .doc(companyId)
  //         .update({'status': status});
  //   } catch (e) {
  //     //
  //   }
  // }

  // this function is to select an image for logo
  Future<void> pickImage() async {
    final imagePicker = ImagePickerService();
    imagePicker.pickImage(imageBytes, logoSelectedError);
  }

  void filterBrands() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredBrands.clear();
    } else {
      filteredBrands.assignAll(
        allBrands.where((brand) {
          return brand.name.toString().toLowerCase().contains(query.value) ||
              textToDate(
                brand.createdAt,
              ).toString().toLowerCase().contains(query.value);
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
          return model.name.toString().toLowerCase().contains(
                queryForModels.value,
              ) ||
              textToDate(
                model.createdAt,
              ).toString().toLowerCase().contains(queryForModels.value);
        }).toList(),
      );
    }
  }

  // getModelsValues(brandId) {
  //   try {
  //     loadingModels.value = true;

  //     FirebaseFirestore.instance
  //         .collection('all_brands')
  //         .doc(brandId)
  //         .collection('values')
  //         .orderBy('name', descending: false)
  //         .snapshots()
  //         .listen((values) {
  //           allModels.assignAll(values.docs);
  //           loadingModels.value = false;
  //         });
  //   } catch (e) {
  //     loadingModels.value = false;
  //   }
  // }

  // addNewModel(brandId) {
  //   try {
  //     addingNewmodelValue.value = true;
  //     FirebaseFirestore.instance
  //         .collection('all_brands')
  //         .doc(brandId)
  //         .collection('values')
  //         .add({
  //           'name': modelName.text,
  //           'added_date': DateTime.now().toString(),
  //           'status': true,
  //         });
  //     addingNewmodelValue.value = false;
  //     Get.back();
  //   } catch (e) {
  //     addingNewmodelValue.value = false;
  //   }
  // }

  // deleteModel(brandId, modelId) {
  //   try {
  //     Get.back();
  //     FirebaseFirestore.instance
  //         .collection('all_brands')
  //         .doc(brandId)
  //         .collection('values')
  //         .doc(modelId)
  //         .delete();
  //   } catch (e) {
  //     //
  //   }
  // }

  // editmodel(brandId, modelId) {
  //   try {
  //     FirebaseFirestore.instance
  //         .collection('all_brands')
  //         .doc(brandId)
  //         .collection('values')
  //         .doc(modelId)
  //         .update({'name': modelName.text});
  //     Get.back();
  //   } catch (e) {
  //     //
  //   }
  // }

  // editHideOrUnhide(brandId, modelId, status) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('all_brands')
  //         .doc(brandId)
  //         .collection('values')
  //         .doc(modelId)
  //         .update({'status': status});
  //   } catch (e) {
  //     //
  //   }
  // }
}
