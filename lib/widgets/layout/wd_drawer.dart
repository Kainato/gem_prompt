import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:prompt_app/enum/pages_enum.dart';
import 'package:prompt_app/extensions/context_extensions.dart';

import '../../main.dart';

class WdDrawer extends Drawer {
  const WdDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        spacing: 8.0,
        children: <Widget>[
          DrawerHeader(
            margin: EdgeInsets.all(0.0),
            padding: EdgeInsets.all(20.0),
            curve: Curves.bounceInOut,
            decoration: BoxDecoration(color: context.primaryColor),
            child: Center(
              child: AutoSizeText(
                'Gerador de Prompts IA',
                style: TextStyle(color: context.onPrimaryColor, fontSize: 24),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: PagesEnum.values.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8.0),
              itemBuilder: (context, index) {
                final page = PagesEnum.values[index];
                return ListTile(
                  style: ListTileStyle.drawer,
                  leading: Icon(page.icon),
                  title: Text(page.title),
                  selected: ModalRoute.of(context)?.settings.name == page.route,
                  onTap: () {
                    if (ModalRoute.of(context)?.settings.name != page.route) {
                      Navigator.pushReplacementNamed(context, page.route);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.0),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: context.dividerColor, width: 1.0),
              ),
            ),
            child: Text(
              'Versão: ${packageInfo.version}+${packageInfo.buildNumber}',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
