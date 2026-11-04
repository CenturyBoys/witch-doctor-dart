import 'package:witch_doctor/witch_doctor.dart';

import 'greeter.dart';

/// A service that depends on a [Greeter].
///
/// `@Remedy()` (factory scope) makes the generator wire [greeter] by resolving
/// it from the injector — no manual registration code needed.
@Remedy()
class GreetingService {
  GreetingService(this.greeter);

  final Greeter greeter;

  String greet() => greeter.greet();
}
