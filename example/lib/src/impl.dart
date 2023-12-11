import 'package:witch_doctor/witch_doctor.dart';

import 'interface.dart';

part 'impl.g.dart';

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
