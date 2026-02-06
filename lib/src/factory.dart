/// Code generator that use the Antibiotic annotation
///
/// The generator will create ClassNamePythonPoison and ClassNameStatic.
/// *PythonPoison is a generic object factory that have the method distill()
/// and recaeve generic params List<dynamic> and , generic named params Map<Symbol, dynamic>?.
/// *Static is a static function that returns a object instance .

import 'dart:async';

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:witch_doctor/src/antibiotic.dart';

class MedicineFactory extends Generator {
  TypeChecker get typeChecker =>
      TypeChecker.typeNamed(Antibiotic, inPackage: 'witch_doctor');

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    final values = <String>{};
    for (var annotatedElement in library.annotatedWith(typeChecker)) {
      var element = annotatedElement.element;
      if (element is ClassElement) {
        final className = element.name;
        if (className == null) continue;
        final funcName =
            '${className}Static'.replaceRange(0, 1, className[0].toLowerCase());
        final parameters = element.unnamedConstructor?.formalParameters ?? [];
        values.add(MedicineFactory.genStaticFunctionConstructor(
            className, funcName, parameters));
        values.add(MedicineFactory.genPythonPoison(className, funcName));
      }
    }
    return values.join('\n');
  }

  static String genStaticFunctionConstructor(String className, String funcName,
      List<FormalParameterElement> parameters) {
    final signature =
        parameters.map((param) => '${param.type} ${param.name}').join(', ');
    return '''
          $className $funcName($signature) {
            return $className(${parameters.map((param) => param.name).join(', ')});
          }
        ''';
  }

  static String genPythonPoison(String className, String funcName) {
    return '''
          class ${className}PythonPoison extends PythonPoison {
            @override
            Function(List<dynamic>, Map<Symbol, dynamic>?) distill() {
              return (List<dynamic> params, Map<Symbol, dynamic>? namedParams) =>
                    Function.apply($funcName, params, namedParams);
            }
            @override
            bool isSubtype<T>() => <$className>[] is List<T>;
          }
        ''';
  }
}
