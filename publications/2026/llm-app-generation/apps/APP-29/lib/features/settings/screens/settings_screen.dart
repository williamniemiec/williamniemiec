import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/subscription_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/subscription_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubscriptionSection(),
            const SizedBox(height: 24),
            _buildAccountSection(),
            const SizedBox(height: 24),
            _buildAppearanceSection(),
            const SizedBox(height: 24),
            _buildDataSection(),
            const SizedBox(height: 24),
            _buildAboutSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionSection() {
    return Consumer<SubscriptionProvider>(
      builder: (context, subscriptionProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subscription',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const SubscriptionCard(),
            if (!subscriptionProvider.isPlusSubscriber) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showSubscriptionDialog(context),
                  child: const Text('Upgrade to ChatGPT Plus'),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildAccountSection() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            if (authProvider.isAuthenticated) ...[
              _buildSettingsTile(
                icon: Icons.person_outline,
                title: 'Profile',
                subtitle: authProvider.userEmail ?? 'Manage your profile',
                onTap: () {
                  // Navigate to profile screen
                },
              ),
              _buildSettingsTile(
                icon: Icons.logout,
                title: 'Sign Out',
                subtitle: 'Sign out of your account',
                onTap: () => _showSignOutDialog(context, authProvider),
                textColor: AppTheme.errorColor,
              ),
            ] else ...[
              _buildSettingsTile(
                icon: Icons.login,
                title: 'Sign In',
                subtitle: 'Sign in to sync your conversations',
                onTap: () {
                  // Navigate to sign in screen
                },
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildAppearanceSection() {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appearance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingsTile(
              icon: Icons.palette_outlined,
              title: 'Theme',
              subtitle: _getThemeModeText(appProvider.themeMode),
              onTap: () => _showThemeDialog(context, appProvider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDataSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Data & Privacy',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Builder(
          builder: (context) => _buildSettingsTile(
            icon: Icons.history,
            title: 'Clear Chat History',
            subtitle: 'Delete all conversations',
            onTap: () => _showClearHistoryDialog(context),
          ),
        ),
        Builder(
          builder: (context) => _buildSettingsTile(
            icon: Icons.download_outlined,
            title: 'Export Data',
            subtitle: 'Download your conversation history',
            onTap: () {
              // Implement data export
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export feature coming soon')),
              );
            },
          ),
        ),
        _buildSettingsTile(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          subtitle: 'Learn how we protect your data',
          onTap: () {
            // Open privacy policy
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        _buildSettingsTile(
          icon: Icons.info_outline,
          title: 'Version',
          subtitle: '1.0.0',
          onTap: null,
        ),
        _buildSettingsTile(
          icon: Icons.help_outline,
          title: 'Help & Support',
          subtitle: 'Get help with the app',
          onTap: () {
            // Open help screen
          },
        ),
        _buildSettingsTile(
          icon: Icons.star_outline,
          title: 'Rate the App',
          subtitle: 'Share your feedback',
          onTap: () {
            // Open app store rating
          },
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Color? textColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: textColor ?? AppTheme.textSecondary,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: textColor ?? AppTheme.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: AppTheme.textSecondary,
          ),
        ),
        trailing: onTap != null
            ? const Icon(
                Icons.chevron_right,
                color: AppTheme.textSecondary,
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  void _showThemeDialog(BuildContext context, AppProvider appProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('Light'),
              value: ThemeMode.light,
              groupValue: appProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  appProvider.setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('Dark'),
              value: ThemeMode.dark,
              groupValue: appProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  appProvider.setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('System'),
              value: ThemeMode.system,
              groupValue: appProvider.themeMode,
              onChanged: (value) {
                if (value != null) {
                  appProvider.setThemeMode(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSubscriptionDialog(BuildContext context) {
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ChatGPT Plus'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Upgrade to ChatGPT Plus for:'),
            const SizedBox(height: 12),
            ...subscriptionProvider.plusFeatures.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.check, color: AppTheme.successColor, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(feature, style: const TextStyle(fontSize: 14))),
                ],
              ),
            )),
            const SizedBox(height: 16),
            Text(
              'Monthly: \$${subscriptionProvider.monthlyPrice.toStringAsFixed(0)}/month',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              'Yearly: \$${subscriptionProvider.yearlyPrice.toStringAsFixed(0)}/year (Save \$${subscriptionProvider.yearlySavings.toStringAsFixed(0)})',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await subscriptionProvider.subscribeToPlusMonthly();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Subscribed to ChatGPT Plus!' : 'Subscription failed'),
                    backgroundColor: success ? AppTheme.successColor : AppTheme.errorColor,
                  ),
                );
              }
            },
            child: const Text('Subscribe'),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              authProvider.signOut();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat History'),
        content: const Text('This will delete all your conversations. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Clear chat history
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chat history cleared')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}