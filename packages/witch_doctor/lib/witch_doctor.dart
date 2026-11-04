/// Witch Doctor — a simple, type-safe dependency injection library for Dart.
///
/// "Which doctor you expecting?"
library;

// `Antibiotic` is re-exported intentionally for 1.x backward compatibility,
// even though it is deprecated.
// ignore_for_file: deprecated_member_use_from_same_package

export 'src/antibiotic.dart' show Antibiotic;
export 'src/dispensary.dart' show Dispensary;
export 'src/errors.dart'
    show
        DependencyCycleError,
        DispensaryNotFoundError,
        DuplicateRegistrationError,
        NotRegisteredError,
        WitchDoctorError;
export 'src/injector.dart' show Injector;
export 'src/remedy.dart' show Remedy, lazySingleton, singleton;
export 'src/scope.dart' show Scope;
export 'src/witch_doctor.dart' show WitchDoctor, inject;
