import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../providers/coloring_provider.dart';
import '../constants/app_constants.dart';
import '../widgets/coloring_canvas.dart';
import '../widgets/color_palette.dart';
import '../widgets/coloring_toolbar.dart';

class ColoringScreen extends StatefulWidget {
  final String pageId;

  const ColoringScreen({
    super.key,
    required this.pageId,
  });

  @override
  State<ColoringScreen> createState() => _ColoringScreenState();
}

class _ColoringScreenState extends State<ColoringScreen> {
  @override
  void initState() {
    super.initState();
    // Load the coloring page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ColoringProvider>().loadColoringPage(widget.pageId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _showExitDialog(context);
      },
      child: Scaffold(
        backgroundColor: AppConstants.backgroundColor,
        body: SafeArea(
          child: Consumer<ColoringProvider>(
            builder: (context, coloringProvider, child) {
              if (coloringProvider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppConstants.primaryColor,
                  ),
                );
              }

              if (coloringProvider.error != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppConstants.errorColor,
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      Text(
                        'Failed to load coloring page',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      Text(
                        coloringProvider.error!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppConstants.paddingLarge),
                      ElevatedButton(
                        onPressed: () => context.pop(),
                        child: const Text('Go Back'),
                      ),
                    ],
                  ),
                );
              }

              final currentPage = coloringProvider.currentPage;
              if (currentPage == null) {
                return const Center(
                  child: Text('No coloring page loaded'),
                );
              }

              return Column(
                children: [
                  // Top Bar
                  Container(
                    color: AppConstants.surfaceColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingMedium,
                      vertical: AppConstants.paddingSmall,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => _handleBackPressed(context),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentPage.title,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${coloringProvider.progressPercentage.toInt()}% complete',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppConstants.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ColoringToolbar(
                          onHintPressed: () => coloringProvider.showHint(),
                          onResetZoom: () => coloringProvider.resetCanvasTransform(),
                          onShare: () => _shareArtwork(context, coloringProvider),
                        ),
                      ],
                    ),
                  ),

                  // Progress Bar
                  LinearProgressIndicator(
                    value: coloringProvider.progressPercentage / 100,
                    backgroundColor: AppConstants.backgroundColor,
                    valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
                    minHeight: 3,
                  ),

                  // Canvas
                  Expanded(
                    child: ColoringCanvas(
                      page: currentPage,
                      onRegionTapped: (regionNumber) {
                        coloringProvider.colorRegion(regionNumber);
                      },
                    ),
                  ),

                  // Color Palette
                  ColorPaletteWidget(
                    availableColors: coloringProvider.getAvailableColors(),
                    completedColors: coloringProvider.getCompletedColors(),
                    selectedColorNumber: coloringProvider.selectedColorNumber,
                    onColorSelected: (colorNumber) {
                      coloringProvider.selectColor(colorNumber);
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    final coloringProvider = context.read<ColoringProvider>();
    
    if (!coloringProvider.hasUnsavedProgress) {
      return true;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Progress?'),
        content: const Text(
          'You have unsaved progress. Do you want to save before leaving?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Leave'),
          ),
          ElevatedButton(
            onPressed: () async {
              await coloringProvider.autoSave();
              if (context.mounted) {
                Navigator.of(context).pop(true);
              }
            },
            child: const Text('Save & Leave'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  void _handleBackPressed(BuildContext context) async {
    final shouldExit = await _showExitDialog(context);
    if (shouldExit && context.mounted) {
      context.pop();
    }
  }

  void _shareArtwork(BuildContext context, ColoringProvider provider) {
    if (provider.isCompleted) {
      Share.share(
        '${AppConstants.shareText}\n\nTitle: ${provider.currentPage?.title}',
        subject: 'My Color by Number Artwork',
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete the artwork to share it!'),
          backgroundColor: AppConstants.primaryColor,
        ),
      );
    }
  }

  @override
  void dispose() {
    // Auto-save on dispose
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ColoringProvider>().autoSave();
    });
    super.dispose();
  }
}