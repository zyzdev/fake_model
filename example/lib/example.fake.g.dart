/// Code was generate by [fake_model](https://pub.dev/packages/fake_model)

part of 'example.dart';


PersonalInfo _$PersonalInfoFromFake() => PersonalInfo(
      name: 'Jerry',
      married: boolGenerator(),
      age: intGenerator(minValue: -100, maxValue: 100),
      height: doubleGenerator(minValue: 0, maxValue: 10000.0),
      weight: numGenerator(minValue: 0, maxValue: 10000.0),
      gender: enumGenerator<Gender>(Gender.values),
      friends: [
        stringGenerator('PersonalInfo', 'friends'),
        stringGenerator('PersonalInfo', 'friends'),
        stringGenerator('PersonalInfo', 'friends')
      ],
      bankAccounts: {
        stringGenerator('PersonalInfo', 'bankAccounts'): Bank(
          intGenerator(minValue: 0, maxValue: 10000.0),
        )
      },
      secretInfo: SecretInfo(
        realAge: 18,
        realHeight: 190.0,
        realWeight: 70,
        lover: 'fake_model',
      ),
    );
