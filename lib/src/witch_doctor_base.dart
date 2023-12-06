import 'package:witch_doctor/src/witch_doctor_container.dart';

const String _defaultContainerName = "default";

class WitchDoctor {
  static final WitchDoctor _instance = WitchDoctor._init();
  static final Map<String, TopHatContainer> _containers = {};
  static final Map<Type, Box> _services = {};

  WitchDoctor._init();

  factory WitchDoctor() => _instance;

  static TopHatContainer getContainer({String name = _defaultContainerName}) {
    if (!_containers.containsKey(name)) {
      final container = TopHatContainer();
      _containers[name] = container;
    }
    return _containers[name]!;
  }

  static void load({String name = _defaultContainerName}) {
    if (!_containers.containsKey(name)) {
      throw Exception("Container with name: $name not registered");
    }
    _services.addAll(_containers[name]!.references);
  }

  static T resolve<T>() {
    if (!_services.containsKey(T)) {
      throw Exception("Reference not registered $T");
    }
    return _services[T]!.getInstance();
  }
}
