import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../providers/blood_pressure_provider.dart';
import '../models/blood_pressure_reading.dart';
import '../widgets/add_reading_dialog.dart';
import '../services/pdf_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Week', 'Month', '3 Months', '6 Months'];

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
        title: const Text('Reading History'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.file_download),
                    SizedBox(width: 8),
                    Text('Export PDF'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 8),
                    Text('Refresh'),
                  ],
                ),
              ),
            ],
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

          return Column(
            children: [
              // Filter bar
              _buildFilterBar(),
              
              // Readings list
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => provider.loadReadings(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppConstants.mediumSpacing),
                    itemCount: filteredReadings.length,
                    itemBuilder: (context, index) {
                      final reading = filteredReadings[index];
                      return _buildReadingCard(reading);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.mediumSpacing),
      child: Row(
        children: [
          Text(
            'Filter:',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: AppConstants.smallSpacing),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filterOptions.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppConstants.smallSpacing),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingCard(BloodPressureReading reading) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.mediumSpacing),
      child: InkWell(
        onTap: () => _showReadingDetails(reading),
        borderRadius: BorderRadius.circular(AppConstants.mediumBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.mediumSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with date and category
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reading.formattedDate,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        reading.formattedTime,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.smallSpacing,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(reading.category),
                      borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
                    ),
                    child: Text(
                      reading.category.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.mediumSpacing),
              
              // Blood pressure values
              Row(
                children: [
                  _buildValueDisplay('SYS', '${reading.systolic}', 'mmHg', Colors.red[400]!),
                  const SizedBox(width: AppConstants.mediumSpacing),
                  _buildValueDisplay('DIA', '${reading.diastolic}', 'mmHg', Colors.blue[400]!),
                  const SizedBox(width: AppConstants.mediumSpacing),
                  _buildValueDisplay('PUL', '${reading.pulse}', 'bpm', Colors.pink[400]!),
                ],
              ),
              
              // Tags if available
              if (reading.tags.isNotEmpty) ...[
                const SizedBox(height: AppConstants.smallSpacing),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: reading.tags.map((tag) => Chip(
                    label: Text(
                      tag,
                      style: const TextStyle(fontSize: 10),
                    ),
                    backgroundColor: Colors.grey[100],
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  )).toList(),
                ),
              ],
              
              // Notes preview if available
              if (reading.notes != null && reading.notes!.isNotEmpty) ...[
                const SizedBox(height: AppConstants.smallSpacing),
                Text(
                  reading.notes!.length > 50 
                      ? '${reading.notes!.substring(0, 50)}...'
                      : reading.notes!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValueDisplay(String label, String value, String unit, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppConstants.smallSpacing),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              unit,
              style: TextStyle(
                fontSize: 10,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppConstants.mediumSpacing),
          Text(
            'No readings found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppConstants.smallSpacing),
          Text(
            'Start tracking your blood pressure to see your history here',
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
            'Error loading history',
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

    switch (_selectedFilter) {
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

  void _showReadingDetails(BloodPressureReading reading) {
    showDialog(
      context: context,
      builder: (context) => AddReadingDialog(editReading: reading),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'export':
        _exportToPdf();
        break;
      case 'refresh':
        context.read<BloodPressureProvider>().loadReadings();
        break;
    }
  }

  Future<void> _exportToPdf() async {
    final provider = context.read<BloodPressureProvider>();
    final readings = _getFilteredReadings(provider.readings);

    if (readings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No readings to export'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      final pdfFile = await PdfService().generateBloodPressureReport(
        readings: readings,
      );
      
      await PdfService().shareReport(pdfFile);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppConstants.successReportGenerated),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating report: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}