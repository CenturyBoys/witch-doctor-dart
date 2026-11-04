# Getting started

## Install

For the simple, closure-based path you only need the runtime package:

```yaml
dependencies:
  witch_doctor: ^2.0.0
```

Add the generator only if you want annotation-based auto-wiring:

```yaml
dependencies:
  witch_doctor: ^2.0.0

dev_dependencies:
  witch_doctor_generator: ^2.0.0
  build_runner: ^2.11.0
```

Then:

```bash
dart pub get
```

## Your first injection (no code generation)

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
  // 1. Get a container and register implementations.
  WitchDoctor.dispensary()
    ..registerSingleton<Greeter>(EnglishGreeter())
    ..registerFactory<GreetingService>((i) => GreetingService(i<Greeter>()));

  // 2. Load the container into the active graph.
  WitchDoctor.load();

  // 3. Resolve anywhere.
  print(WitchDoctor.resolve<GreetingService>().run()); // Hello!
}
```

That's the whole lifecycle: **register → load → resolve**.

!!! tip "Why `(i) => ...`?"
    Every factory closure receives an [`Injector`](guide.md#resolving-dependencies)
    (`i`) so it can resolve its own dependencies from the graph —
    `GreetingService(i<Greeter>())` pulls the registered `Greeter`.

## Next steps

- [Guide](guide.md) — lifetimes, named scopes, dependency resolution, errors.
- [Annotations & codegen](annotations.md) — zero-boilerplate wiring with `@Remedy`.
- [Comparison](comparison.md) — how Witch Doctor stacks up against get_it, kiwi,
  injectable and riverpod.
