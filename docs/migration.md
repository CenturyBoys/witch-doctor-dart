# Migration (1.x → 2.0)

Version 2 is a simpler, fully type-safe rewrite. The old `PythonPoison` /
`Function.apply` machinery is gone; registrations are closures checked by the
compiler, and code generation is **optional**.

The canonical, always-current guide lives in the repository:
[MIGRATION.md](https://github.com/CenturyBoys/witch-doctor-dart/blob/main/MIGRATION.md).

## At a glance

| Concern | 1.x | 2.0 |
|---|---|---|
| Get a container | `WitchDoctor.getContainer(name: "c")` | `WitchDoctor.dispensary(name: "c")` |
| Register (factory) | `c.register<I>(InjectionType.factory, ImplPythonPoison(), [10, 20], {})` | `c.registerFactory<I>((i) => Impl(10, 20))` |
| Register (singleton) | `c.register<I>(InjectionType.singleton, ImplPythonPoison(), [..])` | `c.registerSingleton<I>(Impl(10, 20))` or `c.registerLazySingleton<I>((i) => Impl(10, 20))` |
| Resolve a dependency in a registration | not supported | `c.registerFactory<I>((i) => Impl(i<Dep>()))` |
| Load / resolve | `load(name: "c")` / `resolve<I>()` | unchanged (`resolve` or `wd<I>()`) |
| Annotation | `@Antibiotic()` + `part '*.g.dart'` | `@Remedy(as: I)` + generated `initRemedies(d)` |
| Generated artifact | `*PythonPoison` / `*Static` per class | one `initRemedies(Dispensary)` per package |
| Subtype check | runtime `isSubtype<T>()` | compile-time via generics |
| Errors | `Exception("...")` | sealed `WitchDoctorError` subtypes |
| Teardown | none | `WitchDoctor.reset()` |

## Key steps

1. **Dependencies.** Keep `witch_doctor` in `dependencies`; move code generation
   to `witch_doctor_generator` + `build_runner` under `dev_dependencies`.
2. **Registrations → closures.** Replace the positional
   `register(InjectionType, PythonPoison, [args], {named})` with
   `registerFactory` / `registerSingleton` / `registerLazySingleton`. Arguments
   become real, compiler-checked constructor calls.
3. **Dependencies via the injector.** `c.registerFactory<I>((i) => Impl(i<Dep>()))`.
4. **`@Antibiotic` → `@Remedy`.** The old annotation still works as a deprecated
   alias; switch when convenient and regenerate with
   `dart run build_runner build`.
5. **Typed errors.** Catch `NotRegisteredError`, `DispensaryNotFoundError`,
   `DuplicateRegistrationError`, or `DependencyCycleError`.
6. **Tests.** Call `WitchDoctor.reset()` in `setUp`/`tearDown`.
