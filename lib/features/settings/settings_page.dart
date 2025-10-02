import 'package:flutter/material.dart';
import 'package:prompt_app/enum/pages_enum.dart';
import 'package:prompt_app/widgets/layout/wd_scaffold.dart';

import '../../main.dart';
import '../../services/gemini_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WdScaffold(
      title: PagesEnum.settings.title,
      body: FutureBuilder(
        future: GeminiService.listarModelos(apiKey),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LinearProgressIndicator();
          } else if (snapshot.hasError) {
            return Text("Erro ao carregar modelos");
          } else {
            return DropdownMenu(
              menuHeight: MediaQuery.of(context).size.height * 0.4,
              dropdownMenuEntries: GeminiService.dropdownModelos,
              expandedInsets: EdgeInsets.all(0),
              enableSearch: false,
              enableFilter: false,
              label: Text("Selecione o modelo de IA"),
              controller: GeminiService.selectedModel.$1,
              onSelected: (value) {
                if (value != null) {
                  GeminiService.selectedModel.$2.value = value;
                }
              },
            );
          }
        },
      ),
    );
  }
}
