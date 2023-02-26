import 'package:flutter/material.dart';
import 'package:itpsm_mobile/widgets/login/login_form.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 48,
                  child: Image.asset('assets/images/logos/logo-ITPSM-p.jpg', fit: BoxFit.cover,),
                ),
                Text('Iniciar sesión', style: Theme.of(context).textTheme.titleMedium),
                const LoginForm()
              ],
            ),
          ),
        )
      )
    );
  }
}