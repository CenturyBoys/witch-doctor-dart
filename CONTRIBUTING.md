# Contributing to Witch Doctor

Thanks for helping! Please read [`AGENTS.md`](AGENTS.md) for the full project
guide; this document is the quick, human-facing checklist.

## Getting started

```bash
git clone https://github.com/CenturyBoys/witch-doctor-dart.git
cd witch-doctor-dart
dart pub get            # resolves the whole workspace
dart analyze
cd packages/witch_doctor && dart test
```

## Branching — GitFlow

We follow GitFlow strictly:

- `main` — released, production code. Never commit to it directly.
- `develop` — integration branch. Never commit to it directly.
- `feature/<name>` — new work, branched from `develop`, merged back into `develop`.
- `release/<version>` — release prep, branched from `develop`, merged into `main` and `develop`.
- `hotfix/<name>` — urgent fixes, branched from `main`, merged into `main` and `develop`.

```bash
git checkout develop && git pull
git checkout -b feature/my-change
```

## Commits — Conventional Commits

Every commit message follows `type(scope): summary`. Allowed types: `feat`,
`fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`,
`revert`. Mark breaking changes with `!` or a `BREAKING CHANGE:` footer.

**Do not add AI co-author trailers** (`Co-Authored-By:` for any assistant) or
AI-generated footers. Commits are attributed to the human author only.

Enable the git hooks (format + analyze + commit-message linting):

```bash
pip install pre-commit && pre-commit install --hook-type pre-commit --hook-type commit-msg
```

## Before opening a PR

- [ ] `dart format .` produces no changes.
- [ ] `dart analyze` is clean.
- [ ] `dart test` passes.
- [ ] The example still builds: `cd packages/witch_doctor/example && dart run build_runner build`.
- [ ] Public API changes are documented with dartdoc and noted in the relevant `CHANGELOG.md`.
- [ ] Your branch follows GitFlow and your commits follow Conventional Commits.

Open the PR against `develop` (or `main` for a `hotfix/`).

## Releasing (maintainers)

1. Cut `release/<version>` from `develop`; bump `version` and update
   `CHANGELOG.md` in the changed package(s).
2. Merge the release PR into `main` (and back into `develop`).
3. Push the version tag — CI publishes to pub.dev via OIDC
   (`.github/workflows/publish.yml`). No tokens/secrets are stored.
