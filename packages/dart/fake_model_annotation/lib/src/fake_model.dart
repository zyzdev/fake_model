import 'package:meta/meta_meta.dart';

/// This is an annotation for [fake_model](https://pub.dev/packages/fake_model) to specify a class to generate code for.
@Target({TargetKind.classType})
class FakeModel {
  const FakeModel({this.randomValue = true});

  /// Decide `fake model generation function` will return `final model` or `new instance model`.
  /// The property value of `final model` was decided once when 'fake model generation function' was generated,
  /// it means call `Model.fromFake()` will get same result each time.
  /// The property value of `new instance model` will generate randomly,
  /// it means call `Model.fromFake()` will get different result each time,
  /// except you annotating property with [FakeConfig.defaultValue].
  final bool randomValue;
}
