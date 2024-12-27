import 'package:flutter/material.dart';

class AutoSizedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int maxLines;
  final constraints;

  const AutoSizedText({
    super.key,
    required this.text,
    this.style,
    this.maxLines = 1,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    double fontSize = style?.fontSize ?? 16; // Default font size
    const double minFontSize = 10; // Minimum font size
    final TextStyle effectiveStyle = style ?? const TextStyle();
    return Builder(
      builder: (context) {
        while (fontSize > minFontSize) {
          final TextPainter textPainter = TextPainter(
            text: TextSpan(
                text: text, style: effectiveStyle.copyWith(fontSize: fontSize)),
            maxLines: maxLines,
            textDirection: TextDirection.ltr,
          )..layout(maxWidth: constraints.maxWidth);

          if (textPainter.didExceedMaxLines ||
              textPainter.size.width > constraints.maxWidth) {
            fontSize -= 1; // Reduce font size to fit
          } else {
            break;
          }
        }

        return Text(
          text,
          style: effectiveStyle.copyWith(fontSize: fontSize),
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}
