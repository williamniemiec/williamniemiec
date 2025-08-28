import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool _isRecording = false;
  bool _isFlashOn = false;
  bool _isFrontCamera = false;
  double _recordingProgress = 0.0;

  final List<String> _effects = [
    'None',
    'Beauty',
    'Vintage',
    'Black & White',
    'Sepia',
    'Blur',
  ];

  final List<String> _filters = [
    'Original',
    'Warm',
    'Cool',
    'Bright',
    'Dark',
    'Vivid',
  ];

  String _selectedEffect = 'None';
  String _selectedFilter = 'Original';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: Stack(
        children: [
          // Camera Preview (placeholder)
          Positioned.fill(
            child: Container(
              color: Colors.black,
              child: const Center(
                child: Icon(
                  Icons.camera_alt,
                  size: 100,
                  color: AppConstants.textSecondaryColor,
                ),
              ),
            ),
          ),

          // Top Controls
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Close Button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Flash Toggle
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isFlashOn = !_isFlashOn;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isFlashOn ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Side Controls (Right)
          Positioned(
            right: 16,
            top: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                // Flip Camera
                _buildSideButton(
                  icon: Icons.flip_camera_ios,
                  onTap: () {
                    setState(() {
                      _isFrontCamera = !_isFrontCamera;
                    });
                  },
                ),
                const SizedBox(height: 20),

                // Speed Control
                _buildSideButton(
                  icon: Icons.speed,
                  label: '1x',
                  onTap: () {
                    // TODO: Show speed options
                  },
                ),
                const SizedBox(height: 20),

                // Timer
                _buildSideButton(
                  icon: Icons.timer,
                  onTap: () {
                    // TODO: Show timer options
                  },
                ),
              ],
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Effects and Filters
                SizedBox(
                  height: 80,
                  child: Row(
                    children: [
                      // Effects
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Effects',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 50,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _effects.length,
                                itemBuilder: (context, index) {
                                  final effect = _effects[index];
                                  final isSelected = effect == _selectedEffect;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedEffect = effect;
                                      });
                                    },
                                    child: Container(
                                      width: 60,
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppConstants.primaryColor
                                            : Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          effect,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Filters
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Filters',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 50,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _filters.length,
                                itemBuilder: (context, index) {
                                  final filter = _filters[index];
                                  final isSelected = filter == _selectedFilter;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedFilter = filter;
                                      });
                                    },
                                    child: Container(
                                      width: 60,
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppConstants.primaryColor
                                            : Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          filter,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Recording Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Upload from Gallery
                    GestureDetector(
                      onTap: () {
                        // TODO: Open gallery
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.photo_library,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Record Button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isRecording = !_isRecording;
                        });
                        // TODO: Start/stop recording
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _isRecording
                                ? AppConstants.primaryColor
                                : Colors.white,
                            shape: _isRecording
                                ? BoxShape.rectangle
                                : BoxShape.circle,
                            borderRadius: _isRecording
                                ? BorderRadius.circular(8)
                                : null,
                          ),
                        ),
                      ),
                    ),

                    // Switch to Photo Mode
                    GestureDetector(
                      onTap: () {
                        // TODO: Switch to photo mode
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.camera,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Recording Progress Bar
          if (_isRecording)
            Positioned(
              top: MediaQuery.of(context).padding.top + 80,
              left: 16,
              right: 16,
              child: LinearProgressIndicator(
                value: _recordingProgress,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppConstants.primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSideButton({
    required IconData icon,
    String? label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: label != null ? 20 : 24,
            ),
            if (label != null) ...[
              const SizedBox(height: 2),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}