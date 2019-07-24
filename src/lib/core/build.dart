class Build {
  static Environment environment = Environment.Production;

  static bool get inProduction => environment == Environment.Production;

  static bool get inDevelopment => environment == Environment.Development;
}

enum Environment { Production, Development }
