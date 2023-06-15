import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

bool isCustomClass(List<ConstructorElement> elements) {
  for (ConstructorElement element in elements) {
    if (element.name.isEmpty) return element.librarySource.uri.toString() != 'dart:core';
  }
  return false;
}

bool isCustomEnum(InterfaceType type) {
  return type.element.declaration is EnumElement;
}
