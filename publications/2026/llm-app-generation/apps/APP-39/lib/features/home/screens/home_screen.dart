import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../widgets/google_search_bar.dart';
import '../widgets/discover_feed.dart';
import '../../profile/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more articles when near bottom
      context.read<AppProvider>().loadDiscoverFeed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Consumer<AppProvider>(
          builder: (context, appProvider, child) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                // App Bar with Google logo and profile
                SliverAppBar(
                  floating: true,
                  snap: true,
                  elevation: 0,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  title: Row(
                    children: [
                      // Google Logo
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              'G',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                            Text(
                              'o',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryRed,
                              ),
                            ),
                            Text(
                              'o',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryYellow,
                              ),
                            ),
                            Text(
                              'g',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryBlue,
                              ),
                            ),
                            Text(
                              'l',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryGreen,
                              ),
                            ),
                            Text(
                              'e',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryRed,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Profile Icon
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: appProvider.currentUser != null
                                ? AppTheme.primaryBlue
                                : AppTheme.textSecondary,
                          ),
                          child: appProvider.currentUser?.profileImageUrl != null
                              ? ClipOval(
                                  child: Image.network(
                                    appProvider.currentUser!.profileImageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 20,
                                      );
                                    },
                                  ),
                                )
                              : Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 20,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: GoogleSearchBar(
                      onTap: () {
                        // Navigate to search screen
                        Navigator.pushNamed(context, '/search');
                      },
                    ),
                  ),
                ),
                
                // Incognito Mode Banner
                if (appProvider.isIncognitoMode)
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: AppConstants.defaultPadding,
                        vertical: AppConstants.smallPadding,
                      ),
                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                      decoration: BoxDecoration(
                        color: AppTheme.textSecondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.visibility_off,
                            color: AppTheme.textSecondary,
                            size: 20,
                          ),
                          const SizedBox(width: AppConstants.smallPadding),
                          Expanded(
                            child: Text(
                              'You\'re in Incognito mode',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              appProvider.toggleIncognitoMode();
                            },
                            child: Text('Turn off'),
                          ),
                        ],
                      ),
                    ),
                  ),
                
                // Discover Feed
                const DiscoverFeed(),
                
                // Loading indicator
                if (appProvider.isLoadingDiscover)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(AppConstants.defaultPadding),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}