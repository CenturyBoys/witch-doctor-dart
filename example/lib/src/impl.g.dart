// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'impl.dart';

// **************************************************************************
// Generator: MedicineFactory
// **************************************************************************

Impl implStatic(int a, int b) {
  return Impl(a, b);
}

class ImplPythonPoison extends PythonPoison {
  @override
  Function(List<dynamic>, Map<Symbol, dynamic>?) distill() {
    return (List<dynamic> params, Map<Symbol, dynamic>? namedParams) =>
        Function.apply(implStatic, params, namedParams);
  }

  @override
  bool isSubtype<T>() => <Impl>[] is List<T>;
}
