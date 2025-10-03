import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/Mobile section controllers/cards_screen_controller.dart';
import 'building_cards_screen.dart';

class NewCardsScreen extends StatelessWidget {
  NewCardsScreen({super.key});
  final CardsScreenController cardsScreenController =
      Get.put(CardsScreenController());

  @override
  Widget build(BuildContext context) {
    return cardsScreen(
      numberOfCars: cardsScreenController.numberOfNewCars,
        context: context,
        pageName: 'New Cards',
        listOfData: cardsScreenController.newCarCards,
        controller: cardsScreenController);
  }
}
