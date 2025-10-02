import 'package:flutter/material.dart';

import 'features/home/home_page.dart';

class PromptApp extends StatelessWidget {
  const PromptApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerador de Prompts',
      theme: ThemeData(primarySwatch: Colors.indigo),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: PromptForm(),
    );
  }
}
