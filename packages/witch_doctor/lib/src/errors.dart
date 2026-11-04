// Error hierarchy thrown by Witch Doctor. Every error is a subtype of
// [WitchDoctorError], which is `sealed` so callers can handle them
// exhaustively with a `switch`.

/// Base type for every error thrown by Witch Doctor.
sealed class WitchDoctorError implements Exception {
  /// Creates an error with a human readable [message].
  const WitchDoctorError(this.message);

  /// A human readable description of what went wrong.
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when a type is resolved but nothing has been registered for it.
final class NotRegisteredError extends WitchDoctorError {
  /// Creates the error for the missing [type].
  NotRegisteredError(this.type)
    : super(
        'No remedy registered for type `$type`. Register it in a Dispensary '
        'and call WitchDoctor.load() before resolving.',
      );

  /// The type that could not be resolved.
  final Type type;
}

/// Thrown when loading or reading a dispensary that was never created.
final class DispensaryNotFoundError extends WitchDoctorError {
  /// Creates the error for the missing dispensary [name].
  DispensaryNotFoundError(this.name)
    : super(
        "Dispensary '$name' was never created. Create it with "
        "WitchDoctor.dispensary(name: '$name') before loading it.",
      );

  /// The dispensary name that could not be found.
  final String name;
}

/// Thrown when the same type is registered twice in a single dispensary.
///
/// Overriding a registration across different dispensaries is allowed on
/// purpose (that is the last-wins merge behaviour of `WitchDoctor.load`); this
/// error only guards against accidental double registration inside one
/// dispensary.
final class DuplicateRegistrationError extends WitchDoctorError {
  /// Creates the error for the duplicated [type].
  DuplicateRegistrationError(this.type)
    : super(
        'Type `$type` is already registered in this Dispensary. Register it '
        'once, or scope the second registration to a separate Dispensary.',
      );

  /// The type that was registered more than once.
  final Type type;
}

/// Thrown when resolving a type requires resolving itself, directly or through
/// a chain of dependencies.
final class DependencyCycleError extends WitchDoctorError {
  /// Creates the error for the offending [chain] of types.
  DependencyCycleError(this.chain)
    : super('Dependency cycle detected: ${chain.join(' -> ')}.');

  /// The resolution chain that closed the cycle, e.g. `[A, B, A]`.
  final List<Type> chain;
}
