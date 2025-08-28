import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/app_provider.dart';
import '../../../shared/models/search.dart';
import '../widgets/search_widget.dart';
import '../widgets/service_tabs.dart';
import '../widgets/recent_searches.dart';
import '../widgets/promotional_banners.dart';
import '../../search/screens/search_results_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _selectedService = 'stays';

  final List<Widget> _screens = [
    const HomeTab(),
    const SearchTab(),
    const BookingsTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryBlue,
        unselectedItemColor: AppTheme.mediumGrey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String _selectedService = 'stays';

  void _handleSearch(SearchCriteria criteria) {
    final appProvider = context.read<AppProvider>();
    appProvider.updateSearchCriteria(criteria);
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SearchResultsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.travel_explore,
                size: 20,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(width: 12),
            const Text('Booking.com'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          Consumer<AppProvider>(
            builder: (context, appProvider, child) {
              return IconButton(
                icon: CircleAvatar(
                  radius: 16,
                  backgroundColor: AppTheme.lightGrey,
                  child: Text(
                    appProvider.currentUser?.firstName.substring(0, 1).toUpperCase() ?? 'U',
                    style: const TextStyle(
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onPressed: () {
                  // TODO: Navigate to profile
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Section
            Container(
              color: AppTheme.primaryBlue,
              child: Column(
                children: [
                  // Service Tabs
                  ServiceTabs(
                    selectedService: _selectedService,
                    onServiceChanged: (service) {
                      setState(() {
                        _selectedService = service;
                      });
                    },
                  ),
                  
                  // Search Widget
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SearchWidget(
                      serviceType: _selectedService,
                      onSearch: _handleSearch,
                    ),
                  ),
                ],
              ),
            ),
            
            // Recent Searches
            Consumer<AppProvider>(
              builder: (context, appProvider, child) {
                if (appProvider.recentSearches.isNotEmpty) {
                  return RecentSearches(
                    searches: appProvider.recentSearches,
                    onSearchTap: (search) {
                      final criteria = SearchCriteria(
                        destination: search.destination,
                        checkInDate: DateTime.now().add(const Duration(days: 1)),
                        checkOutDate: DateTime.now().add(const Duration(days: 3)),
                        serviceType: search.serviceType,
                      );
                      _handleSearch(criteria);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            
            // Promotional Banners
            const PromotionalBanners(),
            
            // Featured Destinations
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Popular Destinations',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final destinations = ['Paris', 'London', 'New York', 'Tokyo', 'Sydney'];
                        return Container(
                          width: 160,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: NetworkImage('https://picsum.photos/160/200?random=$index'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    destinations[index],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${(index + 1) * 100}+ properties',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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
}

// Placeholder tabs
class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Search Tab - Coming Soon'),
      ),
    );
  }
}

class BookingsTab extends StatelessWidget {
  const BookingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Bookings Tab - Coming Soon'),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AppProvider>().signOut();
            },
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          final user = appProvider.currentUser;
          if (user == null) return const SizedBox.shrink();
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.lightGrey,
                  child: Text(
                    user.firstName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 32,
                      color: AppTheme.primaryBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.fullName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.mediumGrey,
                  ),
                ),
                if (user.isGeniusMember) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.accentOrange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Genius Level ${user.geniusLevel}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}