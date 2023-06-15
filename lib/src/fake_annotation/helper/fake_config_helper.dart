import 'dart:math';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:fake_model/src/util.dart';

class FakeConfigHelper {
  static String defaultValueHelper(DartObject fieldDartObject) {
    var type = fieldDartObject.type!;
    var value = '';
    if (type.isDartCoreBool) {
      // boolean
      value = fieldDartObject.toBoolValue().toString();
    } else if (type.isDartCoreInt) {
      // integer
      value = fieldDartObject.toIntValue().toString();
    } else if (type.isDartCoreDouble) {
      // double
      value = fieldDartObject.toDoubleValue().toString();
    } else if (type.isDartCoreNum) {
      // num
      value = (fieldDartObject.toIntValue() ?? fieldDartObject.toDoubleValue())
          .toString();
    } else if (type.isDartCoreString) {
      // string
      value = '\'${fieldDartObject.toStringValue().toString()}\'';
    } else if (type.isDartCoreIterable || type.isDartCoreList) {
      // list or iterable or set
      value = _genParameterValue(type, fieldDartObject.toString());
    } else if (type.isDartCoreSet){
      // set
      value = _genParameterValue(type, fieldDartObject.toString());
    }else if (type.isDartCoreMap) {
      // map
      value = _genParameterValue(type, fieldDartObject.toMapValue().toString());
      //value = fieldDartObject.toMapValue().toString();
    } else {
      final isCustomizeEnum =
          type is InterfaceType ? isCustomEnum(type) : false;
      final isCustomizeClass =
          type is InterfaceType ? isCustomClass(type.constructors) : false;
      if (isCustomizeEnum || isCustomizeClass) {

        value = _genParameterValue(type, fieldDartObject.toString());
        return value;
      }
      // class
/*      var valueString = fieldDartObject.toString();
      var valueMap = convertConstructorStringToMap(valueString);
      var classElement = fieldDartObject.type?.element as ClassElement;
      var className = classElement.displayName;
      var constructorString = classElement.unnamedConstructor!.parameters.fold('', (previousValue, element) {
        var nextParameter = _genParameterElement(element, valueMap[element.name]!);
        if (nextParameter.isEmpty) return previousValue;
        return '$previousValue \n $nextParameter,';
      });
      value = '$className($constructorString)';*/
    }
    return value;
  }

  static String _genConstructorElement(
      ConstructorElement element, String valueString) {
    var valueMap = convertConstructorStringToMap(valueString);

    var className = element.displayName;
    var constructorString =
        element.parameters.fold('', (previousValue, element) {
      var nextParameter =
          _genParameterElement(element, valueMap[element.name]!);
      if (nextParameter.isEmpty) return previousValue;
      return '$previousValue \n $nextParameter,';
    });

    return '$className($constructorString)';
  }

  static String _genParameterElement(
      ParameterElement element, String valueString) {
    var type = element.type;
    var propertyName = element.name;
    if (element.isOptional) {
      var feedParameter = Random().nextBool() == true;
      if (!feedParameter) return '';
    }
    var parameterString = _genParameterValue(type, valueString);
    if (element.isRequiredNamed) {
      parameterString = '$propertyName: $parameterString';
    }
    return parameterString;
  }

