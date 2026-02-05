import 'package:flutter/material.dart';

class ClickableHoverText extends StatefulWidget {
  final String? text;
  final Widget? widget;
  final void Function()? onTap;
  final void Function()? onSecondaryTap;
  final Color? color1;
  final Color? color2;
  final bool? underLine;

  const ClickableHoverText({
    super.key,
    this.text,
    this.widget,
    this.onTap,
    this.color1,
    this.color2,
    this.underLine,
    this.onSecondaryTap,
  });

  @override
  State<ClickableHoverText> createState() => _ClickableHoverTextState();
}

class _ClickableHoverTextState extends State<ClickableHoverText> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onSecondaryTap: widget.onSecondaryTap,
        onTap: widget.onTap,
        child: widget.text != null
            ? Text(
                widget.text ?? '',
                style: TextStyle(
                  decoration: widget.underLine == true
                      ? TextDecoration.underline
                      : null,
                  color: _isHovering
                      ? widget.color1 ?? Colors.white
                      : widget.color2 ?? Colors.grey.shade400,
                  // decoration: TextDecoration.underline,
                ),
              )
            : widget.widget,
      ),
    );
  }
}
