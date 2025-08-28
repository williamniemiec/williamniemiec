import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast_carousel.dart';
import '../widgets/daily_forecast_list.dart';
import '../widgets/weather_metrics_grid.dart';
import '../widgets/location_header.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          if (appProvider.isLoadingLocation && appProvider.currentLocation == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Getting your location...'),
                ],
              ),
            );
          }

          if (appProvider.errorMessage != null && appProvider.currentWeatherData == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Unable to load weather data',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    appProvider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      appProvider.clearError();
                      appProvider.refreshWeatherData();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await appProvider.refreshWeatherData();
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // App Bar with location
                SliverAppBar(
                  expandedHeight: 120,
                  floating: true,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            _getWeatherGradientColor(appProvider.currentWeatherData?.current.condition),
                            _getWeatherGradientColor(appProvider.currentWeatherData?.current.condition).withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    title: LocationHeader(
                      location: appProvider.selectedLocation,
                      isLoading: appProvider.isLoadingLocation,
                    ),
                  ),
                  actions: [
                    if (appProvider.isLoadingWeather)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () => appProvider.refreshWeatherData(),
                      ),
                  ],
                ),

                // Main content
                SliverPadding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Current weather card
                      if (appProvider.currentWeatherData != null)
                        CurrentWeatherCard(
                          weatherData: appProvider.currentWeatherData!,
                        ),
                      
                      const SizedBox(height: AppConstants.defaultPadding),

                      // Hourly forecast
                      if (appProvider.currentWeatherData != null)
                        HourlyForecastCarousel(
                          hourlyForecast: appProvider.currentWeatherData!.hourlyForecast,
                        ),
                      
                      const SizedBox(height: AppConstants.defaultPadding),

                      // Weather metrics grid
                      if (appProvider.currentWeatherData != null)
                        WeatherMetricsGrid(
                          weatherData: appProvider.currentWeatherData!,
                        ),
                      
                      const SizedBox(height: AppConstants.defaultPadding),

                      // Daily forecast
                      if (appProvider.currentWeatherData != null)
                        DailyForecastList(
                          dailyForecast: appProvider.currentWeatherData!.dailyForecast,
                        ),
                      
                      // Weather alerts
                      if (appProvider.currentWeatherData != null && 
                          appProvider.currentWeatherData!.alerts.isNotEmpty)
                        Column(
                          children: [
                            const SizedBox(height: AppConstants.defaultPadding),
                            _buildWeatherAlerts(context, appProvider.currentWeatherData!.alerts),
                          ],
                        ),
                      
                      const SizedBox(height: 100), // Bottom padding for navigation bar
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getWeatherGradientColor(String? condition) {
    if (condition == null) return AppTheme.primaryBlue;
    return AppTheme.getWeatherConditionColor(condition);
  }

  Widget _buildWeatherAlerts(BuildContext context, List<dynamic> alerts) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning,
                  color: AppTheme.alertSevere,
                ),
                const SizedBox(width: 8),
                Text(
                  'Weather Alerts',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...alerts.map((alert) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.getAlertSeverityColor(alert.severity).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.getAlertSeverityColor(alert.severity),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.getAlertSeverityColor(alert.severity),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      alert.description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}