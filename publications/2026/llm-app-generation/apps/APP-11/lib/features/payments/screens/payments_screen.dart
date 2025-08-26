import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/transaction.dart';
import '../../../shared/models/contact.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  // Mock data
  final List<Contact> mockFrequentContacts = [
    Contact(
      id: '1',
      firstName: 'Sarah',
      lastName: 'Johnson',
      email: 'sarah.johnson@example.com',
      isPaypalUser: true,
      isFrequentContact: true,
      transactionCount: 15,
      createdAt: DateTime.now(),
    ),
    Contact(
      id: '2',
      firstName: 'Mike',
      lastName: 'Wilson',
      phoneNumber: '+1234567890',
      isPaypalUser: true,
      isFrequentContact: true,
      transactionCount: 8,
      createdAt: DateTime.now(),
    ),
    Contact(
      id: '3',
      firstName: 'Emma',
      lastName: 'Davis',
      email: 'emma.davis@example.com',
      isPaypalUser: true,
      isFrequentContact: true,
      transactionCount: 12,
      createdAt: DateTime.now(),
    ),
  ];

  final List<Transaction> mockTransactions = [
    Transaction(
      id: '1',
      userId: '1',
      type: TransactionType.send,
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
      type: TransactionType.receive,
      status: TransactionStatus.completed,
      amount: 25.00,
      currency: 'USD',
      recipientName: 'Mike Wilson',
      description: 'Coffee payment',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      completedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      appBar: AppBar(
        title: const Text('Payments'),
        backgroundColor: AppTheme.paypalBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              // Navigate to QR scanner
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Action Buttons
          Container(
            color: AppTheme.white,
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    context,
                    icon: Icons.send,
                    label: 'Send Money',
                    color: AppTheme.paypalBlue,
                    onPressed: () {
                      _showSendMoneyBottomSheet(context);
                    },
                  ),
                ),
                const SizedBox(width: AppConstants.defaultPadding),
                Expanded(
                  child: _buildQuickActionButton(
                    context,
                    icon: Icons.request_page,
                    label: 'Request Money',
                    color: AppTheme.paypalLightBlue,
                    onPressed: () {
                      _showRequestMoneyBottomSheet(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Tab Bar
          Container(
            color: AppTheme.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.paypalBlue,
              unselectedLabelColor: AppTheme.mediumGray,
              indicatorColor: AppTheme.paypalBlue,
              tabs: const [
                Tab(text: 'Activity'),
                Tab(text: 'Bills'),
              ],
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActivityTab(),
                _buildBillsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AppTheme.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
        ),
      ),
    );
  }

  Widget _buildActivityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Frequent Contacts
          if (mockFrequentContacts.isNotEmpty) ...[
            Text(
              'Send Again',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: mockFrequentContacts.length,
                itemBuilder: (context, index) {
                  final contact = mockFrequentContacts[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: AppConstants.defaultPadding),
                    child: _buildContactAvatar(context, contact),
                  );
                },
              ),
            ),
            const SizedBox(height: AppConstants.largePadding),
          ],

          // Recent Transactions
          Text(
            'Recent Transactions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mockTransactions.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final transaction = mockTransactions[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: transaction.isIncoming 
                        ? AppTheme.successColor.withOpacity(0.1)
                        : AppTheme.errorColor.withOpacity(0.1),
                    child: Icon(
                      transaction.isIncoming ? Icons.arrow_downward : Icons.arrow_upward,
                      color: transaction.isIncoming 
                          ? AppTheme.successColor 
                          : AppTheme.errorColor,
                    ),
                  ),
                  title: Text(transaction.recipientName ?? 'Unknown'),
                  subtitle: Text(transaction.description ?? ''),
                  trailing: Text(
                    transaction.displayAmount,
                    style: TextStyle(
                      color: transaction.isIncoming 
                          ? AppTheme.successColor 
                          : AppTheme.primaryTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    // Navigate to transaction details
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.largePadding),
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 48,
                    color: AppTheme.mediumGray,
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  Text(
                    'No Bills Yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    'Add your bills to pay them easily with PayPal',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.secondaryTextColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.largePadding),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to add bill screen
                    },
                    child: const Text('Add a Bill'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactAvatar(BuildContext context, Contact contact) {
    return GestureDetector(
      onTap: () {
        _showSendMoneyBottomSheet(context, preselectedContact: contact);
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppTheme.paypalBlue,
            child: Text(
              contact.initials,
              style: const TextStyle(
                color: AppTheme.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            contact.firstName,
            style: Theme.of(context).textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showSendMoneyBottomSheet(BuildContext context, {Contact? preselectedContact}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
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
                'Send Money',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              // Add send money form here
              const Expanded(
                child: Center(
                  child: Text('Send money form would go here'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRequestMoneyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
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
                'Request Money',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              // Add request money form here
              const Expanded(
                child: Center(
                  child: Text('Request money form would go here'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}