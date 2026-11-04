# FAQ

### Do I need code generation?

No. The closure-based API (`registerFactory` / `registerSingleton` /
`registerLazySingleton`) covers everything with zero code generation. The
`@Remedy` generator is a convenience for auto-wiring constructors — opt in per
class when you want it.

### Does it work with Flutter?

Yes. Witch Doctor is pure Dart with no reflection (`dart:mirrors` is never used),
so it works in Flutter and AOT builds. It is a DI container, not a state
management solution — pair it with your widgets as you see fit.

### What's the difference between `singleton` and `lazySingleton`?

`registerSingleton` takes an instance you create **now** (eager).
`registerLazySingleton` takes a closure and builds the instance **once, on first
resolve** (lazy). Both return the same shared instance afterwards.

### How do I override a registration?

Register the replacement in another dispensary and load it after the first one.
Loading is last-wins, so the most recently loaded registration for a type wins.
Within a *single* dispensary, re-registering the same type throws
`DuplicateRegistrationError` to catch accidental duplicates.

### How do I reset everything between tests?

Call `WitchDoctor.reset()` in `setUp`/`tearDown`. See
[Testing with reset](examples.md#testing-with-reset).

### Why are there two packages?

`witch_doctor` is the runtime container and has **zero** production
dependencies, so apps stay lean. `witch_doctor_generator` holds the build-time
code generator and is only ever a `dev_dependency`. This mirrors the
`json_annotation` / `json_serializable` split.

### How do I migrate from 1.x?

See the [Migration guide](migration.md). In short: replace `PythonPoison` +
positional `register(...)` with type-safe `registerFactory` /
`registerSingleton` closures, and `@Antibiotic` with `@Remedy`.

### Where's the API reference?

In the [API reference](https://centuryboys.github.io/witch-doctor-dart/api/),
generated from the source with `dart doc`.
