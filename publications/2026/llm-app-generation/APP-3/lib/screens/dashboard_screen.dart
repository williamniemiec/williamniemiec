import 'dart:async';

import 'package:apex_altimeter/services/barometer_service.dart';
import 'package:apex_altimeter/services/gps_service.dart';
import 'package:apex_altimeter/services/imu_service.dart';
import 'package:apex_altimeter/services/session_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double _altitude = 0.0;
  double _pressure = 0.0;
  double _speed = 0.0;
  double _incline = 0.0;
  StreamSubscription<double>? _pressureSubscription;
  StreamSubscription<Position>? _positionSubscription;
  StreamSubscription<double>? _inclineSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final barometerService =
        Provider.of<BarometerService>(context, listen: false);
    final gpsService = Provider.of<GpsService>(context, listen: false);
    final imuService = Provider.of<ImuService>(context, listen: false);
    final sessionService = Provider.of<SessionService>(context, listen: false);

    _pressureSubscription ??=
        barometerService.pressureStream.listen((pressure) {
      setState(() {
        _pressure = pressure;
        _altitude = barometerService.getAltitude(pressure, 1013.25);
        if (sessionService.isRecording) {
          sessionService.addDataPoint({
            'timestamp': DateTime.now().toIso8601String(),
            'altitude': _altitude,
            'pressure': _pressure,
          });
        }
      });
    });
    _positionSubscription ??= gpsService.positionStream.listen((position) {
      setState(() {
        _speed = position.speed;
        if (sessionService.isRecording) {
          sessionService.addDataPoint({
            'timestamp': DateTime.now().toIso8601String(),
            'latitude': position.latitude,
            'longitude': position.longitude,
            'speed': _speed,
          });
        }
      });
    });
    _inclineSubscription ??= imuService.inclineStream.listen((incline) {
      setState(() {
        _incline = incline;
        if (sessionService.isRecording) {
          sessionService.addDataPoint({
            'timestamp': DateTime.now().toIso8601String(),
            'incline': _incline,
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _pressureSubscription?.cancel();
    _positionSubscription?.cancel();
    _inclineSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apex Altimeter'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPrimaryAltitudeDisplay(),
            const SizedBox(height: 24),
            _buildSecondaryDataModules(),
            const Spacer(),
            _buildStartRecordingButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryAltitudeDisplay() {
    return Column(
      children: [
        const Text(
          'ALTITUDE',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        Text(
          '${_altitude.toStringAsFixed(1)}m',
          style: const TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryDataModules() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _DataModule(
            label: 'AIR PRESSURE',
            value: '${_pressure.toStringAsFixed(1)} hPa'),
        _DataModule(
            label: 'SPEED', value: '${_speed.toStringAsFixed(1)} km/h'),
        _DataModule(label: 'INCLINE', value: '${_incline.toStringAsFixed(1)}%'),
      ],
    );
  }

  Widget _buildStartRecordingButton() {
    return Consumer<SessionService>(
      builder: (context, sessionService, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (sessionService.isRecording) {
                sessionService.stopRecording();
              } else {
                sessionService.startRecording();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  sessionService.isRecording ? Colors.red : Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              sessionService.isRecording ? 'Stop Recording' : 'Start Recording',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        );
      },
    );
  }
}

class _DataModule extends StatelessWidget {
  final String label;
  final String value;
  const _DataModule({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}