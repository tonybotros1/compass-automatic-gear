import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/Mobile section controllers/cards_screen_controller.dart';
import 'building_cards_screen.dart';

class DoneCardsScreen extends StatelessWidget {
  const DoneCardsScreen({super.key});
  // final CardsScreenController cardsScreenController =
  //     Get.put(CardsScreenController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardsScreenController>(
      builder: (controller) {
        return cardsScreen(
          numberOfCars: controller.numberOfDoneCars,
          context: context,
          pageName: 'Other Cards',
          listOfData: controller.doneCarCards,
          controller: controller,
          isDoneScreen: true,
        );
      },
    );
  }
}
