import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 240,
        maxWidth: 380,
      ),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Correo electónico',
                    border: OutlineInputBorder(),
                    hintText: 'Correo electónico'
                  )
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(),
                    hintText: 'Contraseña',
                    suffixIcon: Icon(Icons.remove_red_eye)
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(onPressed: () {}, child: const Text('¿Olvidaste tu contraseña?'))
              ),
              FilledButton(
                onPressed: () {},
                child: const Text('Iniciar sesión'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
