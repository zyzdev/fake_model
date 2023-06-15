import 'dart:math';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:fake_model/src/fake_annotation/helper/fake_config_helper.dart';

import 'package:fake_model/src/util.dart';

import 'generator.dart';

class GeneratorConst extends Generator {

  @override
  Object? genParameterValue(DartType type, FakeValueConfig valueConfig,
      [String prefix = '', String propertyName = '']) {
    if (valueConfig.defaultValue != null) return valueConfig.defaultValue;
    var value = '';
    if (isUnsupportedType(type)) {
      return value;
    }

    var isCustomizeClass = type is InterfaceType ? isCustomClass(type.constructors) : false;
    var isCustomizeEnum = type is InterfaceType ? isCustomEnum(type) : false;

    if (type.nullabilitySuffix == NullabilitySuffix.question) {
      var nullValue = Random().nextBool() == true;
      if (nullValue) return null;
    }
    if (isCustomizeEnum) {
      // enum
      var enumElement = type.element.declaration as EnumElement;
      var enumMember = enumElement.fields.where((element) => !element.type.isDartCoreList).toList();
      var size = enumMember.length;
      var index = Random().nextInt(size);
      value = '${enumElement.name}.${enumMember[index].name}';
    } else if (isCustomizeClass) {
      // enum
      var constructorElement = type.constructors.firstWhere((element) => element.name.isEmpty);
      value = genConstructorElement(constructorElement, '$prefix${propertyName.isNotEmpty ? '_$propertyName' : ''}');
    } else if (type.isDartCoreBool) {
      // boolean
      value = '${Random().nextBool()}';
    } else if (type.isDartCoreInt) {
      // integer
      final maxValue = max(valueConfig.minValue, valueConfig.maxValue).toInt();
      final minValue = min(valueConfig.minValue, valueConfig.maxValue).toInt();
      final baseValue = maxValue - minValue;
      value = '${Random().nextInt(baseValue) + minValue}';
    } else if (type.isDartCoreDouble) {
      // double
      final maxValue = max(valueConfig.minValue, valueConfig.maxValue).toDouble();
      final minValue = min(valueConfig.minValue, valueConfig.maxValue).toDouble();
      final baseValue = maxValue - minValue;
      value = '${Random().nextDouble() * baseValue + minValue}';
    } else if (type.isDartCoreNum) {
      final maxValue = max(valueConfig.minValue, valueConfig.maxValue).toDouble();
      final minValue = min(valueConfig.minValue, valueConfig.maxValue).toDouble();
      final baseValue = maxValue - minValue;
      // num
      var r = Random();
      // feed int or double
      r.nextBool()
          ? value = '${r.nextInt(baseValue.toInt()) + minValue}'
          : value = '${r.nextDouble() * baseValue.toDouble() + minValue}';
    } else if (type.isDartCoreString) {
      var key = '${prefix}_$propertyName';
      var cnt = (Generator.strPropertyNameCnt[key] ?? 0) + 1;
      // string
      value = '\'${prefix}_'
          '${propertyName.isNotEmpty ? '${propertyName}_' : ''}$cnt\'';
      Generator.strPropertyNameCnt[key] = cnt;
    } else if (type.isDartCoreIterable || type.isDartCoreList || type.isDartCoreSet) {
      var typeArguments = (type as InterfaceType).typeArguments;
      var values = List.generate(valueConfig.itemSize,
          (index) => genParameterValue(typeArguments[0], valueConfig, prefix, propertyName));
      value = type.isDartCoreSet ? '${values.toSet()}' : '$values';
    } else if (type.isDartCoreMap) {
      var typeArguments = (type as InterfaceType).typeArguments;
      value = List.generate(valueConfig.itemSize, (index) {
        var keyAndValue = typeArguments.map(
          (e) => genParameterValue(e, valueConfig, prefix, propertyName),
        );
        return MapEntry(keyAndValue.elementAt(0), keyAndValue.elementAt(1));
      }).fold({}, (previousValue, element) {
        previousValue[element.key] = element.value;
        return previousValue;
      }).toString();
    }
    return value;
  }
}
