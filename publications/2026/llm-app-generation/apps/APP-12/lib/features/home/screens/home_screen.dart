import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../providers/home_provider.dart';
import '../widgets/account_card.dart';
import '../widgets/credit_card_card.dart';
import '../widgets/action_shortcuts.dart';
import '../widgets/recent_transactions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().initializeMockData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGray,
      body: SafeArea(
        child: Consumer<HomeProvider>(
          builder: (context, homeProvider, child) {
            if (homeProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primaryPurple,
                ),
              );
            }

            if (homeProvider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppTheme.errorRed,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      homeProvider.error!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppTheme.textGray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => homeProvider.refreshData(),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => homeProvider.refreshData(),
              color: AppTheme.primaryPurple,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: AppTheme.primaryPurple,
                    expandedHeight: 120,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: Text(
                              homeProvider.user?.name.substring(0, 1).toUpperCase() ?? 'U',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Olá,',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                                Text(
                                  homeProvider.user?.name.split(' ').first ?? 'Usuário',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.visibility_outlined),
                        onPressed: () {
                          // Toggle balance visibility
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.help_outline),
                        onPressed: () {
                          // Show help
                        },
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        if (homeProvider.account != null)
                          AccountCard(account: homeProvider.account!),
                        if (homeProvider.creditCard != null)
                          CreditCardCard(creditCard: homeProvider.creditCard!),
                        const ActionShortcuts(),
                        if (homeProvider.recentTransactions.isNotEmpty)
                          RecentTransactions(
                            transactions: homeProvider.recentTransactions,
                          ),
                        const SizedBox(height: 100), // Bottom padding for navigation
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}