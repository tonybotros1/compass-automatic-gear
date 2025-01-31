import 'package:flutter/material.dart';

class SmartInfoOverlay extends StatefulWidget {
  final Widget Function(VoidCallback showOverlay) triggerBuilder;
  final Widget Function(VoidCallback dismissOverlay) overlayContent;
  // final Widget overlayContent;
  final double maxWidth;
  final Color backgroundColor;
  final double elevation;
  final double verticalOffset;
  final double horizontalEdgeMargin;

  const SmartInfoOverlay({
    super.key,
    required this.triggerBuilder,
    required this.overlayContent,
    this.maxWidth = 280,
    this.backgroundColor = Colors.white,
    this.elevation = 4.0,
    this.verticalOffset = 4.0,
    this.horizontalEdgeMargin = 8.0,
  });

  @override
  SmartInfoOverlayState createState() => SmartInfoOverlayState();
}

class SmartInfoOverlayState extends State<SmartInfoOverlay> {
  final GlobalKey _triggerKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  void showOverlay() {
    final renderBox =
        _triggerKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final buttonPosition = renderBox.localToGlobal(Offset.zero);
    final buttonSize = renderBox.size;
    final screenSize = MediaQuery.of(context).size;

    final position = _calculateOverlayPosition(
      buttonPosition,
      buttonSize,
      screenSize,
    );

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: dismissOverlay,
            behavior: HitTestBehavior.opaque,
          ),
          Positioned(
            left: position.left,
            top: position.top,
            child: Material(
              elevation: widget.elevation,
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: position.width,
                constraints: BoxConstraints(
                  maxHeight: screenSize.height,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SingleChildScrollView(
                  child: widget.overlayContent(dismissOverlay),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  OverlayPosition _calculateOverlayPosition(
    Offset buttonPosition,
    Size buttonSize,
    Size screenSize,
  ) {
    // Calculate available width considering screen edges
    final maxAllowedWidth = screenSize.width - 2 * widget.horizontalEdgeMargin;
    final overlayWidth = widget.maxWidth.clamp(0.0, maxAllowedWidth);

    // Calculate horizontal position to align with button's right edge
    double leftPosition = buttonPosition.dx + buttonSize.width - overlayWidth;

    // Adjust for screen edges
    leftPosition = leftPosition.clamp(
      widget.horizontalEdgeMargin,
      screenSize.width - widget.horizontalEdgeMargin - overlayWidth,
    );

    // Calculate vertical position
    final verticalSpaceBelow =
        screenSize.height - buttonPosition.dy - buttonSize.height;
    final verticalSpaceAbove = buttonPosition.dy;

    double topPosition;
    if (verticalSpaceBelow > 100 || verticalSpaceBelow > verticalSpaceAbove) {
      // Show below if enough space or more space below than above
      topPosition =
          buttonPosition.dy + buttonSize.height + widget.verticalOffset;
    } else {
      // Show above if not enough space below
      topPosition = buttonPosition.dy - widget.verticalOffset - 100;
    }

    return OverlayPosition(
      left: leftPosition,
      top: topPosition,
      width: overlayWidth,
    );
  }

  void dismissOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _triggerKey,
      child: widget.triggerBuilder(showOverlay),
    );
  }

  @override
  void dispose() {
    dismissOverlay();
    super.dispose();
  }
}

class OverlayPosition {
  final double left;
  final double top;
  final double width;

  OverlayPosition({
    required this.left,
    required this.top,
    required this.width,
  });
}
