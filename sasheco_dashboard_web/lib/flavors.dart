enum Flavor {
  development,
  production,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.development:
        return 'Sasheco Dev';
      case Flavor.production:
        return 'Sasheco';
      default:
        return 'title';
    }
  }

  static String get apiBaseUrl {
    switch (appFlavor) {
      case Flavor.development:
        return 'http://localhost:5191/';
      case Flavor.production:
        return 'https://api.sasheco.com/';
      default:
        return 'http://localhost:5191/';
    }
  }
}
