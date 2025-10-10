import 'package:flutter/material.dart';
import 'package:prompt_app/enum/pages_enum.dart';

import 'features/home/home_page.dart';

class PromptApp extends StatelessWidget {
  const PromptApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerador de Prompts',
      initialRoute: PagesEnum.home.routesPages.$1,
      theme: ThemeData(primaryColor: Colors.purple, useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      routes: {
        for (PagesEnum page in PagesEnum.values)
          page.routesPages.$1: (context) => page.routesPages.$2,
      },
      home: const HomePage(),
    );
  }
}
