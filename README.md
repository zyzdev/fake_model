## Features

Provides [dart build system] builder to generate `fake model generation function` for model class.

Annotation [`FakeModel`] and [`FakeConfig`] defined builder to find which model class you want to
generate `fake model generation function` and
generation configuration of property value.

* To decide the model class you want to generate `fake model generation function`, you should annotate it
  with [`FakeModel`].


* To generate a class model property, you can annotate it with [`FakeConfig`] to config the value generation rule.

## Usage

More info see [example].

Assume there has a model class `Info` written in `info.dart` with annotation [`FakeModel`]:

```dart
import 'package:fake_model/fake_model.dart';

part 'info.fake.dart';

@FakeModel()
class Info {

  Info(this.age, this.name);

  final int age;
  final String name;

  /// Add named factory `fromFake` to connect the generated `fake model generation function` [_$InfoFromFake()].
  factory Info.fromFake() => _$InfoFromFake();
}
```

Builder generate a part code file was named `info.fake.dart`:

```dart
part of 'info.dart';


Info _$InfoFromFake() =>
    Info(
      intGenerator(minValue: 0, maxValue: 10000.0),
      stringGenerator('Info', 'name'),
    );
```

## Generating code

Same as other code generation package.

To generate code for Dart project, run below command in package folder.

```shell
cd $YOUR_PROJECT_ROOT_PATH

dart run build_runner build
```

To generate code for Flutter project, run below command in package folder.

```shell
cd $YOUR_PROJECT_ROOT_PATH

flutter pub run build_runner build
```

## Property supported types

[`bool`], [`double`], [`Enum`], [`int`], [`Iterable`], [`List`], [`Map`], [`num`], [`Object`], [`Set`], [`String`]

## Default property value generation rules

Following table shows the value generation rule for supported types. You can change the rule by annotate property
with [`FakeConfig`].

| Type         | Rule                                                                                              |
|--------------|---------------------------------------------------------------------------------------------------|
| [`bool`]     | true / false                                                                                      |
| [`num`]      | random value, 0 - 10000                                                                           |
| [`int`]      | random value, 0 - 10000                                                                           |
| [`double`]   | random value, 0 - 10000                                                                           |
| [`Enum`]     | randomly choose one of the types in the enum                                                      |
| [`String`]   | generate string by format '${class name}\_${property name}\_${generation count of this property}' |
| [`Iterable`] | generate one item only                                                                            |
| [`List`]     | generate one item only                                                                            |
| [`Set`]      | generate one item only                                                                            |
| [`Map`]      | generate one item only                                                                            |

## Custom property value generation rule

More info see [example].

### @FakeModel
By default, the `fake model generation function` return fake model with difference value of property(s) called each
time.

Set `@FakeModel(randomValue: false)` let builder to generates final variable for `fake model generation function` to
return the fake model.
To change the return value, run [Generating code](#Generating-code) to let builder to generates code again.

See difference of `fake model generation function` shown below:

By default, `@FakeModel(randomValue: true)`:

```dart
// property value was regenerated different values each time 
Info _$InfoFromFake() =>
    Info(
      age: 18,
      chanceOfRain: doubleGenerator(minValue: 50, maxValue: 100),
      friends: [
        stringGenerator('Info', 'friends'),
        stringGenerator('Info', 'friends'),
        stringGenerator('Info', 'friends')
      ],
    );
```

When `@FakeModel(randomValue: false)`:

```dart
// always return final variable, the property value never change
final _fake_Info_model = Info(
  age: 18,
  chanceOfRain: 57.415846441589835,
  friends: ['Info_friends_1', 'Info_friends_2', 'Info_friends_3'],
);

Info _$InfoFromFake() => _fake_Info_model;
```
### @FakeConfig
To design the property generation rule, you can annotate property with [`FakeConfig`].

```dart
import 'package:fake_model/fake_model.dart';

part 'info.fake.dart';

@FakeModel()
class Info {
  Info({required this.age, required this.chanceOfRain, required this.friends});

  /// age always 18
  @FakeConfig(defaultValue: 18)
  final int age;

  /// value between 50 to 100
  @FakeConfig(minValue: 50, maxValue: 100)
  final double chanceOfRain;

  /// Generate 10 item
  @FakeConfig(itemSize: 3)
  final List<String> friends;

  factory Info.fromFake() => _$InfoFromFake();
}
```

`fake model generation function` shown below:

```dart
Info _$InfoFromFake() =>
    Info(
      age: 18,
      chanceOfRain: doubleGenerator(minValue: 50, maxValue: 100),
      friends: [
        stringGenerator('Info', 'friends'),
        stringGenerator('Info', 'friends'),
        stringGenerator('Info', 'friends')
      ],
    );
```

[example]: https://github.com/zyzdev/fake_model/tree/main/example

[dart build system]: https://github.com/dart-lang/build

[`FakeModel`]: https://pub.dev/documentation/fake_model/latest/fake_model/FakeModel-class.html

[`FakeConfig`]: https://pub.dev/documentation/fake_model/latest/fake_model/FakeConfig-class.html

[`bool`]: https://api.dart.dev/stable/dart-core/bool-class.html

[`double`]: https://api.dart.dev/stable/dart-core/double-class.html

[`Enum`]: https://api.dart.dev/stable/dart-core/Enum-class.html

[`int`]: https://api.dart.dev/stable/dart-core/int-class.html

[`Iterable`]: https://api.dart.dev/stable/dart-core/Iterable-class.html

[`List`]: https://api.dart.dev/stable/dart-core/List-class.html

[`Map`]: https://api.dart.dev/stable/dart-core/Map-class.html

[`num`]: https://api.dart.dev/stable/dart-core/num-class.html

[`Object`]: https://api.dart.dev/stable/dart-core/Object-class.html

[`Set`]: https://api.dart.dev/stable/dart-core/Set-class.html

[`String`]: https://api.dart.dev/stable/dart-core/String-class.html