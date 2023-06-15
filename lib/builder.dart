import 'package:build/build.dart';
import 'package:fake_model/src/fake_annotation/helper/fake_model_helper.dart';
import 'package:fake_model/src/generator/generator.dart';

Builder fakeBuilder(BuilderOptions options) => FakeBuilder();

class FakeBuilder implements Builder {
  @override
  Future build(BuildStep buildStep) async {
    if (buildStep.inputId.path.endsWith('.g.dart')) {
      // Skip processing files with the '.g.dart' suffix
      return;
    }
    final entryLib = await buildStep.inputLibrary;

    Generator.findAllValueConfig(entryLib);
    final classElements = findClassWithFakeModel(entryLib);
    if (classElements.isEmpty) return;
    final modelFileName = buildStep.inputId.pathSegments.last;
    final info = buildStep.inputId.changeExtension('.fake.g.dart');

    await buildStep.writeAsString(
      info,
      _addFileIntroduction(
        _addPartKeyword(
          modelFileName, Generator.startGen(classElements),
        ),
      ),
    );
  }

  @override
  final buildExtensions = const {
    '.dart': ['.fake.g.dart']
  };

  String _addFileIntroduction(String code) {
    return '/// Code was generate by [fake_model](https://translate.google.com/?sl=en&tl=zh-TW&text=was%20generate%20by%20%5Bfake_model%5D&op=translate)\n\n'
        '$code';
  }

  String _addPartKeyword(String fileName, String code) {
    return 'part of \'$fileName\';\n\n$code';
  }
}
