# Witch Doctor

[![pub package](https://img.shields.io/pub/v/witch_doctor.svg)](https://pub.dev/packages/witch_doctor)
[![CI](https://github.com/CenturyBoys/witch-doctor-dart/actions/workflows/ci.yml/badge.svg)](https://github.com/CenturyBoys/witch-doctor-dart/actions/workflows/ci.yml)
[![license: Apache 2.0](https://img.shields.io/github/license/CenturyBoys/witch-doctor-dart.svg)](https://github.com/CenturyBoys/witch-doctor-dart/blob/main/LICENSE)

> _"Which doctor you expecting?"_

A simple, **type-safe dependency injection** library for Dart. Register
implementations as closures, scope them in named containers, and resolve them
anywhere — with **no code generation required**. When you want zero-boilerplate
wiring, add the optional [`witch_doctor_generator`](https://pub.dev/packages/witch_doctor_generator).

Witch Doctor is the Dart sibling of the Python package
[`CenturyBoys/witch-doctor`](https://github.com/CenturyBoys/witch-doctor) and
shares its philosophy: **explicit registration, validated bindings, injection
lifetimes, and named container scopes** — kept small and predictable.

## Why Witch Doctor?

- **Type-safe, no magic.** The generic `<T>` is the resolution key; binding a
  non-subtype simply does not compile. No runtime reflection, no `Function.apply`.
- **Zero runtime dependencies.** The core library pulls in nothing.
- **Code generation is optional.** Start with closures; adopt `@Remedy`
  annotations later for auto-wiring — your choice, per class.
- **Scoped by design.** Named dispensaries let you compose and override
  registrations (last-wins), which is great for environments and tests.
- **Fails loudly, clearly.** A sealed error hierarchy and dependency-cycle
  detection replace cryptic runtime crashes.

## Install

```yaml
dependencies:
  witch_doctor: ^2.0.0

# Only if you want annotation-based auto-wiring:
dev_dependencies:
  witch_doctor_generator: ^2.0.0
  build_runner: ^2.11.0
```

## Quick start (no code generation)

```dart
import 'package:witch_doctor/witch_doctor.dart';

abstract interface class Greeter {
  String greet();
}

class EnglishGreeter implements Greeter {
  @override
  String greet() => 'Hello!';
}

class GreetingService {
  GreetingService(this.greeter);
  final Greeter greeter;
  String run() => greeter.greet();
}

void main() {
  WitchDoctor.dispensary()
    ..registerSingleton<Greeter>(EnglishGreeter())
    ..registerFactory<GreetingService>((i) => GreetingService(i<Greeter>()));

  WitchDoctor.load();

  print(WitchDoctor.resolve<GreetingService>().run()); // Hello!
}
```

## Core concepts

### Dispensaries

A `Dispensary` is a named, scoped set of registrations. Get one with
`WitchDoctor.dispensary(name: ...)` (the default name is `'default'`), fill it,
then make it active with `WitchDoctor.load(name: ...)`.

### Lifetimes

| Method | Behaviour |
|---|---|
| `registerFactory<T>((i) => ...)` | a **new** instance on every resolve |
| `registerSingleton<T>(instance)` | an **eager**, shared instance supplied now |
| `registerLazySingleton<T>((i) => ...)` | a shared instance built **once**, on first resolve |

Prefer themed aliases? `prescribe`, `remedy`, and `lazyRemedy` are one-to-one
aliases of the three methods above.

### Resolving dependencies

Every factory closure receives an `Injector` (`i`) that resolves against the
merged graph, so registrations can depend on one another — even across
dispensaries that were loaded together:

```dart
WitchDoctor.dispensary()
  ..registerLazySingleton<Db>((i) => Db(connectionString))
  ..registerFactory<UserRepo>((i) => UserRepo(i<Db>()));
```

Resolve with `WitchDoctor.resolve<T>()`, the callable shorthand
(`final wd = WitchDoctor.instance; wd<T>();`), or `WitchDoctor.tryResolve<T>()`
which returns `null` instead of throwing.

### Scopes and overrides (last-wins)

```dart
WitchDoctor.dispensary(name: 'prod').registerSingleton<Clock>(SystemClock());
WitchDoctor.dispensary(name: 'test').registerSingleton<Clock>(FakeClock());

WitchDoctor.load(name: 'prod');
WitchDoctor.load(name: 'test'); // overrides Clock; other types aggregate
```

Call `WitchDoctor.reset()` to clear everything — handy in `setUp`/`tearDown`.

### Errors

All failures are subtypes of the sealed `WitchDoctorError`:
`NotRegisteredError`, `DispensaryNotFoundError`, `DuplicateRegistrationError`,
and `DependencyCycleError` (resolution detects cycles and reports the chain).

## Optional: annotation-based auto-wiring

Add `witch_doctor_generator`, annotate your classes, and let the generator wire
constructor dependencies for you:

```dart
import 'package:witch_doctor/witch_doctor.dart';

@Remedy(scope: Scope.singleton, as: Greeter)
class EnglishGreeter implements Greeter { /* ... */ }

@Remedy() // factory scope; `greeter` is auto-resolved
class GreetingService {
  GreetingService(this.greeter);
  final Greeter greeter;
}
```

Run the generator:

```bash
dart run build_runner build
```

It emits a single `lib/witch_doctor.init.dart` with `initRemedies(Dispensary)`:

```dart
import 'witch_doctor.init.dart';

void main() {
  initRemedies(WitchDoctor.dispensary());
  WitchDoctor.load();
  final service = WitchDoctor.resolve<GreetingService>();
}
```

If a constructor parameter is not an injectable type (e.g. a plain `int`), the
build fails with a clear message telling you to register that class by hand.

## How it compares

| | **witch_doctor** | get_it | injectable | kiwi | riverpod |
|---|:--:|:--:|:--:|:--:|:--:|
| Type-safe registration | ✅ | ✅ | ✅ | ✅ | ✅ |
| Code generation required | ❌ optional | ❌ | ✅ | ❌ optional | ❌ |
| Deps resolved inside factory | ✅ `Injector` | manual | ✅ | ✅ | ✅ `ref` |
| Named, mergeable scopes | ✅ last-wins | partial | via get_it | ❌ | overrides |
| Factory / singleton / lazy | ✅ | ✅ | ✅ | ✅ | providers |
| Cycle detection | ✅ | ❌ | ❌ | ❌ | ✅ |
| Zero runtime dependencies | ✅ | ✅ | ❌ | ✅ | ❌ |
| Primary focus | pure-Dart DI | service locator | codegen over get_it | DI container | state + DI |

Witch Doctor's sweet spot: you want **get_it-level simplicity and type safety**,
**kiwi-style dependency resolution inside registrations**, **named scopes you can
merge/override**, and the option — not the obligation — of **injectable-style
code generation**, all with **zero runtime dependencies** and built-in cycle
detection.

## Migrating from 1.x

Version 2 is a breaking, simpler rewrite. See
[MIGRATION.md](https://github.com/CenturyBoys/witch-doctor-dart/blob/main/MIGRATION.md).

## Contributing

See [CONTRIBUTING.md](https://github.com/CenturyBoys/witch-doctor-dart/blob/main/CONTRIBUTING.md)
and [AGENTS.md](https://github.com/CenturyBoys/witch-doctor-dart/blob/main/AGENTS.md).

## License

[Apache 2.0](LICENSE) © CenturyBoys
