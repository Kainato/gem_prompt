import 'package:flutter/material.dart';

import '../features/home/home_page.dart';
import '../features/padrao/prompt_padrao_page.dart';
import '../features/settings/settings_page.dart';
import '../features/task_creator/task_creator_page.dart';
import '../features/screenshot_assistant/screenshot_assistant_page.dart';

enum PagesEnum { home, padrao, task, screenshotAssistant, settings }

extension PagesEnumExtension on PagesEnum {
  String get title {
    switch (this) {
      case PagesEnum.home:
        return 'Página inicial';
      case PagesEnum.padrao:
        return 'Prompt Padrão';
      case PagesEnum.task:
        return 'Reformulador de "Tasks"';
      case PagesEnum.screenshotAssistant:
        return 'Screenshot Assistant';
      case PagesEnum.settings:
        return 'Configurações';
    }
  }

  IconData get icon {
    switch (this) {
      case PagesEnum.home:
        return Icons.home;
      case PagesEnum.padrao:
        return Icons.text_fields;
      case PagesEnum.task:
        return Icons.task;
      case PagesEnum.screenshotAssistant:
        return Icons.screenshot;
      case PagesEnum.settings:
        return Icons.settings;
    }
  }

  (String, Widget) get routesPages {
    switch (this) {
      case PagesEnum.home:
        return ('/home', const HomePage());
      case PagesEnum.padrao:
        return ('/padrao', const PromptPadraoPage());
      case PagesEnum.task:
        return ('/task', const TaskCreatorPage());
      case PagesEnum.screenshotAssistant:
        return ('/screenshot-assistant', const ScreenshotAssistantPage());
      case PagesEnum.settings:
        return ('/settings', const SettingsPage());
    }
  }

  bool get homeVisible {
    switch (this) {
      case PagesEnum.home:
        return false;
      case PagesEnum.padrao:
        return true;
      case PagesEnum.task:
        return true;
      case PagesEnum.screenshotAssistant:
        return true;
      case PagesEnum.settings:
        return true;
    }
  }
}
