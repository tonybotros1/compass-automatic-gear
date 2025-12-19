import 'dart:convert';
import 'dart:typed_data';
import 'package:datahubai/Controllers/Main%20screen%20controllers/main_screen_contro.dart';
import 'package:datahubai/Models/primary_model.dart';
import 'package:datahubai/Models/type_model.dart';
import 'package:datahubai/consts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/entity information/entity_information_model.dart';
import '../../helpers.dart';
import 'websocket_controller.dart';

class EntityInformationsController extends GetxController {
  TextEditingController entityName = TextEditingController();
  TextEditingController groupName = TextEditingController();
  TextEditingController creditLimit = TextEditingController();
  TextEditingController warrantyDays = TextEditingController();
  TextEditingController trn = TextEditingController();
  Rx<TextEditingController> industry = TextEditingController().obs;
  Rx<TextEditingController> salesMAn = TextEditingController().obs;
  Rx<TextEditingController> entityType = TextEditingController().obs;
  RxString industryId = RxString('');
  RxString salesManId = RxString('');
  RxString entityTypeId = RxString('');
  RxList<TypeModel> phoneTypesControllers = RxList<TypeModel>([]);
  RxList<PrimaryModel> phonePrimary = RxList<PrimaryModel>([]);
  RxList<PrimaryModel> addressPrimary = RxList<PrimaryModel>([]);
  RxList<TypeModel> socialTypesControllers = RxList<TypeModel>([]);
  RxList<TypeModel> countriesControllers = RxList<TypeModel>([]);
  RxList<TypeModel> citiesControllers = RxList<TypeModel>([]);
  RxList<TypeModel> linesControllers = RxList<TypeModel>([]);
  RxList<TypeModel> phoneNumbersControllers = RxList<TypeModel>([]);
  RxList<TypeModel> linksControllers = RxList<TypeModel>([]);
  RxList<TypeModel> emailsControllers = RxList<TypeModel>([]);
  RxList<TypeModel> namesControllers = RxList<TypeModel>([]);
  RxList<TypeModel> jobTitlesControllers = RxList<TypeModel>([]);
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool isScreenLoding = RxBool(false);
  final RxList<EntityInformationModel> allEntities =
      RxList<EntityInformationModel>([]);
  final RxList<EntityInformationModel> filteredEntities =
      RxList<EntityInformationModel>([]);
  RxBool addingNewEntity = RxBool(false);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  RxBool isVendorSelected = RxBool(false);
  RxBool isCustomerSelected = RxBool(true);
  RxBool isCompanySelected = RxBool(true);
  RxBool isIndividualSelected = RxBool(false);
  RxString logoUrl = RxString('');
  RxMap industryMap = RxMap({});
  RxMap salesManMap = RxMap({});
  RxMap entityTypeMap = RxMap({});
  RxMap typeOfSocialsMap = RxMap({});
  RxMap phoneTypesMap = RxMap({});
  Uint8List? imageBytes;
  List<RxMap> allCities = [];
  RxMap allCountries = RxMap({});
  // RxMap filterdCitiesByCountry = RxMap({});
  RxList entityCode = RxList([]);
  RxString entityStatus = RxString('');
  final GlobalKey<AnimatedListState> listKeyForPhoneLine =
      GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> listKeyForSocialLine =
      GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> listKeyForAddressLine =
      GlobalKey<AnimatedListState>();
  List<EntityPhone> contactPhone = [];
  List<EntitySocial> contactSocial = [];
  List<EntityAddress> contactAddress = [];
  final ScrollController horizontalController = ScrollController();
  String backendUrl = backendTestURI;
  var buttonLoadingStates = <String, bool>{}.obs;
  WebSocketService ws = Get.find<WebSocketService>();

  @override
  void onInit() {
    connectWebSocket();
    getCountries();
    getSalesMan();
    getPhoneTypes();
    getTypeOfSocial();
    getIndustries();
    getEntityType();
    getEntities();
    generateControllerForAdressCountriesAndCities();
    generateControllerForPhoneTypes();
    generateControllerForSocialTypes();

    super.onInit();
  }

