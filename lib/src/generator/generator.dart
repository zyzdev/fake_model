import 'dart:math';
import 'dart:mirrors';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:dart_style/dart_style.dart';
import 'package:fake_model/src/fake_annotation/fake_config.dart';
import 'package:fake_model/src/fake_annotation/fake_model.dart';
import 'package:fake_model/src/fake_annotation/helper/fake_config_helper.dart';
import 'package:fake_model/src/fake_annotation/helper/fake_model_helper.dart';
import 'package:fake_model/src/generator/generator_random.dart';

import 'generator_final.dart';

abstract class Generator {
  static const defConfig = FakeValueConfig();
  static Map<String, int> strPropertyNameCnt = {};

  static final Map<String, Map<String, FakeValueConfig>> _allFakeValueConfig =
      {};

  static void cleanPropertyNameCnt() => strPropertyNameCnt.clear();

  static GeneratorRandom? _generatorRandom;
  static GeneratorConst? _generatorConst;

  static Future<void> findAllValueConfig(LibraryElement entryLib) async {
    for (var element in entryLib.children) {
      for (var element in element.children) {
        if (element is ClassElement) {
          _allFakeValueConfig[element.name] = _valueConfigMap(element.fields);
        }
      }
    }
  }

  static Generator _generatorSelector(bool randomValue) => randomValue
      ? _generatorRandom ??= GeneratorRandom()
      : _generatorConst ??= GeneratorConst();

  static String startGen(List<ClassElement> classElements) {
    return classElements.fold('', (previousValue, element) {
      final index = element.metadata.indexWhere((annotation) {
        return annotation.element?.librarySource?.uri ==
            (reflectClass(FakeModel).owner as LibraryMirror).uri;
        //return annotation.element?.displayName == "FakeModel";
      });
      final withAnnotation = index > -1;
      if (!withAnnotation) return previousValue;
      ElementAnnotation elementAnnotation = element.metadata[index];
      final fakeModelConfig = toFakeModelConfig(elementAnnotation);
      final randomValue = fakeModelConfig.randomValue;
      final code = _generatorSelector(randomValue)
          .genFakeModelCode(classElements, randomValue);
      previousValue = '$previousValue\n$code';
      return previousValue;
    });
  }

  String genFakeModelCode(List<ClassElement> classElements, bool randomValue) {
    final codeOutput = classElements.fold('', (previousValue, element) {
      cleanPropertyNameCnt();
      if (element.unnamedConstructor == null) return previousValue;
      return '''
        $previousValue
        ${_wrapToFakeFunction(element, genClassElement(element), randomValue)}
        ''';
    });
    return DartFormatter().format(codeOutput);
  }

  String _wrapToFakeFunction(
      ClassElement element, String code, bool randomValue) {
    final name = element.displayName;
    if (!randomValue) {
      final valueName = '_fake_${name}_model';
      final finalValue = 'final $valueName = $code;';
      return '$finalValue \n$name _\$${name}FromFake() => $valueName;';
    } else {
      return '$name _\$${name}FromFake() => $code;';
    }
  }

  String genClassElement(ClassElement classElement, [String prefix = '']) {
    final className = classElement.displayName;

    final annotationMap = _allFakeValueConfig[className];
    final classString = classElement.unnamedConstructor!.parameters.fold('',
        (previousValue, element) {
      final nextParameter = genParameterElement(
        element,
        prefix.isNotEmpty ? '${prefix}_$className' : className,
        annotationMap?[element.name] ?? defConfig,
      );
      if (nextParameter.isEmpty) return previousValue;
      return '$previousValue \n $nextParameter,';
    });

    return '$className($classString)';
  }

  String genConstructorElement(ConstructorElement element,
      [String prefix = '']) {
    final className = element.displayName;
    final annotationMap = _allFakeValueConfig[className];
    final constructorString =
        element.parameters.fold('', (previousValue, element) {
      final nextParameter = genParameterElement(
        element,
        prefix.isNotEmpty ? '${prefix}_$className' : className,
        annotationMap?[element.name] ?? defConfig,
      );
      if (nextParameter.isEmpty) return previousValue;
      return '$previousValue \n $nextParameter,';
    });

    return '$className($constructorString)';
  }

  String genParameterElement(
      ParameterElement element, String prefix, FakeValueConfig fakeConfig) {
    final type = element.type;
    final propertyName = element.name;
    if (element.isOptional) {
      var feedParameter = Random().nextBool() == true;
      if (!feedParameter) return '';
    }
    var parameterString =
        '${genParameterValue(type, fakeConfig, prefix, propertyName)}';
    if (element.isRequiredNamed) {
      parameterString = '$propertyName: $parameterString';
    }
    return parameterString;
  }

  Object? genParameterValue(DartType type, FakeValueConfig valueConfig,
      [String prefix = '', String propertyName = '']);

  bool isUnsupportedType(DartType type) {
    return type.isDartAsyncFuture ||
        type.isDartAsyncFutureOr ||
        type.isDartCoreFunction ||
        type.isDartAsyncStream;
  }

  static Map<String, FakeValueConfig> _valueConfigMap(
      List<FieldElement> fields) {
    return fields.fold(<String, FakeValueConfig>{}, (previousValue, element) {
      final fieldName = element.name;

      // find @FakeConfig
      final annotationIndex = element.metadata.indexWhere((elementAnnotation) {
        return elementAnnotation.element?.librarySource?.uri ==
            (reflectClass(FakeConfig).owner as LibraryMirror).uri;
        //return elementAnnotation.element?.displayName == "FakeConfig";
      });
      if (annotationIndex > -1) {
        final annotation = element.metadata[annotationIndex];
        previousValue[fieldName] = _dartObjectToFakeConfig(annotation);
      }
      return previousValue;
    });
  }

  static FakeValueConfig _dartObjectToFakeConfig(
      ElementAnnotation elementAnnotation) {
    final dartObject = elementAnnotation.computeConstantValue();
    String? defaultValue;
    var minValue = defConfig.minValue;
    var maxValue = defConfig.maxValue;
    var itemSize = defConfig.itemSize;
    for (var param
        in (elementAnnotation.element as ConstructorElement).parameters) {
      var name = param.name;
      var fieldDartObject = dartObject?.getField(name);
      switch (name) {
        case 'defaultValue':
          if (!fieldDartObject!.isNull) {
            defaultValue = FakeConfigHelper.defaultValueHelper(fieldDartObject);
          }
          break;
        case 'minValue':
          var value =
              fieldDartObject?.toIntValue() ?? fieldDartObject?.toDoubleValue();
          if (value != null) minValue = value;
          break;
        case 'maxValue':
          var value =
              fieldDartObject?.toIntValue() ?? fieldDartObject?.toDoubleValue();
          if (value != null) maxValue = value;
          break;
        case 'itemSize':
          var value = fieldDartObject?.toIntValue();
          if (value != null) itemSize = value;
          break;
      }
    }

    return FakeValueConfig(
      defaultValue: defaultValue,
      minValue: minValue,
      maxValue: maxValue,
      itemSize: itemSize,
    );
  }
}
