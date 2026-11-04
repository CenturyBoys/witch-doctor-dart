## 2.0.0

Witch Doctor 2.0 is a ground-up rewrite with a simpler, fully type-safe API.
See [MIGRATION.md](../../MIGRATION.md) for a step-by-step upgrade guide.

### Breaking changes

- Registration is now closure-based and type-safe. `TopHatContainer` becomes
  `Dispensary`; `WitchDoctor.getContainer` becomes `WitchDoctor.dispensary`.
- Replaced the positional `register(InjectionType, PythonPoison, [args], {named})`
  API with `registerFactory`, `registerSingleton` and `registerLazySingleton`.
  Constructor arguments are now real, compiler-checked constructor calls.
- Removed `PythonPoison`, `distill()`, `isSubtype()` and the generated
  `*Static` / `*PythonPoison` classes. Subtype safety is now enforced at
  compile time by the generic resolution key.
- Code generation moved to the separate `witch_doctor_generator` dev
  dependency. The runtime package now has **zero** production dependencies.
- `@Antibiotic` is deprecated in favour of `@Remedy`.

### Added

- An `Injector` is passed into every factory closure, so a registration can
  resolve its own dependencies against the merged graph.
- Lazy singletons via `registerLazySingleton`.
- A sealed `WitchDoctorError` hierarchy (`NotRegisteredError`,
  `DispensaryNotFoundError`, `DuplicateRegistrationError`,
  `DependencyCycleError`) and runtime dependency-cycle detection.
- `WitchDoctor.tryResolve`, `WitchDoctor.reset`, a callable resolve shorthand,
  and the `inject` helper.
- Optional `@Remedy` auto-wiring that generates a single
  `initRemedies(Dispensary)` function for the whole package.

## 1.2.1

- Version bump and dependency maintenance.

## 1.2.0

- Update Dart SDK to ^3.10.3
- Update all dependencies to latest versions (analyzer ^10.0.2, build ^4.0.4, source_gen ^4.2.0)
- Fix compatibility with source_gen 4.x and analyzer 10.x APIs

## 1.1.2

- Fix error fpr object creation internal logic

## 1.1.1

- Fixing documentation --"

## 1.1.0

- Remove `dart:mirrors` lib.
- Add `source_gen` and `build_runner` libs to generate `witch_doctor` base classes.
- Add _@Antibiotic()_ decorator to tag possible injections classes.
- Register need an instance of the generated code _${className}PythonPoison_.

## 1.0.0

- Add containers feature
- Add injections type (singleton and factory) feature
