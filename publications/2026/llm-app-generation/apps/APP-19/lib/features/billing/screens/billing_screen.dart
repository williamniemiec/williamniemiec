import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/models/bill.dart';
import '../providers/billing_provider.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BillingProvider>(context, listen: false).loadBills();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Billing'),
      ),
      body: Consumer<BillingProvider>(
        builder: (context, billingProvider, child) {
          if (billingProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (billingProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    billingProvider.errorMessage!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      billingProvider.loadBills();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => billingProvider.loadBills(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Account Summary
                  _buildAccountSummary(billingProvider),
                  
                  const SizedBox(height: 24),
                  
                  // Bills List
                  Text(
                    'Recent Statements',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  if (billingProvider.bills.isEmpty)
                    _buildEmptyState()
                  else
                    ...billingProvider.bills.map((bill) => _BillCard(
                      bill: bill,
                      onPayNow: () => _showPaymentDialog(bill),
                      onSetupPaymentPlan: () => _showPaymentPlanDialog(bill),
                      onViewDetails: () => _showBillDetails(bill),
                    )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAccountSummary(BillingProvider billingProvider) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Balance',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textOnPrimary.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${billingProvider.totalBalance.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppColors.textOnPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pending Bills',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textOnPrimary.withOpacity(0.8),
                        ),
                      ),
                      Text(
                        '${billingProvider.pendingBills.length}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.textOnPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overdue Bills',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textOnPrimary.withOpacity(0.8),
                        ),
                      ),
                      Text(
                        '${billingProvider.overdueBills.length}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.textOnPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (billingProvider.totalBalance > 0) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showPayAllDialog(billingProvider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textOnPrimary,
                    foregroundColor: AppColors.primary,
                  ),
                  child: const Text('Pay All Bills'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'No bills available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your billing statements will appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(Bill bill) {
    final amountController = TextEditingController(
      text: bill.balanceDue.toStringAsFixed(2),
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pay Bill - ${bill.statementNumber}'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Balance Due: \$${bill.balanceDue.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Payment Amount',
                  prefixText: '\$',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  if (amount > bill.balanceDue) {
                    return 'Amount cannot exceed balance due';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'credit',
                    child: Text('Credit Card ending in 1234'),
                  ),
                  DropdownMenuItem(
                    value: 'bank',
                    child: Text('Bank Account ending in 5678'),
                  ),
                ],
                onChanged: (value) {},
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a payment method';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          Consumer<BillingProvider>(
            builder: (context, billingProvider, child) {
              return ElevatedButton(
                onPressed: billingProvider.isLoading
                    ? null
                    : () async {
                        if (formKey.currentState!.validate()) {
                          final amount = double.parse(amountController.text);
                          final success = await billingProvider.payBill(bill.id, amount);
                          
                          if (success && mounted) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Payment of \$${amount.toStringAsFixed(2)} processed successfully'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          }
                        }
                      },
                child: billingProvider.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Pay Now'),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showPaymentPlanDialog(Bill bill) {
    final monthlyPaymentController = TextEditingController();
    final numberOfPaymentsController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Setup Payment Plan - ${bill.statementNumber}'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Balance: \$${bill.balanceDue.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: monthlyPaymentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monthly Payment',
                  prefixText: '\$',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter monthly payment amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: numberOfPaymentsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Number of Payments',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of payments';
                  }
                  final number = int.tryParse(value);
                  if (number == null || number <= 0) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          Consumer<BillingProvider>(
            builder: (context, billingProvider, child) {
              return ElevatedButton(
                onPressed: billingProvider.isLoading
                    ? null
                    : () async {
                        if (formKey.currentState!.validate()) {
                          final monthlyPayment = double.parse(monthlyPaymentController.text);
                          final numberOfPayments = int.parse(numberOfPaymentsController.text);
                          
                          final success = await billingProvider.setupPaymentPlan(
                            bill.id,
                            monthlyPayment,
                            numberOfPayments,
                          );
                          
                          if (success && mounted) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Payment plan setup successfully'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          }
                        }
                      },
                child: billingProvider.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Setup Plan'),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showPayAllDialog(BillingProvider billingProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pay All Bills'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Amount: \$${billingProvider.totalBalance.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This will pay all ${billingProvider.pendingBills.length} pending bills.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pay all bills feature coming soon!'),
                ),
              );
            },
            child: const Text('Pay All'),
          ),
        ],
      ),
    );
  }

  void _showBillDetails(Bill bill) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Statement ${bill.statementNumber}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Statement Date', DateFormat('MMM dd, yyyy').format(bill.statementDate)),
              if (bill.dueDate != null)
                _buildDetailRow('Due Date', DateFormat('MMM dd, yyyy').format(bill.dueDate!)),
              _buildDetailRow('Total Amount', '\$${bill.totalAmount.toStringAsFixed(2)}'),
              _buildDetailRow('Amount Paid', '\$${bill.amountPaid.toStringAsFixed(2)}'),
              _buildDetailRow('Balance Due', '\$${bill.balanceDue.toStringAsFixed(2)}'),
              _buildDetailRow('Status', bill.statusDisplayName),
              
              if (bill.lineItems.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Services',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ...bill.lineItems.map((item) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Service Date: ${DateFormat('MMM dd, yyyy').format(item.serviceDate)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        'Code: ${item.serviceCode}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Charge:', style: Theme.of(context).textTheme.bodySmall),
                          Text('\$${item.amount.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Insurance Covered:', style: Theme.of(context).textTheme.bodySmall),
                          Text('\$${item.insuranceCovered.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Your Responsibility:', 
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                          Text('\$${item.patientResponsibility.toStringAsFixed(2)}', 
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                )),
              ],
              
              if (bill.hasPaymentPlan) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.info.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Plan Active',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.info,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Monthly Payment: \$${bill.paymentPlan!.monthlyPayment.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        'Remaining Payments: ${bill.paymentPlan!.remainingPayments}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (bill.paymentPlan!.nextPaymentDate != null)
                        Text(
                          'Next Payment: ${DateFormat('MMM dd, yyyy').format(bill.paymentPlan!.nextPaymentDate!)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _BillCard extends StatelessWidget {
  final Bill bill;
  final VoidCallback onPayNow;
  final VoidCallback onSetupPaymentPlan;
  final VoidCallback onViewDetails;

  const _BillCard({
    required this.bill,
    required this.onPayNow,
    required this.onSetupPaymentPlan,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.receipt_long_outlined,
                    color: _getStatusColor(),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Statement ${bill.statementNumber}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        DateFormat('MMM dd, yyyy').format(bill.statementDate),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${bill.balanceDue.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: bill.balanceDue > 0 ? AppColors.textPrimary : AppColors.success,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor().withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        bill.statusDisplayName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _getStatusColor(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            if (bill.dueDate != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: bill.isOverdue ? AppColors.error : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Due: ${DateFormat('MMM dd, yyyy').format(bill.dueDate!)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: bill.isOverdue ? AppColors.error : AppColors.textSecondary,
                      fontWeight: bill.isOverdue ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  if (bill.isOverdue) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'OVERDUE',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
            
            if (bill.hasPaymentPlan) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule_outlined,
                      size: 16,
                      color: AppColors.info,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Payment Plan: \$${bill.paymentPlan!.monthlyPayment.toStringAsFixed(2)}/month',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.info,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            if (bill.balanceDue > 0) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onViewDetails,
                      child: const Text('View Details'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (!bill.hasPaymentPlan)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onSetupPaymentPlan,
                        child: const Text('Payment Plan'),
                      ),
                    ),
                  if (!bill.hasPaymentPlan)
                    const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onPayNow,
                      child: const Text('Pay Now'),
                    ),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onViewDetails,
                  child: const Text('View Details'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    if (bill.isOverdue) return AppColors.error;
    
    switch (bill.status) {
      case BillStatus.pending:
        return AppColors.warning;
      case BillStatus.paid:
        return AppColors.success;
      case BillStatus.overdue:
        return AppColors.error;
      case BillStatus.partiallyPaid:
        return AppColors.info;
      case BillStatus.disputed:
        return AppColors.error;
    }
  }
}