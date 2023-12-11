import 'package:witch_doctor/witch_doctor.dart';

import 'src/impl.dart';
import 'src/interface.dart';

void main() {
  // Creating container with name container_name_b
  TopHatContainer container = WitchDoctor.getContainer(name: "container_name");

  // Register <Interface, Implementation> passing the injection type and default args
  container.register<Interface>(
      InjectionType.factory, ImplPythonPoison(), [10, 20], {});

  // Load container
  WitchDoctor.load(name: "container_name");

  // Resolve instance using his interface
  Interface instance = WitchDoctor.resolve<Interface>();

  // Calling abstract method sum from implementation
  int value = instance.sum();

  print('value: $value');
}
