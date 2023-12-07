import 'package:witch_doctor/witch_doctor.dart';

abstract class InterfaceA {
  int sum();
}

class ImplA extends InterfaceA {
  int a;
  int b;

  ImplA(this.a, this.b);

  @override
  int sum() {
    return a + b;
  }
}

void main() {
  // Creating container with name container_name_b
  TopHatContainer container = WitchDoctor.getContainer(name: "container_name");

  // Register <Interface, Implementation> passing the injection type and default args
  container.register<InterfaceA, ImplA>(InjectionType.factory, [10, 20]);

  // Load container
  WitchDoctor.load(name: "container_name");

  // Resolve instance using his interface
  InterfaceA instance = WitchDoctor.resolve<InterfaceA>();

  // Calling abstract method sum from implementation
  int value = instance.sum();

  print('value: $value');
}
