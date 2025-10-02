enum PagesEnum {
  home,
  settings,
}

extension PagesEnumExtension on PagesEnum {
  String get title {
    switch (this) {
      case PagesEnum.home:
        return 'Página inicial';
      case PagesEnum.settings:
        return 'Configurações';
    }
  }
}