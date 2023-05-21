import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class HorizontalIconedText extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? iconColor;
  final TextStyle? style;
  
  const HorizontalIconedText({super.key, required this.text, this.icon, this.style, this.iconColor});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if(icon != null) Icon(icon, color: iconColor),
        SizedBox(width: icon == null ? 0 : 5),
        Flexible(
          child: AutoSizeText(text, style: style),
        )
      ],
    );
  }
}