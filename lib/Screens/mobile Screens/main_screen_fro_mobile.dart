import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../Controllers/Mobile section controllers/main_screen_fro_mobile_controller.dart';

class MainScreenForMobile extends StatelessWidget {
  MainScreenForMobile({super.key});

  final PersistentTabController bottomBarController = PersistentTabController(
    initialIndex: 0,
  );

  // final MainCardScreenController mainCardScreenController =
  //     Get.put(MainCardScreenController());

  @override
  Widget build(BuildContext context) {
    Get.put(bottomBarController);

    return GetBuilder<MainCardScreenController>(
      init: MainCardScreenController(),
      builder: (controller) {
        return PersistentTabView(
          hideNavigationBarWhenKeyboardAppears: false,
          popBehaviorOnSelectedNavBarItemPress: PopBehavior.once,
          context,
          controller: bottomBarController,
          screens: controller.buildScreens(),
          items: controller.navBarsItems(),
          backgroundColor: Colors.white, // Default is Colors.white.
          handleAndroidBackButtonPress: true, // Default is true.
          resizeToAvoidBottomInset:
              true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          stateManagement: true, // Default is true.
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(10.0),
            colorBehindNavBar: Colors.white,
          ),
          animationSettings: const NavBarAnimationSettings(
            navBarItemAnimation: ItemAnimationSettings(
              // Navigation Bar's items animation properties.
              duration: Duration(milliseconds: 400),
              curve: Curves.ease,
            ),
            screenTransitionAnimation: ScreenTransitionAnimationSettings(
              // Screen transition animation on change of selected tab.
              animateTabTransition: true,
              duration: Duration(milliseconds: 300),
              screenTransitionAnimationType:
                  ScreenTransitionAnimationType.slide,
            ),
            onNavBarHideAnimation: OnHideAnimationSettings(
              duration: Duration(milliseconds: 100),
              curve: Curves.bounceInOut,
            ),
          ),
          confineToSafeArea: true,
          navBarStyle: NavBarStyle
              .style10, // Choose the nav bar style with this property.
        );
      },
    );
  }
}
