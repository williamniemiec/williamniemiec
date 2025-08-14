import 'package:flutter/material.dart';

class ContextService {
  List<Map<String, dynamic>> getSuggestions() {
    final hour = DateTime.now().hour;

    if (hour >= 6 && hour < 12) {
      // Morning
      return [
        {'icon': Icons.calendar_today, 'text': 'Calendar'},
        {'icon': Icons.book, 'text': 'News App'},
        {'icon': Icons.headset, 'text': 'Podcast'},
      ];
    } else if (hour >= 12 && hour < 18) {
      // Afternoon (Office)
      return [
        {'icon': Icons.email, 'text': 'Email'},
        {'icon': Icons.message, 'text': 'Slack'},
        {'icon': Icons.check_box, 'text': 'To-Do List'},
      ];
    } else {
      // Evening/Night
      return [
        {'icon': Icons.music_note, 'text': 'Music'},
        {'icon': Icons.movie, 'text': 'Entertainment'},
        {'icon': Icons.phone, 'text': 'Call Mom'},
      ];
    }
  }
}