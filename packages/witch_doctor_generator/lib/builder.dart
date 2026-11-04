/// Entry point exposing the witch_doctor code generator to `build_runner`.
library;

import 'package:build/build.dart';

import 'src/remedy_init_builder.dart';

/// Builder factory referenced by `build.yaml`.
Builder witchDoctorGenerator(BuilderOptions options) => RemedyInitBuilder();
