import 'package:witch_doctor/witch_doctor.dart';
import 'package:test/test.dart';

import 'class_test.dart';

void main() {
  group('WitchDoctor', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('Singleton witch doctor instance', () {
      expect(identical(WitchDoctor(), WitchDoctor()), isTrue);
    });

    test('Error on load not registered container', () {
      expect(() => WitchDoctor.load(name: "container_name_a"), throwsException);
    });

    test('Singleton container same name', () {
      bool sameName = identical(
          WitchDoctor.getContainer(name: "container_name_a"),
          WitchDoctor.getContainer(name: "container_name_a"));
      expect(sameName, isTrue);
    });

    test('Singleton container different name', () {
      bool diffName = identical(
          WitchDoctor.getContainer(name: "container_name_a"),
          WitchDoctor.getContainer(name: "container_name_b"));
      expect(diffName, isFalse);
    });

    test('Error on resolve not registered type', () {
      expect(() => WitchDoctor.resolve<bool>(), throwsException);
    });

    test('Error on register wrong types', () {
      TopHatContainer container =
          WitchDoctor.getContainer(name: "container_name_a");
      expect(
          () => {
                container.register<InterfaceA>(
                    InjectionType.factory, ImplCPythonPoison())
              },
          throwsException);
    });

    test('Register new container and resolve it', () {
      TopHatContainer container =
          WitchDoctor.getContainer(name: "container_name_b");
      container.register<InterfaceA>(
          InjectionType.factory, ImplAPythonPoison(), [10, 20]);
      WitchDoctor.load(name: "container_name_b");
      expect(WitchDoctor.resolve<InterfaceA>().sum() == 30, isTrue);
    });

    test('Test container load overflow with replacement', () {
      TopHatContainer containerC =
          WitchDoctor.getContainer(name: "container_name_c");
      containerC.register<InterfaceA>(
          InjectionType.factory, ImplAPythonPoison(), [10, 20]);

      TopHatContainer containerD =
          WitchDoctor.getContainer(name: "container_name_d");
      containerD.register<InterfaceA>(
          InjectionType.factory, ImplBPythonPoison(), [10, 20]);

      WitchDoctor.load(name: "container_name_c");
      expect(WitchDoctor.resolve<InterfaceA>().sum() == 30, isTrue);

      WitchDoctor.load(name: "container_name_d");
      expect(WitchDoctor.resolve<InterfaceA>().sum() == -10, isTrue);
    });

    test('Test container load overflow aggregated', () {
      TopHatContainer containerE =
          WitchDoctor.getContainer(name: "container_name_e");
      containerE.register<InterfaceA>(
          InjectionType.factory, ImplAPythonPoison(), [10, 20]);

      TopHatContainer containerF =
          WitchDoctor.getContainer(name: "container_name_f");
      containerF.register<InterfaceB>(
          InjectionType.factory, ImplCPythonPoison(), [10, 20]);

      WitchDoctor.load(name: "container_name_e");
      WitchDoctor.load(name: "container_name_f");

      expect(WitchDoctor.resolve<InterfaceA>().sum() == 30, isTrue);
      expect(WitchDoctor.resolve<InterfaceB>().sum() == 200, isTrue);
    });
  });
}
