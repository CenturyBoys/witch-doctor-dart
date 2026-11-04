import 'package:witch_doctor/witch_doctor.dart';

import 'src/greeter.dart';
import 'src/greeting_service.dart';
import 'witch_doctor.init.dart';

void main() {
  final dispensary = WitchDoctor.dispensary();

  // Option A — annotation-based auto-wiring. `initRemedies` is generated from
  // the @Remedy annotations by `dart run build_runner build`.
  initRemedies(dispensary);

  // Option B — the same wiring by hand, no code generation required:
  // dispensary
  //   ..registerSingleton<Greeter>(EnglishGreeter())
  //   ..registerFactory<GreetingService>((i) => GreetingService(i<Greeter>()));

  WitchDoctor.load();

  final service = WitchDoctor.resolve<GreetingService>();
  print(service.greet()); // Hello from Witch Doctor!

  // The Greeter is a shared singleton; GreetingService is a new factory each time.
  final a = WitchDoctor.resolve<Greeter>();
  final b = WitchDoctor.resolve<Greeter>();
  print('Greeter is a singleton: ${identical(a, b)}'); // true
}
