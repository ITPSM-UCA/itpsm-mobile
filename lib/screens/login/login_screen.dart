import 'package:flutter/material.dart';
import 'package:itpsm_mobile/widgets/login/login_form.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 48,
            margin: const EdgeInsets.only(bottom: 10),
            child: 
              Image.network('https://itpsm.edu.sv/wp-content/uploads/2019/01/logo-ITPSM-p.jpg')
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Text('Iniciar sesión', style: Theme.of(context).textTheme.titleMedium)
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: LoginForm()
          )
      ],),
    );
  }
}