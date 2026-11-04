import 'remedy.dart';

/// Deprecated alias for [Remedy], kept for a smoother 1.x → 2.x migration.
///
/// Replace `@Antibiotic()` with `@Remedy()`. This alias will be removed in a
/// future major release.
@Deprecated(
  'Use @Remedy instead. Antibiotic will be removed in a future release.',
)
typedef Antibiotic = Remedy;
