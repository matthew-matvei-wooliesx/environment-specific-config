class Configuration {
  static const multiplier = String.fromEnvironment(
    "multiplier",
    defaultValue: "1",
  );
}
