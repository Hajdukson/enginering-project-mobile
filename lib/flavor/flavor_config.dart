import 'package:money_manager_mobile/flavor/flavor_values.dart';

class FlavorConfig {
  final FlavorValues values;
  static FlavorConfig? _instance;

  factory FlavorConfig({required FlavorValues values}) {
    _instance = FlavorConfig._interna(values);
    return _instance!;
  }

  FlavorConfig._interna(this.values);

  static FlavorConfig get instance => _instance!;
}