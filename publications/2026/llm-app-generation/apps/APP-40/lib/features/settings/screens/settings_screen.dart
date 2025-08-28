import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../core/providers/app_provider.dart';
import '../../../core/constants/app_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AppProvider>(
          builder: (context, appProvider, child) {
            return CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  floating: true,
                  snap: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                  title: Text(
                    'Settings',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Home Information Section
                SliverToBoxAdapter(
                  child: _buildHomeInfoSection(context, appProvider),
                ),

                // Settings Sections
                SliverList(
                  delegate: SliverChildListDelegate([
                    _buildSettingsSection(
                      context,
                      'Home & Family',
                      [
                        _buildSettingsItem(
                          context,
                          'Home information',
                          'Manage home name and location',
                          Icons.home,
                          () => _showHomeInfoDialog(context, appProvider),
                        ),
                        _buildSettingsItem(
                          context,
                          'Members',
                          'Invite and manage family members',
                          Icons.people,
                          () => _showMembersScreen(context),
                        ),
                        _buildSettingsItem(
                          context,
                          'Rooms & devices',
                          'Organize your smart home',
                          MdiIcons.devices,
                          () => _showRoomsDevicesScreen(context),
                        ),
                      ],
                    ),
                    _buildSettingsSection(
                      context,
                      'Preferences',
                      [
                        _buildSwitchItem(
                          context,
                          'Dark mode',
                          'Use dark theme',
                          Icons.dark_mode,
                          appProvider.isDarkMode,
                          (value) => appProvider.setDarkMode(value),
                        ),
                        _buildSwitchItem(
                          context,
                          'Notifications',
                          'Receive device and security alerts',
                          Icons.notifications,
                          appProvider.notificationsEnabled,
                          (value) => appProvider.setNotificationsEnabled(value),
                        ),
                        _buildSettingsItem(
                          context,
                          'Voice & speech',
                          'Manage voice commands and responses',
                          Icons.mic,
                          () => _showVoiceSettingsScreen(context),
                        ),
                      ],
                    ),
                    _buildSettingsSection(
                      context,
                      'Privacy & Security',
                      [
                        _buildSettingsItem(
                          context,
                          'Privacy controls',
                          'Manage data usage and privacy',
                          Icons.privacy_tip,
                          () => _showPrivacyScreen(context),
                        ),
                        _buildSettingsItem(
                          context,
                          'Activity controls',
                          'Control what data is saved',
                          Icons.history,
                          () => _showActivityControlsScreen(context),
                        ),
                        _buildSettingsItem(
                          context,
                          'Guest mode',
                          'Temporary access for visitors',
                          Icons.person_outline,
                          () => _showGuestModeScreen(context),
                        ),
                      ],
                    ),
                    _buildSettingsSection(
                      context,
                      'Services',
                      [
                        _buildSettingsItem(
                          context,
                          'Works with Google',
                          'Connected services and apps',
                          MdiIcons.googleAssistant,
                          () => _showConnectedServicesScreen(context),
                        ),
                        _buildSettingsItem(
                          context,
                          'Music services',
                          'Spotify, YouTube Music, and more',
                          Icons.music_note,
                          () => _showMusicServicesScreen(context),
                        ),
                        _buildSettingsItem(
                          context,
                          'Video services',
                          'Netflix, YouTube, and more',
                          Icons.video_library,
                          () => _showVideoServicesScreen(context),
                        ),
                      ],
                    ),
                    _buildSettingsSection(
                      context,
                      'Support',
                      [
                        _buildSettingsItem(
                          context,
                          'Help & feedback',
                          'Get help and send feedback',
                          Icons.help,
                          () => _showHelpScreen(context),
                        ),
                        _buildSettingsItem(
                          context,
                          'About',
                          'App version and legal information',
                          Icons.info,
                          () => _showAboutDialog(context),
                        ),
                      ],
                    ),
                  ]),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHomeInfoSection(BuildContext context, AppProvider appProvider) {
    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.home,
              color: Theme.of(context).colorScheme.primary,
              size: 32,
            ),
          ),
          const SizedBox(width: AppConstants.defaultPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appProvider.homeName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${appProvider.devices.length} devices • ${appProvider.rooms.length} rooms',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Managed by ${appProvider.userName}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    String title,
    List<Widget> items,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.smallPadding,
              vertical: AppConstants.smallPadding,
            ),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Card(
            child: Column(children: items),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  // Dialog and Screen Navigation Methods
  void _showHomeInfoDialog(BuildContext context, AppProvider appProvider) {
    final nameController = TextEditingController(text: appProvider.homeName);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Home Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Home name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              appProvider.setHomeName(nameController.text);
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: AppConstants.appVersion,
      applicationIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.home,
          color: Theme.of(context).colorScheme.primary,
          size: 32,
        ),
      ),
      children: [
        const Text('A comprehensive smart home control application.'),
        const SizedBox(height: 16),
        const Text('© 2024 Google Home App. All rights reserved.'),
      ],
    );
  }

  // Placeholder methods for navigation
  void _showMembersScreen(BuildContext context) {
    _showPlaceholderDialog(context, 'Members', 'Family member management would be implemented here.');
  }

  void _showRoomsDevicesScreen(BuildContext context) {
    _showPlaceholderDialog(context, 'Rooms & Devices', 'Room and device organization would be implemented here.');
  }

  void _showVoiceSettingsScreen(BuildContext context) {
    _showPlaceholderDialog(context, 'Voice & Speech', 'Voice command settings would be implemented here.');
  }

  void _showPrivacyScreen(BuildContext context) {
    _showPlaceholderDialog(context, 'Privacy Controls', 'Privacy settings would be implemented here.');
  }

  void _showActivityControlsScreen(BuildContext context) {
    _showPlaceholderDialog(context, 'Activity Controls', 'Activity data controls would be implemented here.');
  }

  void _showGuestModeScreen(BuildContext context) {
    _showPlaceholderDialog(context, 'Guest Mode', 'Guest access settings would be implemented here.');
  }

  void _showConnectedServicesScreen(BuildContext context) {
    _showPlaceholderDialog(context, 'Works with Google', 'Connected services management would be implemented here.');
  }

  void _showMusicServicesScreen(BuildContext context) {
    _showPlaceholderDialog(context, 'Music Services', 'Music service connections would be implemented here.');
  }

  void _showVideoServicesScreen(BuildContext context) {
    _showPlaceholderDialog(context, 'Video Services', 'Video service connections would be implemented here.');
  }

  void _showHelpScreen(BuildContext context) {
    _showPlaceholderDialog(context, 'Help & Feedback', 'Help and support options would be implemented here.');
  }

  void _showPlaceholderDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}