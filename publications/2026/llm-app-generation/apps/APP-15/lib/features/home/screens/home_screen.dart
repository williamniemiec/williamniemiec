import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../auth/providers/auth_provider.dart';
import '../widgets/content_card.dart';
import '../widgets/quick_action_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildCheckInCard(),
                const SizedBox(height: 24),
                _buildQuickActions(),
                const SizedBox(height: 24),
                _buildFeaturedContent(),
                const SizedBox(height: 24),
                _buildRecentActivity(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;
        final membership = authProvider.currentMembership;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.firstName ?? 'Member',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppTheme.primaryColor,
                  backgroundImage: user?.profileImageUrl != null
                      ? NetworkImage(user!.profileImageUrl!)
                      : null,
                  child: user?.profileImageUrl == null
                      ? Text(
                          user?.firstName.substring(0, 1).toUpperCase() ?? 'M',
                          style: const TextStyle(
                            color: AppTheme.textOnPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
              ],
            ),
            if (membership != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: membership.isActive ? AppTheme.successColor : AppTheme.warningColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '${membership.planDisplayName} • ${membership.statusDisplayName}',
                  style: const TextStyle(
                    color: AppTheme.textOnPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildCheckInCard() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.qr_code,
                      color: AppTheme.primaryColor,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gym Check-in',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Show this code at the front desk',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.borderColor),
                  ),
                  child: Center(
                    child: QrImageView(
                      data: user?.membershipId ?? 'BLINK0000',
                      version: QrVersions.auto,
                      size: 150,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user?.membershipId ?? 'BLINK0000',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontFamily: 'monospace',
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.push(AppConstants.barcodeRoute),
                    icon: const Icon(Icons.fullscreen),
                    label: const Text('Full Screen'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: QuickActionCard(
                icon: Icons.person_add,
                title: 'Invite Guest',
                subtitle: 'Bring a friend',
                onTap: () => context.push(AppConstants.guestRoute),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: QuickActionCard(
                icon: Icons.credit_card,
                title: 'Billing',
                subtitle: 'Manage payments',
                onTap: () => context.push(AppConstants.billingRoute),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeaturedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Featured Content',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.go(AppConstants.contentRoute),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _getFeaturedContent().length,
            itemBuilder: (context, index) {
              final content = _getFeaturedContent()[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < _getFeaturedContent().length - 1 ? 12 : 0,
                ),
                child: ContentCard(
                  title: content['title']!,
                  subtitle: content['subtitle']!,
                  duration: content['duration']!,
                  imageUrl: content['imageUrl'],
                  onTap: () {
                    // Navigate to content detail
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            final user = authProvider.currentUser;
            
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  children: [
                    if (user?.lastCheckIn != null) ...[
                      _buildActivityItem(
                        icon: Icons.login,
                        title: 'Last Check-in',
                        subtitle: _formatDateTime(user!.lastCheckIn!),
                        color: AppTheme.successColor,
                      ),
                      const Divider(),
                    ],
                    _buildActivityItem(
                      icon: Icons.card_membership,
                      title: 'Member Since',
                      subtitle: _formatDate(user?.memberSince ?? DateTime.now()),
                      color: AppTheme.primaryColor,
                    ),
                    if (user?.guestPassesRemaining != null && user!.guestPassesRemaining > 0) ...[
                      const Divider(),
                      _buildActivityItem(
                        icon: Icons.people,
                        title: 'Guest Passes',
                        subtitle: '${user.guestPassesRemaining} remaining',
                        color: AppTheme.accentColor,
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
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

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays == 0) {
      return 'Today at ${_formatTime(dateTime)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${_formatTime(dateTime)}';
    } else {
      return _formatDate(dateTime);
    }
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  List<Map<String, String>> _getFeaturedContent() {
    return [
      {
        'title': '15-Min HIIT Workout',
        'subtitle': 'Aaptiv',
        'duration': '15 min',
        'imageUrl': '',
      },
      {
        'title': 'Morning Yoga Flow',
        'subtitle': 'Daily Burn',
        'duration': '20 min',
        'imageUrl': '',
      },
      {
        'title': 'Strength Training',
        'subtitle': 'Sworkit',
        'duration': '30 min',
        'imageUrl': '',
      },
    ];
  }

  Future<void> _handleRefresh() async {
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Refresh user data
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // Add refresh logic here if needed
    
    if (mounted) {
      setState(() {});
    }
  }
}