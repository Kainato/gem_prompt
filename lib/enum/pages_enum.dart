import 'package:flutter/material.dart';

import '../features/home/home_page.dart';
import '../features/settings/settings_page.dart';
import '../features/task_creator/task_creator_page.dart';

enum PagesEnum { home, task, settings }

extension PagesEnumExtension on PagesEnum {
  String get title {
    switch (this) {
      case PagesEnum.home:
        return 'Página inicial';
      case PagesEnum.task:
        return 'Reformulador de "Tasks"';
      case PagesEnum.settings:
        return 'Configurações';
    }
  }

  IconData get icon {
    switch (this) {
      case PagesEnum.home:
        return Icons.home;
      case PagesEnum.task:
        return Icons.task;
      case PagesEnum.settings:
        return Icons.settings;
    }
  }

  (String, Widget) get routesPages {
    switch (this) {
      case PagesEnum.home:
        return ('/home', const HomePage());
      case PagesEnum.task:
        return ('/task', const TaskCreatorPage());
      case PagesEnum.settings:
        return ('/settings', const SettingsPage());
    }
  }
}