  static String _genParameterValue(DartType type, String valueString) {
    var value = '';

    var isCustomizeClass =
        type is InterfaceType ? isCustomClass(type.constructors) : false;
    var isCustomizeEnum = type is InterfaceType ? isCustomEnum(type) : false;

    if (type.nullabilitySuffix == NullabilitySuffix.question) {}
    if (isCustomizeEnum) {
      // enum
      value = extractEnumValueFromString(valueString);
    } else if (isCustomizeClass) {
      // class
      value = _genConstructorElement(type.constructors[0], valueString);
    } else if (type.isDartCoreBool) {
      // boolean
      value = extractValueFromString(valueString);
    } else if (type.isDartCoreInt) {
      // integer
      value = extractValueFromString(valueString);
    } else if (type.isDartCoreDouble) {
      // double
      value = extractValueFromString(valueString);
    } else if (type.isDartCoreNum) {
      // num
      value = extractValueFromString(valueString);
    } else if (type.isDartCoreString) {
      // string
      value = extractValueFromString(valueString);
    } else if (type.isDartCoreIterable ||
        type.isDartCoreList ||
        type.isDartCoreSet) {
      var typeArgument = (type as InterfaceType).typeArguments[0];
      var valueStrings = extractValuesFromString(
        valueString,
        isSet: type.isDartCoreSet,
      );
      var values = valueStrings.fold([], (previousValue, itemValueString) {
        previousValue.add(_genParameterValue(typeArgument, itemValueString));
        return previousValue;
      });
      value = type.isDartCoreSet ? '${values.toSet()}' : '$values';
    } else if (type.isDartCoreMap) {
      var valueStringsKeyAndValue =
          extractMapValueStringFromString(valueString);
      var typeArguments = (type as InterfaceType).typeArguments;

      value = valueStringsKeyAndValue.fold({}, (previousValue, e) {
        var keyAndValue = [];
        for (var index = 0; index < 2; index++) {
          keyAndValue.add(
            _genParameterValue(
                typeArguments[index], index == 0 ? e.key : e.value),
          );
        }
        previousValue[keyAndValue[0]] = keyAndValue[1];
        return previousValue;
      }).toString();
    }

    return value;
  }

  static void customizeClass(FieldElement element, String valueString) {
    element.children.fold('', (previousValue, element) {
      return previousValue;
    });
  }

  static Map<String, String> convertConstructorStringToMap(String valueString) {
    var map = <String, String>{};
// get value string
    int firstLeftBrackets = valueString.indexOf("(");
    var varStringTmp =
        valueString.substring(firstLeftBrackets + 1, valueString.length - 1);
    List<String> leftSymbol = [];
    bool startFindFieldName = true;
    bool startFindValue = false;
    var runes = varStringTmp.runes.toList();
    var indexStart = -1;
    var fieldName = '';
    for (int i = 0; i < runes.length; i++) {
      var rune = runes[i];
      var character = String.fromCharCode(rune);
      if (startFindFieldName) {
        if (character.trim().isNotEmpty) {
          if (indexStart == -1) {
            indexStart = i;
          }
        } else {
          if (indexStart > -1) {
            fieldName = runes.sublist(indexStart, i).fold(
                '',
                (previousValue, element) =>
                    '$previousValue${String.fromCharCode(element)}');
            startFindFieldName = false;
            startFindValue = true;
            // for finding value string, skip '= '
            indexStart = i + 2;
          }
        }
        continue;
      } else if (startFindValue) {
        if (character == '(' || character == '[' || character == '{') {
          leftSymbol.add(character);
        } else if (character == ')' || character == ']' || character == '}') {
          if (character == ')') {
            if (leftSymbol.last == '(') {
              leftSymbol.removeLast();
            } else {
              print("last char is '${leftSymbol.last}', but expect '('!");
            }
          } else if (character == ']') {
            if (leftSymbol.last == '[') {
              leftSymbol.removeLast();
            } else {
              print("last char is '${leftSymbol.last}', but expect '['!");
            }
          } else if (character == '}') {
            if (leftSymbol.last == '{') {
              leftSymbol.removeLast();
            } else {
              print("last char is '${leftSymbol.last}', but expect '{'!");
            }
          }
          if (leftSymbol.isEmpty) {
            bool valueStringIsFind = false;
            var endIndex = i;
            if (i == runes.length - 1) {
              valueStringIsFind = true;
              endIndex++;
            } else if (String.fromCharCode(runes[i + 1]) == ';') {
              valueStringIsFind = true;
              endIndex++;
              // skip ';'
              i++;
            }

            if (valueStringIsFind) {
              var valueString = runes.sublist(indexStart, endIndex).fold(
                  '',
                  (previousValue, element) =>
                      '$previousValue${String.fromCharCode(element)}');
              map[fieldName] = valueString.trim();
              startFindFieldName = true;
              startFindValue = false;
              indexStart = -1;
            } else {
              print("Should not be here!");
            }
            continue;
          }
        }
      }
    }
    return map;
  }

