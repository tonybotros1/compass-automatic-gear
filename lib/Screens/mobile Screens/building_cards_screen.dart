import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../Controllers/Mobile section controllers/cards_screen_controller.dart';
import '../../Widgets/Mobile widgets/cards screen widgets/card_style.dart';
import '../../Widgets/main screen widgets/auto_size_box.dart';
import '../../consts.dart';
import '../../main.dart';

Scaffold cardsScreen(
    {required BuildContext context,
    required String pageName,
    required RxList<DocumentSnapshot<Object?>> listOfData,
    required CardsScreenController controller,
    required RxInt numberOfCars}) {
  return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                        title: const Text('Alert'),
                        content: const Text('Are you sure you want to Logout?'),
                        actions: [
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              'No',
                              style: TextStyle(color: mainColor),
                            ),
                          ),
                          CupertinoDialogAction(
                            child: const Text('Yes'),
                            onPressed: () {
                              alertDialog(
                                  context: context,
                                  content: "Are you sure you want to logout?",
                                  onPressed: () async {
                                    await globalPrefs?.remove('userId');
                                    await globalPrefs?.remove('companyId');
                                    await globalPrefs?.remove('userEmail');
                                    Get.offAllNamed('/');
                                  });
                            },
                          )
                        ],
                      ));
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            )),
        automaticallyImplyLeading: false,
        title: Text(
          pageName,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: mainColor,
        actions: [
          Obx(() => AutoSizedText(
                text: 'Cards: $numberOfCars',
                style: const TextStyle(color: Colors.white),
                constraints: const BoxConstraints(),
              )),
          const SizedBox(
            width: 10,
          ),
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ))
        ],
      ),
      body: GetX<CardsScreenController>(builder: (controller) {
        if (controller.loading.value == true) {
          return Center(
            child: CircularProgressIndicator(
              color: mainColor,
            ),
          );
        } else if (listOfData.isEmpty) {
          return Column(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    'No Cards',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                        fontSize: 25),
                  ),
                ),
              ),
            ],
          );
        } else {
          return LiquidPullToRefresh(
            onRefresh: () => controller.getAllCards(),
            color: mainColor,
            animSpeedFactor: 2,
            height: 300,
            child: cardStyle(controller: controller, listName: listOfData),
          );
        }
      }));
}

class DataSearch extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return GetX<CardsScreenController>(builder: (controller) {
      final CardsScreenController cardsScreenController =
          Get.put(CardsScreenController());

      cardsScreenController.filterResults(query);

      if (controller.filteredCarCards.isEmpty) {
        return Center(
            child: Text(
          'No Cards Yet',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: mainColor, fontSize: 25),
        ));
      } else {
        return cardStyle(
            controller: controller, listName: controller.allCarCards);
      }
    });
  }
}
