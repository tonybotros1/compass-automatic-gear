import 'package:flutter/material.dart';

class CustomExpandIcon extends StatelessWidget {
  final bool isExpanded;
  final ValueChanged<bool>? onPressed;
  final double iconSize;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Color? expandedColor;

  const CustomExpandIcon({
    super.key,
    this.isExpanded = false,
    this.onPressed,
    this.iconSize = 20.0,
    this.padding = const EdgeInsets.all(0),
    this.color,
    this.expandedColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => onPressed?.call(!isExpanded),
      highlightShape: BoxShape.circle,
      radius: 1.0, // Reduce the ripple radius
      child: Padding(
        padding: padding,
        child: Icon(
          isExpanded ? Icons.expand_less : Icons.expand_more,
          size: iconSize,
          color: isExpanded ? expandedColor : color,
        ),
      ),
    );
  }
}
