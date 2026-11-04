/// Witch Doctor — a simple, type-safe dependency injection library for Dart.
///
/// "Which doctor you expecting?"
library;

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
