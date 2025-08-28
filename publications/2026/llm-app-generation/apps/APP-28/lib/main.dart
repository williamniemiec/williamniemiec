import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/providers/app_provider.dart';
import 'features/photos/screens/photos_screen.dart';
import 'features/search/screens/search_screen.dart';
import 'features/library/screens/library_screen.dart';

void main() {
  runApp(const GooglePhotosApp());
}

class GooglePhotosApp extends StatelessWidget {
  const GooglePhotosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const MainScreen(),
        debugShowCheckedModeBanner: false,
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
  int _currentIndex = AppConstants.photosTabIndex;

  final List<Widget> _screens = [
    const PhotosScreen(),
    const SearchScreen(),
    const LibraryScreen(),
  ];

  final List<BottomNavigationBarItem> _navigationItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.photo_library_outlined),
      activeIcon: Icon(Icons.photo_library),
      label: 'Photos',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.search_outlined),
      activeIcon: Icon(Icons.search),
      label: 'Search',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.video_library_outlined),
      activeIcon: Icon(Icons.video_library),
      label: 'Library',
    ),
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
        items: _navigationItems,
      ),
    );
  }
}