  static String extractValueFromString(String valueString) {
    final valuePattern = RegExp(r'\(([^)]+)\)');
    final match = valuePattern.firstMatch(valueString);
    if (match != null) {
      return match.group(1)?.trim() ?? '';
    }
    return '';
  }

  static List<String> extractValuesFromString(String valueString,
      {bool isSet = false}) {
    List<String> values = [];
    final tmp =
    valueString.substring(
        valueString.indexOf(isSet ? '({' : '([') + 2, valueString.length - 2);
    List<String> leftSymbol = [];
    bool startFindTypeName = true;
    bool startFindValue = false;

    var runes = tmp.runes.toList();
    var indexStart = 0;
    for (int i = 0; i < runes.length; i++) {
      var rune = runes[i];
      var character = String.fromCharCode(rune);
      if (character == '(' || character == '[' || character == '{') {
        leftSymbol.add(character);
      } else if (character == ')' || character == ']' || character == '}') {
        if (character == ')') {
          if (leftSymbol.last == '(') {
            leftSymbol.removeLast();
          } else {
            print("last char is '${leftSymbol.last}', but expect '('!");
          }
        } else if (character == ']') {
          if (leftSymbol.last == '[') {
            leftSymbol.removeLast();
          } else {
            print("last char is '${leftSymbol.last}', but expect '['!");
          }
        } else if (character == '}') {
          if (leftSymbol.last == '{') {
            leftSymbol.removeLast();
          } else {
            print("last char is '${leftSymbol.last}', but expect '{'!");
          }
        }
      }
      if(startFindTypeName) {
        if(leftSymbol.length == 1 && leftSymbol.first == '(') {
          // find type name and start to find value
          startFindTypeName = false;
          startFindValue = true;
          print(String.fromCharCodes(runes.sublist(indexStart, i + 1)).trim());
        }
       continue;
      }
      if (leftSymbol.isEmpty) {
        if (startFindValue) {
          bool findValue = false;
          if (i + 1 < runes.length) {
            findValue = String.fromCharCode(runes[i + 1]) == ",";
          } else {
            findValue = i + 1 == runes.length;
          }
          if(findValue) {
            final itemValue =
                String.fromCharCodes(runes.sublist(indexStart, i + 1)).trim();
            // skip ','
            i = i + 2;
            indexStart = i;
            startFindValue = false;
            startFindTypeName = true;
            values.add(itemValue);
          }
        }
      }
    }
    return values;
  }

  /// [0] valueString of key, [1] valueString of value
  static List<MapEntry<String, String>> extractMapValueStringFromString(
      String valueString) {
    final List<MapEntry<String, String>> keyAndValues = [];
    final tmp =
        valueString.substring(valueString.indexOf('{') + 1, valueString.length - 1);
    List<String> leftSymbol = [];
    bool startFindKey = true;
    bool startFindValue = false;
    var runes = tmp.runes.toList();
    var indexStart = 0;
    var fieldKey = '';
    for (int i = 0; i < runes.length; i++) {
      var rune = runes[i];
      var character = String.fromCharCode(rune);
      if (character == '(' || character == '[' || character == '{') {
        leftSymbol.add(character);
      } else if (character == ')' || character == ']' || character == '}') {
        if (character == ')') {
          if (leftSymbol.last == '(') {
            leftSymbol.removeLast();
          } else {
            print("last char is '${leftSymbol.last}', but expect '('!");
          }
        } else if (character == ']') {
          if (leftSymbol.last == '[') {
            leftSymbol.removeLast();
          } else {
            print("last char is '${leftSymbol.last}', but expect '['!");
          }
        } else if (character == '}') {
          if (leftSymbol.last == '{') {
            leftSymbol.removeLast();
          } else {
            print("last char is '${leftSymbol.last}', but expect '{'!");
          }
        }
      }
      if (leftSymbol.isEmpty) {
        if (startFindKey) {
          if (i + 1 < runes.length) {
            if (String.fromCharCode(runes[i + 1]) == ":") {
              fieldKey =
                  String.fromCharCodes(runes.sublist(indexStart, i + 1)).trim();
              // skip ':'
              i = i + 2;
              indexStart = i;
              startFindKey = false;
              startFindValue = true;
            }
          }
        } else if (startFindValue) {
          bool findValue = false;
          if (i + 1 < runes.length) {
            findValue = String.fromCharCode(runes[i + 1]) == ",";
          } else {
            findValue = i + 1 == runes.length;
          }
          if (findValue) {
            final fieldValue =
                String.fromCharCodes(runes.sublist(indexStart, i + 1)).trim();
            // skip ','
            i = i + 2;
            indexStart = i;
            startFindKey = true;
            startFindValue = false;
            keyAndValues.add(MapEntry(fieldKey, fieldValue));
          }
        }
      }
    }

    return keyAndValues;
  }

