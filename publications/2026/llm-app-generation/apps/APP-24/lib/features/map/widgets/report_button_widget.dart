import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/models.dart';

class ReportButtonWidget extends StatelessWidget {
  const ReportButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConstants.reportButtonSize,
      height: AppConstants.reportButtonSize,
      decoration: BoxDecoration(
        color: const Color(AppColors.wazeOrange),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppConstants.reportButtonSize / 2),
          onTap: () {
            _showReportMenu(context);
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  void _showReportMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 400,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                AppStrings.reportHazard,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Report options grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    _buildReportOption(
                      context,
                      ReportType.police,
                      Icons.local_police,
                      AppStrings.police,
                      WazeColors.policeBlue,
                    ),
                    _buildReportOption(
                      context,
                      ReportType.accident,
                      Icons.car_crash,
                      AppStrings.accident,
                      WazeColors.accidentRed,
                    ),
                    _buildReportOption(
                      context,
                      ReportType.traffic,
                      Icons.traffic,
                      AppStrings.traffic,
                      WazeColors.trafficRed,
                    ),
                    _buildReportOption(
                      context,
                      ReportType.hazard,
                      Icons.warning,
                      AppStrings.hazard,
                      WazeColors.hazardOrange,
                    ),
                    _buildReportOption(
                      context,
                      ReportType.construction,
                      Icons.construction,
                      AppStrings.construction,
                      WazeColors.constructionYellow,
                    ),
                    _buildReportOption(
                      context,
                      ReportType.speedCamera,
                      Icons.camera_alt,
                      AppStrings.speedCamera,
                      WazeColors.policeBlue,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportOption(
    BuildContext context,
    ReportType reportType,
    IconData icon,
    String label,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.pop(context);
            _handleReportSelection(context, reportType);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleReportSelection(BuildContext context, ReportType reportType) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report ${reportType.name}'),
        content: Text('Are you sure you want to report ${reportType.name.toLowerCase()} at your current location?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _submitReport(context, reportType);
            },
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  void _submitReport(BuildContext context, ReportType reportType) {
    // TODO: Implement actual report submission
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.reportSent),
        backgroundColor: const Color(AppColors.successColor),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}