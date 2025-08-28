import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/weather_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/weather_data.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/daily_forecast_list.dart';
import '../widgets/weather_details_grid.dart';
import '../widgets/weather_alerts_banner.dart';
import '../../location/screens/location_search_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWeatherData();
    });
  }

  Future<void> _loadWeatherData() async {
    final weatherProvider = context.read<WeatherProvider>();
    if (!weatherProvider.hasData) {
      await weatherProvider.initialize();
    }
  }

  Future<void> _refreshWeather() async {
    final weatherProvider = context.read<WeatherProvider>();
    await weatherProvider.refreshWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<WeatherProvider>(
          builder: (context, weatherProvider, child) {
            final location = weatherProvider.currentLocation;
            return Text(
              location?.displayName ?? 'Weather',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LocationSearchScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshWeather,
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryBlue,
                AppTheme.lightBlue,
              ],
            ),
          ),
        ),
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          if (weatherProvider.isLoading && !weatherProvider.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (weatherProvider.hasError) {
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
                    'Error Loading Weather',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    weatherProvider.errorMessage ?? 'Unknown error occurred',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _refreshWeather,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!weatherProvider.hasData) {
            return const Center(
              child: Text('No weather data available'),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshWeather,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Weather Alerts Banner
                if (weatherProvider.activeAlerts.isNotEmpty)
                  SliverToBoxAdapter(
                    child: WeatherAlertsBanner(
                      alerts: weatherProvider.activeAlerts,
                    ),
                  ),

                // Current Weather Card
                SliverToBoxAdapter(
                  child: CurrentWeatherCard(
                    currentWeather: weatherProvider.currentWeather!,
                    location: weatherProvider.currentLocation!,
                  ),
                ),

                // Hourly Forecast
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Hourly Forecast',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: HourlyForecastList(
                    hourlyForecast: weatherProvider.hourlyForecast,
                  ),
                ),

                // Weather Details Grid
                SliverToBoxAdapter(
                  child: WeatherDetailsGrid(
                    currentWeather: weatherProvider.currentWeather!,
                  ),
                ),

                // Daily Forecast
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '7-Day Forecast',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: DailyForecastList(
                    dailyForecast: weatherProvider.dailyForecast,
                  ),
                ),

                // Bottom padding
                const SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}