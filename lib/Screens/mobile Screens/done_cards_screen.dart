import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/Mobile section controllers/cards_screen_controller.dart';
import 'building_cards_screen.dart';

class DoneCardsScreen extends StatelessWidget {
  DoneCardsScreen({super.key});
  final CardsScreenController cardsScreenController =
      Get.put(CardsScreenController());

  @override
  Widget build(BuildContext context) {
    return cardsScreen(
      numberOfCars: cardsScreenController.numberOfDoneCars,
        context: context,
        pageName: 'Finished Cards',
        listOfData: cardsScreenController.doneCarCards,
        controller: cardsScreenController);
  }
}
