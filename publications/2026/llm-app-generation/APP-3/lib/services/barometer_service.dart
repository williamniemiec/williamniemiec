import 'package:flutter_barometer/flutter_barometer.dart';
import 'dart:async';
import 'package:vector_math/vector_math.dart';

class BarometerService {
  Stream<double> get pressureStream =>
      flutterBarometerEvents.map((event) => event.pressure);

  double getAltitude(double pressure, double seaLevelPressure) {
    // Simplified conversion from pressure to altitude
    return (1 - (pressure / seaLevelPressure)) * 44330.0;
  }
}