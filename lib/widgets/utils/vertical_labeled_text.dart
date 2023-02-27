import 'package:flutter/material.dart';

class VerticalLabeledText extends StatelessWidget {
  final String label;
  final TextStyle? labelStyle;
  final String text;
  final TextStyle? textStyle;

  const VerticalLabeledText({
    super.key,
    required this.label,
    this.labelStyle,
    required this.text,
    this.textStyle
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft, 
          child: Text(label, style: labelStyle ?? const TextStyle(fontWeight: FontWeight.bold))
        ),
        Align(
          alignment: Alignment.centerLeft, 
          child: Text(text, style: textStyle)
        ),
      ],
    );
  }
}
