import 'scope.dart';

/// Marks a class for optional, build-time auto-wiring.
///
/// Annotating a class makes the generator emit a registration for it inside the
/// generated `initRemedies(Dispensary)` function, wiring each constructor
/// parameter by resolving it from the injector. It is entirely optional:
/// everything can be registered by hand with the `register*` methods.
///
/// ```dart
/// @Remedy(as: UserRepo)
/// class SqlUserRepo implements UserRepo {
///   SqlUserRepo(this.db);
///   final Db db; // resolved automatically
/// }
/// ```
class Remedy {
  /// Creates an annotation with the given [scope], binding target [as] and
  /// optional [container].
  const Remedy({this.scope = Scope.transient, this.as, this.container});

  /// The lifetime of the generated registration. Defaults to [Scope.transient].
  final Scope scope;

  /// The type to register the class under (usually an interface it implements).
  ///
  /// Defaults to the annotated class itself when `null`.
  final Type? as;

  /// The name of the dispensary to register into. Defaults to the `'default'`
  /// dispensary when `null`.
  final String? container;
}

/// Convenience annotation for a class registered as an eager singleton.
const Remedy singleton = Remedy(scope: Scope.singleton);

/// Convenience annotation for a class registered as a lazy singleton.
const Remedy lazySingleton = Remedy(scope: Scope.lazySingleton);
