# AGENTS.md

Canonical guide for humans **and** AI agents working in this repository. Other
assistant config files (for example `CLAUDE.md`) defer to this document — if
anything disagrees, this file wins.

## Project overview

Witch Doctor is a simple, type-safe **dependency injection** library and code
generator for Dart. It is the Dart sibling of the Python package
[`CenturyBoys/witch-doctor`](https://github.com/CenturyBoys/witch-doctor) and
shares its core ideas: explicit registration with validation, `singleton` vs
`factory` lifetimes, and named container scopes.

This is a **pub workspace** (monorepo) with two published packages:

| Package | Path | Role |
|---|---|---|
| `witch_doctor` | `packages/witch_doctor` | Runtime DI container + annotations. **Zero** production dependencies. |
| `witch_doctor_generator` | `packages/witch_doctor_generator` | Build-time code generator. Used as a `dev_dependency`. |

The example app lives in `packages/witch_doctor/example`.

## Repository layout

```
pubspec.yaml                      # workspace root (publish_to: none)
analysis_options.yaml             # lints shared by every package
packages/
  witch_doctor/
    lib/witch_doctor.dart         # public export surface
    lib/src/                      # dispensary, witch_doctor, injector, scope, errors, remedy, antibiotic(deprecated)
    test/
    example/                      # runnable example (@Remedy + manual wiring)
  witch_doctor_generator/
    lib/builder.dart              # build_runner entry point
    lib/src/remedy_init_builder.dart
    build.yaml
```

## Commands

Run from the repository root (the workspace resolves all packages together):

```bash
dart pub get                      # resolve the whole workspace
dart analyze                      # static analysis (run per package or at root)
dart format .                     # format
dart test                         # run tests (cd packages/witch_doctor)
```

Regenerate the example's injection code:

```bash
cd packages/witch_doctor/example
dart run build_runner build       # writes lib/witch_doctor.init.dart
```

## Architecture (v2)

- `WitchDoctor` — global singleton. Holds named `Dispensary` instances and a
  single merged graph. `dispensary()`, `load()` (last-wins merge), `resolve()`,
  `tryResolve()`, `reset()`, and a callable shorthand via `WitchDoctor.instance`.
- `Dispensary` — a named, scoped set of registrations: `registerFactory`,
  `registerSingleton`, `registerLazySingleton` (+ themed aliases `prescribe`,
  `remedy`, `lazyRemedy`). The generic `<T>` is the resolution key, so binding a
  non-subtype simply does not compile.
- `Injector` — read-only graph view passed into every factory closure so a
  registration can resolve its own dependencies.
- `Scope` / `Remedy` — the optional `@Remedy` annotation drives build-time
  auto-wiring; the generator emits one `initRemedies(Dispensary)` per package.
- `WitchDoctorError` — sealed error hierarchy; resolution detects cycles.

Never reintroduce `dart:mirrors` — AOT/Flutter forbid it (removed in 1.1.0).

## Contribution rules (hard requirements)

### Git flow — follow it strictly

- Branch off `develop` for features: `feature/<short-description>`.
- Branch off `main` for urgent fixes: `hotfix/<short-description>`.
- Prepare releases on `release/<version>` cut from `develop`.
- Open PRs into `develop` (or into `main` for hotfixes). Never commit directly
  to `main` or `develop`.

### Conventional Commits — required

Format: `type(optional-scope): summary`. Allowed types:
`feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`,
`chore`, `revert`. Use `!` or a `BREAKING CHANGE:` footer for breaking changes.

Examples: `feat(dispensary): add lazy singletons`, `fix: guard empty graph`.

### Commit authorship — no AI co-authors

Commits in this repository MUST NOT include AI co-author trailers. Do **not**
add `Co-Authored-By:` lines for Claude, Copilot, or any other assistant, and do
not add AI-generated footers to commit messages or PR descriptions. Commits are
attributed to the human author only.

### Code style

- `dart format .` must produce no changes.
- `dart analyze` must be clean (lints in the root `analysis_options.yaml`).
- Document every public member with dartdoc (`///`).
- Prefer single quotes and ordered directives (enforced by lints).

### Tests

- Add/adjust tests in `packages/witch_doctor/test` for any behaviour change.
- Tests call `WitchDoctor.reset()` in `setUp` to stay isolated.
- `dart test` must pass before opening a PR.

## Documentation

- The published, pub.dev-facing docs are the package `README.md` files,
  `MIGRATION.md`, and the dartdoc on every public member.
- The documentation **site** lives in `docs/` (MkDocs Material, config in
  `mkdocs.yml`). Build it locally with `pip install mkdocs-material && mkdocs serve`.
- `.github/workflows/docs.yml` builds the site plus the `dart doc` API reference
  and deploys both to GitHub Pages on pushes to `main` (API served under `/api/`).
- Keep the site pages in `docs/` in sync with the READMEs when the public API
  changes.

## Release process

1. Bump the package `version` and add a `CHANGELOG.md` entry (both packages if
   both changed).
2. Merge to `main` via a `release/` PR.
3. Push a version tag; CI publishes to pub.dev via OIDC (no secrets). See
   `.github/workflows/publish.yml` and `CONTRIBUTING.md`.
