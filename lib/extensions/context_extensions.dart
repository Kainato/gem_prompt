import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  String get currentRoute {
    return ModalRoute.of(this)?.settings.name ?? '';
  }
  Color get primaryColor {
    return Theme.of(this).colorScheme.primary;
  }
  Color get onPrimaryColor {
    return Theme.of(this).colorScheme.onPrimary;
  }
}
