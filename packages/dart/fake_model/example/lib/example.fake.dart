/// Code was generate by [fake_model](https://pub.dev/packages/fake_model)

part of 'example.dart';

// ==========================================================================
// Class: PersonalInfo
// Model type: final model
// ==========================================================================
final _fakePersonalInfo = PersonalInfo(
  name: 'Jerry',
  married: true,
  age: -11,
  height: null,
  weight: null,
  gender: Gender.female,
  friends: [
    'PersonalInfo_friends_1',
    'PersonalInfo_friends_2',
    'PersonalInfo_friends_3'
  ],
  bankAccounts: {
    'PersonalInfo_bankAccounts_1': Bank(
      4241,
    ),
    'PersonalInfo_bankAccounts_2': Bank(
      434,
    )
  },
  secretInfo: SecretInfo(
    realAge: 18,
    realHeight: 190.0,
    realWeight: 70,
    lover: 'fake_model',
  ),
);
PersonalInfo _$PersonalInfoFromFake() => _fakePersonalInfo;
// ==========================================================================
// Class: Bank
// Model type: new instance model
// ==========================================================================
Bank _$BankFromFake() => Bank(
      intGenerator(minValue: 0, maxValue: 10000.0),
    );
