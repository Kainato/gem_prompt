import 'package:flutter/material.dart';

class WdScaffold extends StatelessWidget {
  final Widget body;
  final EdgeInsetsGeometry? padding ;
  final List<Widget>? actions;
  const WdScaffold({super.key, required this.body, this.actions, this.padding});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Gerador de Prompts IA'), actions: actions),
        body: Padding(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: body,
        ),
      ),
    );
  }
}
