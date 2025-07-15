import 'package:datahubai/Controllers/Main%20screen%20controllers/main_screen_contro.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';

import '../../../consts.dart';

class FirstMainScreen extends StatelessWidget {
  const FirstMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetX<MainScreenController>(builder: (controller) {
        bool isFavoriteLoading = controller.favoriteScreens.isEmpty;
        return isFavoriteLoading
            ? Center(child: Text('No Favorits', style: fontStyleForAppBar))
            : GridView.count(
                crossAxisCount: 5,
                childAspectRatio: 1.5,
                padding: EdgeInsets.all(20),
                crossAxisSpacing: 40,
                mainAxisSpacing: 40,
                children: controller.favoriteScreens.map((fav) {
                  return InkWell(
                    onTap: () {
                      controller.selectedScreen.value =
                          controller.getScreenFromRoute(fav['screen_route']);
                      controller.selectedScreenRoute.value =
                          fav['screen_route'];
                      controller.selectedScreenName.value = fav['screen_name'];
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5))),
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFE0F7F4),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 16),
                              child: Center(
                                child: Text(
                                  fav['screen_name'],
                                  style: textStyleForFavoritesCards.copyWith(
                                    color: Color(0xFF00695C),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
      }),
    );
  }
}
