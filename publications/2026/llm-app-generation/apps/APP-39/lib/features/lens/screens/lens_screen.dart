import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../widgets/lens_camera_view.dart';
import '../widgets/lens_mode_selector.dart';
import '../widgets/lens_results_overlay.dart';

class LensScreen extends StatefulWidget {
  const LensScreen({super.key});

  @override
  State<LensScreen> createState() => _LensScreenState();
}

class _LensScreenState extends State<LensScreen> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _hasPermission = false;
  String _selectedMode = 'Search';
  bool _isProcessing = false;
  List<LensResult> _results = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    // Request camera permission
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      setState(() {
        _hasPermission = false;
      });
      return;
    }

    setState(() {
      _hasPermission = true;
    });

    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _cameraController = CameraController(
          _cameras.first,
          ResolutionPreset.high,
          enableAudio: false,
        );

        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera View
            if (_isCameraInitialized && _cameraController != null)
              LensCameraView(
                controller: _cameraController!,
                onCapture: _captureAndAnalyze,
              )
            else if (!_hasPermission)
              _buildPermissionDenied()
            else
              _buildLoadingView(),

            // Top Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Google Lens',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _openGallery,
                      icon: const Icon(
                        Icons.photo_library,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Mode Selector
            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: LensModeSelector(
                selectedMode: _selectedMode,
                onModeChanged: (mode) {
                  setState(() {
                    _selectedMode = mode;
                    _results.clear();
                  });
                },
              ),
            ),

            // Capture Button
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _isProcessing ? null : _captureAndAnalyze,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                    ),
                    child: _isProcessing
                        ? const CircularProgressIndicator(
                            color: AppTheme.primaryBlue,
                          )
                        : const Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                            size: 32,
                          ),
                  ),
                ),
              ),
            ),

            // Results Overlay
            if (_results.isNotEmpty)
              LensResultsOverlay(
                results: _results,
                mode: _selectedMode,
                onClose: () {
                  setState(() {
                    _results.clear();
                  });
                },
              ),

            // Processing Overlay
            if (_isProcessing)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      Text(
                        'Analyzing image...',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionDenied() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 64,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Text(
              'Camera Permission Required',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              'Google Lens needs camera access to identify objects and text',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.largePadding),
            ElevatedButton(
              onPressed: () async {
                await openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _captureAndAnalyze() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final image = await _cameraController!.takePicture();
      
      // Simulate processing delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock results based on selected mode
      final results = _generateMockResults(_selectedMode);
      
      if (mounted) {
        setState(() {
          _results = results;
          _isProcessing = false;
        });
      }
    } catch (e) {
      debugPrint('Error capturing image: $e');
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _openGallery() {
    // In a real app, you would use image_picker to select from gallery
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gallery'),
        content: const Text('Gallery selection feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  List<LensResult> _generateMockResults(String mode) {
    switch (mode) {
      case 'Translate':
        return [
          LensResult(
            id: '1',
            type: LensResultType.translation,
            title: 'Translation',
            description: 'Hello World',
            confidence: 0.95,
            boundingBox: const Rect.fromLTWH(100, 200, 200, 50),
          ),
        ];
      case 'Text':
        return [
          LensResult(
            id: '1',
            type: LensResultType.text,
            title: 'Text Recognition',
            description: 'Sample text detected in image',
            confidence: 0.92,
            boundingBox: const Rect.fromLTWH(50, 150, 300, 100),
          ),
        ];
      case 'Shopping':
        return [
          LensResult(
            id: '1',
            type: LensResultType.product,
            title: 'Similar Products',
            description: 'Found 5 similar items online',
            confidence: 0.88,
            boundingBox: const Rect.fromLTWH(80, 180, 240, 200),
          ),
        ];
      default: // Search
        return [
          LensResult(
            id: '1',
            type: LensResultType.object,
            title: 'Object Detected',
            description: 'This appears to be a common household item',
            confidence: 0.85,
            boundingBox: const Rect.fromLTWH(120, 160, 160, 180),
          ),
        ];
    }
  }
}

class LensResult {
  final String id;
  final LensResultType type;
  final String title;
  final String description;
  final double confidence;
  final Rect boundingBox;

  const LensResult({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.confidence,
    required this.boundingBox,
  });
}

enum LensResultType {
  object,
  text,
  translation,
  product,
  landmark,
  plant,
  animal,
}