<img src="https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2Fe6%2Fff%2F86%2Fe6ff86db1ad224c37d328579786e13f3.jpg&f=1&nofb=1&ipt=448de94a888dd920ca7383f804f09f69d49ad4d226d9bee06115bbc9b188e1d2&ipo=images" alt="drawing" style="width:400px;display: block;  margin-left: auto;margin-right: auto;"/>
By: CenturyBoys

# Witch-doctor

A simple dependency injection for dart.

Witch Doctor provides a container how you will be able to register interfaces, implementation, injection type, instance args and container name.

- The interface and implementation inheritance will be checked and will raise an Exception if was some issue.
- The injection type will be checked and will raise an Exception if was some issue. There are two types the singleton and factory types, the singleton will return the same instance for all injection and the factory will return a new instance for each injection.
- If no values was giving will not pass the args to the class constructor.
- The container name will segregate the injections by scopes.

## Container

You must register your injections using containers. The method `getContainer` will provide a container register  with a register method. The containers are scoped by name, if no name are provide the will use the default container. see below the signature:

```dart
class TopHatContainer{
    void register<T, B>(InjectionType injectionType, [List<dynamic> defaultArgs = const []])
}
```

The `T` type must be the abstract class and `B` must be his implementation.

You create a container and registered it out and now? 

To use the container you need to load it using `load` method. The current container is a flat aggregation of loaded containers, it means that if you have to containers with the same abstract class registered but with different implementations and you loaded both containers the last container loaded will overwrite the previous one.

```dart
import 'package:witch_doctor/src/witch_doctor_container.dart';
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
  TopHatContainer container =  WitchDoctor.getContainer(name: "container_name");

  // Register <Interface, Implementation> passing the injection type and default args
  container.register<InterfaceA, ImplA>(InjectionType.factory, [10, 20]);

  // Load container
  WitchDoctor.load(name: "container_name");

}


```
## Resolve

Witch Doctor can be called where you want for this use the resolve method. The abstract class signature will ber check and Witch Doctor will search on the registered interfaces to inject the dependencies.

```dart
class WitchDoctor{
  static T resolve<T>();
}
```

## Usage example

```dart
import 'package:witch_doctor/src/witch_doctor_container.dart';
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
  TopHatContainer container =  WitchDoctor.getContainer(name: "container_name");

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

```