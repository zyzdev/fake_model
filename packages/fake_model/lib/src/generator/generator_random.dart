import 'dart:math';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:fake_model/src/helper/fake_config_helper.dart';
import 'package:fake_model/src/generator/generator.dart';
import 'package:fake_model/src/util.dart';

class GeneratorRandom extends Generator {
  @override
  Object? genParameterValue(DartType type, FakeValueConfig valueConfig,
      [String prefix = '', String propertyName = '']) {
    if (valueConfig.defaultValue != null) return valueConfig.defaultValue;
    var value = '';
    if (isUnsupportedType(type)) {
      return value;
    }

    final isCustomizeClass =
        type is InterfaceType ? isCustomClass(type.constructors) : false;
    final isCustomizeEnum = type is InterfaceType ? isCustomEnum(type) : false;

    if (type.nullabilitySuffix == NullabilitySuffix.question) {
      final nullValue = Random().nextBool() == true;
      if (nullValue) return null;
    }
    if (isCustomizeEnum) {
      // enum
      final enumElement = type.element.declaration as EnumElement;
      final enumName = enumElement.name;
      value = 'enumGenerator<$enumName>($enumName.values)';
    } else if (isCustomizeClass) {
      // class
      var constructorElement =
          type.constructors.firstWhere((element) => element.name.isEmpty);
      value = genConstructorElement(constructorElement,
          '$prefix${propertyName.isNotEmpty ? '_$propertyName' : ''}');
    } else if (type.isDartCoreBool) {
      // boolean
      value = 'boolGenerator()';
    } else if (type.isDartCoreInt) {
      // integer
      value =
          'intGenerator(minValue:${valueConfig.minValue}, maxValue:${valueConfig.maxValue})';
    } else if (type.isDartCoreDouble) {
      // double
      value =
          'doubleGenerator(minValue:${valueConfig.minValue}, maxValue:${valueConfig.maxValue})';
    } else if (type.isDartCoreNum) {
      value =
          'numGenerator(minValue:${valueConfig.minValue}, maxValue:${valueConfig.maxValue})';
    } else if (type.isDartCoreString) {
      // string
      value = 'stringGenerator(\'$prefix\', \'$propertyName\')';
    } else if (type.isDartCoreIterable ||
        type.isDartCoreList ||
        type.isDartCoreSet) {
      final typeArguments = (type as InterfaceType).typeArguments;
      final values = List.generate(
          valueConfig.itemSize,
          (index) => genParameterValue(
              typeArguments[0], valueConfig, prefix, propertyName));
      value = type.isDartCoreSet ? '${values.toSet()}' : '$values';
    } else if (type.isDartCoreMap) {
      final typeArguments = (type as InterfaceType).typeArguments;
      value = List.generate(valueConfig.itemSize, (index) {
        final keyAndValue = typeArguments.map(
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
