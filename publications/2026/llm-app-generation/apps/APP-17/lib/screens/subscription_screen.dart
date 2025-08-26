import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_theme.dart';
import '../constants/app_constants.dart';
import '../providers/tea_provider.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String? _selectedPlan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Upgrade to Premium'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<TeaProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: AppTheme.defaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.workspace_premium,
                        size: 64,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Unlock Your Dating Potential',
                        style: AppTheme.headlineMedium.copyWith(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Get unlimited access to all AI-powered dating features',
                        style: AppTheme.bodyMedium.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Features list
                Text(
                  'Premium Features',
                  style: AppTheme.headlineSmall,
                ),
                
                const SizedBox(height: 16),
                
                ...AppConstants.premiumFeatures.map((feature) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppTheme.successColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            feature,
                            style: AppTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                
                const SizedBox(height: 32),
                
                // Subscription plans
                Text(
                  'Choose Your Plan',
                  style: AppTheme.headlineSmall,
                ),
                
                const SizedBox(height: 16),
                
                // Weekly plan
                _buildPlanCard(
                  id: AppConstants.weeklySubscriptionId,
                  title: 'Weekly Premium',
                  price: '\$4.99',
                  period: 'per week',
                  description: 'Perfect for trying out premium features',
                  isPopular: false,
                ),
                
                const SizedBox(height: 12),
                
                // Monthly plan
                _buildPlanCard(
                  id: AppConstants.monthlySubscriptionId,
                  title: 'Monthly Premium',
                  price: '\$14.99',
                  period: 'per month',
                  description: 'Best value for regular users',
                  isPopular: true,
                ),
                
                const SizedBox(height: 12),
                
                // Lifetime plan
                _buildPlanCard(
                  id: AppConstants.lifetimeSubscriptionId,
                  title: 'Lifetime Premium',
                  price: '\$99.99',
                  period: 'one-time',
                  description: 'Unlimited access forever',
                  isPopular: false,
                ),
                
                const SizedBox(height: 32),
                
                // Purchase button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedPlan != null && !provider.isLoading
                        ? () => _purchaseSubscription(provider)
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: provider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            _selectedPlan != null 
                                ? 'Start Premium'
                                : 'Select a Plan',
                            style: AppTheme.titleMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Terms and privacy
                Text(
                  'By purchasing, you agree to our Terms of Service and Privacy Policy. Subscriptions auto-renew unless cancelled.',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlanCard({
    required String id,
    required String title,
    required String price,
    required String period,
    required String description,
    required bool isPopular,
  }) {
    final isSelected = _selectedPlan == id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlan = id;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? AppTheme.primaryColor 
                : AppTheme.textTertiary.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
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
                            title,
                            style: AppTheme.titleLarge.copyWith(
                              color: isSelected 
                                  ? AppTheme.primaryColor 
                                  : AppTheme.textPrimary,
                            ),
                          ),
                          if (isPopular) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                gradient: AppTheme.secondaryGradient,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'POPULAR',
                                style: AppTheme.labelSmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: AppTheme.bodySmall.copyWith(
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
                      price,
                      style: AppTheme.headlineSmall.copyWith(
                        color: isSelected 
                            ? AppTheme.primaryColor 
                            : AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      period,
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 20,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Selected',
                      style: AppTheme.labelMedium.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _purchaseSubscription(TeaProvider provider) async {
    if (_selectedPlan == null) return;

    try {
      await provider.purchaseSubscription(_selectedPlan!);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppConstants.subscriptionSuccess),
            backgroundColor: AppTheme.successColor,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Purchase failed: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }
}