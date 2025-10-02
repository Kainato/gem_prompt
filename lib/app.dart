import 'package:flutter/material.dart';
import 'package:prompt_app/enum/pages_enum.dart';

import 'features/home/home_page.dart';
import 'features/settings/settings_page.dart';

class PromptApp extends StatelessWidget {
  const PromptApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerador de Prompts',
      initialRoute: PagesEnum.home.route,
      theme: ThemeData(primaryColor: Colors.purple, useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      routes: {
        PagesEnum.home.route: (context) => const HomePage(),
        PagesEnum.settings.route: (context) => const SettingsPage(),
      },
      home: const HomePage(),
    );
  }
}
