import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../auth/providers/auth_provider.dart';
import '../widgets/account_menu_item.dart';
import '../widgets/membership_status_card.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildMembershipCard(),
              const SizedBox(height: 24),
              _buildAccountSection(context),
              const SizedBox(height: 24),
              _buildSupportSection(context),
              const SizedBox(height: 24),
              _buildLogoutButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;
        
        return Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: AppTheme.primaryColor,
              backgroundImage: user?.profileImageUrl != null
                  ? NetworkImage(user!.profileImageUrl!)
                  : null,
              child: user?.profileImageUrl == null
                  ? Text(
                      user?.firstName.substring(0, 1).toUpperCase() ?? 'M',
                      style: const TextStyle(
                        color: AppTheme.textOnPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.fullName ?? 'Member',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => context.push(AppConstants.profileRoute),
              icon: const Icon(Icons.edit),
              style: IconButton.styleFrom(
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                foregroundColor: AppTheme.primaryColor,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMembershipCard() {
    return const MembershipStatusCard();
  }

  Widget _buildAccountSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              AccountMenuItem(
                icon: Icons.person_outline,
                title: AppStrings.profile,
                subtitle: 'Manage your personal information',
                onTap: () => context.push(AppConstants.profileRoute),
              ),
              const Divider(height: 1),
              AccountMenuItem(
                icon: Icons.card_membership,
                title: AppStrings.membership,
                subtitle: 'View membership details',
                onTap: () => context.push(AppConstants.membershipRoute),
              ),
              const Divider(height: 1),
              AccountMenuItem(
                icon: Icons.credit_card,
                title: AppStrings.billing,
                subtitle: 'Payment methods and history',
                onTap: () => context.push(AppConstants.billingRoute),
              ),
              const Divider(height: 1),
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  final canBringGuest = authProvider.canBringGuest();
                  return AccountMenuItem(
                    icon: Icons.people_outline,
                    title: AppStrings.guestPasses,
                    subtitle: canBringGuest 
                        ? '${authProvider.getRemainingGuestPasses()} passes remaining'
                        : 'Not available with your plan',
                    onTap: canBringGuest 
                        ? () => context.push(AppConstants.guestRoute)
                        : null,
                    isEnabled: canBringGuest,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Support & Settings',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              AccountMenuItem(
                icon: Icons.notifications,
                title: AppStrings.notifications,
                subtitle: 'Manage notification preferences',
                onTap: () => context.push(AppConstants.settingsRoute),
              ),
              const Divider(height: 1),
              AccountMenuItem(
                icon: Icons.privacy_tip_outlined,
                title: AppStrings.privacy,
                subtitle: 'Privacy settings and data',
                onTap: () {
                  // Navigate to privacy settings
                },
              ),
              const Divider(height: 1),
              AccountMenuItem(
                icon: Icons.help_outline,
                title: AppStrings.support,
                subtitle: 'Get help and contact us',
                onTap: () {
                  // Navigate to support
                },
              ),
              const Divider(height: 1),
              AccountMenuItem(
                icon: Icons.info_outline,
                title: AppStrings.about,
                subtitle: 'App version and information',
                onTap: () => _showAboutDialog(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: authProvider.isLoading ? null : () => _handleLogout(context),
            icon: authProvider.isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.logout),
            label: Text(authProvider.isLoading ? 'Signing out...' : AppStrings.logout),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.errorColor,
              side: const BorderSide(color: AppTheme.errorColor),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text(AppStrings.logout),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.signOut();
      
      if (success && context.mounted) {
        context.go(AppConstants.loginRoute);
      }
    }
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppConstants.appName,
      applicationVersion: AppConstants.appVersion,
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.fitness_center,
          color: AppTheme.textOnPrimary,
          size: 32,
        ),
      ),
      children: [
        const SizedBox(height: 16),
        Text(
          AppConstants.appDescription,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        const Text('© 2024 Blink Fitness. All rights reserved.'),
      ],
    );
  }
}