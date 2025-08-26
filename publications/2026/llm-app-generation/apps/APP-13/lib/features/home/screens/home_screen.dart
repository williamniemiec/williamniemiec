import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/cookie.dart';
import '../widgets/weekly_menu_carousel.dart';
import '../widgets/cookie_detail_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load weekly cookies when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWeeklyCookies();
    });
  }

  void _loadWeeklyCookies() {
    // TODO: Load cookies from provider
  }

  void _showCookieDetail(Cookie cookie) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CookieDetailModal(cookie: cookie),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Crumbl',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.crumblPink,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppTheme.crumblLightPink,
                      Colors.white,
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                color: AppTheme.crumblPink,
                onPressed: () {
                  // TODO: Navigate to cart
                },
              ),
            ],
          ),

          // Welcome Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This Week\'s Menu',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    'Fresh, warm cookies baked daily',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.mediumGray,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Weekly Menu Carousel
          SliverToBoxAdapter(
            child: SizedBox(
              height: 300,
              child: WeeklyMenuCarousel(
                onCookieTap: _showCookieDetail,
              ),
            ),
          ),

          // Order Now Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                children: [
                  const SizedBox(height: AppConstants.defaultPadding),
                  Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: AppTheme.crumblGradient,
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                        onTap: () {
                          // Navigate to order screen
                          DefaultTabController.of(context)?.animateTo(1);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(AppConstants.defaultPadding),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.shopping_bag,
                                color: Colors.white,
                                size: 32,
                              ),
                              const SizedBox(height: AppConstants.smallPadding),
                              Text(
                                'Order Now',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Skip the line, order ahead',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Features Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Why Choose Crumbl?',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFeatureCard(
                          context,
                          Icons.schedule,
                          'Fresh Daily',
                          'Baked fresh every day',
                        ),
                      ),
                      const SizedBox(width: AppConstants.smallPadding),
                      Expanded(
                        child: _buildFeatureCard(
                          context,
                          Icons.local_shipping,
                          'Fast Delivery',
                          'Delivered warm to your door',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFeatureCard(
                          context,
                          Icons.star,
                          'Weekly Specials',
                          'New flavors every week',
                        ),
                      ),
                      const SizedBox(width: AppConstants.smallPadding),
                      Expanded(
                        child: _buildFeatureCard(
                          context,
                          Icons.card_giftcard,
                          'Loyalty Rewards',
                          'Earn points with every order',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: AppConstants.largePadding),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppTheme.crumblPink,
            size: 32,
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}