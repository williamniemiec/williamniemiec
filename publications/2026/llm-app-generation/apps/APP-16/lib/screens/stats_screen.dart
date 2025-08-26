import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../constants/app_constants.dart';
import '../providers/blood_pressure_provider.dart';
import '../models/blood_pressure_reading.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  String _selectedTimeFilter = 'Month';
  final List<String> _timeFilters = ['Week', 'Month', '3 Months', '6 Months', 'All'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BloodPressureProvider>().loadReadings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<BloodPressureProvider>().loadReadings();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Consumer<BloodPressureProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return _buildErrorState(provider.error!);
          }

          final filteredReadings = _getFilteredReadings(provider.readings);

          if (filteredReadings.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadReadings(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.mediumSpacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time filter
                  _buildTimeFilterBar(),
                  const SizedBox(height: AppConstants.largeSpacing),
                  
                  // Summary stats
                  _buildSummaryStats(filteredReadings),
                  const SizedBox(height: AppConstants.largeSpacing),
                  
                  // Blood pressure trend chart
                  _buildTrendChart(filteredReadings),
                  const SizedBox(height: AppConstants.largeSpacing),
                  
                  // Category distribution
                  _buildCategoryDistribution(filteredReadings),
                  const SizedBox(height: AppConstants.largeSpacing),
                  
                  // Average by time of day
                  _buildTimeOfDayStats(filteredReadings),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeFilterBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time Period',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppConstants.smallSpacing),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _timeFilters.map((filter) {
              final isSelected = _selectedTimeFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: AppConstants.smallSpacing),
                child: FilterChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedTimeFilter = filter;
                      });
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryStats(List<BloodPressureReading> readings) {
    final stats = _calculateStats(readings);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Summary Statistics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.mediumSpacing),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Average Systolic',
                    '${stats['avgSystolic']?.round() ?? 0}',
                    'mmHg',
                    Colors.red[400]!,
                  ),
                ),
                const SizedBox(width: AppConstants.smallSpacing),
                Expanded(
                  child: _buildStatCard(
                    'Average Diastolic',
                    '${stats['avgDiastolic']?.round() ?? 0}',
                    'mmHg',
                    Colors.blue[400]!,
                  ),
                ),
                const SizedBox(width: AppConstants.smallSpacing),
                Expanded(
                  child: _buildStatCard(
                    'Average Pulse',
                    '${stats['avgPulse']?.round() ?? 0}',
                    'bpm',
                    Colors.pink[400]!,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.mediumSpacing),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Readings',
                    '${readings.length}',
                    '',
                    Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: AppConstants.smallSpacing),
                Expanded(
                  child: _buildStatCard(
                    'Highest Systolic',
                    '${stats['maxSystolic']?.round() ?? 0}',
                    'mmHg',
                    Colors.red[600]!,
                  ),
                ),
                const SizedBox(width: AppConstants.smallSpacing),
                Expanded(
                  child: _buildStatCard(
                    'Lowest Systolic',
                    '${stats['minSystolic']?.round() ?? 0}',
                    'mmHg',
                    Colors.green[600]!,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String unit, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.smallSpacing),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (unit.isNotEmpty) ...[
            Text(
              unit,
              style: TextStyle(
                fontSize: 12,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendChart(List<BloodPressureReading> readings) {
    if (readings.length < 2) {
      return Card(
        child: Container(
          height: 200,
          padding: const EdgeInsets.all(AppConstants.mediumSpacing),
          child: Center(
            child: Text(
              'Need at least 2 readings to show trend',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
      );
    }

    final sortedReadings = List<BloodPressureReading>.from(readings)
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    final systolicSpots = <FlSpot>[];
    final diastolicSpots = <FlSpot>[];

    for (int i = 0; i < sortedReadings.length; i++) {
      final reading = sortedReadings[i];
      systolicSpots.add(FlSpot(i.toDouble(), reading.systolic.toDouble()));
      diastolicSpots.add(FlSpot(i.toDouble(), reading.diastolic.toDouble()));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Blood Pressure Trend',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.mediumSpacing),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[300]!,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: (sortedReadings.length / 5).ceil().toDouble(),
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < sortedReadings.length) {
                            final reading = sortedReadings[index];
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                '${reading.dateTime.day}/${reading.dateTime.month}',
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  minX: 0,
                  maxX: (sortedReadings.length - 1).toDouble(),
                  minY: 40,
                  maxY: 200,
                  lineBarsData: [
                    LineChartBarData(
                      spots: systolicSpots,
                      isCurved: true,
                      color: Colors.red[400]!,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                    LineChartBarData(
                      spots: diastolicSpots,
                      isCurved: true,
                      color: Colors.blue[400]!,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppConstants.smallSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Systolic', Colors.red[400]!),
                const SizedBox(width: AppConstants.mediumSpacing),
                _buildLegendItem('Diastolic', Colors.blue[400]!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }

  Widget _buildCategoryDistribution(List<BloodPressureReading> readings) {
    final distribution = _getCategoryDistribution(readings);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Distribution',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.mediumSpacing),
            ...distribution.entries.map((entry) {
              final percentage = (entry.value / readings.length * 100).round();
              return Padding(
                padding: const EdgeInsets.only(bottom: AppConstants.smallSpacing),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: _getCategoryColor(entry.key),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: AppConstants.smallSpacing),
                    Expanded(
                      child: Text(entry.key.displayName),
                    ),
                    Text(
                      '${entry.value} ($percentage%)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeOfDayStats(List<BloodPressureReading> readings) {
    final morningReadings = readings.where((r) => r.dateTime.hour < 12).toList();
    final afternoonReadings = readings.where((r) => r.dateTime.hour >= 12 && r.dateTime.hour < 18).toList();
    final eveningReadings = readings.where((r) => r.dateTime.hour >= 18).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Average by Time of Day',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.mediumSpacing),
            if (morningReadings.isNotEmpty)
              _buildTimeOfDayRow('Morning', morningReadings, Icons.wb_sunny),
            if (afternoonReadings.isNotEmpty)
              _buildTimeOfDayRow('Afternoon', afternoonReadings, Icons.wb_sunny_outlined),
            if (eveningReadings.isNotEmpty)
              _buildTimeOfDayRow('Evening', eveningReadings, Icons.nights_stay),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeOfDayRow(String timeOfDay, List<BloodPressureReading> readings, IconData icon) {
    final stats = _calculateStats(readings);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.smallSpacing),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: AppConstants.smallSpacing),
          Expanded(
            child: Text(
              '$timeOfDay (${readings.length} readings)',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            '${stats['avgSystolic']?.round() ?? 0}/${stats['avgDiastolic']?.round() ?? 0}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppConstants.mediumSpacing),
          Text(
            'No statistics available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppConstants.smallSpacing),
          Text(
            'Add some blood pressure readings to see your statistics',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: AppConstants.mediumSpacing),
          Text(
            'Error loading statistics',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppConstants.smallSpacing),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.mediumSpacing),
          ElevatedButton(
            onPressed: () {
              context.read<BloodPressureProvider>().loadReadings();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  List<BloodPressureReading> _getFilteredReadings(List<BloodPressureReading> readings) {
    final now = DateTime.now();
    DateTime? cutoffDate;

    switch (_selectedTimeFilter) {
      case 'Week':
        cutoffDate = now.subtract(const Duration(days: 7));
        break;
      case 'Month':
        cutoffDate = now.subtract(const Duration(days: 30));
        break;
      case '3 Months':
        cutoffDate = now.subtract(const Duration(days: 90));
        break;
      case '6 Months':
        cutoffDate = now.subtract(const Duration(days: 180));
        break;
      case 'All':
      default:
        return readings;
    }

    return readings.where((reading) => reading.dateTime.isAfter(cutoffDate!)).toList();
  }

  Map<String, double> _calculateStats(List<BloodPressureReading> readings) {
    if (readings.isEmpty) {
      return {
        'avgSystolic': 0.0,
        'avgDiastolic': 0.0,
        'avgPulse': 0.0,
        'maxSystolic': 0.0,
        'minSystolic': 0.0,
      };
    }

    final systolicValues = readings.map((r) => r.systolic).toList();
    final diastolicValues = readings.map((r) => r.diastolic).toList();
    final pulseValues = readings.map((r) => r.pulse).toList();

    return {
      'avgSystolic': systolicValues.reduce((a, b) => a + b) / systolicValues.length,
      'avgDiastolic': diastolicValues.reduce((a, b) => a + b) / diastolicValues.length,
      'avgPulse': pulseValues.reduce((a, b) => a + b) / pulseValues.length,
      'maxSystolic': systolicValues.reduce((a, b) => a > b ? a : b).toDouble(),
      'minSystolic': systolicValues.reduce((a, b) => a < b ? a : b).toDouble(),
    };
  }

  Map<BloodPressureCategory, int> _getCategoryDistribution(List<BloodPressureReading> readings) {
    final distribution = <BloodPressureCategory, int>{};
    
    for (final reading in readings) {
      distribution[reading.category] = (distribution[reading.category] ?? 0) + 1;
    }
    
    return distribution;
  }

  Color _getCategoryColor(BloodPressureCategory category) {
    switch (category) {
      case BloodPressureCategory.normal:
        return Colors.green;
      case BloodPressureCategory.elevated:
        return Colors.orange;
      case BloodPressureCategory.hypertensionStage1:
        return Colors.deepOrange;
      case BloodPressureCategory.hypertensionStage2:
        return Colors.red;
      case BloodPressureCategory.hypertensiveCrisis:
        return Colors.purple;
    }
  }
}