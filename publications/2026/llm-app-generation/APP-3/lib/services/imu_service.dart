import 'dart:async';
import 'dart:math';
import 'package:motion_sensors/motion_sensors.dart';
import 'package:vector_math/vector_math.dart';

class ImuService {
  Stream<double> get inclineStream =>
      motionSensors.accelerometer.map((event) {
        final angle = atan(event.y / sqrt(pow(event.x, 2) + pow(event.z, 2)));
        return degrees(angle);
      });
}