import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itpsm_mobile/core/utils/log/get_logger.dart';
import 'package:itpsm_mobile/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:itpsm_mobile/features/authentication/presentation/cubit/login/login_cubit.dart';
import 'package:itpsm_mobile/features/authentication/presentation/cubit/login/login_state.dart';
import 'package:logger/logger.dart';

class LoginForm extends StatefulWidget {
  static final Logger logger = getLogger();
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FocusNode _focusPsswd = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _psswdCtrl = TextEditingController();
  final Map<String, String> _credentials = { 'email': '', 'password': '' };

  String? _validateEmail(String? email) {
    if(email != null) {
      if (email.isEmpty || !EmailValidator.validate(email)) {
        return 'Por favor ingrese un correo electrónico válido.';
      }

      return null;
    }
    else {
      return 'El ingreso del correo electrónico es obligatorio.';
    }
  }

  String? _validatePsswd(String? passwd) {
    if(passwd != null) {
      // TODO: Add necessary validations
      if(passwd.isEmpty) return 'El ingreso de la contraseña es obligatorio.';
      
      return null;
    }
    else {
      return 'El ingreso de la contraseña es obligatorio.';
    }
  }

  void _submit() {
    final form = _formKey.currentState;

    if(form == null || !form.validate()) return;

    form.save();

    LoginForm.logger.d('email: ${_credentials['email']} psswd: ${_credentials['password']}');

    context.read<LoginCubit>().login(_credentials['email']!, _credentials['password']!);
  }

  @override
  void dispose() {
    super.dispose();
    _emailCtrl.dispose();
    _psswdCtrl.dispose();
    _focusPsswd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode focusScope = FocusScope.of(context);

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if(state.status == LoginStatus.success) {
          context.read<AuthenticationBloc>().setAuthentication(state.authenticatedUser);
        }
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 240,
          maxWidth: 380,
        ),
        child: Container(
          margin: const EdgeInsets.all(15),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 8.0,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: TextFormField(
                        autocorrect: false,
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        onFieldSubmitted: (value) => focusScope.requestFocus(_focusPsswd),
                        decoration: const InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                          hintText: 'Correo electónico',
                          labelText: 'Correo electónico'
                        ),
                        validator: (value) { return _validateEmail(value); },
                        onSaved: (value) { 
                          if(value != null) {
                            _credentials['email'] = value; 
                          }
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        obscureText: true,
                        autocorrect: false,
                        controller: _psswdCtrl,
                        focusNode: _focusPsswd,
                        enableSuggestions: false,
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Contraseña',
                          labelText: 'Contraseña',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.password),
                          suffixIcon: Icon(Icons.remove_red_eye),
                        ),
                        validator: (value) { return _validatePsswd(value); },
                        onSaved: (value) {
                          if(value != null) {
                            _credentials['password'] = value; 
                          }
                        },
                        onFieldSubmitted: (value) { _submit(); },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(onPressed: () {}, child: const Text('¿Olvidaste tu contraseña?'))
                    ),
                    FilledButton(
                      onPressed: () {
                        _submit();
                        // Navigator.of(context).pushNamed(AcademicRecordScreen.routeName);
                      },
                      child: const Text('Iniciar sesión'),
                    )
                  ]
                ),
              ),
            ),
          ),
        ),
        // child: Card(
        //   elevation: 4,
        //   child: Padding(
        //     padding: const EdgeInsets.all(15),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.stretch,
        //       children: [
        //         Container(
        //           margin: const EdgeInsets.only(bottom: 10),
        //           child: TextFormField(
        //             decoration: const InputDecoration(
        //               labelText: 'Correo electónico',
        //               border: OutlineInputBorder(),
        //               hintText: 'Correo electónico'
        //             )
        //           ),
        //         ),
        //         Container(
        //           margin: const EdgeInsets.only(top: 10),
        //           child: TextFormField(
        //             decoration: const InputDecoration(
        //               labelText: 'Contraseña',
        //               border: OutlineInputBorder(),
        //               hintText: 'Contraseña',
        //               suffixIcon: Icon(Icons.remove_red_eye)
        //             ),
        //           ),
        //         ),
        //        Align(
        //          alignment: Alignment.centerLeft,
        //          child: TextButton(onPressed: () {}, child: const Text('¿Olvidaste tu contraseña?'))
        //        ),
        //         FilledButton(
        //           onPressed: () {
        //             Navigator.of(context).pushNamed(AcademicRecordScreen.routeName);
        //           },
        //           child: const Text('Iniciar sesión'),
        //         )
        //       ],
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
