import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_router.dart';
import '../../../shared/services/app_provider.dart';
import '../../../shared/services/photo_service.dart';
import '../../../shared/models/design_style.dart';
import '../../../shared/models/room_type.dart';

class EditorScreen extends StatefulWidget {
  final String? imagePath;

  const EditorScreen({super.key, this.imagePath});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final PhotoService _photoService = PhotoService();
  
  String? _selectedImagePath;
  RoomType? _selectedRoomType;
  DesignStyle? _selectedDesignStyle;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _selectedImagePath = widget.imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Design Editor'),
        actions: [
          if (_selectedImagePath != null)
            IconButton(
              onPressed: _handleChangePhoto,
              icon: const Icon(Icons.photo_camera),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Preview Section
            _buildImagePreview(),
            const SizedBox(height: 24),
            
            // Room Type Selection
            _buildRoomTypeSelection(),
            const SizedBox(height: 24),
            
            // Design Style Selection
            _buildDesignStyleSelection(),
            const SizedBox(height: 32),
            
            // Generate Button
            _buildGenerateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_selectedImagePath == null) {
      return Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.borderColor,
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: _handleSelectPhoto,
          borderRadius: BorderRadius.circular(12),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate,
                size: 64,
                color: AppTheme.textTertiary,
              ),
              SizedBox(height: 16),
              Text(
                'Select Photo',
                style: AppTheme.headingSmall,
              ),
              SizedBox(height: 8),
              Text(
                'Choose a photo of your space to redesign',
                style: AppTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.file(
                File(_selectedImagePath!),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppTheme.backgroundColor,
                    child: const Center(
                      child: Icon(
                        Icons.error_outline,
                        size: 48,
                        color: AppTheme.errorColor,
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Change photo button
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  onPressed: _handleChangePhoto,
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomTypeSelection() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Room Type',
              style: AppTheme.headingSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Select the type of space you want to redesign',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            
            // Interior Rooms
            _buildRoomTypeCategory('Interior', provider.interiorRoomTypes),
            const SizedBox(height: 16),
            
            // Exterior Spaces
            _buildRoomTypeCategory('Exterior', provider.exteriorRoomTypes),
          ],
        );
      },
    );
  }

  Widget _buildRoomTypeCategory(String title, List<RoomType> roomTypes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: roomTypes.map((roomType) {
            final isSelected = _selectedRoomType?.id == roomType.id;
            return FilterChip(
              label: Text(roomType.name),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedRoomType = selected ? roomType : null;
                  // Clear style selection when room type changes
                  if (selected) {
                    _selectedDesignStyle = null;
                  }
                });
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDesignStyleSelection() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        if (_selectedRoomType == null) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.borderColor),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.palette_outlined,
                  size: 48,
                  color: AppTheme.textTertiary,
                ),
                SizedBox(height: 16),
                Text(
                  'Select Room Type First',
                  style: AppTheme.bodyMedium,
                ),
                Text(
                  'Choose a room type to see available design styles',
                  style: AppTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Design Style',
              style: AppTheme.headingSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose a style to transform your space',
              style: AppTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            
            // Free Styles
            if (provider.freeDesignStyles.isNotEmpty) ...[
              _buildStyleCategory('Free Styles', provider.freeDesignStyles, false),
              const SizedBox(height: 16),
            ],
            
            // Premium Styles
            if (provider.premiumDesignStyles.isNotEmpty)
              _buildStyleCategory('Premium Styles', provider.premiumDesignStyles, true),
          ],
        );
      },
    );
  }

  Widget _buildStyleCategory(String title, List<DesignStyle> styles, bool isPremium) {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                if (isPremium) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'PRO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: styles.length,
              itemBuilder: (context, index) {
                final style = styles[index];
                final isSelected = _selectedDesignStyle?.id == style.id;
                final canSelect = !isPremium || provider.isPremiumUser;
                
                return GestureDetector(
                  onTap: canSelect ? () {
                    setState(() {
                      _selectedDesignStyle = isSelected ? null : style;
                    });
                  } : () {
                    AppNavigation.pushSubscription(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ] : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          // Style preview (placeholder)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.primaryColor.withOpacity(0.3),
                                    AppTheme.secondaryColor.withOpacity(0.3),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: const Icon(
                                Icons.home_filled,
                                size: 32,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          
                          // Overlay
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          
                          // Style info
                          Positioned(
                            bottom: 8,
                            left: 8,
                            right: 8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  style.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  style.description,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 10,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          
                          // Premium lock overlay
                          if (isPremium && !provider.isPremiumUser)
                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withOpacity(0.5),
                                child: const Center(
                                  child: Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ),
                          
                          // Selection indicator
                          if (isSelected)
                            const Positioned(
                              top: 8,
                              right: 8,
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: AppTheme.primaryColor,
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildGenerateButton() {
    final canGenerate = _selectedImagePath != null && 
                       _selectedRoomType != null && 
                       _selectedDesignStyle != null;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: canGenerate && !_isGenerating ? _handleGenerate : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canGenerate ? AppTheme.primaryColor : AppTheme.textTertiary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isGenerating
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Generating...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : const Text(
                'Generate Design',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Future<void> _handleSelectPhoto() async {
    try {
      final imagePath = await _photoService.showImageSourceDialog(context);
      if (imagePath != null) {
        setState(() {
          _selectedImagePath = imagePath;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error selecting photo: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _handleChangePhoto() async {
    try {
      final imagePath = await _photoService.showImageSourceDialog(context);
      if (imagePath != null) {
        setState(() {
          _selectedImagePath = imagePath;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error changing photo: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  Future<void> _handleGenerate() async {
    if (_selectedImagePath == null || 
        _selectedRoomType == null || 
        _selectedDesignStyle == null) {
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      final provider = Provider.of<AppProvider>(context, listen: false);
      
      final project = await provider.createProject(
        originalImagePath: _selectedImagePath!,
        roomType: _selectedRoomType!,
        designStyle: _selectedDesignStyle!,
      );

      if (mounted) {
        AppNavigation.goToResults(context, project.id);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating design: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }
}