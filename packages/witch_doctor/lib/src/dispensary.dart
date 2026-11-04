import 'dart:collection';

import 'errors.dart';
import 'injector.dart';
import 'scope.dart';

/// A single registration: how to build a type and its lifetime.
///
/// This is an internal detail of a [Dispensary]; you never create it directly.
class Registration {
  /// A registration that builds a new instance on every resolve.
  Registration.transient(Object Function(Injector injector) create)
    : scope = Scope.transient,
      _create = create;

  /// A registration backed by an eagerly supplied, shared [instance].
  Registration.singleton(Object instance)
    : scope = Scope.singleton,
      _create = null,
      _instance = instance;

  /// A registration that builds a shared instance lazily on first resolve.
  Registration.lazySingleton(Object Function(Injector injector) create)
    : scope = Scope.lazySingleton,
      _create = create;

  /// The lifetime of this registration.
  final Scope scope;

  final Object Function(Injector injector)? _create;
  Object? _instance;

  /// Produces (or returns the cached) instance for this registration.
  Object resolve(Injector injector) => switch (scope) {
    Scope.transient => _create!(injector),
    Scope.singleton => _instance!,
    Scope.lazySingleton => _instance ??= _create!(injector),
  };
}

/// A named, scoped collection of registrations.
///
/// Obtain one with `WitchDoctor.dispensary(name: ...)`, fill it with
/// `register*` calls, then make it active with `WitchDoctor.load(name: ...)`.
///
/// The generic `<T>` on each register method is the *resolution key*. Because a
/// factory closure must return `T`, the compiler rejects
/// `registerFactory<Animal>((i) => 42)` — binding an implementation that is not
/// a subtype of the key simply does not compile. This replaces the runtime
/// subtype check of earlier versions.
class Dispensary {
  final Map<Type, Registration> _registrations = {};

  /// Read-only view of the registrations in this dispensary.
  ///
  /// Used by `WitchDoctor.load` to merge this dispensary into the global graph.
  UnmodifiableMapView<Type, Registration> get registrations =>
      UnmodifiableMapView(_registrations);

  /// Registers [T] so a new instance is built on every resolve.
  ///
  /// The [create] closure receives an [Injector] to resolve dependencies:
  /// ```dart
  /// d.registerFactory<UserRepo>((i) => UserRepo(i<Db>()));
  /// ```
  void registerFactory<T extends Object>(T Function(Injector injector) create) {
    _put<T>(Registration.transient(create));
  }

  /// Registers [T] as an eager singleton backed by [instance].
  void registerSingleton<T extends Object>(T instance) {
    _put<T>(Registration.singleton(instance));
  }

  /// Registers [T] as a lazy singleton, built once on first resolve via
  /// [create] and cached afterwards.
  void registerLazySingleton<T extends Object>(
    T Function(Injector injector) create,
  ) {
    _put<T>(Registration.lazySingleton(create));
  }

  /// Themed alias for [registerFactory].
  void prescribe<T extends Object>(T Function(Injector injector) create) =>
      registerFactory<T>(create);

  /// Themed alias for [registerSingleton].
  void remedy<T extends Object>(T instance) => registerSingleton<T>(instance);

  /// Themed alias for [registerLazySingleton].
  void lazyRemedy<T extends Object>(T Function(Injector injector) create) =>
      registerLazySingleton<T>(create);

  /// Whether [T] is registered in this dispensary.
  bool isRegistered<T extends Object>() => _registrations.containsKey(T);

  void _put<T extends Object>(Registration registration) {
    if (_registrations.containsKey(T)) {
      throw DuplicateRegistrationError(T);
    }
    _registrations[T] = registration;
  }
}
