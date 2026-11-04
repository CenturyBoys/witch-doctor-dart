# Guide

## Dispensaries

A `Dispensary` is a named, scoped set of registrations. Get one with
`WitchDoctor.dispensary(name: ...)` (the default name is `'default'`), fill it,
then activate it with `WitchDoctor.load(name: ...)`.

```dart
final prod = WitchDoctor.dispensary(name: 'prod');
prod.registerSingleton<Clock>(SystemClock());
WitchDoctor.load(name: 'prod');
```

## Lifetimes

| Method | Behaviour |
|---|---|
| `registerFactory<T>((i) => ...)` | a **new** instance on every resolve |
| `registerSingleton<T>(instance)` | an **eager**, shared instance supplied now |
| `registerLazySingleton<T>((i) => ...)` | a shared instance built **once**, on first resolve |

Prefer themed names? `prescribe`, `remedy` and `lazyRemedy` are one-to-one
aliases of the three methods above.

```dart
WitchDoctor.dispensary()
  ..registerFactory<Uuid>((i) => Uuid())            // new each time
  ..registerSingleton<Config>(Config.fromEnv())      // one, created now
  ..registerLazySingleton<Db>((i) => Db.connect());  // one, on first use
```

## Resolving dependencies

Every factory closure receives an `Injector` (`i`) that resolves against the
**merged graph**, so registrations can depend on one another — even across
dispensaries loaded together.

```dart
WitchDoctor.dispensary()
  ..registerLazySingleton<Db>((i) => Db(connectionString))
  ..registerFactory<UserRepo>((i) => UserRepo(i<Db>()))
  ..registerFactory<UserService>((i) => UserService(i<UserRepo>()));
```

Resolve with any of:

```dart
final repo = WitchDoctor.resolve<UserRepo>();        // throws if missing
final maybe = WitchDoctor.tryResolve<UserRepo>();    // null if missing

final wd = WitchDoctor.instance;                     // callable shorthand
final repo2 = wd<UserRepo>();
```

## Named scopes and overrides (last-wins)

Loading is **last-wins**: when two loaded dispensaries register the same type,
the most recently loaded one wins. Types that don't overlap are aggregated.

```dart
WitchDoctor.dispensary(name: 'prod').registerSingleton<Clock>(SystemClock());
WitchDoctor.dispensary(name: 'test').registerSingleton<Clock>(FakeClock());

WitchDoctor.load(name: 'prod');
WitchDoctor.load(name: 'test'); // Clock -> FakeClock; everything else aggregates
```

## Resetting state

```dart
WitchDoctor.reset(); // clears every dispensary and the active graph
```

Call it in `setUp`/`tearDown` to keep tests isolated — see
[Examples](examples.md#testing-with-reset).

## Errors

All failures are subtypes of the sealed `WitchDoctorError`, so you can `switch`
over them exhaustively:

| Error | When |
|---|---|
| `NotRegisteredError` | resolving a type nothing is registered for |
| `DispensaryNotFoundError` | loading a dispensary that was never created |
| `DuplicateRegistrationError` | registering the same type twice in one dispensary |
| `DependencyCycleError` | a registration depends on itself (directly or via a chain) |

```dart
try {
  WitchDoctor.resolve<UserRepo>();
} on NotRegisteredError catch (e) {
  print(e.message);
}
```

`DependencyCycleError` reports the offending chain, e.g. `A -> B -> A`.
