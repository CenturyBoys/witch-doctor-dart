/// The read-only view of the dependency graph handed to registration closures.
///
/// A factory receives an [Injector] so it can resolve its own dependencies:
///
/// ```dart
/// dispensary.registerFactory<UserRepo>((i) => UserRepo(i<Db>()));
/// ```
///
/// The injector always resolves against the merged, loaded graph, so a
/// registration can depend on types that live in a different dispensary as long
/// as both have been loaded.
abstract interface class Injector {
  /// Returns an instance registered for [T], throwing [NotRegisteredError] if
  /// none exists.
  T resolve<T extends Object>();

  /// Shorthand for [resolve]; lets you write `i<Db>()` inside a closure.
  T call<T extends Object>();

  /// Like [resolve] but returns `null` instead of throwing when [T] is not
  /// registered.
  T? tryResolve<T extends Object>();
}