  static String extractEnumValueFromString(String valueString) {
    final classNamePattern = RegExp(r'(\w+)\s*\(');
    final classNameMatch = classNamePattern.firstMatch(valueString);
    final valuePattern = RegExp(r"'([^']+)'");
    final valueMatch = valuePattern.firstMatch(valueString);
    if (classNameMatch != null && valueMatch != null) {
      final className = classNameMatch.group(1)?.trim();
      final value = valueMatch.group(1)?.trim();
      return '$className.$value';
    }
    return '';
  }
}

class FakeValueConfig {
  final String? defaultValue;
  final num minValue;
  final num maxValue;
  final int itemSize;

  const FakeValueConfig({
    this.defaultValue,
    this.minValue = 0,
    this.maxValue = 10000.0,
    this.itemSize = 1,
  });

  @override
  String toString() {
    return 'FakeValueConfig{defaultValue: $defaultValue, minValue: $minValue, maxValue: $maxValue, itemSize: $itemSize}';
  }
}

/*
  static Map<String, String> convertConstructorStringToMap(String valueString) {
    final parameterPattern = RegExp(r'(\w+)\s*=\s*([^;]+)');
    final matches = parameterPattern.allMatches(valueString);

    final paramMap = <String, String>{};
    for (var index = 0; index < matches.length; index++) {
      var element = matches.elementAt(index);
      final paramName = element.group(1)!.trim();
      String paramValue;
      //last ite should remove extra ')'
      if (index == matches.length - 1) {
        var tmp = element.group(2)!.trim();
        paramValue = tmp.substring(0, tmp.length - 1);
      } else {
        paramValue = element.group(2)!.trim();
      }
//      print("$paramName:$paramValue");
      paramMap[paramName] = paramValue;
    }
    // check value strings with enum or not
    // the format should be like '[index] = a: TT (_name = String ('a')', [index + 1] = index: int (0))'
    MapEntry<String, String>? findEnumNamePart;
    return paramMap.entries.fold({}, (previousValue, element) {
      final key = element.key;
      final value = element.value;
      if(findEnumNamePart == null) {
        print(value);
        if (value.contains('(_name = String ')) {
          var cntLeftBrackets = value.split("(").length;
          var cntRightBrackets = value.split(")").length;
          print('value:$value, cntLeftBrackets:$cntLeftBrackets, cntRightBrackets:$cntRightBrackets');
          if (cntLeftBrackets > cntRightBrackets) {
            findEnumNamePart = element;
          }
        }
      } else {
        final keyAndValue = '$key = $value';
        print(keyAndValue);
        if (keyAndValue.contains('index = int ')) {
          var cntLeftBrackets = value.split("(").length;
          var cntRightBrackets = value.split(")").length;
          print("value:$value, cntLeftBrackets:$cntLeftBrackets, cntRightBrackets:$cntRightBrackets");
          if (cntRightBrackets > cntLeftBrackets) {
            previousValue[findEnumNamePart!.key] = '${previousValue[findEnumNamePart!.key]}; $keyAndValue';
            return previousValue;
          }
        }
        findEnumNamePart = null;
      }
      previousValue[element.key] = value;
      return previousValue;
    });
  }*/
