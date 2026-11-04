# Witch Doctor (Dart)

[![CI](https://github.com/CenturyBoys/witch-doctor-dart/actions/workflows/ci.yml/badge.svg)](https://github.com/CenturyBoys/witch-doctor-dart/actions/workflows/ci.yml)
[![license: Apache 2.0](https://img.shields.io/github/license/CenturyBoys/witch-doctor-dart.svg)](LICENSE)

> _"Which doctor you expecting?"_

A simple, type-safe **dependency injection** library for Dart — the sibling of
the Python package [`CenturyBoys/witch-doctor`](https://github.com/CenturyBoys/witch-doctor).

This repository is a **pub workspace** (monorepo) with two published packages:

| Package | Description | pub.dev |
|---|---|---|
| [`witch_doctor`](packages/witch_doctor) | Runtime DI container + annotations. Zero runtime dependencies. | [![pub](https://img.shields.io/pub/v/witch_doctor.svg)](https://pub.dev/packages/witch_doctor) |
| [`witch_doctor_generator`](packages/witch_doctor_generator) | Optional build-time code generator (`@Remedy` → registrations). | [![pub](https://img.shields.io/pub/v/witch_doctor_generator.svg)](https://pub.dev/packages/witch_doctor_generator) |

👉 **Start with the [`witch_doctor` README](packages/witch_doctor/README.md).**

## Repository docs

- [AGENTS.md](AGENTS.md) — canonical guide for contributors and AI agents.
- [CONTRIBUTING.md](CONTRIBUTING.md) — GitFlow + Conventional Commits workflow.
- [MIGRATION.md](MIGRATION.md) — upgrading from 1.x to 2.0.
- [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) · [SECURITY.md](SECURITY.md)

## Developing

```bash
dart pub get                                   # resolve the whole workspace
dart analyze packages/*                        # static analysis
cd packages/witch_doctor && dart test          # run tests
cd packages/witch_doctor/example && dart run build_runner build
```

## License

[Apache 2.0](LICENSE) © CenturyBoys
