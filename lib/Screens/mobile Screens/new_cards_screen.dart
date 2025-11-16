import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/Mobile section controllers/cards_screen_controller.dart';
import 'building_cards_screen.dart';

class NewCardsScreen extends StatelessWidget {
  const NewCardsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardsScreenController>(
      init: CardsScreenController(),
      builder: (controller) {
        return cardsScreen(
          numberOfCars: controller.numberOfNewCars,
          context: context,
          pageName: 'New Cards',
          listOfData: controller.newCarCards,
          controller: controller,
          isDoneScreen: false
        );
      },
    );
  }
}
