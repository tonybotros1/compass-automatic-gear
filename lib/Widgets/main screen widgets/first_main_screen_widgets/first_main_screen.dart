import 'package:datahubai/Controllers/Main%20screen%20controllers/main_screen_contro.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../consts.dart';

class FirstMainScreen extends StatelessWidget {
  const FirstMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetX<MainScreenController>(
        builder: (controller) {
          bool isFavoriteLoading = controller.favoriteScreens.isEmpty;
          return isFavoriteLoading
              ? Center(child: Text('No Favorites', style: fontStyleForAppBar))
              : GridView.count(
                  crossAxisCount: (MediaQuery.of(context).size.width ~/ 250)
                      .clamp(1, 5),
                  childAspectRatio: 1.5,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 40,
                  mainAxisSpacing: 40,
                  children: List.generate(controller.favoriteScreens.length, (
                    index,
                  ) {
                    final fav = controller.favoriteScreens[index];
                    String screenName = fav.screenName;
                    String emoji = screenName.characters.first;
                    String name = screenName.substring(emoji.length).trim();
                    String description = fav.description;
                    String screenRoute = fav.routeName;
                    String screenId = fav.screenId;

                    // توزيع اللون حسب الفهرس
                    final cardColor = cardColors[index % cardColors.length];

                    return HoverCard(
                      emoji: emoji,
                      name: name,
                      description: description,
                      color: cardColor,
                      onTap: () {
                        controller.selectedScreen.value = controller
                            .getScreenFromRoute(screenRoute);
                        controller.selectedScreenRoute.value = screenRoute;
                        controller.selectedScreenName.value = screenName;
                        controller.selectedScreenId.value = screenId;
                      },
                    );
                  }),
                );
        },
      ),
    );
  }
}

class HoverCard extends StatefulWidget {
  final String emoji;
  final String name;
  final String description;
  final VoidCallback onTap;
  final Color color;

  const HoverCard({
    super.key,
    required this.emoji,
    required this.name,
    required this.description,
    required this.onTap,
    required this.color,
  });

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(10),
          child: Material(
            shadowColor: Colors.black,
            borderRadius: BorderRadius.circular(10),
            elevation: 4,
            child: Container(
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    widget.emoji,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AutoSizeText(
                    widget.name,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: textStyleForFavoritesCards.copyWith(
                      color: colorForNameInCards,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const Divider(),
                  AutoSizeText(
                    widget.description.isNotEmpty
                        ? widget.description
                        : 'Click To Start Working',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
