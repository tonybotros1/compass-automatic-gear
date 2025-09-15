import 'dart:convert';
import 'dart:typed_data';
import 'package:datahubai/web_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/brands/brand_model.dart';
import '../../Models/brands/brand_nodel_model.dart';
import '../../consts.dart';
import '../../helpers.dart';
import 'main_screen_contro.dart';
import 'websocket_controller.dart';

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
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      final response = await http.get(
        Uri.parse('$backendTestURI/brands/get_all_brands'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        List<dynamic> jsonData = decoded['brands'];
        allBrands.assignAll(
          jsonData.map((item) => Brand.fromJson(item)).toList(),
        );
        isScreenLoding.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getCarBrands();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        isScreenLoding.value = false;
        logout();
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
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$backendTestURI/brands/add_new_brand"),
      );
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
      request.headers.addAll({
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'multipart/form-data',
      });
      var response = await request.send();
      if (response.statusCode == 200) {
        await response.stream.bytesToString();
        addingNewValue.value = false;
        Get.back();
        showSnackBar('Done', 'New brand added successfully');
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewBrand();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        addingNewValue.value = false;
        logout();
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
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      final response = await http.delete(
        Uri.parse("$backendTestURI/brands/delete_brand/$id"),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        Get.back();
        showSnackBar('Done', 'Brand deleted Successfully');
      } else if (response.statusCode == 404) {
        Get.back();
        showSnackBar('Alert', 'Brand not found');
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteBrand(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        addingNewValue.value = false;
        logout();
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
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendTestURI/brands/edit_brand_status/$id');
      final response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({"status": status}),
      );

      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await editActiveOrInActiveStatus(id, status);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
    } catch (e) {
      // print(e);
    }
  }

  Future<void> editBrand(String id) async {
    try {
      addingNewValue.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
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
      request.headers.addAll({
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'multipart/form-data',
      });
      var response = await request.send();
      if (response.statusCode == 200) {
        await response.stream.bytesToString();
        addingNewValue.value = false;
        Get.back();
        showSnackBar('Done', 'Brand updated successfully');
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await editBrand(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        addingNewValue.value = false;
        logout();
      } else {
        addingNewValue.value = false;
        Get.back();
        showSnackBar('Alert', 'Something went wrong please try again');
      }
    } catch (e) {
      addingNewValue.value = false;
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  // ===================================== Models Section =============================================

  Future<void> getModelsValues(String brandId) async {
    try {
      loadingModels.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendTestURI/brands/get_models/$brandId');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decode = jsonDecode(response.body);
        List<dynamic> jsonData = decode['models'];
        allModels.assignAll(jsonData.map((model) => Model.fromJson(model)));
        loadingModels.value = false;
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getModelsValues(brandId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        loadingModels.value = false;
        logout();
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
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendTestURI/brands/add_new_model/$brandId');
      final response = await http.post(
        url,
        body: jsonEncode({"name": modelName.text}),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        addingNewmodelValue.value = false;
        Get.back();
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await addNewModel(brandId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        addingNewmodelValue.value = false;
        logout();
      }
      addingNewmodelValue.value = false;
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
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendTestURI/brands/edit_model_status/$modelId');
      final response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({"status": status}),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await editActiveOrInActiveStatusForModels(modelId, status);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
    } catch (e) {
      //
    }
  }

  Future<void> deleteModel(String modelId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendTestURI/brands/delete_model/$modelId');
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        Get.back();
        showSnackBar('Done', 'Model deleted Successfully');
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteModel(modelId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
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
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      var url = Uri.parse('$backendTestURI/brands/edit_model/$modelId');
      final response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({"name": modelName.text}),
      );
      if (response.statusCode == 200) {
        Get.back();
        showSnackBar('Done', 'Model updated Successfully');
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await editModel(modelId);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else if (response.statusCode == 404) {
        Get.back();
        showSnackBar('Alert', 'Model not found');
      } else {
        Get.back();
        showSnackBar('Alert', 'Something went wrong please try again');
      }
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

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
}
