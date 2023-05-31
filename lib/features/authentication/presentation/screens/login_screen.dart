import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itpsm_mobile/core/utils/constants/constants.dart';
import 'package:itpsm_mobile/features/authentication/data/models/authenticated_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/authentication_bloc.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // bool _isInit = true;

  bool isSessionStillValid(AuthenticatedUserModel authUser) {
    return DateTime.parse(authUser.expiresAt).isAfter(DateTime.now());
  }

  void autoLogin(BuildContext context) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userJson = sharedPreferences.getString(authenticatedUserKey);

    if(userJson != null && context.mounted) {
      final authUser = AuthenticatedUserModel.fromJson(json.decode(userJson));

      if(isSessionStillValid(authUser)) {
        context.read<AuthenticationBloc>().setAuthentication(authUser);
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    autoLogin(context);
    // if(_isInit) {
      // setState(() { _isInit = false; });
    // }
  }

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