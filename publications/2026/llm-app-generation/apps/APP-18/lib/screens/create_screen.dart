import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../widgets/custom_app_bar.dart';

class CreateScreen extends StatelessWidget {
  const CreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: const CustomAppBar(
        title: 'Create',
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Create Pin Option
            _buildCreateOption(
              context: context,
              icon: Icons.push_pin_outlined,
              title: 'Create Pin',
              subtitle: 'Share your ideas with the world',
              color: AppTheme.primaryColor,
              onTap: () => _navigateToCreatePin(context),
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            
            // Create Board Option
            _buildCreateOption(
              context: context,
              icon: Icons.dashboard_outlined,
              title: 'Create Board',
              subtitle: 'Organize your pins by topic',
              color: AppTheme.accentBlue,
              onTap: () => _navigateToCreateBoard(context),
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            
            // Import from Camera Option
            _buildCreateOption(
              context: context,
              icon: Icons.camera_alt_outlined,
              title: 'Take Photo',
              subtitle: 'Create a pin from your camera',
              color: AppTheme.accentGreen,
              onTap: () => _takePhoto(context),
            ),
            const SizedBox(height: AppTheme.spacingLarge),
            
            // Import from Gallery Option
            _buildCreateOption(
              context: context,
              icon: Icons.photo_library_outlined,
              title: 'Choose from Gallery',
              subtitle: 'Select photos from your device',
              color: AppTheme.accentPurple,
              onTap: () => _chooseFromGallery(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppTheme.spacingLarge),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          boxShadow: const [
            BoxShadow(
              color: AppTheme.shadowColor,
              blurRadius: AppTheme.elevationMedium,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(width: AppTheme.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: AppTheme.fontSizeLarge,
                      fontWeight: AppTheme.fontWeightSemiBold,
                      color: AppTheme.textPrimary,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: AppTheme.fontSizeMedium,
                      color: AppTheme.textSecondary,
                      fontFamily: AppTheme.fontFamily,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.grey400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCreatePin(BuildContext context) {
    Navigator.pushNamed(context, '/create_pin');
  }

  void _navigateToCreateBoard(BuildContext context) {
    Navigator.pushNamed(context, '/create_board');
  }

  void _takePhoto(BuildContext context) {
    Navigator.pushNamed(context, '/create_pin_camera');
  }

  void _chooseFromGallery(BuildContext context) {
    Navigator.pushNamed(context, '/create_pin_gallery');
  }
}