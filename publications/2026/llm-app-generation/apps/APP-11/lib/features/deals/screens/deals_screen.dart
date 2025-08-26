import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/deal.dart';

class DealsScreen extends StatefulWidget {
  const DealsScreen({super.key});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';

  // Mock deals data
  final List<Deal> mockDeals = [
    Deal(
      id: '1',
      merchantId: 'starbucks',
      merchantName: 'Starbucks',
      merchantLogoUrl: 'https://logo.clearbit.com/starbucks.com',
      title: '5% Cash Back',
      description: 'Get 5% cash back on all Starbucks purchases',
      type: DealType.cashBack,
      status: DealStatus.active,
      cashBackPercentage: 5.0,
      startDate: DateTime.now().subtract(const Duration(days: 7)),
      endDate: DateTime.now().add(const Duration(days: 30)),
      categories: ['Food & Dining'],
      usageCount: 0,
      isExclusive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    Deal(
      id: '2',
      merchantId: 'amazon',
      merchantName: 'Amazon',
      merchantLogoUrl: 'https://logo.clearbit.com/amazon.com',
      title: '10% Off Electronics',
      description: 'Save 10% on electronics with minimum \$100 purchase',
      type: DealType.discount,
      status: DealStatus.active,
      discountPercentage: 10.0,
      minimumPurchase: 100.0,
      startDate: DateTime.now().subtract(const Duration(days: 3)),
      endDate: DateTime.now().add(const Duration(days: 14)),
      categories: ['Electronics', 'Shopping'],
      usageCount: 0,
      isExclusive: false,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Deal(
      id: '3',
      merchantId: 'target',
      merchantName: 'Target',
      merchantLogoUrl: 'https://logo.clearbit.com/target.com',
      title: 'Free Shipping',
      description: 'Free shipping on orders over \$35',
      type: DealType.freeShipping,
      status: DealStatus.active,
      minimumPurchase: 35.0,
      startDate: DateTime.now().subtract(const Duration(days: 1)),
      endDate: DateTime.now().add(const Duration(days: 60)),
      categories: ['Shopping'],
      usageCount: 0,
      isExclusive: false,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Deal(
      id: '4',
      merchantId: 'nike',
      merchantName: 'Nike',
      merchantLogoUrl: 'https://logo.clearbit.com/nike.com',
      title: 'Buy One Get One 50% Off',
      description: 'Buy one item, get the second 50% off',
      type: DealType.buyOneGetOne,
      status: DealStatus.active,
      startDate: DateTime.now().subtract(const Duration(days: 5)),
      endDate: DateTime.now().add(const Duration(days: 21)),
      categories: ['Sports & Outdoors', 'Shopping'],
      usageCount: 0,
      isExclusive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Deal(
      id: '5',
      merchantId: 'uber',
      merchantName: 'Uber Eats',
      merchantLogoUrl: 'https://logo.clearbit.com/uber.com',
      title: '3% Cash Back',
      description: 'Earn 3% cash back on food delivery orders',
      type: DealType.cashBack,
      status: DealStatus.saved,
      cashBackPercentage: 3.0,
      startDate: DateTime.now().subtract(const Duration(days: 10)),
      endDate: DateTime.now().add(const Duration(days: 20)),
      categories: ['Food & Dining'],
      usageCount: 2,
      isExclusive: false,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      savedAt: DateTime.now().subtract(const Duration(days: 8)),
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
        title: const Text('Deals'),
        backgroundColor: AppTheme.paypalBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Navigate to search deals
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: AppTheme.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.paypalBlue,
              unselectedLabelColor: AppTheme.mediumGray,
              indicatorColor: AppTheme.paypalBlue,
              tabs: const [
                Tab(text: 'Available'),
                Tab(text: 'Saved'),
              ],
            ),
          ),

          // Category Filter
          Container(
            color: AppTheme.white,
            padding: const EdgeInsets.symmetric(vertical: AppConstants.smallPadding),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
                itemCount: AppConstants.dealCategories.length,
                itemBuilder: (context, index) {
                  final category = AppConstants.dealCategories[index];
                  final isSelected = category == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppConstants.smallPadding),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      backgroundColor: AppTheme.lightGray,
                      selectedColor: AppTheme.paypalBlue.withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: isSelected ? AppTheme.paypalBlue : AppTheme.primaryTextColor,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAvailableDealsTab(),
                _buildSavedDealsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableDealsTab() {
    final filteredDeals = _getFilteredDeals(mockDeals.where((deal) => 
        deal.status == DealStatus.active).toList());

    return RefreshIndicator(
      onRefresh: () async {
        // Implement refresh logic
        await Future.delayed(const Duration(seconds: 1));
      },
      child: filteredDeals.isEmpty
          ? _buildEmptyState('No deals available', 'Check back later for new offers')
          : ListView.builder(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              itemCount: filteredDeals.length,
              itemBuilder: (context, index) {
                final deal = filteredDeals[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
                  child: _buildDealCard(context, deal),
                );
              },
            ),
    );
  }

  Widget _buildSavedDealsTab() {
    final savedDeals = _getFilteredDeals(mockDeals.where((deal) => 
        deal.status == DealStatus.saved).toList());

    return savedDeals.isEmpty
        ? _buildEmptyState('No saved deals', 'Save deals to use them later')
        : ListView.builder(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            itemCount: savedDeals.length,
            itemBuilder: (context, index) {
              final deal = savedDeals[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
                child: _buildDealCard(context, deal),
              );
            },
          );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.extraLargePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_offer_outlined,
              size: 64,
              color: AppTheme.mediumGray,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDealCard(BuildContext context, Deal deal) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: InkWell(
        onTap: () {
          _showDealDetails(context, deal);
        },
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Merchant Logo
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.lightGray,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.store,
                      color: AppTheme.mediumGray,
                    ),
                  ),
                  const SizedBox(width: AppConstants.defaultPadding),
                  
                  // Deal Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              deal.merchantName,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (deal.isExclusive) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.paypalYellow,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'EXCLUSIVE',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppTheme.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          deal.dealValue,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppTheme.paypalBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Action Button
                  _buildDealActionButton(context, deal),
                ],
              ),
              const SizedBox(height: AppConstants.defaultPadding),
              
              // Description
              Text(
                deal.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              
              if (deal.minimumPurchaseText.isNotEmpty) ...[
                const SizedBox(height: AppConstants.smallPadding),
                Text(
                  deal.minimumPurchaseText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.secondaryTextColor,
                  ),
                ),
              ],
              
              const SizedBox(height: AppConstants.defaultPadding),
              
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    deal.expiryText,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: deal.daysUntilExpiry <= 3 
                          ? AppTheme.errorColor 
                          : AppTheme.secondaryTextColor,
                    ),
                  ),
                  if (deal.categories.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.lightGray,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        deal.categories.first,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.secondaryTextColor,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDealActionButton(BuildContext context, Deal deal) {
    if (deal.status == DealStatus.saved) {
      return ElevatedButton(
        onPressed: () {
          // Use deal
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.successColor,
          foregroundColor: AppTheme.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: const Text('Use'),
      );
    } else {
      return OutlinedButton(
        onPressed: () {
          _saveDeal(deal);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.paypalBlue,
          side: const BorderSide(color: AppTheme.paypalBlue),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: const Text('Save'),
      );
    }
  }

  void _saveDeal(Deal deal) {
    setState(() {
      // In a real app, this would update the deal status via state management
      final index = mockDeals.indexWhere((d) => d.id == deal.id);
      if (index != -1) {
        mockDeals[index] = deal.copyWith(
          status: DealStatus.saved,
          savedAt: DateTime.now(),
        );
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${deal.merchantName} deal saved!'),
        backgroundColor: AppTheme.successColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showDealDetails(BuildContext context, Deal deal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
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
              
              // Deal Header
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppTheme.lightGray,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.store,
                      color: AppTheme.mediumGray,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: AppConstants.defaultPadding),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          deal.merchantName,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          deal.dealValue,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.paypalBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppConstants.largePadding),
              
              // Deal Description
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                deal.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              
              const SizedBox(height: AppConstants.largePadding),
              
              // Terms and Conditions
              if (deal.termsAndConditions != null) ...[
                Text(
                  'Terms & Conditions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppConstants.smallPadding),
                Text(
                  deal.termsAndConditions!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: AppConstants.largePadding),
              ],
              
              const Spacer(),
              
              // Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (deal.status == DealStatus.saved) {
                      // Use deal
                    } else {
                      _saveDeal(deal);
                    }
                  },
                  child: Text(deal.status == DealStatus.saved ? 'Use Deal' : 'Save Deal'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Deal> _getFilteredDeals(List<Deal> deals) {
    if (_selectedCategory == 'All') {
      return deals;
    }
    return deals.where((deal) => deal.categories.contains(_selectedCategory)).toList();
  }
}