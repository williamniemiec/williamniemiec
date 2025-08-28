import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/models/appointment.dart';
import '../providers/appointment_provider.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppointmentProvider>(context, listen: false).loadAppointments();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Appointments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showScheduleAppointmentDialog();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: Consumer<AppointmentProvider>(
        builder: (context, appointmentProvider, child) {
          if (appointmentProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (appointmentProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    appointmentProvider.errorMessage!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      appointmentProvider.loadAppointments();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildAppointmentsList(appointmentProvider.upcomingAppointments, true),
              _buildAppointmentsList(appointmentProvider.pastAppointments, false),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppointmentsList(List<Appointment> appointments, bool isUpcoming) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              isUpcoming ? 'No upcoming appointments' : 'No past appointments',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isUpcoming
                  ? 'Schedule your next appointment to get started'
                  : 'Your appointment history will appear here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
            if (isUpcoming) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _showScheduleAppointmentDialog,
                child: const Text('Schedule Appointment'),
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => Provider.of<AppointmentProvider>(context, listen: false).loadAppointments(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return _AppointmentCard(
            appointment: appointment,
            isUpcoming: isUpcoming,
            onCancel: isUpcoming && appointment.canCancel
                ? () => _cancelAppointment(appointment)
                : null,
          );
        },
      ),
    );
  }

  void _showScheduleAppointmentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Schedule Appointment'),
        content: const Text(
          'Appointment scheduling functionality would be implemented here with a full form including provider selection, date/time picker, and reason for visit.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Appointment scheduling feature coming soon!'),
                ),
              );
            },
            child: const Text('Schedule'),
          ),
        ],
      ),
    );
  }

  void _cancelAppointment(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: Text(
          'Are you sure you want to cancel your appointment with ${appointment.providerName} on ${DateFormat('MMM dd, yyyy \'at\' h:mm a').format(appointment.dateTime)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Keep Appointment'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await Provider.of<AppointmentProvider>(context, listen: false)
                  .cancelAppointment(appointment.id);
              
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Appointment cancelled successfully'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.textOnPrimary,
            ),
            child: const Text('Cancel Appointment'),
          ),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final bool isUpcoming;
  final VoidCallback? onCancel;

  const _AppointmentCard({
    required this.appointment,
    required this.isUpcoming,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getAppointmentIcon(),
                    color: _getStatusColor(),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.providerName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        appointment.department,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    appointment.statusDisplayName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _getStatusColor(),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMM dd, yyyy \'at\' h:mm a').format(appointment.dateTime),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Row(
              children: [
                Icon(
                  Icons.medical_services_outlined,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    appointment.reason,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            
            if (appointment.location != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    appointment.type == AppointmentType.video
                        ? Icons.videocam_outlined
                        : Icons.location_on_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      appointment.type == AppointmentType.video
                          ? 'Video Visit'
                          : appointment.location!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ],
            
            if (isUpcoming) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  if (appointment.canCheckIn)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('eCheck-in feature coming soon!'),
                            ),
                          );
                        },
                        child: const Text('Check In'),
                      ),
                    ),
                  if (appointment.canCheckIn && onCancel != null)
                    const SizedBox(width: 12),
                  if (onCancel != null)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onCancel,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: BorderSide(color: AppColors.error),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (appointment.status) {
      case AppointmentStatus.scheduled:
        return AppColors.appointmentScheduled;
      case AppointmentStatus.confirmed:
        return AppColors.appointmentConfirmed;
      case AppointmentStatus.cancelled:
        return AppColors.appointmentCancelled;
      case AppointmentStatus.completed:
        return AppColors.appointmentCompleted;
      case AppointmentStatus.noShow:
        return AppColors.appointmentCancelled;
    }
  }

  IconData _getAppointmentIcon() {
    switch (appointment.type) {
      case AppointmentType.video:
        return Icons.videocam;
      case AppointmentType.phone:
        return Icons.phone;
      case AppointmentType.inPerson:
        return Icons.person;
    }
  }
}