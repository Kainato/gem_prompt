import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginState {
  LoginState();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  ValueNotifier<bool> obscureText = ValueNotifier<bool>(true);

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> toggleObscureText() async {
    obscureText.value = !obscureText.value;
  }

  Future<void> login() async {
    // Lógica de autenticação aqui
  }

  Future<void> register(BuildContext context) async {
    // Captura o ScaffoldMessenger sincronamente para evitar usar o BuildContext
    // depois de awaits (evita o problema de usar BuildContext através de gaps async).
    final messenger = ScaffoldMessenger.maybeOf(context);

    try {
      final email = emailController.text.trim();
      final password = passwordController.text;

      // Validação de e-mail mais robusta e sem caracteres inválidos.
      final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
      if (!emailRegex.hasMatch(email)) {
        if (messenger?.mounted ?? false) {
          messenger!.showSnackBar(
            const SnackBar(content: Text("E-mail inválido!")),
          );
        }
        return;
      }

      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        log("Usuário registrado com sucesso!", name: "LoginState.dart");
        if (messenger?.mounted ?? false) {
          messenger!.showSnackBar(
            const SnackBar(content: Text("Usuário registrado com sucesso!")),
          );
        }
      } else {
        log(
          "Erro ao registrar usuário: resposta inesperada.",
          name: "LoginState.dart",
        );
        if (messenger?.mounted ?? false) {
          messenger!.showSnackBar(
            const SnackBar(
              content: Text("Erro ao registrar usuário. Tente novamente."),
            ),
          );
        }
      }
    } catch (e, s) {
      log(
        "Erro ao registrar usuário!",
        name: "LoginState.dart",
        error: e,
        stackTrace: s,
      );
      if (messenger?.mounted ?? false) {
        messenger!.showSnackBar(
          SnackBar(content: Text("Falha ao registrar usuário: $e")),
        );
      }
    }
  }
}
