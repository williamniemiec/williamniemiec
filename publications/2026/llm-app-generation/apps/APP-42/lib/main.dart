import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/weather_provider.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/radar/screens/radar_screen.dart';
import 'features/alerts/screens/alerts_screen.dart';
import 'features/location/screens/location_search_screen.dart';

void main() {
  runApp(const NOAAWeatherRadarApp());
}

class NOAAWeatherRadarApp extends StatelessWidget {
  const NOAAWeatherRadarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
      ],
      child: MaterialApp(
        title: 'NOAA Weather Radar Live',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
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
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const DashboardScreen(),
    const RadarScreen(),
    const AlertsScreen(),
  ];

  final List<BottomNavigationBarItem> _navigationItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.radar),
      label: 'Radar',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.warning),
      label: 'Alerts',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          final alertCount = weatherProvider.activeAlerts.length;
          
          return BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppTheme.primaryBlue,
            unselectedItemColor: Colors.grey[600],
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 8,
            items: _navigationItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              
              // Add badge for alerts tab
              if (index == 2 && alertCount > 0) {
                return BottomNavigationBarItem(
                  icon: Stack(
                    children: [
                      item.icon,
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: AppTheme.warningRed,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            alertCount > 99 ? '99+' : alertCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  label: item.label,
                );
              }
              
              return item;
            }).toList(),
          );
        },
      ),
    );
  }
}
