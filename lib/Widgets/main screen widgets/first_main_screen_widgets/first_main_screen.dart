import 'package:datahubai/Controllers/Main%20screen%20controllers/main_screen_contro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
            ? Center(child: Text('No Favorites', style: fontStyleForAppBar))
            : GridView.count(
                crossAxisCount:
                    (MediaQuery.of(context).size.width ~/ 250.w).clamp(1, 5),
                childAspectRatio: 1.5,
                padding: EdgeInsets.all(20.w),
                crossAxisSpacing: 40.w,
                mainAxisSpacing: 40.h,
                children:
                    List.generate(controller.favoriteScreens.length, (index) {
                  final fav = controller.favoriteScreens[index];
                  final data = fav.data() as Map<String, dynamic>? ?? {};
                  String screenName = data['screen_name'] ?? '';
                  String emoji = screenName.characters.first;
                  String name = screenName.substring(emoji.length).trim();
                  String description = data.containsKey('description')
                      ? data['description'] ?? ''
                      : '';

                  // توزيع اللون حسب الفهرس
                  final cardColor = cardColors[index % cardColors.length];

                  return HoverCard(
                    emoji: emoji,
                    name: name,
                    description: description,
                    color: cardColor,
                    onTap: () {
                      controller.selectedScreen.value =
                          controller.getScreenFromRoute(data['screen_route']);
                      controller.selectedScreenRoute.value =
                          data['screen_route'];
                      controller.selectedScreenName.value = data['screen_name'];
                    },
                  );
                }),
              );
      }),
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
          borderRadius: BorderRadius.circular(10.r),
          child: Material(
            shadowColor: Colors.black,
            borderRadius: BorderRadius.circular(10.r),
            elevation: 4,
            child: Container(
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FittedBox(
                    child: Text(
                      widget.emoji,
                      style: TextStyle(
                          fontSize: 25.sp,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  AutoSizeText(
                    widget.name,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: textStyleForFavoritesCards.copyWith(
                      color: const Color(0xFF00695C),
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                  Divider(),
                  AutoSizeText(
                    widget.description.isNotEmpty
                        ? widget.description
                        : 'Click To Start Working',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700),
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
