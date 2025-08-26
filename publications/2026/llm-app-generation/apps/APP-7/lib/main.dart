import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/home/screens/home_screen.dart';
import 'features/messages/screens/messages_screen.dart';
import 'features/events/screens/events_screen.dart';
import 'features/explore/screens/explore_screen.dart';
import 'features/more/screens/more_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: ParentSquareApp(),
    ),
  );
}

class ParentSquareApp extends ConsumerWidget {
  const ParentSquareApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppConstants.supportedLanguages.keys
          .map((languageCode) => Locale(languageCode))
          .toList(),
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainNavigationWrapper(child: child);
      },
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.messages,
          builder: (context, state) => const MessagesScreen(),
        ),
        GoRoute(
          path: AppRoutes.events,
          builder: (context, state) => const EventsScreen(),
        ),
        GoRoute(
          path: AppRoutes.explore,
          builder: (context, state) => const ExploreScreen(),
        ),
        GoRoute(
          path: AppRoutes.more,
          builder: (context, state) => const MoreScreen(),
        ),
      ],
    ),
  ],
);

class MainNavigationWrapper extends StatefulWidget {
  final Widget child;

  const MainNavigationWrapper({
    super.key,
    required this.child,
  });

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      route: AppRoutes.home,
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Home',
    ),
    NavigationItem(
      route: AppRoutes.messages,
      icon: Icons.message_outlined,
      selectedIcon: Icons.message,
      label: 'Messages',
    ),
    NavigationItem(
      route: AppRoutes.events,
      icon: Icons.event_outlined,
      selectedIcon: Icons.event,
      label: 'Events',
    ),
    NavigationItem(
      route: AppRoutes.explore,
      icon: Icons.explore_outlined,
      selectedIcon: Icons.explore,
      label: 'Explore',
    ),
    NavigationItem(
      route: AppRoutes.more,
      icon: Icons.more_horiz_outlined,
      selectedIcon: Icons.more_horiz,
      label: 'More',
    ),
  ];

  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      context.go(_navigationItems[index].route);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCurrentIndex();
  }

  void _updateCurrentIndex() {
    final String location = GoRouterState.of(context).uri.path;
    for (int i = 0; i < _navigationItems.length; i++) {
      if (location == _navigationItems[i].route) {
        if (_currentIndex != i) {
          setState(() {
            _currentIndex = i;
          });
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: _navigationItems.map((item) {
          final isSelected = _navigationItems.indexOf(item) == _currentIndex;
          return BottomNavigationBarItem(
            icon: Icon(isSelected ? item.selectedIcon : item.icon),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}

class NavigationItem {
  final String route;
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  NavigationItem({
    required this.route,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
