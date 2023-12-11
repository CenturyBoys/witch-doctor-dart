import 'package:witch_doctor/witch_doctor.dart';

// part 'class_test.g.dart';

abstract class InterfaceA {
  int sum();
}

abstract class InterfaceB {
  int sum();
}

@Antibiotic()
class ImplA extends InterfaceA {
  int a;
  int b;

  ImplA(this.a, this.b);

  @override
  int sum() {
    return a + b;
  }
}

@Antibiotic()
class ImplB extends InterfaceA {
  int a;
  int b;

  ImplB(this.a, this.b);

  @override
  int sum() {
    return a - b;
  }
}

@Antibiotic()
class ImplC extends InterfaceB {
  int a;
  int b;

  ImplC(this.a, this.b);

  @override
  int sum() {
    return a * b;
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'class_test.dart';

// **************************************************************************
// Generator: MedicineFactory
// **************************************************************************

ImplA implAStatic(int a, int b) {
  return ImplA(a, b);
}

class ImplAPythonPoison extends PythonPoison {
  @override
  Function(List<dynamic>, Map<Symbol, dynamic>?) distill() {
    return (List<dynamic> params, Map<Symbol, dynamic>? namedParams) =>
        Function.apply(implAStatic, params, namedParams);
  }

  @override
  bool isSubtype<T>() => <ImplA>[] is List<T>;
}

ImplB implBStatic(int a, int b) {
  return ImplB(a, b);
}

class ImplBPythonPoison extends PythonPoison {
  @override
  Function(List<dynamic>, Map<Symbol, dynamic>?) distill() {
    return (List<dynamic> params, Map<Symbol, dynamic>? namedParams) =>
        Function.apply(implBStatic, params, namedParams);
  }

  @override
  bool isSubtype<T>() => <ImplB>[] is List<T>;
}

ImplC implCStatic(int a, int b) {
  return ImplC(a, b);
}

class ImplCPythonPoison extends PythonPoison {
  @override
  Function(List<dynamic>, Map<Symbol, dynamic>?) distill() {
    return (List<dynamic> params, Map<Symbol, dynamic>? namedParams) =>
        Function.apply(implCStatic, params, namedParams);
  }

  @override
  bool isSubtype<T>() => <ImplC>[] is List<T>;
}

void main() {}
