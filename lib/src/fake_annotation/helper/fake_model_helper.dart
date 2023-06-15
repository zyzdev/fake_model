import 'dart:mirrors';

import 'package:analyzer/dart/element/element.dart';
import 'package:fake_model/src/fake_annotation/fake_model.dart';

List<ClassElement> findClassWithFakeModel(LibraryElement entryLib) {
  try {
    final classElements =
        entryLib.children.fold(<ClassElement>[], (previousValue, element) {
      final model =
          element.children.fold(<ClassElement>[], (previousValue, element) {
        final withAnnotation = element.metadata.indexWhere((annotation) {
              return annotation.element?.librarySource?.uri ==
                  (reflectClass(FakeModel).owner as LibraryMirror).uri;
              //return annotation.element?.displayName == "FakeModel";
            }) >
            -1;
        if (!withAnnotation) return previousValue;
        if (element is ClassElement) previousValue.add(element);
        return previousValue;
      });
      previousValue.addAll(model);
      return previousValue;
    });
    return classElements;
  } catch (e) {
    return [];
  }
}

FakeModelConfig toFakeModelConfig(ElementAnnotation elementAnnotation) {
  final dartObject = elementAnnotation.computeConstantValue();
  bool randomValue = true;
  for (var param
      in (elementAnnotation.element as ConstructorElement).parameters) {
    var name = param.name;
    var fieldDartObject = dartObject?.getField(name);
    switch (name) {
      case 'randomValue':
        randomValue = fieldDartObject?.toBoolValue() ?? true;
        break;
    }
  }
  return FakeModelConfig(randomValue: randomValue);
}

class FakeModelConfig {
  final bool randomValue;

  const FakeModelConfig({
    this.randomValue = true,
  });
}
