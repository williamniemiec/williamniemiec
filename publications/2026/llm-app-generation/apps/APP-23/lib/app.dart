import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/explore/screens/explore_screen.dart';
import 'features/explore/providers/explore_provider.dart';
import 'features/navigation/providers/navigation_provider.dart';
import 'features/saved/providers/saved_provider.dart';
import 'shared/services/location_service.dart';
import 'shared/services/places_service.dart';

class GoogleMapsApp extends StatelessWidget {
  const GoogleMapsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExploreProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => SavedProvider()),
        Provider(create: (_) => LocationService()),
        Provider(create: (_) => PlacesService()),
      ],
      child: MaterialApp(
        title: 'Google Maps',
        theme: AppTheme.lightTheme,
        home: const ExploreScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}