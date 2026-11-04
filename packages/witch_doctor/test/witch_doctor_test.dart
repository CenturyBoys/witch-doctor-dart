import 'package:test/test.dart';
import 'package:witch_doctor/witch_doctor.dart';

import 'fixtures.dart';

void main() {
  // Reset global state between tests so nothing leaks.
  setUp(WitchDoctor.reset);

  group('WitchDoctor singleton', () {
    test('is a single instance', () {
      expect(identical(WitchDoctor(), WitchDoctor()), isTrue);
      expect(identical(WitchDoctor(), WitchDoctor.instance), isTrue);
    });
  });

  group('Dispensary', () {
    test('same name returns the same dispensary', () {
      expect(
        identical(
          WitchDoctor.dispensary(name: 'a'),
          WitchDoctor.dispensary(name: 'a'),
        ),
        isTrue,
      );
    });

    test('different names return different dispensaries', () {
      expect(
        identical(
          WitchDoctor.dispensary(name: 'a'),
          WitchDoctor.dispensary(name: 'b'),
        ),
        isFalse,
      );
    });

    test('registering the same type twice throws', () {
      final d = WitchDoctor.dispensary()..registerFactory<Animal>((i) => Dog());
      expect(
        () => d.registerFactory<Animal>((i) => Cat()),
        throwsA(isA<DuplicateRegistrationError>()),
      );
    });

    test('isRegistered reflects registrations', () {
      final d = WitchDoctor.dispensary();
      expect(d.isRegistered<Animal>(), isFalse);
      d.registerFactory<Animal>((i) => Dog());
      expect(d.isRegistered<Animal>(), isTrue);
    });
  });

  group('load', () {
    test('throws when the dispensary was never created', () {
      expect(
        () => WitchDoctor.load(name: 'missing'),
        throwsA(isA<DispensaryNotFoundError>()),
      );
    });

    test('last loaded dispensary wins on conflicts', () {
      WitchDoctor.dispensary(
        name: 'dogs',
      ).registerFactory<Animal>((i) => Dog());
      WitchDoctor.dispensary(
        name: 'cats',
      ).registerFactory<Animal>((i) => Cat());

      WitchDoctor.load(name: 'dogs');
      expect(WitchDoctor.resolve<Animal>().speak(), 'woof');

      WitchDoctor.load(name: 'cats');
      expect(WitchDoctor.resolve<Animal>().speak(), 'meow');
    });

    test('loading disjoint dispensaries aggregates them', () {
      WitchDoctor.dispensary(name: 'a').registerSingleton<Engine>(Engine());
      WitchDoctor.dispensary(name: 'b').registerFactory<Animal>((i) => Dog());

      WitchDoctor.load(name: 'a');
      WitchDoctor.load(name: 'b');

      expect(WitchDoctor.resolve<Engine>(), isA<Engine>());
      expect(WitchDoctor.resolve<Animal>(), isA<Dog>());
    });
  });

  group('resolve', () {
    test('throws for an unregistered type', () {
      expect(
        () => WitchDoctor.resolve<Animal>(),
        throwsA(isA<NotRegisteredError>()),
      );
    });

    test('factory returns a new instance each time', () {
      WitchDoctor.dispensary().registerFactory<Animal>((i) => Dog());
      WitchDoctor.load();
      expect(
        identical(WitchDoctor.resolve<Animal>(), WitchDoctor.resolve<Animal>()),
        isFalse,
      );
    });

    test('singleton returns the same instance each time', () {
      WitchDoctor.dispensary().registerSingleton<Engine>(Engine());
      WitchDoctor.load();
      expect(
        identical(WitchDoctor.resolve<Engine>(), WitchDoctor.resolve<Engine>()),
        isTrue,
      );
    });

    test('lazy singleton is created once, on first resolve', () {
      var builds = 0;
      WitchDoctor.dispensary().registerLazySingleton<Engine>((i) {
        builds++;
        return Engine();
      });
      WitchDoctor.load();
      expect(builds, 0, reason: 'not built until first resolve');
      final first = WitchDoctor.resolve<Engine>();
      final second = WitchDoctor.resolve<Engine>();
      expect(builds, 1);
      expect(identical(first, second), isTrue);
    });

    test('a factory resolves its own dependencies from the injector', () {
      WitchDoctor.dispensary()
        ..registerSingleton<Engine>(Engine())
        ..registerFactory<Car>((i) => Car(i<Engine>()));
      WitchDoctor.load();

      final car = WitchDoctor.resolve<Car>();
      expect(identical(car.engine, WitchDoctor.resolve<Engine>()), isTrue);
    });

    test('tryResolve returns null instead of throwing', () {
      expect(WitchDoctor.tryResolve<Animal>(), isNull);
      WitchDoctor.dispensary().registerFactory<Animal>((i) => Dog());
      WitchDoctor.load();
      expect(WitchDoctor.tryResolve<Animal>(), isA<Dog>());
    });

    test('callable shorthand resolves like resolve()', () {
      WitchDoctor.dispensary().registerSingleton<Engine>(Engine());
      WitchDoctor.load();
      final wd = WitchDoctor.instance;
      expect(identical(wd<Engine>(), WitchDoctor.resolve<Engine>()), isTrue);
    });
  });

  group('dependency cycles', () {
    test('resolving a cycle throws DependencyCycleError', () {
      WitchDoctor.dispensary()
        ..registerFactory<Chicken>((i) => Chicken(i<Egg>()))
        ..registerFactory<Egg>((i) => Egg(i<Chicken>()));
      WitchDoctor.load();

      expect(
        () => WitchDoctor.resolve<Chicken>(),
        throwsA(isA<DependencyCycleError>()),
      );
    });

    test('the resolution stack recovers after a thrown cycle', () {
      WitchDoctor.dispensary()
        ..registerFactory<Chicken>((i) => Chicken(i<Egg>()))
        ..registerFactory<Egg>((i) => Egg(i<Chicken>()))
        ..registerSingleton<Engine>(Engine());
      WitchDoctor.load();

      expect(() => WitchDoctor.resolve<Chicken>(), throwsA(anything));
      // A later, unrelated resolve must still work.
      expect(WitchDoctor.resolve<Engine>(), isA<Engine>());
    });
  });

  group('inject helper', () {
    test('passes the graph so dependencies can be pulled', () {
      WitchDoctor.dispensary().registerSingleton<Engine>(Engine());
      WitchDoctor.load();

      final revs = inject((i) => i<Engine>().revs);
      expect(revs, 0);
    });
  });
}
