import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          // App Info Section
          _buildSectionHeader(context, 'App Information'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Version'),
                  subtitle: Text(AppConstants.appVersion),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showAboutDialog(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: const Text('What\'s New'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showWhatsNew(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),

          // Export Settings Section
          _buildSectionHeader(context, 'Export Settings'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.high_quality),
                  title: const Text('Default Quality'),
                  subtitle: const Text('1080p'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showQualitySettings(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.folder),
                  title: const Text('Export Location'),
                  subtitle: const Text('Downloads/CapCut'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showExportLocationSettings(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),

          // Performance Section
          _buildSectionHeader(context, 'Performance'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.speed),
                  title: const Text('Hardware Acceleration'),
                  subtitle: const Text('Use GPU for faster processing'),
                  value: true,
                  onChanged: (value) {
                    // TODO: Implement hardware acceleration toggle
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.memory),
                  title: const Text('Cache Size'),
                  subtitle: const Text('500 MB'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showCacheSettings(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),

          // Privacy Section
          _buildSectionHeader(context, 'Privacy'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.analytics),
                  title: const Text('Usage Analytics'),
                  subtitle: const Text('Help improve the app'),
                  value: false,
                  onChanged: (value) {
                    // TODO: Implement analytics toggle
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.bug_report),
                  title: const Text('Crash Reports'),
                  subtitle: const Text('Send crash reports automatically'),
                  value: true,
                  onChanged: (value) {
                    // TODO: Implement crash reports toggle
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),

          // Storage Section
          _buildSectionHeader(context, 'Storage'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.storage),
                  title: const Text('Clear Cache'),
                  subtitle: const Text('Free up storage space'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showClearCacheDialog(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_sweep),
                  title: const Text('Clear All Data'),
                  subtitle: const Text('Reset app to default state'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showClearDataDialog(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),

          // Support Section
          _buildSectionHeader(context, 'Support'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Help & FAQ'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showHelp(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.feedback),
                  title: const Text('Send Feedback'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showFeedback(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.star_rate),
                  title: const Text('Rate App'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showRateApp(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),

          // Legal Section
          _buildSectionHeader(context, 'Legal'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showPrivacyPolicy(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.article),
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showTermsOfService(context),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.copyright),
                  title: const Text('Open Source Licenses'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showLicenses(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppConstants.smallPadding,
        bottom: AppConstants.smallPadding,
        top: AppConstants.smallPadding,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppTheme.accentColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: AppConstants.appVersion,
      applicationIcon: const Icon(
        Icons.video_call,
        size: 48,
        color: AppTheme.accentColor,
      ),
      children: [
        Text(AppConstants.appDescription),
        const SizedBox(height: AppConstants.defaultPadding),
        const Text('A professional video editing app built with Flutter.'),
      ],
    );
  }

  void _showWhatsNew(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('What\'s New'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Version 1.0.0', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• Initial release'),
              Text('• Video editing timeline'),
              Text('• Basic editing tools'),
              Text('• Export functionality'),
              Text('• Project management'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showQualitySettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Default Export Quality'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppConstants.resolutions.map((resolution) {
            return RadioListTile<String>(
              title: Text(resolution),
              value: resolution,
              groupValue: '1080p',
              onChanged: (value) {
                Navigator.of(context).pop();
                // TODO: Save quality setting
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showExportLocationSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export location settings coming soon!'),
        backgroundColor: AppTheme.accentColor,
      ),
    );
  }

  void _showCacheSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cache settings coming soon!'),
        backgroundColor: AppTheme.accentColor,
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will clear all cached data and free up storage space. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared successfully'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text('This will delete all projects and reset the app to its default state. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement clear all data
            },
            style: AppTheme.dangerButtonStyle,
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _showHelp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Help & FAQ coming soon!'),
        backgroundColor: AppTheme.accentColor,
      ),
    );
  }

  void _showFeedback(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feedback form coming soon!'),
        backgroundColor: AppTheme.accentColor,
      ),
    );
  }

  void _showRateApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rate app functionality coming soon!'),
        backgroundColor: AppTheme.accentColor,
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy policy coming soon!'),
        backgroundColor: AppTheme.accentColor,
      ),
    );
  }

  void _showTermsOfService(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Terms of service coming soon!'),
        backgroundColor: AppTheme.accentColor,
      ),
    );
  }

  void _showLicenses(BuildContext context) {
    showLicensePage(context: context);
  }
}