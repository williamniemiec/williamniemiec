import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/providers/app_provider.dart';
import 'features/favorites/screens/favorites_screen.dart';
import 'features/devices/screens/devices_screen.dart';
import 'features/automations/screens/automations_screen.dart';
import 'features/activity/screens/activity_screen.dart';
import 'features/settings/screens/settings_screen.dart';

void main() {
  runApp(const GoogleHomeApp());
}

class GoogleHomeApp extends StatelessWidget {
  const GoogleHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return MaterialApp(
            title: 'Google Home',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: appProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _screens = [
    const FavoritesScreen(),
    const DevicesScreen(),
    const AutomationsScreen(),
    const ActivityScreen(),
    const SettingsScreen(),
  ];

  final List<BottomNavigationBarItem> _navigationItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Favorites',
    ),
    BottomNavigationBarItem(
      icon: Icon(MdiIcons.devices),
      activeIcon: Icon(MdiIcons.devices),
      label: 'Devices',
    ),
    BottomNavigationBarItem(
      icon: Icon(MdiIcons.autorenew),
      activeIcon: Icon(MdiIcons.autorenew),
      label: 'Automations',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.timeline_outlined),
      activeIcon: Icon(Icons.timeline),
      label: 'Activity',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings_outlined),
      activeIcon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize app data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  void _initializeApp() {
    // Initialize app data after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final appProvider = Provider.of<AppProvider>(context, listen: false);
        _loadMockData(appProvider);
      }
    });
  }

  void _loadMockData(AppProvider appProvider) {
    // Mock data for demonstration
    // In a real app, this would come from services
    
    // This is just to show the app structure
    // The actual data loading will be implemented in services
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Scaffold(
          body: IndexedStack(
            index: appProvider.currentTabIndex,
            children: _screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: appProvider.currentTabIndex,
            onTap: (index) {
              appProvider.setCurrentTabIndex(index);
            },
            items: _navigationItems,
          ),
        );
      },
    );
  }
}
