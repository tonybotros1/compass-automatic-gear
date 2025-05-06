import 'package:flutter/material.dart';

class ClickableHoverText extends StatefulWidget {
  final String text;
  final void Function()? onTap;
  final Color? color1;
  final Color? color2;

  const ClickableHoverText(
      {super.key, required this.text, this.onTap, this.color1, this.color2});

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
        onTap: widget.onTap,
        child: Text(
          widget.text,
          style: TextStyle(
            color: _isHovering
                ? widget.color1 ?? Colors.blue
                : widget.color2 ?? Colors.white,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
