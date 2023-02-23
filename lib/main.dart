import 'package:flutter/material.dart';
import 'package:itpsm_mobile/screens/login/login_screen.dart';

void main() {
  runApp(const ItpsmMobile());
}

class ItpsmMobile extends StatelessWidget {
  const ItpsmMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ITPSM Mobile',
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen()
      },
    );
  }
}
