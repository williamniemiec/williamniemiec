import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../shared/models/event.dart';
import '../../../core/theme/app_theme.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onTap;
  final Function(Event, RsvpResponse)? onRsvp;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
    this.onRsvp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: AppSpacing.sm),
              _buildContent(context),
              if (event.location != null) ...[
                const SizedBox(height: AppSpacing.xs),
                _buildLocation(context),
              ],
              if (event.requiresRsvp) ...[
                const SizedBox(height: AppSpacing.sm),
                _buildRsvpSection(context),
              ],
              const SizedBox(height: AppSpacing.sm),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: _getEventTypeColor(event.type),
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DateFormat('MMM').format(event.startDate).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateFormat('dd').format(event.startDate),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatTimeRange(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 14,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    event.organizerName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _buildStatusChip(context),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Text(
      event.description,
      style: Theme.of(context).textTheme.bodyMedium,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildLocation(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.location_on,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            event.location!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRsvpSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'RSVP Required',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (event.maxAttendees != null)
                Text(
                  '${event.goingCount}/${event.maxAttendees} attending',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onRsvp != null 
                      ? () => onRsvp!(event, RsvpResponse.going)
                      : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.successColor,
                    side: const BorderSide(color: AppTheme.successColor),
                  ),
                  child: const Text('Going'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton(
                  onPressed: onRsvp != null 
                      ? () => onRsvp!(event, RsvpResponse.maybe)
                      : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.warningColor,
                    side: const BorderSide(color: AppTheme.warningColor),
                  ),
                  child: const Text('Maybe'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton(
                  onPressed: onRsvp != null 
                      ? () => onRsvp!(event, RsvpResponse.notGoing)
                      : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                    side: BorderSide(color: Colors.grey[400]!),
                  ),
                  child: const Text('Can\'t Go'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: _getEventTypeColor(event.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          ),
          child: Text(
            event.type.name.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _getEventTypeColor(event.type),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          ),
          child: Text(
            event.category.name.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Spacer(),
        if (event.attendeeCount > 0)
          Row(
            children: [
              Icon(
                Icons.people,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                '${event.attendeeCount} attending',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildStatusChip(BuildContext context) {
    if (event.isPast) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        ),
        child: Text(
          'PAST',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.grey[700],
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (event.isOngoing) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.successColor,
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        ),
        child: Text(
          'LIVE',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else if (event.isFull) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.errorColor,
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
        ),
        child: Text(
          'FULL',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Color _getEventTypeColor(EventType type) {
    switch (type) {
      case EventType.meeting:
        return AppTheme.primaryColor;
      case EventType.conference:
        return Colors.purple;
      case EventType.workshop:
        return Colors.orange;
      case EventType.social:
        return Colors.pink;
      case EventType.sports:
        return Colors.green;
      case EventType.academic:
        return Colors.blue;
      case EventType.fundraiser:
        return Colors.amber;
      case EventType.volunteer:
        return Colors.teal;
    }
  }

  String _formatTimeRange() {
    if (event.isAllDay) {
      return 'All Day';
    }

    final startTime = DateFormat('h:mm a').format(event.startDate);
    final endTime = DateFormat('h:mm a').format(event.endDate);
    
    if (DateFormat('yyyy-MM-dd').format(event.startDate) == 
        DateFormat('yyyy-MM-dd').format(event.endDate)) {
      return '$startTime - $endTime';
    } else {
      return '$startTime - ${DateFormat('MMM dd, h:mm a').format(event.endDate)}';
    }
  }
}