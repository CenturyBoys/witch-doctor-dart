## 2.0.0

- Initial release of the dedicated generator package, extracted from
  `witch_doctor`.
- Aggregating builder that collects every `@Remedy` annotated class in a package
  and emits a single `lib/witch_doctor.init.dart` with an
  `initRemedies(Dispensary)` function.
- Auto-wires each constructor parameter by resolving it from the injector, and
  fails the build with a clear message when a parameter is not an injectable
  type.
