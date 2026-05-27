import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/Main screen controllers/main_screen_contro.dart';
import '../../Widgets/main screen widgets/first_main_screen_widgets/left_tree.dart';
import '../../Widgets/main screen widgets/first_main_screen_widgets/personal_details_section.dart';
import '../../consts.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final MainScreenController mainScreenController = Get.put(
    MainScreenController(),
  );

  bool _useCompactHeader(double width) => width < 760;

  double _actionRadius(double width) => width < 430 ? 21 : 25;

  double _actionSpacing(double width) => width < 430 ? 8 : 14;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: sideMenuWidget(mainScreenController),
      body: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final bool compactHeader = _useCompactHeader(
                constraints.maxWidth,
              );

              return Container(
                width: constraints.maxWidth,
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(
                  compactHeader ? 8 : 12,
                  12,
                  compactHeader ? 8 : 16,
                  10,
                ),
                child: compactHeader
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              _drawerButton(context),
                              const SizedBox(width: 8),
                              Expanded(child: _screenTitle()),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: _headerActions(
                              context,
                              constraints.maxWidth,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: _drawerButton(context),
                            ),
                          ),
                          Expanded(child: Center(child: _screenTitle())),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: _headerActions(
                                context,
                                constraints.maxWidth,
                              ),
                            ),
                          ),
                        ],
                      ),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Divider(indent: 20, endIndent: 20),
          ),
          Expanded(child: Obx(() => mainScreenController.selectedScreen.value)),
        ],
      ),
    );
  }

  Builder _drawerButton(BuildContext context) {
    return Builder(
      builder: (context) => IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: const Icon(Icons.menu, size: 25),
      ),
    );
  }

  Obx _screenTitle() {
    return Obx(
      () => Text(
        mainScreenController.selectedScreenName.value,
        style: fontStyleForAppBar,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _headerActions(BuildContext context, double width) {
    final double radius = _actionRadius(width);
    final double spacing = _actionSpacing(width);

    return Wrap(
      spacing: spacing,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.end,
      children: [
        Obx(() {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              _roundActionButton(
                radius: radius,
                color: Colors.blueGrey,
                tooltip: 'Notifications',
                icon: Icons.notifications,
                onPressed: () {
                  mainScreenController.selectedScreen.value =
                      mainScreenController.getScreenFromRoute("/toDoList");
                  mainScreenController.selectedScreenRoute.value = "/toDoList";
                  mainScreenController.selectedScreenName.value =
                      "🧾 To Do List";
                },
              ),
              if (mainScreenController.unreadChatCount.value > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      mainScreenController.unreadChatCount.value > 99
                          ? '99+'
                          : '${mainScreenController.unreadChatCount.value}',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          );
        }),
        Obx(() {
          final currentRoute = mainScreenController.selectedScreenRoute.value;
          final isFavorite = mainScreenController.favoriteScreens.any(
            (doc) => doc.routeName == currentRoute,
          );

          return currentRoute != '/home'
              ? _roundActionButton(
                  radius: radius,
                  color: Colors.pink.shade400,
                  tooltip: isFavorite
                      ? 'Remove from favorites'
                      : 'Add to favorites',
                  icon: Icons.star,
                  iconColor: isFavorite ? Colors.yellow : Colors.white,
                  onPressed: () {
                    if (isFavorite) {
                      mainScreenController.removeScreenFromFavorite(
                        mainScreenController.selectedScreenId.value,
                      );
                    } else {
                      mainScreenController.addScreenToFavorite();
                    }
                  },
                )
              : const SizedBox.shrink();
        }),
        _roundActionButton(
          radius: radius,
          color: Colors.teal,
          tooltip: 'Home',
          icon: Icons.home,
          onPressed: () {
            mainScreenController.selectedScreen.value = mainScreenController
                .getScreenFromRoute('/home');
            mainScreenController.selectedScreenName.value = '🏡 Home';
            mainScreenController.selectedScreenRoute.value = '/home';
          },
        ),
        Obx(
          () => mainScreenController.isLoading.isFalse
              ? personalDetailsSection(context, mainScreenController)
              : SizedBox.square(dimension: radius * 2),
        ),
      ],
    );
  }

  CircleAvatar _roundActionButton({
    required double radius,
    required Color color,
    required String tooltip,
    required IconData icon,
    required VoidCallback onPressed,
    Color iconColor = Colors.white,
  }) {
    return CircleAvatar(
      backgroundColor: color,
      radius: radius,
      child: IconButton(
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        constraints: BoxConstraints.tightFor(
          width: radius * 2,
          height: radius * 2,
        ),
        onPressed: onPressed,
        icon: Icon(icon, color: iconColor, size: radius < 24 ? 18 : 20),
      ),
    );
  }
}
