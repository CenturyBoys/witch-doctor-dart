/// WitchDoctor base code
///
/// Box is the class sub-container where all default params, named params and object instance are saved.
/// TopHatContainer is the named scoped container where the classes will be registered.

import 'package:witch_doctor/src/python_poison.dart';

const String _defaultContainerName = "default";

class WitchDoctor {
  static final WitchDoctor _instance = WitchDoctor._init();
  static final Map<String, TopHatContainer> _containers = {};
  static final Map<Type, Box> _services = {};

  WitchDoctor._init();

  factory WitchDoctor() => _instance;

  /// This method will provide a container register
  static TopHatContainer getContainer({String name = _defaultContainerName}) {
    if (!_containers.containsKey(name)) {
      final container = TopHatContainer();
      _containers[name] = container;
    }
    return _containers[name]!;
  }

  /// This method will load the current container using the container name
  static void load({String name = _defaultContainerName}) {
    if (!_containers.containsKey(name)) {
      throw Exception("Container with name: $name not registered");
    }
    _services.addAll(_containers[name]!.references);
  }

  /// This method will return a instance of the registered T class
  static T resolve<T>() {
    if (!_services.containsKey(T)) {
      throw Exception("Reference not registered $T");
    }
    return _services[T]!.getInstance();
  }
}

enum InjectionType { singleton, factory }

class Box<T> {
  InjectionType injectionType;
  Function(List<dynamic>, Map<Symbol, dynamic>?) instanceCallback;
  List<dynamic> params;
  Map<Symbol, dynamic>? namedPrams;
  late T? instance_object;

  Box(this.injectionType, this.instanceCallback, this.params, this.namedPrams,
      [this.instance_object = null]);

  T getInstance() {
    if (injectionType == InjectionType.factory) {
      instance_object = instanceCallback(params, namedPrams);
    } else {
      instance_object ??= instanceCallback(params, namedPrams);
    }
    return instance_object!;
  }
}

class TopHatContainer {
  final Map<Type, Box> _references;

  TopHatContainer() : _references = {};

  Map<Type, Box> get references => _references;

  void register<T>(InjectionType injectionType, PythonPoison instanceCallback,
      [List<dynamic> params = const [],
      Map<Symbol, dynamic>? namedParams = const {}]) {
    if (!(instanceCallback.isSubtype<T>())) {
      throw Exception(
          "The python poison is not for that interface, must extend $T");
    }
    _references[T] =
        Box<T>(injectionType, instanceCallback.distill(), params, namedParams);
  }
}
