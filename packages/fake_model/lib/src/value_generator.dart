import 'dart:math';

final Map<String, int> _strPropertyNameCnt = {};

final Random _r = Random();

bool boolGenerator() => _r.nextBool();

int intGenerator({required num minValue, required num maxValue}) {
  final baseValue = (maxValue - minValue).toInt();
  return _r.nextInt(baseValue) + minValue.toInt();
}

double doubleGenerator({required num minValue, required num maxValue}) {
  final baseValue = (maxValue - minValue).toDouble();
  return _r.nextDouble() * baseValue + minValue;
}

num numGenerator({required num minValue, required num maxValue}) {
  // feed int or double
  return _r.nextBool()
      ? intGenerator(
          minValue: minValue.toInt(),
          maxValue: maxValue.toInt(),
        )
      : doubleGenerator(
          minValue: minValue.toDouble(),
          maxValue: maxValue.toDouble(),
        );
}

String stringGenerator(
  String prefix,
  String propertyName,
) {
  var key = '${prefix}_$propertyName';
  var cnt = (_strPropertyNameCnt[key] ?? 0) + 1;
  _strPropertyNameCnt[key] = cnt;
  return '\'${prefix}_'
      '${propertyName.isNotEmpty ? '${propertyName}_' : ''}$cnt\'';
}

T enumGenerator<T>(List<T> values) {
  var size = values.length;
  var index = _r.nextInt(size);
  return values[index];
}
