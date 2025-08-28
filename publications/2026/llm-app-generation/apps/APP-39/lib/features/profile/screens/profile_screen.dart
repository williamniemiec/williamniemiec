import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        elevation: 0,
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            children: [
              // Profile Header
              if (appProvider.isAuthenticated) ...[
                _buildProfileHeader(context, appProvider),
                const SizedBox(height: AppConstants.largePadding),
              ],

              // Account Section
              _buildSection(
                context,
                'Account',
                [
                  if (!appProvider.isAuthenticated)
                    _buildListTile(
                      context,
                      Icons.login,
                      'Sign in',
                      'Access your Google Account',
                      onTap: () => _showSignInDialog(context),
                    )
                  else
                    _buildListTile(
                      context,
                      Icons.logout,
                      'Sign out',
                      'Sign out of your Google Account',
                      onTap: () => _showSignOutDialog(context, appProvider),
                    ),
                ],
              ),

              // Privacy Section
              _buildSection(
                context,
                'Privacy & Security',
                [
                  _buildSwitchTile(
                    context,
                    Icons.visibility_off,
                    'Incognito mode',
                    'Search privately without saving activity',
                    appProvider.isIncognitoMode,
                    (value) => appProvider.toggleIncognitoMode(),
                  ),
                  _buildListTile(
                    context,
                    Icons.history,
                    'Search history',
                    'Manage your search history',
                    onTap: () => _showSearchHistoryDialog(context, appProvider),
                  ),
                  _buildListTile(
                    context,
                    Icons.delete_sweep,
                    'Delete recent searches',
                    'Delete searches from the last 15 minutes',
                    onTap: () => _showDeleteRecentDialog(context, appProvider),
                  ),
                ],
              ),

              // Preferences Section
              _buildSection(
                context,
                'Preferences',
                [
                  _buildSwitchTile(
                    context,
                    Icons.dark_mode,
                    'Dark theme',
                    'Use dark theme',
                    appProvider.isDarkMode,
                    (value) => appProvider.toggleTheme(),
                  ),
                  if (appProvider.currentUser != null) ...[
                    _buildSwitchTile(
                      context,
                      Icons.mic,
                      'Voice search',
                      'Enable voice search',
                      appProvider.currentUser!.preferences.voiceSearchEnabled,
                      (value) => _updateVoiceSearch(appProvider, value),
                    ),
                    _buildSwitchTile(
                      context,
                      Icons.shield,
                      'SafeSearch',
                      'Filter explicit results',
                      appProvider.currentUser!.preferences.safeSearchEnabled,
                      (value) => _updateSafeSearch(appProvider, value),
                    ),
                  ],
                ],
              ),

              // About Section
              _buildSection(
                context,
                'About',
                [
                  _buildListTile(
                    context,
                    Icons.info,
                    'About Google',
                    'Learn more about Google',
                    onTap: () => _showAboutDialog(context),
                  ),
                  _buildListTile(
                    context,
                    Icons.privacy_tip,
                    'Privacy Policy',
                    'Read our privacy policy',
                    onTap: () {},
                  ),
                  _buildListTile(
                    context,
                    Icons.description,
                    'Terms of Service',
                    'Read our terms of service',
                    onTap: () {},
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, AppProvider appProvider) {
    final user = appProvider.currentUser!;
    
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppTheme.primaryBlue,
            backgroundImage: user.profileImageUrl != null
                ? NetworkImage(user.profileImageUrl!)
                : null,
            child: user.profileImageUrl == null
                ? Text(
                    user.displayName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: AppConstants.defaultPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: AppConstants.smallPadding,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Card(
          child: Column(children: children),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
      ],
    );
  }

  Widget _buildListTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.textSecondary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppTheme.textSecondary),
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.primaryBlue,
    );
  }

  void _showSignInDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign in to Google'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AppProvider>().signIn('user@gmail.com', 'password');
            },
            child: const Text('Sign in'),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, AppProvider appProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              appProvider.signOut();
            },
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }

  void _showSearchHistoryDialog(BuildContext context, AppProvider appProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search History'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Manage your search history and activity.'),
            const SizedBox(height: AppConstants.defaultPadding),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                appProvider.clearSearchHistory();
              },
              child: const Text('Clear all history'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDeleteRecentDialog(BuildContext context, AppProvider appProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete recent searches'),
        content: const Text(
          'This will delete your search activity from the last 15 minutes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              appProvider.deleteRecentSearches();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Google'),
        content: const Text(
          'Google app version 1.0.0\n\n'
          'This is a demo Google app built with Flutter, showcasing search, '
          'discover feed, and Google Lens functionality.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _updateVoiceSearch(AppProvider appProvider, bool enabled) {
    final preferences = appProvider.currentUser!.preferences.copyWith(
      voiceSearchEnabled: enabled,
    );
    appProvider.updateUserPreferences(preferences);
  }

  void _updateSafeSearch(AppProvider appProvider, bool enabled) {
    final preferences = appProvider.currentUser!.preferences.copyWith(
      safeSearchEnabled: enabled,
    );
    appProvider.updateUserPreferences(preferences);
  }
}