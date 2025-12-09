import 'package:flutter/material.dart';
import 'package:prompt_app/features/auth/login/login_state.dart';

import '../../../widgets/layout/wd_scaffold.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    LoginState loginState = LoginState();
    return WdScaffold(
      title: 'Página de acesso',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16.0),
          ValueListenableBuilder(
            valueListenable: loginState.obscureText,
            builder: (context, obscureText, child) => TextFormField(
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
              obscureText: obscureText,
            ),
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () {
              // Lógica de login aqui
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              // Lógica de registro aqui
            },
            child: const Text('Registrar-se'),
          ),
        ],
      ),
    );
  }
}
