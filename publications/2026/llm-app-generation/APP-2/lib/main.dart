import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'barcode_painter.dart';

void main() {
  runApp(const SwiftScanApp());
}

class SwiftScanApp extends StatelessWidget {
  const SwiftScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwiftScan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ScanningScreen(),
    );
  }
}

class ScanningScreen extends StatefulWidget {
  const ScanningScreen({super.key});

  @override
  _ScanningScreenState createState() => _ScanningScreenState();
}

class _ScanningScreenState extends State<ScanningScreen> {
  CameraController? _cameraController;
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  bool _isScanning = false;
  final Set<String> _scannedCodes = {};
  final Set<String> _duplicateCodes = {};
  String _lastScannedCode = '';
  Timer? _scanTimer;
  List<Barcode> _barcodes = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _cameraController = CameraController(
      firstCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  void _startStopSession() {
    setState(() {
      _isScanning = !_isScanning;
      if (_isScanning) {
        _startStreaming();
      } else {
        _stopStreaming();
      }
    });
  }

  void _startStreaming() {
    _scanTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (!_isScanning) {
        timer.cancel();
        return;
      }
      _cameraController?.startImageStream((image) {
        _processImage(image);
      });
    });
  }

  void _stopStreaming() {
    _scanTimer?.cancel();
    _cameraController?.stopImageStream();
  }

  Future<void> _processImage(CameraImage image) async {
    final InputImage inputImage = InputImage.fromBytes(
      bytes: image.planes[0].bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation0deg,
        format: InputImageFormat.nv21,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );

    final List<Barcode> barcodes = await _barcodeScanner.processImage(inputImage);

    for (Barcode barcode in barcodes) {
      final String? code = barcode.rawValue;
      if (code != null) {
        if (_scannedCodes.add(code)) {
          HapticFeedback.lightImpact();
          setState(() {
            _lastScannedCode = code;
          });
        } else {
          _duplicateCodes.add(code);
        }
      }
    }
    setState(() {
      _barcodes = barcodes;
    });
  }

  void _clearList() {
    setState(() {
      _scannedCodes.clear();
      _duplicateCodes.clear();
      _lastScannedCode = '';
    });
  }

  Future<void> _exportData() async {
    final List<List<String>> csvData = [
      ['Scanned Codes'],
      ..._scannedCodes.map((code) => [code]),
    ];

    final String csv = const ListToCsvConverter().convert(csvData);
    final String timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final String fileName = 'Scan-$timestamp.csv';
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final File file = File(filePath);
    await file.writeAsString(csv);

    Share.shareXFiles([XFile(filePath)], text: 'SwiftScan Data');
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _barcodeScanner.close();
    _scanTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _cameraController == null || !_cameraController!.value.isInitialized
              ? const Center(child: CircularProgressIndicator())
              : CameraPreview(_cameraController!),
          CustomPaint(
            painter: BarcodePainter(
              barcodes: _barcodes,
              scannedCodes: _scannedCodes,
              imageSize: _cameraController!.value.previewSize!,
            ),
          ),
          _buildDataPanel(),
          _buildControlBar(),
        ],
      ),
    );
  }

  Widget _buildDataPanel() {
    return Positioned(
      bottom: 80,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.black.withOpacity(0.5),
        child: Column(
          children: [
            Text(
              'Unique Scans: ${_scannedCodes.length}',
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Duplicate Scans: ${_duplicateCodes.length}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Last Scanned: $_lastScannedCode',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        color: Colors.black.withOpacity(0.7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _startStopSession,
              child: Text(_isScanning ? 'Pause Session' : 'Start Session'),
            ),
            ElevatedButton(
              onPressed: _clearList,
              child: const Text('Clear List'),
            ),
            ElevatedButton(
              onPressed: _exportData,
              child: const Text('Export'),
            ),
          ],
        ),
      ),
    );
  }
}
