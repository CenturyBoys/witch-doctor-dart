# Migrating to Witch Doctor 2.0

Version 2 is a ground-up rewrite with a simpler, fully type-safe API. The old
`PythonPoison` / `Function.apply` machinery is gone; registrations are now
closures checked by the compiler, and code generation is **optional**.

## At a glance

| Concern | 1.x | 2.0 |
|---|---|---|
| Get a container | `WitchDoctor.getContainer(name: "c")` → `TopHatContainer` | `WitchDoctor.dispensary(name: "c")` → `Dispensary` |
| Register (factory) | `c.register<I>(InjectionType.factory, ImplPythonPoison(), [10, 20], {})` | `c.registerFactory<I>((i) => Impl(10, 20))` |
| Register (singleton) | `c.register<I>(InjectionType.singleton, ImplPythonPoison(), [..])` | `c.registerSingleton<I>(Impl(10, 20))` or `c.registerLazySingleton<I>((i) => Impl(10, 20))` |
| Resolve a dependency in a registration | not supported | `c.registerFactory<I>((i) => Impl(i<Dep>()))` |
| Load a container | `WitchDoctor.load(name: "c")` | `WitchDoctor.load(name: "c")` (unchanged) |
| Resolve | `WitchDoctor.resolve<I>()` | `WitchDoctor.resolve<I>()` (or `wd<I>()`) |
| Annotation | `@Antibiotic()` + `part '*.g.dart'` + register `*PythonPoison` | `@Remedy(as: I)` + generated `initRemedies(d)` |
| Generated artifact | `*PythonPoison` / `*Static` per class | one `initRemedies(Dispensary)` per package |
| Subtype check | runtime `isSubtype<T>()` | compile-time via generics |
| Errors | `Exception("...")` | sealed `WitchDoctorError` subtypes |
| Teardown | none | `WitchDoctor.reset()` |

## Steps

### 1. Update dependencies

The library split into a dependency-free runtime package and an optional
generator package.

```yaml
dependencies:
  witch_doctor: ^2.0.0

dev_dependencies:
  # only if you use @Remedy annotations:
  witch_doctor_generator: ^2.0.0
  build_runner: ^2.11.0
```

### 2. Replace registrations with closures

Before:

```dart
final c = WitchDoctor.getContainer(name: "app");
c.register<Interface>(InjectionType.factory, ImplPythonPoison(), [10, 20], {});
WitchDoctor.load(name: "app");
```

After:

```dart
final c = WitchDoctor.dispensary(name: "app");
c.registerFactory<Interface>((i) => Impl(10, 20));
WitchDoctor.load(name: "app");
```

Constructor arguments are now real constructor calls — the compiler checks them,
so there is no more untyped `[args]` list or `Map<Symbol, dynamic>` of named
arguments.

### 3. Choose a lifetime explicitly

- `InjectionType.factory` → `registerFactory`
- `InjectionType.singleton` → `registerSingleton` (eager) or
  `registerLazySingleton` (lazy)

### 4. Resolve dependencies via the injector

Instead of passing primitive argument lists, resolve dependencies from the
injector handed to each closure:

```dart
c.registerFactory<UserRepo>((i) => UserRepo(i<Db>()));
```

### 5. Annotations: `@Antibiotic` → `@Remedy`

`@Antibiotic` still works as a deprecated alias, but switch to `@Remedy`:

```dart
@Remedy(as: Interface, scope: Scope.singleton)
class Impl implements Interface { /* ... */ }
```

Run `dart run build_runner build`. The generator now emits a single
`lib/witch_doctor.init.dart` with `initRemedies(Dispensary)` instead of a
per-class `*PythonPoison` part file. Call it once:

```dart
initRemedies(WitchDoctor.dispensary());
WitchDoctor.load();
```

Note: `@Remedy` can only auto-wire constructor parameters that are themselves
registered types. For classes with plain-value parameters (e.g. an `int`),
register them manually with `registerFactory`/`registerSingleton`.

### 6. Catch typed errors

Replace `catch (e) { /* Exception */ }` with the specific error you care about:
`NotRegisteredError`, `DispensaryNotFoundError`, `DuplicateRegistrationError`,
or `DependencyCycleError` — all subtypes of the sealed `WitchDoctorError`.

### 7. Reset between tests

Call `WitchDoctor.reset()` in `setUp`/`tearDown` to isolate tests.