  void setButtonLoading(String id, bool isLoading) {
    buttonLoadingStates[id] = isLoading;
    buttonLoadingStates.refresh(); // Notify listeners
  }

  String getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  void connectWebSocket() {
    ws.events.listen((message) {
      switch (message["type"]) {
        case "entity_created":
          final newCounter = EntityInformationModel.fromJson(message["data"]);
          allEntities.add(newCounter);
          break;

        case "entity_status_updated":
          final entityId = message["data"]['_id'];
          final entityStatus = message["data"]['status'];
          final index = allEntities.indexWhere((m) => m.id == entityId);
          if (index != -1) {
            allEntities[index].status = entityStatus;
            allEntities.refresh();
          }
          break;

        case "entity_updated":
          final updated = EntityInformationModel.fromJson(message["data"]);
          final index = allEntities.indexWhere((m) => m.id == updated.id);
          if (index != -1) {
            allEntities[index] = updated;
          }
          break;

        case "entity_deleted":
          final deletedId = message["data"]["_id"];
          allEntities.removeWhere((m) => m.id == deletedId);
          break;
      }
    });
  }

  Future<void> getCountries() async {
    allCountries.assignAll(await helper.getCountries());
  }

  Future<void> getCitiesByCountryID(String? countryID, int index) async {
    if (countryID == null || countryID.trim().isEmpty) {
      return; // do nothing if id is null or empty
    }
    allCities[index].value = await helper.getCitiesValues(countryID);
  }

  Future<void> getSalesMan() async {
    salesManMap.assignAll(await helper.getSalesMan());
  }

  Future<void> getPhoneTypes() async {
    phoneTypesMap.assignAll(await helper.getAllListValues('CONTACT_TYPES'));
  }

  Future<void> getTypeOfSocial() async {
    typeOfSocialsMap.assignAll(await helper.getAllListValues('SOCIAL_MEDIA'));
  }

  Future<void> getIndustries() async {
    industryMap.assignAll(await helper.getAllListValues('INDUSTRIES'));
  }

  Future<void> getEntityType() async {
    entityTypeMap.assignAll(await helper.getAllListValues('ENTITY_TYPES'));
  }

