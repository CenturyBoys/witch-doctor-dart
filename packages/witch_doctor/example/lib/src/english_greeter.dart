import 'package:witch_doctor/witch_doctor.dart';

import 'greeter.dart';

/// An English implementation of [Greeter].
///
/// `@singleton` makes the generator bind it to [Greeter] as a single shared
/// instance.
@Remedy(scope: Scope.singleton, as: Greeter)
class EnglishGreeter implements Greeter {
  @override
  String greet() => 'Hello from Witch Doctor!';
}
