import 'package:fake_model/fake_model.dart';

/// [fake_model] generated 'part of' file named 'example.fake.dart'.
/// Don't forget adding the part file.
part 'example.fake.dart';

/// [FakeModel.randomValue] to decide the fake model generation function [_$PersonalInfoFromFake]
/// to return `final model` or `new instance model`.
/// The property value of `final model` was decided once when 'example.fake.dart' was generated.
/// The property value of `new instance model` will generate randomly,
/// it means call `PersonalInfo.fromFake()` will get different result each time,
/// except you annotating property with [FakeConfig.defaultValue].
@FakeModel(randomValue: false)
class PersonalInfo {
  PersonalInfo({
    required this.name,
    required this.married,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    required this.friends,
    required this.bankAccounts,
    required this.secretInfo,
  });

  /// By default, create string value by format '${Class.name}_${Property.name}_${}'.
  /// You can feed default value to field.
  @FakeConfig(defaultValue: "Jerry")
  final String name;
  final bool married;

  /// By default, the value generate randomly which the field type is num and the range from 0 - 10000.
  /// You can decide range by feed [FakeConfig.minValue] and [FakeConfig.maxValue]
  @FakeConfig(minValue: -100, maxValue: 100)
  final int age;
  final double? height;
  final num? weight;

  /// Enum
  /// By default, create enum value randomly.
  final Gender gender;

  /// List
  /// By default, the data length of `List` is 1.
  /// You can decide data length by feed [FakeConfig.itemSize]
  @FakeConfig(itemSize: 3)
  final List<String> friends;

  /// Map
  /// By default, the data length of `Map` is 1.
  /// You can decide data length by feed [FakeConfig.itemSize]
  @FakeConfig(itemSize: 2)
  final Map<String, Bank> bankAccounts;

  /// Class
  /// Property type can be class too!
  /// You can feed default value to field or let [fake_model] auto create it.
  @FakeConfig(
    defaultValue: SecretInfo(
      lover: "fake_model",
      realAge: 18,
      realHeight: 190,
      realWeight: 70,
    ),
  )
  final SecretInfo secretInfo;

  /// Call the generated fake model generation function [_$PersonalInfoFromFake].
  /// The format of fake model generation function is '_$[Class Name]FromFake()'.
  factory PersonalInfo.fromFake() => _$PersonalInfoFromFake();

  @override
  String toString() {
    return 'PersonalInfo{name: $name, married: $married, age: $age, height: $height, weight: $weight, gender: $gender, friends: $friends, bankAccounts: $bankAccounts, secretInfo: $secretInfo}';
  }
}

@FakeModel()
class Bank {
  final int money;

  Bank(this.money);

  @override
  String toString() {
    return 'Bank{money: $money}';
  }
}

enum Gender { male, female }

class SecretInfo {
  final int realAge;
  final double realHeight;
  final num realWeight;
  final String lover;

  const SecretInfo({
    required this.realAge,
    required this.realHeight,
    required this.realWeight,
    required this.lover,
  });

  @override
  String toString() {
    return 'SecretInfo{realAge: $realAge, realHeight: $realHeight, realWeight: $realWeight, lover: $lover}';
  }
}

void main() {
  for (int i = 0; i < 10; i++) {
    print(PersonalInfo.fromFake());
  }
}
