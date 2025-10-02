import 'package:flutter/material.dart';
import 'package:prompt_app/widgets/layout/wd_drawer.dart';

class WdScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final EdgeInsetsGeometry? padding;
  final List<Widget>? actions;
  const WdScaffold({
    super.key,
    required this.body,
    this.actions,
    this.padding,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: WdDrawer(),
        appBar: AppBar(title: Text(title), actions: actions),
        body: Padding(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: body,
        ),
      ),
    );
  }
}
