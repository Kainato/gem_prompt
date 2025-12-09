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
              prefixIcon: Icon(Icons.email_rounded),
            ),
          ),
          const SizedBox(height: 16.0),
          ValueListenableBuilder(
            valueListenable: loginState.obscureText,
            builder: (context, obscureText, child) => TextFormField(
              decoration: InputDecoration(
                labelText: 'Senha',
                border: const OutlineInputBorder(),
                prefixIcon: Icon(Icons.password_rounded),
                suffixIcon: IconButton(
                  onPressed: () => loginState.toggleObscureText(),
                  icon: Icon(
                    !obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ),
              obscureText: obscureText,
            ),
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () => loginState.login(),
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () => loginState.register(context),
            child: const Text('Registrar-se'),
          ),
        ],
      ),
    );
  }
}
