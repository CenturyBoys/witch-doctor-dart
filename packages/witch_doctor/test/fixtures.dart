// Plain test fixtures. The runtime library needs no code generation, so these
// are hand written.

abstract interface class Animal {
  String speak();
}

class Dog implements Animal {
  @override
  String speak() => 'woof';
}

class Cat implements Animal {
  @override
  String speak() => 'meow';
}

/// A dependency used to exercise injector-based resolution.
class Engine {
  int revs = 0;
}

class Car {
  Car(this.engine);

  final Engine engine;
}

/// A pair that depends on each other, used to exercise cycle detection.
class Chicken {
  Chicken(this.egg);
  final Egg egg;
}

class Egg {
  Egg(this.chicken);
  final Chicken chicken;
}
