/// Code was generate by [fake_model](https://pub.dev/packages/fake_model)

part of 'example.dart';

// ==========================================================================
// Class: PersonalInfo
// Model type: final model
// ==========================================================================
final _fakePersonalInfo = PersonalInfo(
  name: 'Jerry',
  married: false,
  age: -40,
  height: null,
  weight: 1791.0,
  gender: Gender.male,
  friends: [
    'PersonalInfo_friends_1',
    'PersonalInfo_friends_2',
    'PersonalInfo_friends_3'
  ],
  bankAccounts: {
    'PersonalInfo_bankAccounts_1': Bank(
      6576,
    ),
    'PersonalInfo_bankAccounts_2': Bank(
      4033,
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