  Future<void> getEntities() async {
    try {
      isScreenLoding.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/entity_information/get_all_entities');
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List entities = decoded['entities'];
        allEntities.assignAll(
          entities.map((ent) => EntityInformationModel.fromJson(ent)),
        );
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await getEntities();
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

  Future<void> addNewEntity() async {
    try {
      addingNewEntity.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/entity_information/add_new_entities');
      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $accessToken';
      request.fields.addAll({
        "entity_name": entityName.text.trim(),
        "entity_code": entityCode.join(","),
        "credit_limit": creditLimit.text.isEmpty
            ? '0'
            : creditLimit.text.trim(),
        "warranty_days": warrantyDays.text.isEmpty
            ? '0'
            : warrantyDays.text.trim(),
        "salesman_id": salesManId.value,
        "entity_status": entityStatus.value,
        "group_name": groupName.text.trim(),
        "industry_id": industryId.value,
        "trn": trn.text.trim(),
        "entity_type_id": entityTypeId.value,
      });
      request.fields['entity_address'] = jsonEncode(
        contactAddress.map((e) => e.toJson()).toList(),
      );
      request.fields['entity_phone'] = jsonEncode(
        contactPhone.map((e) => e.toJson()).toList(),
      );
      request.fields['entity_social'] = jsonEncode(
        contactSocial.map((e) => e.toJson()).toList(),
      );
      if (imageBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            imageBytes!,
            filename: "entity_picture_${entityName.text}.png",
          ),
        );
      }
      var response = await request.send();
      if (response.statusCode == 200) {
        Get.back();
        addingNewEntity.value = false;
        showSnackBar('Success', 'Entity added successfully');
      } else if (response.statusCode == 400) {
        final respStr = await response.stream.bytesToString();
        final decoded = jsonDecode(respStr);
        showSnackBar('Error', decoded['detail'] ?? 'Bad Request');
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          // maybe add retry limit here
          await addNewEntity();
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
    } finally {
      addingNewEntity.value = false;
    }
  }

  Future<void> updateEntity(String id) async {
    try {
      addingNewEntity.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/entity_information/update_entity/$id');
      final request = http.MultipartRequest('PATCH', url);
      request.headers['Authorization'] = 'Bearer $accessToken';
      request.fields.addAll({
        "entity_name": entityName.text.trim(),
        "entity_code": entityCode.join(","),
        "credit_limit": creditLimit.text.isEmpty
            ? '0'
            : creditLimit.text.trim(),
        "warranty_days": warrantyDays.text.isEmpty
            ? '0'
            : warrantyDays.text.trim(),
        "salesman_id": salesManId.value,
        "entity_status": entityStatus.value,
        "group_name": groupName.text.trim(),
        "industry_id": industryId.value,
        "trn": trn.text.trim(),
        "entity_type_id": entityTypeId.value,
      });
      request.fields['entity_address'] = jsonEncode(
        contactAddress.map((e) => e.toJson()).toList(),
      );
      request.fields['entity_phone'] = jsonEncode(
        contactPhone.map((e) => e.toJson()).toList(),
      );
      request.fields['entity_social'] = jsonEncode(
        contactSocial.map((e) => e.toJson()).toList(),
      );
      if (imageBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            imageBytes!,
            filename: "entity_picture_${entityName.text}.png",
          ),
        );
      }
      var response = await request.send();
      if (response.statusCode == 200) {
        Get.back();
        addingNewEntity.value = false;
        showSnackBar('Success', 'Entity updated successfully');
      } else if (response.statusCode == 400) {
        final respStr = await response.stream.bytesToString();
        final decoded = jsonDecode(respStr);
        showSnackBar('Error', decoded['detail'] ?? 'Bad Request');
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          // maybe add retry limit here
          await updateEntity(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
    } finally {
      addingNewEntity.value = false;
    }
  }

  Future<void> deleteEntity(String id) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse('$backendUrl/entity_information/delete_entity/$id');
      final response = await http.delete(
        url,
        headers: {"Authorization": "Bearer $accessToken"},
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 400) {
        final decoded = jsonDecode(response.body);
        showSnackBar('Error', decoded['detail'] ?? 'Bad Request');
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await deleteEntity(id);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      }
      Get.back();
    } catch (e) {
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  Future<void> changeEntityStatus(String id, bool status) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var accessToken = '${prefs.getString('accessToken')}';
      final refreshToken = '${await secureStorage.read(key: "refreshToken")}';
      Uri url = Uri.parse(
        '$backendUrl/entity_information/change_entity_status/$id',
      );
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          "Content-Type": "application/json",
        },
        body: jsonEncode(status),
      );
      if (response.statusCode == 200) {
      } else if (response.statusCode == 401 && refreshToken.isNotEmpty) {
        final refreshed = await helper.refreshAccessToken(refreshToken);
        if (refreshed == RefreshResult.success) {
          await changeEntityStatus(id, status);
        } else if (refreshed == RefreshResult.invalidToken) {
          logout();
        }
      } else if (response.statusCode == 401) {
        logout();
      } else {}
    } catch (e) {
      // print(e);
    }
  }

  // =======================================================================================================

  Future<void> loadEntityData(EntityInformationModel entityData) async {
    imageBytes = null;

    // Update entity text controllers
    entityName.text = entityData.entityName ?? '';
    entityCode.clear();
    creditLimit.text = (entityData.creditLimit ?? '').toString();
    groupName.text = entityData.groupName ?? '';
    trn.text = entityData.trn ?? '';
    warrantyDays.text = entityData.warrantyDays.toString();

    isCustomerSelected.value =
        entityData.entityCode?.contains('Customer') ?? false;
    isVendorSelected.value = entityData.entityCode?.contains('Vendor') ?? false;

    // Updating entity-related fields
    updateEntityCode(entityData.entityCode ?? []);
    updateEntityStatus(entityData.entityStatus ?? '');

    salesMAn.value.text = entityData.salesman ?? '';
    salesManId.value = entityData.salesmanId ?? '';

    industry.value.text = entityData.industry ?? '';
    industryId.value = entityData.industryId ?? '';

    entityType.value.text = entityData.entityType ?? '';
    entityTypeId.value = entityData.entityTypeId ?? '';

    // Update logo URL
    logoUrl.value = entityData.entityPicture ?? '';

    // Updating entity-related lists
    updateEntityPhone(entityData.entityPhone ?? []);
    updateEntitySocial(entityData.entitySocial ?? []);
    await updateEntityAddress(entityData.entityAddress ?? []);
  }

  void clearAllVariables() {
    entityName.clear();
    warrantyDays.text = '0';
    entityCode.assign('Customer');
    isVendorSelected.value = false;
    creditLimit.clear();
    salesMAn.value.clear();
    salesManId.value = '';
    logoUrl.value = '';
    imageBytes = null;
    entityStatus.value = 'Company';
    isCompanySelected.value = true;
    groupName.clear();
    industry.value.clear();
    industryId.value = '';
    trn.clear();
    entityType.value.clear();
    entityTypeId.value = '';

    contactAddress.assign(EntityAddress(isPrimary: true));
    contactPhone.assign(EntityPhone(isPrimary: true));
    contactSocial.assign(EntitySocial());

    generateControllerForAdressCountriesAndCities();
    generateControllerForPhoneTypes();
    generateControllerForSocialTypes();
  }

  String formatPhrase(String phrase) {
    return phrase.replaceAll(' ', '_');
  }

  void selectVendor(bool value) {
    isVendorSelected.value = value;
    if (value == true) {
      entityCode.add('Vendor');
    } else {
      entityCode.remove('Vendor');
    }
  }

  void selectCustomer(bool value) {
    isCustomerSelected.value = value;
    if (value == true) {
      entityCode.add('Customer');
    } else {
      entityCode.remove('Customer');
    }
  }

  // this function is to set the entity code fro edit
  void updateEntityCode(List entityCodes) {
    isCustomerSelected.value = entityCodes.contains('Customer');
    isVendorSelected.value = entityCodes.contains('Vendor');

    entityCode.clear();
    entityCode.addAll(entityCodes.toSet());
  }

  // this function is to set the entity status fro edit
  void updateEntityStatus(String entityStatusText) {
    isCompanySelected.value = entityStatusText == 'Company';
    isIndividualSelected.value = entityStatusText == 'Individual';
    entityStatus.value = isCompanySelected.isTrue ? 'Company' : 'Individual';
  }

  Future<void> updateEntityAddress(
    List<EntityAddress> entityAddressFromData,
  ) async {
    contactAddress.assignAll(entityAddressFromData);
    generateControllerForAdressCountriesAndCities();

    final length = contactAddress.length;
    for (var i = 0; i < length; i++) {
      final address = contactAddress[i];

      countriesControllers[i].controller?.text = address.country ?? '';
      addressPrimary[i].isPrimary = address.isPrimary ?? false;
      citiesControllers[i].controller?.text = address.city ?? '';
      linesControllers[i].controller?.text = address.line ?? '';
      await getCitiesByCountryID(address.countryId.toString(), i);
    }
  }

  void updateEntityPhone(List<EntityPhone> entityPhoneFromData) {
    contactPhone.assignAll(entityPhoneFromData);
    generateControllerForPhoneTypes();

    final length = contactPhone.length;
    for (var i = 0; i < length; i++) {
      final phone = contactPhone[i];

      phoneTypesControllers[i].controller?.text = phone.type ?? '';
      phonePrimary[i].isPrimary = phone.isPrimary;
      phoneNumbersControllers[i].controller?.text = phone.number ?? '';
      emailsControllers[i].controller?.text = phone.email ?? '';
      namesControllers[i].controller?.text = phone.name ?? '';
      jobTitlesControllers[i].controller?.text = phone.jobTitle ?? '';
    }
  }

  void updateEntitySocial(List<EntitySocial> entitySocialFromData) {
    try {
      contactSocial.assignAll(entitySocialFromData);
      generateControllerForSocialTypes();

      final length = contactSocial.length;
      for (var i = 0; i < length; i++) {
        final social = contactSocial[i];

        socialTypesControllers[i].controller?.text = social.type ?? '';
        linksControllers[i].controller?.text = social.link ?? '';
      }
    } catch (e) {
      //
    }
  }

  void selectCompanyOrIndividual(String selected, bool value) {
    bool isCompany = selected == 'company';

    isCompanySelected.value = isCompany ? value : false;
    isIndividualSelected.value = isCompany ? false : value;
    entityStatus.value = isCompany ? 'Company' : 'Individual';
    if (!isCompany) {
      groupName.clear();
      industry.value.clear();
      industryId.value = '';
      trn.clear();
      entityType.value.clear();
      entityTypeId.value = '';
    }
  }

  void selectPrimaryAddressField(int index, bool value) {
    if (contactAddress[index].isPrimary == true) {
      return;
    }

    for (var i = 0; i < contactAddress.length; i++) {
      contactAddress[i].isPrimary = false;
      addressPrimary[i].isPrimary = false;
    }

    contactAddress[index].isPrimary = true;
    addressPrimary[index].isPrimary = true;

    update();
  }

  void selectPrimaryPhonesField(int index, bool value) {
    if (contactPhone[index].isPrimary == true) {
      return; // Exit early if already primary
    }

    final previousPrimaryIndex = contactPhone.indexWhere(
      (e) => e.isPrimary == true,
    );
    if (previousPrimaryIndex != -1) {
      contactPhone[previousPrimaryIndex].isPrimary = false;
      phonePrimary[previousPrimaryIndex].isPrimary = false;
    }

    contactPhone[index].isPrimary = true;
    phonePrimary[index].isPrimary = true;

    update();
  }

  void generateControllerForPhoneTypes() {
    final length = contactPhone.length + 1;

    phoneTypesControllers.value = List.generate(
      length,
      (index) => TypeModel(controller: TextEditingController()),
    );

    phoneNumbersControllers.value = List.generate(
      length,
      (index) => TypeModel(controller: TextEditingController()),
    );

    emailsControllers.value = List.generate(
      length,
      (index) => TypeModel(controller: TextEditingController()),
    );

    namesControllers.value = List.generate(
      length,
      (index) => TypeModel(controller: TextEditingController()),
    );

    jobTitlesControllers.value = List.generate(
      length,
      (index) => TypeModel(controller: TextEditingController()),
    );

    phonePrimary.value = List.generate(
      length,
      (index) => PrimaryModel(isPrimary: index == 0),
    );
  }

  void generateControllerForSocialTypes() {
    final length = contactSocial.length + 1;

    // Generate separate controller lists for social types and links
    socialTypesControllers.value = List.generate(
      length,
      (index) => TypeModel(controller: TextEditingController()),
    );

    linksControllers.assignAll(
      List.generate(
        length,
        (index) => TypeModel(controller: TextEditingController()),
      ),
    );
  }

  void generateControllerForAdressCountriesAndCities() {
    final length = contactAddress.length + 1;

    countriesControllers.assignAll(
      List.generate(
        length,
        (index) => TypeModel(controller: TextEditingController()),
      ),
    );

    allCities.assignAll(List.generate(length, (index) => RxMap()));
    citiesControllers.value = List.generate(
      length,
      (index) => TypeModel(controller: TextEditingController()),
    );

    linesControllers.assignAll(
      List.generate(
        length,
        (index) => TypeModel(controller: TextEditingController()),
      ),
    );

    addressPrimary.value = List.generate(
      length,
      (index) => PrimaryModel(isPrimary: index == 0),
    );
  }

  // this function is to select an image for logo
  Future<void> pickImage() async {
    try {
      // Use file_picker to pick an image file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image, // Filter by image file types
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        // Store the file bytes directly into imageBytes
        imageBytes = file.bytes;
        update(); // Trigger any necessary update in your controller
      }
    } catch (e) {
      // Handle error
      // print('Error picking image: $e');
    }
  }

  // this function is to generate a new phone field
  void addPhoneLine() {
    final index = contactPhone.length;

    contactPhone.add(EntityPhone());
    listKeyForPhoneLine.currentState?.insertItem(
      index,
      duration: const Duration(milliseconds: 300),
    );

    phoneTypesControllers.add(TypeModel(controller: TextEditingController()));
    phoneNumbersControllers.add(TypeModel(controller: TextEditingController()));
    emailsControllers.add(TypeModel(controller: TextEditingController()));
    namesControllers.add(TypeModel(controller: TextEditingController()));
    jobTitlesControllers.add(TypeModel(controller: TextEditingController()));
    phonePrimary.add(PrimaryModel(isPrimary: false));
  }

  // this function is to generate a new social field
  void addSocialLine() {
    final index = contactSocial.length;

    contactSocial.add(EntitySocial());
    listKeyForSocialLine.currentState?.insertItem(
      index,
      duration: const Duration(milliseconds: 300),
    );
    socialTypesControllers.add(TypeModel(controller: TextEditingController()));
    linksControllers.add(TypeModel(controller: TextEditingController()));
  }

  // this function is to generate a new address field
  void addAdressLine() {
    final index = contactAddress.length;
    allCities.add(RxMap());
    contactAddress.add(EntityAddress());
    listKeyForAddressLine.currentState?.insertItem(
      index,
      duration: const Duration(milliseconds: 300),
    );
    countriesControllers.add(TypeModel(controller: TextEditingController()));
    citiesControllers.add(TypeModel(controller: TextEditingController()));
    linesControllers.add(TypeModel(controller: TextEditingController()));
    addressPrimary.add(PrimaryModel(isPrimary: false));
  }

  // this function is to remove a phone field
  void removePhoneField(int index) {
    contactPhone.removeAt(index);
    phoneTypesControllers.removeAt(index);
    phoneNumbersControllers.removeAt(index);
    emailsControllers.removeAt(index);
    namesControllers.removeAt(index);
    jobTitlesControllers.removeAt(index);
    phonePrimary.removeAt(index);
  }

  // this function is to remove a social field
  void removeSocialField(int index) {
    contactSocial.removeAt(index);
    socialTypesControllers.removeAt(index);
    linksControllers.removeAt(index);
  }

  // this function is to remove a address field
  void removeAddressField(int index) {
    contactAddress.removeAt(index);
    countriesControllers.removeAt(index);
    citiesControllers.removeAt(index);
    linesControllers.removeAt(index);
    addressPrimary.removeAt(index);
  }

  // this function is to sort data in table
  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      allEntities.sort((screen1, screen2) {
        final String? value1 = screen1.entityName;
        final String? value2 = screen2.entityName;

        // Handle nulls: put nulls at the end
        if (value1 == null && value2 == null) return 0;
        if (value1 == null) return 1;
        if (value2 == null) return -1;

        return compareString(ascending, value1, value2);
      });
    } else if (columnIndex == 2) {
      allEntities.sort((screen1, screen2) {
        final String value1 = screen1.createdAt.toString();
        final String value2 = screen2.createdAt.toString();

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

  void filterEntities() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredEntities.clear();
    } else {
      filteredEntities.assignAll(
        allEntities.where((entity) {
          bool nameMatches = entity.entityName
              .toString()
              .toLowerCase()
              .contains(query);

          final phones = entity.entityPhone ?? [];

          bool phoneMatches = phones.any(
            (phoneData) => phoneData.number.toString().contains(query),
          );

          return nameMatches || phoneMatches;
        }).toList(),
      );
    }
  }
}
