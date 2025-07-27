import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Controllers/Main screen controllers/main_screen_contro.dart';
import '../../Widgets/main screen widgets/first_main_screen_widgets/left_tree.dart';
import '../../Widgets/main screen widgets/first_main_screen_widgets/personal_details_section.dart';
import '../../consts.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final MainScreenController mainScreenController =
      Get.put(MainScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: sideMenuWidget(mainScreenController),
      body: Row(
        children: [
          // if (ScreenSize.isWeb(context)) sideMenuWidget(),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                Container(
                  width: Get.width,
                  color: Colors.white,
                  height: 80.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // if (!ScreenSize.isWeb(context))
                      Builder(
                        builder: (context) => IconButton(
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                            icon: Icon(
                              Icons.menu,
                              size: 25.sp,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15.w),
                        child: Obx(() => Text(
                              mainScreenController.selectedScreenName.value,
                              style: fontStyleForAppBar,
                            )),
                      ),
                      Row(
                        spacing: 20.w,
                        children: [
                          Obx(() {
                            final currentRoute =
                                mainScreenController.selectedScreenRoute.value;
                            final isFavorite = mainScreenController
                                .favoriteScreens
                                .any((doc) =>
                                    doc.get('screen_route') == currentRoute);

                            return currentRoute != '/home'
                                ? CircleAvatar(
                                    backgroundColor: Colors.pink.shade400,
                                    radius: 25.r,
                                    child: IconButton(
                                      tooltip: isFavorite
                                          ? 'Remove from favorites'
                                          : 'Add to favorites',
                                      onPressed: () {
                                        if (isFavorite) {
                                          mainScreenController
                                              .removeScreenFromFavorite(
                                                  currentRoute);
                                        } else {
                                          mainScreenController
                                              .addScreenToFavorite();
                                        }
                                      },
                                      icon: Icon(
                                        Icons.star,
                                        color: isFavorite
                                            ? Colors.yellow
                                            : Colors.white,
                                        size: 20.sp,
                                      ),
                                    ),
                                  )
                                : SizedBox();
                          }),
                          CircleAvatar(
                            backgroundColor: Colors.teal,
                            radius: 25.r,
                            child: IconButton(
                                tooltip: 'Home',
                                onPressed: () {
                                  mainScreenController.selectedScreen.value =
                                      mainScreenController
                                          .getScreenFromRoute('/home');
                                  mainScreenController
                                      .selectedScreenName.value = '🏡 Home';
                                  mainScreenController
                                      .selectedScreenRoute.value = '/home';
                                },
                                icon: Icon(
                                  Icons.home,
                                  size: 20.sp,
                                  color: Colors.white,
                                )),
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: 16.w),
                              child: Obx(() =>
                                  mainScreenController.isLoading.isFalse
                                      ? personalDetailsSection(
                                          context, mainScreenController)
                                      : const SizedBox())),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child:
                        Obx(() => mainScreenController.selectedScreen.value)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
