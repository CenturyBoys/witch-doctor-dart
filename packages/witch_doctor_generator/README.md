# witch_doctor_generator

[![pub package](https://img.shields.io/pub/v/witch_doctor_generator.svg)](https://pub.dev/packages/witch_doctor_generator)

Build-time code generator for [`witch_doctor`](https://pub.dev/packages/witch_doctor).
It turns `@Remedy` annotations into type-safe dependency registrations so you get
zero-boilerplate wiring — without giving up the option to register by hand.

This package is a **dev dependency**. The runtime `witch_doctor` package has no
dependency on it, so apps that don't use annotations stay lean.

## Install

```yaml
dependencies:
  witch_doctor: ^2.0.0

dev_dependencies:
  witch_doctor_generator: ^2.0.0
  build_runner: ^2.11.0
```

## Use

Annotate classes with `@Remedy` (see the `witch_doctor` README for details), then:

```bash
dart run build_runner build
```

The generator scans the package and emits a single `lib/witch_doctor.init.dart`
exposing `initRemedies(Dispensary)`, which registers every annotated class and
auto-wires its constructor dependencies from the injector.

If a constructor parameter is not an injectable type, the build fails with a
clear message pointing you to register that class manually.

## License

[Apache 2.0](LICENSE) © CenturyBoys
