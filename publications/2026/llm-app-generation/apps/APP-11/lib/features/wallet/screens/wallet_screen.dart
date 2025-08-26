import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/payment_method.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  // Mock data
  final double paypalBalance = 1234.56;
  final double savingsBalance = 5678.90;
  
  final List<PaymentMethod> mockPaymentMethods = [
    PaymentMethod(
      id: '1',
      userId: '1',
      type: PaymentMethodType.paypalBalance,
      displayName: 'PayPal Balance',
      isDefault: true,
      isVerified: true,
      createdAt: DateTime.now(),
    ),
    PaymentMethod(
      id: '2',
      userId: '1',
      type: PaymentMethodType.bankAccount,
      displayName: 'Chase Bank',
      lastFourDigits: '1234',
      bankName: 'Chase Bank',
      bankAccountType: BankAccountType.checking,
      isDefault: false,
      isVerified: true,
      createdAt: DateTime.now(),
    ),
    PaymentMethod(
      id: '3',
      userId: '1',
      type: PaymentMethodType.creditCard,
      displayName: 'Visa Credit Card',
      lastFourDigits: '5678',
      cardBrand: CardBrand.visa,
      expiryMonth: '12',
      expiryYear: '25',
      isDefault: false,
      isVerified: true,
      createdAt: DateTime.now(),
    ),
    PaymentMethod(
      id: '4',
      userId: '1',
      type: PaymentMethodType.debitCard,
      displayName: 'Mastercard Debit',
      lastFourDigits: '9012',
      cardBrand: CardBrand.mastercard,
      expiryMonth: '08',
      expiryYear: '26',
      isDefault: false,
      isVerified: true,
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      appBar: AppBar(
        title: const Text('Wallet'),
        backgroundColor: AppTheme.paypalBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddPaymentMethodBottomSheet(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PayPal Balance Card
            _buildBalanceCard(
              context,
              title: 'PayPal Balance',
              balance: paypalBalance,
              currency: 'USD',
              icon: Icons.account_balance_wallet,
              gradient: AppTheme.primaryGradient,
              onAddMoney: () {
                // Navigate to add money screen
              },
              onTransfer: () {
                // Navigate to transfer screen
              },
            ),
            const SizedBox(height: AppConstants.defaultPadding),

            // Savings Account Card (if enabled)
            if (AppConstants.enableSavingsAccount)
              _buildBalanceCard(
                context,
                title: 'High-Yield Savings',
                balance: savingsBalance,
                currency: 'USD',
                subtitle: '4.50% APY',
                icon: Icons.savings,
                gradient: AppTheme.successGradient,
                onAddMoney: () {
                  // Navigate to savings deposit screen
                },
                onTransfer: () {
                  // Navigate to savings withdrawal screen
                },
              ),
            const SizedBox(height: AppConstants.largePadding),

            // Payment Methods Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Methods',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    _showAddPaymentMethodBottomSheet(context);
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.defaultPadding),

            // Payment Methods List
            Card(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mockPaymentMethods.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final paymentMethod = mockPaymentMethods[index];
                  return _buildPaymentMethodTile(context, paymentMethod);
                },
              ),
            ),
            const SizedBox(height: AppConstants.largePadding),

            // Additional Features
            _buildAdditionalFeatures(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(
    BuildContext context, {
    required String title,
    required double balance,
    required String currency,
    String? subtitle,
    required IconData icon,
    required LinearGradient gradient,
    required VoidCallback onAddMoney,
    required VoidCallback onTransfer,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.white, size: 24),
                const SizedBox(width: AppConstants.smallPadding),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.white.withOpacity(0.8),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Text(
              _formatCurrency(balance, currency),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppTheme.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.largePadding),
            Row(
              children: [
                Expanded(
                  child: _buildBalanceActionButton(
                    context,
                    icon: Icons.add,
                    label: 'Add Money',
                    onPressed: onAddMoney,
                  ),
                ),
                const SizedBox(width: AppConstants.defaultPadding),
                Expanded(
                  child: _buildBalanceActionButton(
                    context,
                    icon: Icons.send,
                    label: 'Transfer',
                    onPressed: onTransfer,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.white.withOpacity(0.2),
        foregroundColor: AppTheme.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
          side: BorderSide(
            color: AppTheme.white.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTile(BuildContext context, PaymentMethod paymentMethod) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
      leading: _buildPaymentMethodIcon(paymentMethod),
      title: Text(
        paymentMethod.displayName,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (paymentMethod.maskedNumber.isNotEmpty)
            Text(paymentMethod.maskedNumber),
          if (paymentMethod.isDefault)
            Text(
              'Default',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.paypalBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (paymentMethod.isVerified)
            const Icon(
              Icons.verified,
              color: AppTheme.successColor,
              size: 20,
            ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  // Edit payment method
                  break;
                case 'default':
                  // Set as default
                  break;
                case 'remove':
                  // Remove payment method
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit'),
              ),
              if (!paymentMethod.isDefault)
                const PopupMenuItem(
                  value: 'default',
                  child: Text('Set as Default'),
                ),
              const PopupMenuItem(
                value: 'remove',
                child: Text('Remove'),
              ),
            ],
          ),
        ],
      ),
      onTap: () {
        // Navigate to payment method details
      },
    );
  }

  Widget _buildPaymentMethodIcon(PaymentMethod paymentMethod) {
    IconData iconData;
    Color backgroundColor;
    Color iconColor;

    switch (paymentMethod.type) {
      case PaymentMethodType.paypalBalance:
        iconData = Icons.account_balance_wallet;
        backgroundColor = AppTheme.paypalBlue.withOpacity(0.1);
        iconColor = AppTheme.paypalBlue;
        break;
      case PaymentMethodType.bankAccount:
        iconData = Icons.account_balance;
        backgroundColor = AppTheme.successColor.withOpacity(0.1);
        iconColor = AppTheme.successColor;
        break;
      case PaymentMethodType.creditCard:
        iconData = Icons.credit_card;
        backgroundColor = AppTheme.warningColor.withOpacity(0.1);
        iconColor = AppTheme.warningColor;
        break;
      case PaymentMethodType.debitCard:
        iconData = Icons.payment;
        backgroundColor = AppTheme.infoColor.withOpacity(0.1);
        iconColor = AppTheme.infoColor;
        break;
      case PaymentMethodType.paypalCredit:
        iconData = Icons.credit_score;
        backgroundColor = AppTheme.paypalYellow.withOpacity(0.1);
        iconColor = AppTheme.paypalYellow;
        break;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        iconData,
        size: 20,
        color: iconColor,
      ),
    );
  }

  Widget _buildAdditionalFeatures(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'More Options',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        Card(
          child: Column(
            children: [
              if (AppConstants.enableDebitCard)
                ListTile(
                  leading: const Icon(Icons.credit_card, color: AppTheme.paypalBlue),
                  title: const Text('PayPal Debit Card'),
                  subtitle: const Text('Get cash back rewards'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navigate to debit card screen
                  },
                ),
              if (AppConstants.enablePayIn4)
                ListTile(
                  leading: const Icon(Icons.schedule, color: AppTheme.paypalLightBlue),
                  title: const Text('Pay in 4'),
                  subtitle: const Text('Split purchases into 4 payments'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Navigate to Pay in 4 screen
                  },
                ),
              ListTile(
                leading: const Icon(Icons.history, color: AppTheme.mediumGray),
                title: const Text('Transaction History'),
                subtitle: const Text('View all your transactions'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to transaction history
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddPaymentMethodBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.lightGray,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              Text(
                'Add Payment Method',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppConstants.largePadding),
              _buildAddPaymentOption(
                context,
                icon: Icons.account_balance,
                title: 'Bank Account',
                subtitle: 'Link your bank account',
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to add bank account
                },
              ),
              _buildAddPaymentOption(
                context,
                icon: Icons.credit_card,
                title: 'Credit or Debit Card',
                subtitle: 'Add a card for payments',
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to add card
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddPaymentOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppTheme.paypalBlue),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  String _formatCurrency(double amount, String currency) {
    switch (currency) {
      case 'USD':
        return '\$${amount.toStringAsFixed(2)}';
      case 'EUR':
        return '€${amount.toStringAsFixed(2)}';
      case 'GBP':
        return '£${amount.toStringAsFixed(2)}';
      default:
        return '$currency ${amount.toStringAsFixed(2)}';
    }
  }
}