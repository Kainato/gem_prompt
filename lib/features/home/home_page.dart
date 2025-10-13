import 'package:flutter/material.dart';

import '../../enum/pages_enum.dart';
import '../../widgets/layout/wd_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = 400;
    int crossAxisCount = screenWidth ~/ cardWidth > 0
        ? screenWidth ~/ cardWidth
        : 1;
    double cardHeight = MediaQuery.of(context).size.height / 4;
    List<PagesEnum> visiblePages = PagesEnum.values
        .where((page) => page.homeVisible)
        .toList();
    return WdScaffold(
      title: PagesEnum.home.title,
      body: Column(
        spacing: 16.0,
        children: [
          Text(
            'Bem-vindo ao meu app de prompts com IA!',
            style: TextStyle(fontSize: 18.0),
          ),
          GridView.builder(
            shrinkWrap: true,
            itemCount: visiblePages.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisExtent: cardHeight,
            ),
            itemBuilder: (context, index) {
              String title = visiblePages[index].title;
              IconData icon = visiblePages[index].icon;
              String route = visiblePages[index].routesPages.$1;
              return Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12.0),
                  onTap: () {
                    Navigator.pushNamed(context, route);
                  },
                  child: GridTile(
                    child: Column(
                      spacing: 8.0,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(icon, size: 48.0), Text(title)],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
