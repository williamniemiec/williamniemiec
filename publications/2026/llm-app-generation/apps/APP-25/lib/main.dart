import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/home/providers/home_provider.dart';
import 'features/discover/providers/discover_provider.dart';
import 'features/profile/providers/profile_provider.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/home/screens/home_screen.dart';
import 'features/discover/screens/discover_screen.dart';
import 'features/create/screens/create_screen.dart';
import 'features/chat/screens/chat_screen.dart';
import 'features/inbox/screens/inbox_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/post_detail/screens/post_detail_screen.dart';
import 'features/subreddit/screens/subreddit_screen.dart';

void main() {
  runApp(const RedditApp());
}

class RedditApp extends StatelessWidget {
  const RedditApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => DiscoverProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp.router(
            title: AppConstants.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            routerConfig: _createRouter(authProvider),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

  GoRouter _createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: authProvider.isAuthenticated ? AppRoutes.home : AppRoutes.login,
      redirect: (context, state) {
        final isAuthenticated = authProvider.isAuthenticated;
        final isLoginRoute = state.matchedLocation == AppRoutes.login;

        // Redirect to login if not authenticated and not already on login
        if (!isAuthenticated && !isLoginRoute) {
          return AppRoutes.login;
        }

        // Redirect to home if authenticated and on login page
        if (isAuthenticated && isLoginRoute) {
          return AppRoutes.home;
        }

        return null;
      },
      routes: [
        // Auth routes
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginScreen(),
        ),

        // Main app shell with bottom navigation
        ShellRoute(
          builder: (context, state, child) {
            return MainNavigationShell(child: child);
          },
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: AppRoutes.discover,
              builder: (context, state) => const DiscoverScreen(),
            ),
            GoRoute(
              path: AppRoutes.create,
              builder: (context, state) => const CreateScreen(),
            ),
            GoRoute(
              path: AppRoutes.chat,
              builder: (context, state) => const ChatScreen(),
            ),
            GoRoute(
              path: AppRoutes.inbox,
              builder: (context, state) => const InboxScreen(),
            ),
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),

        // Detail routes (full screen)
        GoRoute(
          path: AppRoutes.postDetail,
          builder: (context, state) {
            final postId = state.pathParameters['postId']!;
            return PostDetailScreen(postId: postId);
          },
        ),
        GoRoute(
          path: AppRoutes.subreddit,
          builder: (context, state) {
            final subredditName = state.pathParameters['subredditName']!;
            return SubredditScreen(subredditName: subredditName);
          },
        ),
      ],
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  final Widget child;

  const MainNavigationShell({
    super.key,
    required this.child,
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Home',
      route: AppRoutes.home,
    ),
    NavigationItem(
      icon: Icons.explore_outlined,
      selectedIcon: Icons.explore,
      label: 'Discover',
      route: AppRoutes.discover,
    ),
    NavigationItem(
      icon: Icons.add_circle_outline,
      selectedIcon: Icons.add_circle,
      label: 'Create',
      route: AppRoutes.create,
    ),
    NavigationItem(
      icon: Icons.chat_bubble_outline,
      selectedIcon: Icons.chat_bubble,
      label: 'Chat',
      route: AppRoutes.chat,
    ),
    NavigationItem(
      icon: Icons.notifications_outlined,
      selectedIcon: Icons.notifications,
      label: 'Inbox',
      route: AppRoutes.inbox,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: _navigationItems.map((item) {
          final isSelected = _navigationItems[_currentIndex] == item;
          return BottomNavigationBarItem(
            icon: Icon(isSelected ? item.selectedIcon : item.icon),
            label: item.label,
          );
        }).toList(),
      ),
      floatingActionButton: _currentIndex == 0 // Show only on home
          ? FloatingActionButton(
              onPressed: () => context.go(AppRoutes.create),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    context.go(_navigationItems[index].route);
  }
}

class NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;

  const NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
  });
}
