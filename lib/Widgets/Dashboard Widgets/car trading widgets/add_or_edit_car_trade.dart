import 'package:flutter/material.dart';
import '../../../Controllers/Dashboard Controllers/car_trading_dashboard_controller.dart';
import 'additional_information_section.dart';
import 'buy_sell_section.dart';
import 'car_information_section.dart';
import 'note_section.dart';

const _workArea = Color(0xFFF4F7FA);
const _panel = Colors.white;
const _border = Color(0xFFD7E0EA);
const _ink = Color(0xFF172033);
const _muted = Color(0xFF64748B);
const _blue = Color(0xFF146C94);
const _blueSoft = Color(0xFFEAF6FB);
const _orange = Color(0xFFC77700);
const _orangeSoft = Color(0xFFFFF7E8);
const _purple = Color(0xFF6D5BD0);
const _purpleSoft = Color(0xFFF1EFFF);

Widget addNewCarTradeOrEdit({
  required BuildContext context,
  required CarTradingDashboardController controller,
  required bool canEdit,
  required BoxConstraints constraints,
}) {
  return Form(
    key: controller.carTradeFormKey,
    child: ColoredBox(
      color: _workArea,
      child: LayoutBuilder(
        builder: (context, bodyConstraints) {
          final isMobile = bodyConstraints.maxWidth <= 760;

          return CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 10 : 12),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _BodyPanel(
                            title: 'Car Information',
                            subtitle: '',
                            icon: Icons.directions_car_filled_outlined,
                            iconColor: _blue,
                            iconBackground: _blueSoft,
                            child: carInformation(
                              context: context,
                              constraints: constraints,
                              controller: controller,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _BodyPanel(
                            title: 'Additional Information',
                            subtitle: '',
                            icon: Icons.directions_car_filled_outlined,
                            iconColor: _blue,
                            iconBackground: _blueSoft,
                            child: additionalInformation(
                              context: context,
                              constraints: constraints,
                              controller: controller,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _BodyPanel(
                            title: 'Buyer Details',
                            subtitle:
                                'Purchase information and internal financial data.',
                            icon: Icons.south_west_rounded,
                            iconColor: _orange,
                            iconBackground: _orangeSoft,
                            child: buyerDetailsSection(
                              context: context,
                              constraints: constraints,
                              controller: controller,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _BodyPanel(
                            title: 'Seller Details',
                            subtitle: 'Sale information.',
                            icon: Icons.north_east_rounded,
                            iconColor: _purple,
                            iconBackground: _purpleSoft,
                            child: sellerDetailsSection(
                              context: context,
                              constraints: constraints,
                              controller: controller,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _BodyPanel(
                            title: 'Note',
                            subtitle: 'Internal notes for this transaction.',
                            icon: Icons.edit_note_outlined,
                            iconColor: _blue,
                            iconBackground: _blueSoft,
                            child: noteSection(
                              context: context,
                              constraints: constraints,
                              controller: controller,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

class _BodyPanel extends StatelessWidget {
  const _BodyPanel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.child,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: _panel,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
            decoration: const BoxDecoration(
              color: _panel,
              border: Border(bottom: BorderSide(color: _border)),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: iconBackground,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icon, color: iconColor, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
}
