# Witch Doctor

> _"Which doctor you expecting?"_

A simple, **type-safe dependency injection** library for Dart. Register
implementations as closures, scope them in named containers, and resolve them
anywhere — with **no code generation required**. Add the optional
`witch_doctor_generator` when you want zero-boilerplate wiring.

Witch Doctor is the Dart sibling of the Python package
[`CenturyBoys/witch-doctor`](https://github.com/CenturyBoys/witch-doctor) and
shares its philosophy: explicit registration, validated bindings, injection
lifetimes, and named container scopes — kept small and predictable.

## Why Witch Doctor?

- **Type-safe, no magic.** The generic `<T>` is the resolution key; binding a
  non-subtype simply does not compile. No runtime reflection.
- **Zero runtime dependencies.** The core library pulls in nothing.
- **Code generation is optional.** Start with closures; adopt `@Remedy`
  annotations later — per class, your choice.
- **Scoped by design.** Named dispensaries compose and override registrations
  (last-wins), great for environments and tests.
- **Fails loudly, clearly.** A sealed error hierarchy and dependency-cycle
  detection replace cryptic runtime crashes.

## The two packages

| Package | Role | pub.dev |
|---|---|---|
| `witch_doctor` | Runtime DI container + annotations (zero deps) | [pub.dev/packages/witch_doctor](https://pub.dev/packages/witch_doctor) |
| `witch_doctor_generator` | Optional build-time code generator | [pub.dev/packages/witch_doctor_generator](https://pub.dev/packages/witch_doctor_generator) |

## Quick taste

```dart
import 'package:witch_doctor/witch_doctor.dart';

void main() {
  WitchDoctor.dispensary()
    ..registerSingleton<Greeter>(EnglishGreeter())
    ..registerFactory<GreetingService>((i) => GreetingService(i<Greeter>()));

  WitchDoctor.load();

  print(WitchDoctor.resolve<GreetingService>().run()); // Hello!
}
```

Ready? Head to [Getting started](getting-started.md).
