# witch_doctor example

A tiny runnable example showing both ways to wire dependencies.

```bash
dart pub get
dart run build_runner build   # generates lib/witch_doctor.init.dart
dart run lib/example.dart
```

Expected output:

```
Hello from Witch Doctor!
Greeter is a singleton: true
```

- `lib/src/*.dart` — a `Greeter` interface, an `EnglishGreeter` implementation
  (`@Remedy` singleton), and a `GreetingService` (`@Remedy` factory) that depends
  on `Greeter`.
- `lib/example.dart` — shows annotation-based wiring via `initRemedies`, with the
  equivalent manual registration shown in comments.
