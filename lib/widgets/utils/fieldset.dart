import 'package:flutter/material.dart';

class Fieldset extends StatelessWidget {
  final Widget? child;
  final String title;
  
  const Fieldset({super.key, this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(width: 1, color: Colors.grey.shade300),
          ),
          child: child,
        ),
        Positioned(
          top: 8,
          left: 35,
          child: Container(
            color: Colors.white,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary
              ),
            ),
          )
        )
      ],
    );
  }
}