import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileSection(context),
            const SizedBox(height: AppSpacing.md),
            _buildMenuSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColorLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 40,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'John Doe',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Parent • Lincoln Elementary',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton(
            onPressed: () => _editProfile(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryColor,
            ),
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      children: [
        _buildMenuCategory(
          context,
          title: 'Account',
          items: [
            _MenuItem(
              icon: Icons.person_outline,
              title: 'Profile Settings',
              subtitle: 'Manage your personal information',
              onTap: () => _navigateToProfileSettings(context),
            ),
            _MenuItem(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Customize your notification preferences',
              onTap: () => _navigateToNotificationSettings(context),
            ),
            _MenuItem(
              icon: Icons.language_outlined,
              title: 'Language',
              subtitle: 'English',
              onTap: () => _navigateToLanguageSettings(context),
            ),
            _MenuItem(
              icon: Icons.security_outlined,
              title: 'Privacy & Security',
              subtitle: 'Manage your privacy settings',
              onTap: () => _navigateToPrivacySettings(context),
            ),
          ],
        ),
        _buildMenuCategory(
          context,
          title: 'School',
          items: [
            _MenuItem(
              icon: Icons.school_outlined,
              title: 'My Children',
              subtitle: 'Manage children and school connections',
              onTap: () => _navigateToChildren(context),
            ),
            _MenuItem(
              icon: Icons.calendar_today_outlined,
              title: 'School Calendar',
              subtitle: 'View full school calendar',
              onTap: () => _navigateToSchoolCalendar(context),
            ),
            _MenuItem(
              icon: Icons.contact_phone_outlined,
              title: 'School Directory',
              subtitle: 'Find contact information',
              onTap: () => _navigateToDirectory(context),
            ),
          ],
        ),
        _buildMenuCategory(
          context,
          title: 'Support',
          items: [
            _MenuItem(
              icon: Icons.help_outline,
              title: 'Help Center',
              subtitle: 'Get help and find answers',
              onTap: () => _navigateToHelp(context),
            ),
            _MenuItem(
              icon: Icons.feedback_outlined,
              title: 'Send Feedback',
              subtitle: 'Share your thoughts with us',
              onTap: () => _sendFeedback(context),
            ),
            _MenuItem(
              icon: Icons.info_outline,
              title: 'About',
              subtitle: 'App version ${AppConstants.appVersion}',
              onTap: () => _showAbout(context),
            ),
          ],
        ),
        _buildMenuCategory(
          context,
          title: 'Legal',
          items: [
            _MenuItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy',
              onTap: () => _openPrivacyPolicy(context),
            ),
            _MenuItem(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              subtitle: 'Read our terms of service',
              onTap: () => _openTermsOfService(context),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _signOut(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.errorColor,
                side: const BorderSide(color: AppTheme.errorColor),
              ),
              child: const Text('Sign Out'),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  Widget _buildMenuCategory(
    BuildContext context, {
    required String title,
    required List<_MenuItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        ...items.map((item) => _buildMenuItem(context, item)),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, _MenuItem item) {
    return ListTile(
      leading: Icon(
        item.icon,
        color: Colors.grey[600],
      ),
      title: Text(item.title),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: item.onTap,
    );
  }

  void _editProfile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit profile feature coming soon!')),
    );
  }

  void _navigateToProfileSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile settings feature coming soon!')),
    );
  }

  void _navigateToNotificationSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification settings feature coming soon!')),
    );
  }

  void _navigateToLanguageSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Language settings feature coming soon!')),
    );
  }

  void _navigateToPrivacySettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy settings feature coming soon!')),
    );
  }

  void _navigateToChildren(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Children management feature coming soon!')),
    );
  }

  void _navigateToSchoolCalendar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('School calendar feature coming soon!')),
    );
  }

  void _navigateToDirectory(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('School directory feature coming soon!')),
    );
  }

  void _navigateToHelp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Help center feature coming soon!')),
    );
  }

  void _sendFeedback(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback feature coming soon!')),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: AppConstants.appVersion,
      applicationIcon: Icon(
        Icons.school,
        size: 48,
        color: AppTheme.primaryColor,
      ),
      children: [
        Text(AppConstants.appDescription),
      ],
    );
  }

  void _openPrivacyPolicy(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Privacy policy feature coming soon!')),
    );
  }

  void _openTermsOfService(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Terms of service feature coming soon!')),
    );
  }

  void _signOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sign out feature coming soon!')),
              );
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });
}