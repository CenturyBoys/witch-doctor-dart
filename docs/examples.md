# Examples

A runnable example lives in the repository under
[`packages/witch_doctor/example`](https://github.com/CenturyBoys/witch-doctor-dart/tree/main/packages/witch_doctor/example).

## Layered wiring

```dart
WitchDoctor.dispensary()
  ..registerLazySingleton<Db>((i) => Db(connectionString))
  ..registerFactory<UserRepo>((i) => UserRepo(i<Db>()))
  ..registerFactory<UserService>((i) => UserService(i<UserRepo>()));

WitchDoctor.load();

final service = WitchDoctor.resolve<UserService>();
```

## Environment-specific containers

```dart
void registerProd() {
  WitchDoctor.dispensary(name: 'prod')
    ..registerSingleton<Clock>(SystemClock())
    ..registerLazySingleton<Api>((i) => HttpApi(baseUrl));
}

void registerTest() {
  WitchDoctor.dispensary(name: 'test')
    ..registerSingleton<Clock>(FakeClock())
    ..registerSingleton<Api>(FakeApi());
}

void bootstrap({required bool isTest}) {
  registerProd();               // base wiring
  if (isTest) {
    registerTest();             // overrides Clock and Api (last-wins)
  }
  WitchDoctor.load(name: 'prod');
  if (isTest) WitchDoctor.load(name: 'test');
}
```

## Testing with `reset`

```dart
import 'package:test/test.dart';
import 'package:witch_doctor/witch_doctor.dart';

void main() {
  setUp(WitchDoctor.reset); // isolate every test

  test('resolves the registered implementation', () {
    WitchDoctor.dispensary().registerSingleton<Clock>(FakeClock());
    WitchDoctor.load();

    expect(WitchDoctor.resolve<Clock>(), isA<FakeClock>());
  });
}
```

## Resolving into a function with `inject`

An AOT-safe echo of the Python sibling's injection decorator — resolve several
dependencies and pass them to a body:

```dart
final report = inject((i) => buildReport(i<Repo>(), i<Logger>()));
```

## Annotation-based wiring

See [Annotations & codegen](annotations.md) for the `@Remedy` + `initRemedies`
flow that generates the registrations above for you.
