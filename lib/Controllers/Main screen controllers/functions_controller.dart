import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datahubai/Models/functions/screens_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../consts.dart';
import 'main_screen_contro.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class FunctionsController extends GetxController {
  late TextEditingController screenName = TextEditingController();
  late TextEditingController route = TextEditingController();
  late TextEditingController description = TextEditingController();
  // final RxList<DocumentSnapshot> allScreens = RxList<DocumentSnapshot>([]);
  final RxList<FunctionsModel> allScreens = RxList<FunctionsModel>([]);
  // final RxList<DocumentSnapshot> filteredScreens = RxList<DocumentSnapshot>([]);
  final RxList<FunctionsModel> filteredScreens = RxList<FunctionsModel>([]);
  RxBool isScreenLoding = RxBool(false);
  RxString query = RxString('');
  Rx<TextEditingController> search = TextEditingController().obs;
  RxBool addingNewScreenProcess = RxBool(false);
  RxInt sortColumnIndex = RxInt(0);
  RxBool isAscending = RxBool(true);
  WebSocketChannel? channel;

  @override
  void onInit() {
    connectWebSocket();
    getScreens();
    super.onInit();
  }

  getScreenName() {
    MainScreenController mainScreenController =
        Get.find<MainScreenController>();
    return mainScreenController.selectedScreenName.value;
  }

  void connectWebSocket() {
    channel = WebSocketChannel.connect(
      Uri.parse("ws://localhost:8000/ws"), // change to wss:// in production
    );

    channel!.stream.listen((event) {
      final message = jsonDecode(event);

      switch (message["type"]) {
        case "screen_created":
          final newBrand = FunctionsModel.fromJson(message["data"]);
          allScreens.add(newBrand);
          break;

        case "screen_updated":
          final updated = FunctionsModel.fromJson(message["data"]);
          final index = allScreens.indexWhere((s) => s.id == updated.id);
          if (index != -1) {
            allScreens[index] = updated;
          }
          break;

        case "screen_deleted":
          final deletedId = message["data"]["_id"];
          allScreens.removeWhere((s) => s.id == deletedId);
          break;
      }
    });
  }

  getScreens() async {
    try {
      isScreenLoding.value = true;
      var url = Uri.parse('$backendTestURI/functions/get_screens');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        List screens = decoded["screens"];
        allScreens.assignAll(
          screens.map((screen) => FunctionsModel.fromJson(screen)),
        );
        isScreenLoding.value = false;
      } else {
        isScreenLoding.value = false;
      }
    } catch (e) {
      isScreenLoding.value = false;
    }
  }

  addNewScreen() async {
    try {
      addingNewScreenProcess.value = true;

      var url = Uri.parse('$backendTestURI/functions/add_screen');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": screenName.text,
          "route_name": route.text,
          "description": description.text,
        }),
      );
      if (response.statusCode == 200) {
        addingNewScreenProcess.value = false;

        Get.back();
        showSnackBar('Done', 'Screen added successfully');
      } else {
        Get.back();
        addingNewScreenProcess.value = false;
        showSnackBar('Alert', 'Something went wrong please try again');
      }
    } catch (e) {
      addingNewScreenProcess.value = false;
      Get.back();
      showSnackBar('Alert', 'Something went wrong please try again');
    }
  }

  // // this function is to sort data in table
  // void onSort(int columnIndex, bool ascending) {
  //   if (columnIndex == 0) {
  //     allScreens.sort((screen1, screen2) {
  //       final String? value1 = screen1.get('name');
  //       final String? value2 = screen2.get('name');

  //       // Handle nulls: put nulls at the end
  //       if (value1 == null && value2 == null) return 0;
  //       if (value1 == null) return 1;
  //       if (value2 == null) return -1;

  //       return compareString(ascending, value1, value2);
  //     });
  //   } else if (columnIndex == 1) {
  //     allScreens.sort((screen1, screen2) {
  //       final String? value1 = screen1.get('routeName');
  //       final String? value2 = screen2.get('routeName');

  //       // Handle nulls: put nulls at the end
  //       if (value1 == null && value2 == null) return 0;
  //       if (value1 == null) return 1;
  //       if (value2 == null) return -1;

  //       return compareString(ascending, value1, value2);
  //     });
  //   } else if (columnIndex == 2) {
  //     allScreens.sort((screen1, screen2) {
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

  // this functions is to get the screens in system and its details
  // getScreens() {
  //   try {
  //     FirebaseFirestore.instance
  //         .collection('screens')
  //         .snapshots()
  //         .listen((screens) {
  //       allScreens.assignAll(List<DocumentSnapshot>.from(screens.docs));
  //       isScreenLoding.value = false;
  //     });
  //   } catch (e) {
  //     isScreenLoding.value = false;
  //   }
  // }

  // this function is to update screen details
  updateScreen(screenID) async {
    try {
      addingNewScreenProcess.value = true;
      await FirebaseFirestore.instance
          .collection('screens')
          .doc(screenID)
          .update({
            'name': screenName.text,
            'routeName': route.text,
            'description': description.text,
          });
      addingNewScreenProcess.value = false;
      Get.back();
      showSnackBar('Done', 'Screen Updated successfully');
    } catch (e) {
      addingNewScreenProcess.value = false;
      showSnackBar('failed', 'Please try again');
    }
  }

  // this function is to filter the search results for web
  void filterScreens() {
    query.value = search.value.text.toLowerCase();
    if (query.value.isEmpty) {
      filteredScreens.clear();
    } else {
      filteredScreens.assignAll(
        allScreens.where((screen) {
          return screen.name.toString().toLowerCase().contains(query);
        }).toList(),
      );
    }
  }

  deleteScreen(screenId) async {
    Get.back();
    await FirebaseFirestore.instance
        .collection('screens')
        .doc(screenId)
        .delete();
  }

  // this function is to add new screen to the system
  // addNewScreen() {
  //   try {
  //     addingNewScreenProcess.value = true;
  //     if (screenName.text.isEmpty || route.text.isEmpty) {
  //       throw Exception();
  //     }
  //     FirebaseFirestore.instance.collection('screens').add({
  //       "name": screenName.text,
  //       "routeName": route.text,
  //       "added_date": DateTime.now().toString(),
  //       "description": description.text,
  //     });
  //     addingNewScreenProcess.value = false;
  //     Get.back();
  //     showSnackBar('Done', 'New Screen added successfully');
  //   } catch (e) {
  //     showSnackBar('Warning', 'Please try Again');
  //     addingNewScreenProcess.value = false;
  //     //
  //   }
  // }
}
