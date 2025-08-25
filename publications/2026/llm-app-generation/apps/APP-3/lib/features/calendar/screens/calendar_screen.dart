import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/meeting.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late final ValueNotifier<List<Meeting>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: AppTheme.white,
        actions: [
          IconButton(
            onPressed: () {
              // Go to today
              setState(() {
                _focusedDay = DateTime.now();
                _selectedDay = DateTime.now();
                _selectedEvents.value = _getEventsForDay(_selectedDay!);
              });
            },
            icon: const Icon(Icons.today),
            tooltip: 'Today',
          ),
          IconButton(
            onPressed: () {
              // Create new meeting
              _showCreateMeetingDialog();
            },
            icon: const Icon(Icons.add),
            tooltip: 'New meeting',
          ),
        ],
      ),
      body: Column(
        children: [
          // Calendar Widget
          _buildCalendar(),
          
          const SizedBox(height: 8),
          
          // Events List
          Expanded(
            child: _buildEventsList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateMeetingDialog,
        backgroundColor: AppTheme.primaryBlue,
        child: const Icon(Icons.add, color: AppTheme.white),
      ),
    );
  }

  Widget _buildCalendar() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: TableCalendar<Meeting>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        eventLoader: _getEventsForDay,
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarStyle: const CalendarStyle(
          outsideDaysVisible: false,
          weekendTextStyle: TextStyle(color: AppTheme.errorRed),
          holidayTextStyle: TextStyle(color: AppTheme.errorRed),
          selectedDecoration: BoxDecoration(
            color: AppTheme.primaryBlue,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: AppTheme.accentBlue,
            shape: BoxShape.circle,
          ),
          markerDecoration: BoxDecoration(
            color: AppTheme.warningOrange,
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: true,
          titleCentered: true,
          formatButtonShowsNext: false,
          formatButtonDecoration: BoxDecoration(
            color: AppTheme.primaryBlue,
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          formatButtonTextStyle: TextStyle(
            color: AppTheme.white,
          ),
        ),
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: _onDaySelected,
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
      ),
    );
  }

  Widget _buildEventsList() {
    return ValueListenableBuilder<List<Meeting>>(
      valueListenable: _selectedEvents,
      builder: (context, events, _) {
        if (events.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final meeting = events[index];
            return _buildMeetingItem(meeting);
          },
        );
      },
    );
  }

  Widget _buildMeetingItem(Meeting meeting) {
    final isUpcoming = meeting.startTime.isAfter(DateTime.now());
    final isActive = meeting.isActive;
    final hasEnded = meeting.hasEnded;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: _buildMeetingStatusIcon(meeting),
        title: Text(
          meeting.title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: hasEnded ? AppTheme.secondaryText : AppTheme.primaryText,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_formatTime(meeting.startTime)} - ${_formatTime(meeting.endTime)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
            if (meeting.description != null) ...[
              const SizedBox(height: 4),
              Text(
                meeting.description!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.secondaryText,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 4),
            Text(
              '${meeting.totalAttendees} attendees',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.secondaryText,
              ),
            ),
          ],
        ),
        trailing: _buildMeetingActions(meeting),
        onTap: () {
          _showMeetingDetails(meeting);
        },
      ),
    );
  }

  Widget _buildMeetingStatusIcon(Meeting meeting) {
    IconData iconData;
    Color iconColor;

    if (meeting.isActive) {
      iconData = Icons.videocam;
      iconColor = AppTheme.successGreen;
    } else if (meeting.hasEnded) {
      iconData = Icons.videocam_off;
      iconColor = AppTheme.secondaryText;
    } else if (meeting.isUpcoming) {
      iconData = Icons.schedule;
      iconColor = AppTheme.warningOrange;
    } else {
      iconData = Icons.event;
      iconColor = AppTheme.primaryBlue;
    }

    return CircleAvatar(
      backgroundColor: iconColor.withOpacity(0.1),
      child: Icon(
        iconData,
        color: iconColor,
        size: 20,
      ),
    );
  }

  Widget _buildMeetingActions(Meeting meeting) {
    if (meeting.isActive) {
      return ElevatedButton(
        onPressed: () {
          _joinMeeting(meeting);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.successGreen,
          minimumSize: const Size(60, 32),
        ),
        child: const Text('Join', style: TextStyle(fontSize: 12)),
      );
    } else if (meeting.isUpcoming && 
               meeting.startTime.difference(DateTime.now()).inMinutes <= 15) {
      return OutlinedButton(
        onPressed: () {
          _joinMeeting(meeting);
        },
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(60, 32),
        ),
        child: const Text('Join', style: TextStyle(fontSize: 12)),
      );
    } else {
      return PopupMenuButton<String>(
        onSelected: (value) {
          switch (value) {
            case 'edit':
              _editMeeting(meeting);
              break;
            case 'delete':
              _deleteMeeting(meeting);
              break;
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Text('Edit'),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Text('Delete'),
          ),
        ],
      );
    }
  }

  Widget _buildEmptyState() {
    final selectedDate = _selectedDay ?? DateTime.now();
    final isToday = isSameDay(selectedDate, DateTime.now());

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available,
            size: 64,
            color: AppTheme.secondaryText.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            isToday ? 'No meetings today' : 'No meetings on this day',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.secondaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isToday 
                ? 'Your schedule is clear for today'
                : 'No meetings scheduled for ${_formatDate(selectedDate)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showCreateMeetingDialog,
            icon: const Icon(Icons.add),
            label: const Text('Schedule meeting'),
          ),
        ],
      ),
    );
  }

  List<Meeting> _getEventsForDay(DateTime day) {
    // Mock data for demonstration
    final mockMeetings = [
      Meeting(
        id: '1',
        title: 'Daily Standup',
        description: 'Team daily sync meeting',
        organizerId: 'organizer1',
        startTime: DateTime(day.year, day.month, day.day, 9, 0),
        endTime: DateTime(day.year, day.month, day.day, 9, 30),
        requiredAttendeeIds: ['user1', 'user2', 'user3'],
        type: MeetingType.scheduled,
        status: MeetingStatus.scheduled,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Meeting(
        id: '2',
        title: 'Project Review',
        description: 'Review project progress and next steps',
        organizerId: 'organizer2',
        startTime: DateTime(day.year, day.month, day.day, 14, 0),
        endTime: DateTime(day.year, day.month, day.day, 15, 0),
        requiredAttendeeIds: ['user4', 'user5'],
        optionalAttendeeIds: ['user6'],
        type: MeetingType.scheduled,
        status: MeetingStatus.scheduled,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];

    // Filter meetings for the selected day
    return mockMeetings.where((meeting) {
      return isSameDay(meeting.startTime, day);
    }).toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  void _showCreateMeetingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Schedule Meeting'),
        content: const Text('Meeting scheduling feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showMeetingDetails(Meeting meeting) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(meeting.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (meeting.description != null) ...[
              Text(meeting.description!),
              const SizedBox(height: 16),
            ],
            Text('Time: ${_formatTime(meeting.startTime)} - ${_formatTime(meeting.endTime)}'),
            const SizedBox(height: 8),
            Text('Attendees: ${meeting.totalAttendees}'),
            const SizedBox(height: 8),
            Text('Status: ${meeting.status.toString().split('.').last}'),
          ],
        ),
        actions: [
          if (meeting.isActive || meeting.isUpcoming)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _joinMeeting(meeting);
              },
              child: const Text('Join'),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _joinMeeting(Meeting meeting) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Joining meeting: ${meeting.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _editMeeting(Meeting meeting) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit meeting: ${meeting.title}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _deleteMeeting(Meeting meeting) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Meeting'),
        content: Text('Are you sure you want to delete "${meeting.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deleted meeting: ${meeting.title}'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}