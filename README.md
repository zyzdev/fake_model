## Features

Provides [dart build system] builder to generate `fake model generative function` for model class.

Annotation [`FakeModel`] and [`FakeConfig`] defined builder to find which model class you want to
generate `fake model generative function` and
generating configuration of property value.

* To decide the model class you want to generate `fake model generative function`, you should annotate it
  with [`FakeModel`].


* To generate a class model property, you can annotate it with [`FakeConfig`] to config the value generating rule.

## Usage

Assume there has a model class `Info` written in `info.dart` with annotation [`FakeModel`]:

```dart
import 'package:fake_model/fake_model.dart';

part 'info.fake.g.dart';

@FakeModel()
class Info {

  Info(this.age, this.name);

  final int age;
  final String name;

  /// Add named factory `fromFake` to connect the generated `fake model generative function` [_$InfoFromFake()].
  factory Info.fromFake() => _$InfoFromFake();
}
```

Builder generate a part code file was named `info.fake.g.dart`:

```dart
part of 'info.dart';


Info _$InfoFromFake() =>
    Info(
      intGenerator(minValue: 0, maxValue: 10000.0),
      stringGenerator('Info', 'name'),
    );
```

## Generating code

Same as other code generating package.

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

## Property generating rule

Following table shows the value generating rule for supported types.

| Type         | Rule                                                                                                   |
|--------------|--------------------------------------------------------------------------------------------------------|
| [`bool`]     | true / false                                                                                           |
| [`num`]      | value in 0 ~ 10000                                                                                     |
| [`int`]      | value in 0 ~ 10000                                                                                     |
| [`double`]   | value in 0 ~ 10000                                                                                     |
| [`Enum`]     | selected type in the enum randomly                                                                     |
| [`String`]   | generate string by format '${class name}\_${property name}\_${generating count of this property}'<br/> |
| [`Iterable`] | generate one item only                                                                                 |
| [`List`]     | generate one item only                                                                                 |
| [`Set`]      | generate one item only                                                                                 |
| [`Map`]      | generate one item only                                                                                 |

## Property supported types

[`bool`], [`double`], [`Enum`], [`int`], [`Iterable`], [`List`], [`Map`], [`num`], [`Object`], [`Set`], [`String`]

Also supported property type is model class.

For example, `Data1` with property `a` that type `Data2`, `Data2` is a model class.

```dart
@FakeModel()
class Data1 {
  final Data2 data;

  Data2(this.data);

  factory Data1.fromFake() => _$Data1FromFake();
}

class Data2 {
  int a;

  Data2(this.a);
}
```

## Config property generating rule

More info see [example].

By default, the `fake model generative function` return difference value of model property called each time.

Set `@FakeModel(randomValue: false)` let builder to generates final value for `fake model generative function`. It means
the return value of `fake model generative function` always be a final value never change. To change the return value,
run [Generating code](#Generating-code) to let builder to generates code again.

See difference of `fake model generative function` shown below:

By default, `@FakeModel(randomValue: true)`:
```dart
Info _$InfoFromFake() => Info(
  age: 18,
  chanceOfRain: doubleGenerator(minValue: 50, maxValue: 100),
  friends: [
    stringGenerator('Info', 'friends'),
    stringGenerator('Info', 'friends'),
    stringGenerator('Info', 'friends')
  ],
);
```
`@FakeModel(randomValue: false)`:
```dart
final _fake_Info_model = Info(
  age: 18,
  chanceOfRain: 57.415846441589835,
  friends: ['Info_friends_1', 'Info_friends_2', 'Info_friends_3'],
);
Info _$InfoFromFake() => _fake_Info_model;
```
To design the property generating rule, you can annotate property with [`FakeConfig`].
```dart
import 'package:fake_model/fake_model.dart';

part 'info.fake.g.dart';

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
`fake model generative function` shown below:
```dart
Info _$InfoFromFake() => Info(
      age: 18,
      chanceOfRain: doubleGenerator(minValue: 50, maxValue: 100),
      friends: [
        stringGenerator('Info', 'friends'),
        stringGenerator('Info', 'friends'),
        stringGenerator('Info', 'friends')
      ],
    );
```

[example]: https://github.com/google/json_serializable.dart/tree/master/example

[dart build system]: https://github.com/dart-lang/build

[`FakeModel`]: https://pub.dev/documentation/json_annotation/4.8.1/json_annotation/JsonSerializable-class.html

[`FakeConfig`]: https://pub.dev/documentation/json_annotation/4.8.1/json_annotation/JsonSerializable-class.html

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