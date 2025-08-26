import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/user.dart';
import '../../../shared/models/transaction.dart';
import '../widgets/balance_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/recent_activity.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Mock user data - in a real app, this would come from a provider/state management
  final User mockUser = User(
    id: '1',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john.doe@example.com',
    paypalBalance: 1234.56,
    isVerified: true,
    createdAt: DateTime.now().subtract(const Duration(days: 365)),
    lastLoginAt: DateTime.now(),
    preferences: UserPreferences(
      biometricEnabled: true,
      notificationsEnabled: true,
      darkModeEnabled: false,
      currency: 'USD',
      language: 'en',
    ),
  );

  // Mock recent transactions
  final List<Transaction> mockTransactions = [
    Transaction(
      id: '1',
      userId: '1',
      type: TransactionType.receive,
      status: TransactionStatus.completed,
      amount: 50.00,
      currency: 'USD',
      recipientName: 'Sarah Johnson',
      description: 'Dinner split',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      completedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Transaction(
      id: '2',
      userId: '1',
      type: TransactionType.send,
      status: TransactionStatus.completed,
      amount: 25.00,
      currency: 'USD',
      recipientName: 'Mike Wilson',
      description: 'Coffee payment',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      completedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Transaction(
      id: '3',
      userId: '1',
      type: TransactionType.purchase,
      status: TransactionStatus.completed,
      amount: 89.99,
      currency: 'USD',
      merchantName: 'Amazon',
      description: 'Online purchase',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      completedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              AppConstants.logoPath,
              height: 32,
              errorBuilder: (context, error, stackTrace) {
                return const Text(
                  'PayPal',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.white,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.white,
              child: Text(
                mockUser.initials,
                style: const TextStyle(
                  color: AppTheme.paypalBlue,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            onPressed: () {
              // Navigate to profile screen
            },
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: AppTheme.paypalBlue,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Implement refresh logic
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message
              Text(
                'Welcome back, ${mockUser.firstName}!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.primaryTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppConstants.defaultPadding),

              // Balance Card
              BalanceCard(
                balance: mockUser.paypalBalance,
                currency: mockUser.preferences.currency,
                isVerified: mockUser.isVerified,
              ),
              const SizedBox(height: AppConstants.largePadding),

              // Quick Actions
              const QuickActions(),
              const SizedBox(height: AppConstants.largePadding),

              // Recent Activity
              RecentActivity(
                transactions: mockTransactions,
              ),
              const SizedBox(height: AppConstants.defaultPadding),

              // Additional features section
              _buildFeaturesSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explore PayPal',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppTheme.primaryTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                context,
                icon: Icons.savings_outlined,
                title: 'High-Yield Savings',
                subtitle: 'Earn 4.50% APY',
                onTap: () {
                  // Navigate to savings screen
                },
              ),
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            Expanded(
              child: _buildFeatureCard(
                context,
                icon: Icons.credit_card_outlined,
                title: 'PayPal Debit Card',
                subtitle: 'Get cash back rewards',
                onTap: () {
                  // Navigate to debit card screen
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                context,
                icon: Icons.receipt_long_outlined,
                title: 'Bill Pay',
                subtitle: 'Pay bills easily',
                onTap: () {
                  // Navigate to bill pay screen
                },
              ),
            ),
            const SizedBox(width: AppConstants.defaultPadding),
            Expanded(
              child: _buildFeatureCard(
                context,
                icon: Icons.schedule_outlined,
                title: 'Pay in 4',
                subtitle: 'Split purchases',
                onTap: () {
                  // Navigate to Pay in 4 screen
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 32,
                color: AppTheme.paypalBlue,
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}