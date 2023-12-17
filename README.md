<img src="https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.pinimg.com%2Foriginals%2Fe6%2Fff%2F86%2Fe6ff86db1ad224c37d328579786e13f3.jpg&f=1&nofb=1&ipt=448de94a888dd920ca7383f804f09f69d49ad4d226d9bee06115bbc9b188e1d2&ipo=images" alt="drawing" style="width:400px;display: block;  margin-left: auto;margin-right: auto;"/>
By: CenturyBoys

# Witch-doctor

A code generator for dependency injection.

Main concept:

- Container how you will be able to register interfaces, implementation, injection type, `params` and `namedParams` scoped by his name.
- Generator this will create all necessary base code for your possibles injectable classes.

## Generator

This lib need generate the base code for the possibles injectable classes, witch_doctor have his on builder `witchDoctorFactory` how will use the annotation `@Antibiotic()` to generate the injection code. 

You need to add `source_gen` and `build_runner` in your _dev_dependencies_ and run `dart pub get`.

In your class file you need to add the part import and annotated your class.

```dart
part 'your_class_file_name.g.dart';

abstract class Interface {
  int sum();
}

@Antibiotic()
class Impl extends Interface {
  int a;
  int b;

  Impl(this.a, this.b);

  @override
  int sum() {
    return a + b;
  }
}
```

Go a head and generate the code, for that run `dart run build_runner build`.

Now, if all runs ok you will find a new file in the current file path with the name `your_class_file_name.g.dart` with the class `YourClassNamePythonPoison`.


## Container

You must register your injections using containers. The method `getContainer` will provide a container register  with a register method. The containers are scoped by name, if no name are provide they will use the default container. see below the signature:

```dart
class TopHatContainer{
  void register<T>(
      InjectionType injectionType, 
      PythonPoison instanceCallback,
      [
        List<dynamic> params = const [],
        Map<Symbol, dynamic>? namedParams = const {}
      ]
      );
}
```

- The interface and implementation inheritance will be checked and will raise an Exception if was some issue. PythonPoison class must be from an extended class of type `T`.
- The injection type will be checked and will raise an Exception if was some issue. There are two types the singleton and factory types, the singleton will return the same instance for all injection and the factory will return a new instance for each injection.


You create a container and registered it out and now? 

To use the container you need to load it using `load` method. The current container is a flat aggregation of loaded containers, it means that if you have to containers with the same abstract class registered but with different implementations, and you loaded both containers the last container loaded will overwrite the previous one.

```dart
import 'package:witch_doctor/src/witch_doctor_container.dart';
import 'package:witch_doctor/witch_doctor.dart';

part 'your_class_file_name.g.dart';

abstract class InterfaceA {
  int sum();
}

@Antibiotic()
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

  // Register <Interface> passing the injection type, pythonPoison, default params and named params
  container.register<InterfaceA>(InjectionType.factory, ImplAPythonPoison(),  [10], {"b": 20});

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