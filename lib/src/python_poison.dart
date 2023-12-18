/// PythonPoison is the base interface for the code generator

abstract class PythonPoison {
  Function(List<dynamic>, Map<Symbol, dynamic>?) distill();
  bool isSubtype<T>();
}
