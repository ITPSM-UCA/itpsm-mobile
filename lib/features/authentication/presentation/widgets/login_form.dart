import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:itpsm_mobile/core/utils/itpsm_utils.dart';
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
  bool _isLoading = false;
  bool _showPassword = false;
  final FocusNode _focusPsswd = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _psswdCtrl = TextEditingController();
  final Map<String, String> _credentials = { 'email': '', 'password': '' };

  String? _validateEmail(String? email) {
    if(email != null) {
      if(email.isEmpty) {
        return 'El ingreso del correo electrónico es obligatorio.';        
      }
      else if (!EmailValidator.validate(email)) {
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
      if(passwd.isEmpty) return 'El ingreso de la contraseña es obligatorio.';
      
      return null;
    }
    else {
      return 'El ingreso de la contraseña es obligatorio.';
    }
  }

  void _submit() async {
    final form = _formKey.currentState;

    if(form == null || !form.validate()) return;

    setState(() { _isLoading = true; });
    form.save();

    LoginForm.logger.d('email: ${_credentials['email']} psswd: ${_credentials['password']}');

    await context.read<LoginCubit>().login(_credentials['email']!, _credentials['password']!);
    setState(() { _isLoading = false; });
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
        else if(state.status == LoginStatus.failure) {
          ItpsmUtils.showAlertDialog(state.failure!.cause, const Icon(Icons.error), context);
        }
      },
      child: _isLoading ?
        const Padding(padding: EdgeInsets.all(15), child: CircularProgressIndicator())
        : ConstrainedBox(
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
                        obscureText: !_showPassword,
                        autocorrect: false,
                        controller: _psswdCtrl,
                        focusNode: _focusPsswd,
                        enableSuggestions: false,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Contraseña',
                          labelText: 'Contraseña',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() { _showPassword = !_showPassword; });
                            }, 
                            icon: _showPassword ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility), 
                          ),
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
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: TextButton(onPressed: () {}, child: const Text('¿Olvidaste tu contraseña?'))
                    // ),
                    const SizedBox(height: 20),
                    FilledButton(
                      onPressed: () {
                        _submit();
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
