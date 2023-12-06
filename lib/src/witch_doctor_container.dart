import 'dart:mirrors';

enum InjectionType { singleton, factory }

class Box<T> {
  InjectionType injectionType;
  Type classReference;
  List<dynamic> defaultArgs;
  late InstanceMirror? object;

  Box(this.injectionType, this.classReference, this.defaultArgs);

  T getInstance() {
    if (injectionType == InjectionType.factory) {
      InstanceMirror instanceMirror =
          reflectClass(classReference).newInstance(Symbol(''), defaultArgs);
      object = instanceMirror;
    } else if (object == null) {
      InstanceMirror instanceMirror =
          reflectClass(classReference).newInstance(Symbol(''), defaultArgs);
      object = instanceMirror;
    }
    return object!.reflectee;
  }
}

class TopHatContainer {
  final Map<Type, Box> _references;

  TopHatContainer() : _references = {};

  Map<Type, Box> get references => _references;

  void register<T, B>(InjectionType injectionType,
      [List<dynamic> defaultArgs = const []]) {
    if (!reflectType(B).isSubtypeOf(reflectType(T))) {
      throw Exception("Type $B must extend $T");
    }
    _references[T] = Box<T>(injectionType, B, defaultArgs);
  }
}
