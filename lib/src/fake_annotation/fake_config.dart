import 'package:meta/meta_meta.dart';

/// This is an annotation for [fake_model] to specify a property generating configuration.
@Target({TargetKind.field})
class FakeConfig {
  const FakeConfig({
    this.defaultValue,
    this.minValue = 0,
    this.maxValue = 10000.0,
    this.itemSize = 1,
  });

  /// Define the property value, null to generate value randomly.
  final Object? defaultValue;

  /// Define min value for [num] type property.
  /// By default, 0.
  final num minValue;

  /// Define max value for [num] type property.
  /// By default, 10000.
  final num maxValue;

  /// Define item size for [List] or [Map]  type property.
  /// By default, 1.
  final int itemSize;

  @override
  String toString() {
    return 'FakeConfig{defaultValue: $defaultValue, minValue: $minValue, maxValue: $maxValue, itemSize: $itemSize}';
  }
}