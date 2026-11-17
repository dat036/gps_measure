enum Flavor {
  dev,
  staging,
  prod
  ;

  static Flavor fromName(String name) => Flavor.values.firstWhere(
    (f) => f.name == name,
    orElse: () => Flavor.dev,
  );

  bool get isProd => this == Flavor.prod;
}
