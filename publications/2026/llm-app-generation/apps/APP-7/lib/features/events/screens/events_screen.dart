import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../shared/models/event.dart';
import '../../../core/theme/app_theme.dart';
import '../widgets/event_card.dart';

class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  ConsumerState<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen> {
  late final ValueNotifier<List<Event>> _selectedEvents;
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
        title: const Text('Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: _goToToday,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createEvent,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCalendar(),
          const Divider(height: 1),
          Expanded(
            child: _buildEventsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      color: Colors.white,
      child: TableCalendar<Event>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        eventLoader: _getEventsForDay,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        calendarStyle: CalendarStyle(
          outsideDaysVisible: false,
          weekendTextStyle: TextStyle(color: Colors.red[400]),
          holidayTextStyle: TextStyle(color: Colors.red[400]),
          markerDecoration: const BoxDecoration(
            color: AppTheme.primaryColor,
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: AppTheme.primaryColor,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: AppTheme.primaryColorLight,
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: true,
          titleCentered: true,
          formatButtonShowsNext: false,
          formatButtonDecoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          formatButtonTextStyle: TextStyle(
            color: Colors.white,
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
    return ValueListenableBuilder<List<Event>>(
      valueListenable: _selectedEvents,
      builder: (context, events, _) {
        if (events.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: _refreshEvents,
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.sm),
            itemCount: events.length,
            itemBuilder: (context, index) {
              return EventCard(
                event: events[index],
                onTap: () => _openEvent(events[index]),
                onRsvp: (event, response) => _handleRsvp(event, response),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final selectedDate = _selectedDay ?? DateTime.now();
    final isToday = isSameDay(selectedDate, DateTime.now());
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            isToday ? 'No events today' : 'No events on this day',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Check other dates or create a new event',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    final allEvents = _getMockEvents();
    return allEvents.where((event) {
      return isSameDay(event.startDate, day);
    }).toList();
  }

  List<Event> _getMockEvents() {
    final now = DateTime.now();
    return [
      Event(
        id: '1',
        title: 'Parent-Teacher Conference',
        description: 'Individual meetings with teachers to discuss student progress.',
        location: 'School Library',
        startDate: DateTime(now.year, now.month, now.day + 1, 9, 0),
        endDate: DateTime(now.year, now.month, now.day + 1, 17, 0),
        type: EventType.meeting,
        category: EventCategory.school,
        organizerId: 'school1',
        organizerName: 'Lincoln Elementary',
        requiresRsvp: true,
        maxAttendees: 50,
        createdAt: now.subtract(const Duration(days: 7)),
        updatedAt: now.subtract(const Duration(days: 7)),
      ),
      Event(
        id: '2',
        title: 'Science Fair',
        description: 'Annual science fair showcasing student projects.',
        location: 'School Gymnasium',
        startDate: DateTime(now.year, now.month, now.day + 3, 10, 0),
        endDate: DateTime(now.year, now.month, now.day + 3, 15, 0),
        type: EventType.academic,
        category: EventCategory.school,
        organizerId: 'teacher1',
        organizerName: 'Ms. Johnson',
        requiresRsvp: false,
        createdAt: now.subtract(const Duration(days: 14)),
        updatedAt: now.subtract(const Duration(days: 14)),
      ),
      Event(
        id: '3',
        title: 'Field Day',
        description: 'Outdoor activities and games for all students.',
        location: 'School Field',
        startDate: DateTime(now.year, now.month, now.day + 7, 9, 0),
        endDate: DateTime(now.year, now.month, now.day + 7, 14, 0),
        type: EventType.sports,
        category: EventCategory.school,
        organizerId: 'teacher2',
        organizerName: 'Mr. Davis',
        requiresRsvp: true,
        createdAt: now.subtract(const Duration(days: 21)),
        updatedAt: now.subtract(const Duration(days: 21)),
      ),
      Event(
        id: '4',
        title: 'Book Fair',
        description: 'Annual book fair with special guest author.',
        location: 'School Cafeteria',
        startDate: DateTime(now.year, now.month, now.day + 10, 8, 0),
        endDate: DateTime(now.year, now.month, now.day + 10, 16, 0),
        type: EventType.academic,
        category: EventCategory.school,
        organizerId: 'librarian1',
        organizerName: 'Mrs. Brown',
        requiresRsvp: false,
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 10)),
      ),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _goToToday() {
    final today = DateTime.now();
    setState(() {
      _selectedDay = today;
      _focusedDay = today;
    });
    _selectedEvents.value = _getEventsForDay(today);
  }

  void _createEvent() {
    // TODO: Navigate to create event screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create event feature coming soon!')),
    );
  }

  void _openEvent(Event event) {
    // TODO: Navigate to event detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening ${event.title}')),
    );
  }

  void _handleRsvp(Event event, RsvpResponse response) {
    // TODO: Implement RSVP functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('RSVP updated to ${response.name}')),
    );
  }

  Future<void> _refreshEvents() async {
    // TODO: Implement refresh functionality
    await Future.delayed(const Duration(seconds: 1));
    if (_selectedDay != null) {
      _selectedEvents.value = _getEventsForDay(_selectedDay!);
    }
  }
}