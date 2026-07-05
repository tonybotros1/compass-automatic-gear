
import 'package:flutter/material.dart';

import '../../../consts.dart';

class SummaryBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? textColor;
  final Color iconColor;
  final bool showRefreshIcon;
  final void Function()? onPressedForRefreshIcon;
  final bool? isFormated;
  final double? width;
  final double? iconSize;
  const SummaryBox({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.textColor,
    required this.showRefreshIcon,
    this.onPressedForRefreshIcon,
    this.isFormated,
    this.width,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.shade300),
        color: const Color(0xffF4F5F8).withValues(alpha: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      showRefreshIcon == true
                          ? IconButton(
                              onPressed: onPressedForRefreshIcon,
                              icon: const Icon(
                                Icons.refresh,
                                size: 20,
                                color: Colors.grey,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  FittedBox(
                    child: textForDataRowInTable(
                      fontSize: 25,
                      isBold: true,
                      color: textColor,
                      text: value,
                      maxWidth: null,
                      formatDouble: isFormated ?? true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(icon, size: iconSize ?? 70, color: iconColor),
          ),
        ],
      ),
    );
  }
}
