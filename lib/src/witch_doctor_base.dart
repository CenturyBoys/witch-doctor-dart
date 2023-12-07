import 'dart:mirrors';

const String _defaultContainerName = "default";

void main() {}

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
