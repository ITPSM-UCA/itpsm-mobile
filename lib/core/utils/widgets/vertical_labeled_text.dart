import 'package:flutter/material.dart';

import 'horizontal_iconed_text.dart';

class VerticalLabeledText extends StatelessWidget {
  final String label;
  final TextStyle? labelStyle;
  final String text;
  final TextStyle? textStyle;
  final IconData? icon;

  const VerticalLabeledText({
    super.key,
    required this.label,
    this.labelStyle,
    required this.text,
    this.textStyle,
    this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft, 
          child: HorizontalIconedText(
            icon: icon,
            style: labelStyle,
            text: label,
          )
          // Text(label, style: labelStyle ?? const TextStyle(fontWeight: FontWeight.bold))
        ),
        Align(
          alignment: Alignment.centerLeft, 
          child: Text(text, style: textStyle)
        ),
      ],
    );
  }
}
