import 'package:flutter/material.dart';

enum PagesEnum {
  home,
  settings,
}

extension PagesEnumExtension on PagesEnum {
  String get title {
    switch (this) {
      case PagesEnum.home:
        return 'Página inicial';
      case PagesEnum.settings:
        return 'Configurações';
    }
  }

  IconData get icon {
    switch (this) {
      case PagesEnum.home:
        return Icons.home;
      case PagesEnum.settings:
        return Icons.settings;
    }
  }

  String get route {
    switch (this) {
      case PagesEnum.home:
        return '/home';
      case PagesEnum.settings:
        return '/settings';
    }
  }
}