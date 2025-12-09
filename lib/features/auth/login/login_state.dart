import 'package:flutter/widgets.dart';

class LoginState {
  LoginState();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  ValueNotifier<bool> obscureText = ValueNotifier<bool>(false);

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}