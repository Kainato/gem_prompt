import 'package:flutter/material.dart';
import 'package:prompt_app/enum/pages_enum.dart';
import 'package:prompt_app/widgets/layout/wd_scaffold.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WdScaffold(
      title: PagesEnum.settings.title,
      body: Center(child: Text("Configurações")),
    );
  }
}
