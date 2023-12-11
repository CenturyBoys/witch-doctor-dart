import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:witch_doctor/src/factory.dart';

Builder witchDoctorFactory(BuilderOptions options) {
  return SharedPartBuilder([MedicineFactory()], 'witch_doctor');
}
