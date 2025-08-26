import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/home/screens/home_screen.dart';
import 'features/games/screens/games_screen.dart';
import 'features/new_hot/screens/new_hot_screen.dart';
import 'features/my_netflix/screens/my_netflix_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.netflixBlack,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const NetflixApp());
}

class NetflixApp extends StatelessWidget {
  const NetflixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Add providers here as we create them
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.darkTheme,
        home: const MainNavigationScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const GamesScreen(),
    const NewHotScreen(),
    const MyNetflixScreen(),
  ];

  final List<BottomNavigationBarItem> _navigationItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: AppStrings.home,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.videogame_asset_outlined),
      activeIcon: Icon(Icons.videogame_asset),
      label: AppStrings.games,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.whatshot_outlined),
      activeIcon: Icon(Icons.whatshot),
      label: AppStrings.newAndHot,
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: AppStrings.myNetflix,
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
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.netflixBlack,
        selectedItemColor: AppTheme.netflixWhite,
        unselectedItemColor: AppTheme.netflixLightGray,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 0,
      ),
    );
  }
}
