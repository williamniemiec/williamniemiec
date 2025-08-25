import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/services/app_provider.dart';
import '../../../shared/models/subscription.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  SubscriptionPlan? _selectedPlan;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Default to monthly plan
    _selectedPlan = AppConstants.defaultSubscriptionPlans
        .firstWhere((plan) => plan.period == SubscriptionPeriod.monthly);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Features'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Features List
            _buildFeaturesList(),
            
            // Subscription Plans
            _buildSubscriptionPlans(),
            
            // Subscribe Button
            _buildSubscribeButton(),
            
            // Terms and Restore
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: AppTheme.primaryGradient,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.diamond,
            size: 64,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          const Text(
            'Unlock Premium',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Get unlimited access to all design styles and features',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    final features = [
      _FeatureItem(
        icon: Icons.all_inclusive,
        title: 'Unlimited Generations',
        description: 'Create as many designs as you want',
        isPremium: true,
      ),
      _FeatureItem(
        icon: Icons.palette,
        title: 'All Design Styles',
        description: 'Access to premium and exclusive styles',
        isPremium: true,
      ),
      _FeatureItem(
        icon: Icons.high_quality,
        title: 'High Resolution',
        description: 'Export designs in 4K quality',
        isPremium: true,
      ),
      _FeatureItem(
        icon: Icons.flash_on,
        title: 'Priority Processing',
        description: 'Faster AI generation times',
        isPremium: true,
      ),
      _FeatureItem(
        icon: Icons.block,
        title: 'Ad-Free Experience',
        description: 'No interruptions while designing',
        isPremium: true,
      ),
      _FeatureItem(
        icon: Icons.cloud_upload,
        title: 'Cloud Storage',
        description: 'Save unlimited projects',
        isPremium: true,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Premium Features',
            style: AppTheme.headingMedium,
          ),
          const SizedBox(height: 16),
          
          ...features.map((feature) => _buildFeatureItem(feature)),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(_FeatureItem feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: feature.isPremium 
                  ? AppTheme.primaryColor.withOpacity(0.1)
                  : AppTheme.textTertiary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              feature.icon,
              color: feature.isPremium 
                  ? AppTheme.primaryColor 
                  : AppTheme.textTertiary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      feature.title,
                      style: AppTheme.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (feature.isPremium) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.secondaryColor,
                          borderRadius: BorderRadius.circular(8),
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
                const SizedBox(height: 4),
                Text(
                  feature.description,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            feature.isPremium ? Icons.check_circle : Icons.close,
            color: feature.isPremium 
                ? AppTheme.successColor 
                : AppTheme.textTertiary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionPlans() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose Your Plan',
            style: AppTheme.headingMedium,
          ),
          const SizedBox(height: 16),
          
          ...AppConstants.defaultSubscriptionPlans.map((plan) {
            return _buildPlanCard(plan);
          }),
        ],
      ),
    );
  }

  Widget _buildPlanCard(SubscriptionPlan plan) {
    final isSelected = _selectedPlan?.id == plan.id;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlan = plan;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.primaryColor.withOpacity(0.1)
              : AppTheme.surfaceColor,
          border: Border.all(
            color: isSelected 
                ? AppTheme.primaryColor 
                : AppTheme.borderColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            plan.name,
                            style: AppTheme.headingSmall.copyWith(
                              color: isSelected 
                                  ? AppTheme.primaryColor 
                                  : AppTheme.textPrimary,
                            ),
                          ),
                          if (plan.isPopular) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.secondaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'POPULAR',
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
                      const SizedBox(height: 4),
                      Text(
                        plan.description,
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${plan.price.toStringAsFixed(2)}',
                      style: AppTheme.headingMedium.copyWith(
                        color: isSelected 
                            ? AppTheme.primaryColor 
                            : AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      '/${plan.period.name}',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    if (plan.discountText != null) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          plan.discountText!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(width: 12),
                Radio<SubscriptionPlan>(
                  value: plan,
                  groupValue: _selectedPlan,
                  onChanged: (value) {
                    setState(() {
                      _selectedPlan = value;
                    });
                  },
                  activeColor: AppTheme.primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscribeButton() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _selectedPlan != null && !_isProcessing 
              ? _handleSubscribe 
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: _isProcessing
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
                      'Processing...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              : Text(
                  _selectedPlan != null 
                      ? 'Subscribe for \$${_selectedPlan!.price.toStringAsFixed(2)}/${_selectedPlan!.period.name}'
                      : 'Select a Plan',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: _handleRestorePurchases,
                child: const Text('Restore Purchases'),
              ),
              TextButton(
                onPressed: _showTermsAndConditions,
                child: const Text('Terms & Conditions'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Subscription automatically renews unless auto-renew is turned off at least 24 hours before the end of the current period.',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubscribe() async {
    if (_selectedPlan == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // In a real app, this would integrate with in_app_purchase
      // For now, we'll simulate the subscription process
      await Future.delayed(const Duration(seconds: 2));

      final provider = Provider.of<AppProvider>(context, listen: false);
      final subscription = UserSubscription(
        userId: 'user_id',
        plan: _selectedPlan!,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(
          _selectedPlan!.period == SubscriptionPeriod.weekly
              ? const Duration(days: 7)
              : _selectedPlan!.period == SubscriptionPeriod.monthly
                  ? const Duration(days: 30)
                  : const Duration(days: 365),
        ),
        isActive: true,
        autoRenew: true,
        transactionId: 'mock_transaction_${DateTime.now().millisecondsSinceEpoch}',
        remainingGenerations: -1, // Unlimited for premium
      );

      await provider.updateSubscription(subscription);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully subscribed to Premium!'),
            backgroundColor: AppTheme.successColor,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Subscription failed: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _handleRestorePurchases() async {
    // In a real app, this would restore purchases from the app store
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No previous purchases found'),
      ),
    );
  }

  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms & Conditions'),
        content: const SingleChildScrollView(
          child: Text(
            'By subscribing to AI Home Design Premium, you agree to our terms of service and privacy policy. '
            'Subscriptions are charged to your account and automatically renew unless cancelled. '
            'You can manage your subscription in your device settings.',
          ),
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
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String description;
  final bool isPremium;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    this.isPremium = false,
  });
}