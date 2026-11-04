/// Defines how a registration produces an instance when it is resolved.
///
/// This is only used by the optional [Remedy] annotation. When registering
/// manually you pick the behaviour by calling the matching method on a
/// `Dispensary` (`registerFactory`, `registerSingleton`,
/// `registerLazySingleton`).
enum Scope {
  /// A brand new instance is created on every resolve.
  ///
  /// Equivalent to `Dispensary.registerFactory`.
  transient,

  /// A single instance is shared for every resolve. The instance is created
  /// eagerly, at registration time.
  ///
  /// Equivalent to `Dispensary.registerSingleton`.
  singleton,

  /// A single instance is shared for every resolve, but it is created lazily on
  /// the first resolve and cached from then on.
  ///
  /// Equivalent to `Dispensary.registerLazySingleton`.
  lazySingleton,
}
