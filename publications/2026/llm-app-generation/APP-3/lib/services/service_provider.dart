import 'package:apex_altimeter/services/barometer_service.dart';
import 'package:apex_altimeter/services/gps_service.dart';
import 'package:apex_altimeter/services/imu_service.dart';
import 'package:apex_altimeter/services/export_service.dart';
import 'package:apex_altimeter/services/session_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceProvider extends StatelessWidget {
  final Widget child;

  const ServiceProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<BarometerService>(
          create: (_) => BarometerService(),
        ),
        Provider<GpsService>(
          create: (_) => GpsService(),
        ),
        Provider<ImuService>(
          create: (_) => ImuService(),
        ),
        ChangeNotifierProvider<SessionService>(
          create: (_) => SessionService(),
        ),
        Provider<ExportService>(
          create: (_) => ExportService(),
        ),
      ],
      child: child,
    );
  }
}