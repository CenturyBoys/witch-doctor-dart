# Annotations & code generation

Code generation is **optional**. When you want to skip the manual registration
closures, add `witch_doctor_generator`, annotate your classes with `@Remedy`,
and let the generator wire constructor dependencies for you.

## Setup

```yaml
dependencies:
  witch_doctor: ^2.0.0

dev_dependencies:
  witch_doctor_generator: ^2.0.0
  build_runner: ^2.11.0
```

## Annotate

```dart
import 'package:witch_doctor/witch_doctor.dart';

abstract interface class Greeter {
  String greet();
}

@Remedy(scope: Scope.singleton, as: Greeter) // (1)!
class EnglishGreeter implements Greeter {
  @override
  String greet() => 'Hello from Witch Doctor!';
}

@Remedy() // (2)!
class GreetingService {
  GreetingService(this.greeter); // (3)!
  final Greeter greeter;
  String greet() => greeter.greet();
}
```

1. Registered as a shared instance, bound to the `Greeter` interface.
2. Factory scope (the default). A new instance per resolve.
3. `greeter` is auto-resolved from the injector — no wiring code needed.

`@Remedy` options:

| Field | Meaning | Default |
|---|---|---|
| `scope` | `Scope.transient` / `singleton` / `lazySingleton` | `transient` |
| `as` | interface to register under | the class itself |
| `container` | named dispensary hint | default dispensary |

Convenience annotations `@singleton` and `@lazySingleton` are shorthands for the
matching scope.

## Generate

```bash
dart run build_runner build
```

The generator scans the package and emits a single `lib/witch_doctor.init.dart`
with an `initRemedies(Dispensary)` function:

```dart
// GENERATED
void initRemedies(Dispensary dispensary) {
  dispensary.registerLazySingleton<Greeter>((i) => EnglishGreeter());
  dispensary.registerFactory<GreetingService>((i) => GreetingService(i<Greeter>()));
}
```

## Use

```dart
import 'witch_doctor.init.dart';

void main() {
  initRemedies(WitchDoctor.dispensary());
  WitchDoctor.load();
  final service = WitchDoctor.resolve<GreetingService>();
}
```

!!! warning "Only injectable parameters are auto-wired"
    If a constructor parameter is not a registered type (e.g. a plain `int` or
    `String`), the build fails with a clear message. Register those classes by
    hand with `registerFactory` / `registerSingleton` instead.

!!! note "Annotation singletons are lazy"
    An annotated `Scope.singleton` is generated as a shared instance created
    lazily on first resolve, so its dependencies resolve from the loaded graph.
