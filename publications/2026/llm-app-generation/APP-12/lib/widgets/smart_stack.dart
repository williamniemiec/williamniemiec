import 'package:flow_launcher/services/context_service.dart';
import 'package:flutter/material.dart';

class SmartStack extends StatefulWidget {
  @override
  _SmartStackState createState() => _SmartStackState();
}

class _SmartStackState extends State<SmartStack> {
  final ContextService _contextService = ContextService();
  late List<Map<String, dynamic>> _suggestions;

  @override
  void initState() {
    super.initState();
    _suggestions = _contextService.getSuggestions();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: PageView(
        children: _suggestions.map((suggestion) {
          return _buildSuggestionCard(suggestion['icon'], suggestion['text']);
        }).toList(),
      ),
    );
  }

  Widget _buildSuggestionCard(IconData icon, String text) {
    return Card(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            SizedBox(height: 10),
            Text(text),
          ],
        ),
      ),
    );
  }
}