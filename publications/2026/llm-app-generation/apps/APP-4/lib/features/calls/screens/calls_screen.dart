import 'package:flutter/material.dart';

class CallsScreen extends StatefulWidget {
  const CallsScreen({super.key});

  @override
  State<CallsScreen> createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen> {
  final List<CallRecord> _callRecords = [
    CallRecord(
      contactName: 'John Smith',
      contactPhone: '+1234567890',
      callType: CallType.incoming,
      callStatus: CallStatus.answered,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      duration: const Duration(minutes: 5, seconds: 23),
    ),
    CallRecord(
      contactName: 'Sarah Johnson',
      contactPhone: '+1234567891',
      callType: CallType.outgoing,
      callStatus: CallStatus.answered,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      duration: const Duration(minutes: 12, seconds: 45),
    ),
    CallRecord(
      contactName: 'Mike Wilson',
      contactPhone: '+1234567892',
      callType: CallType.incoming,
      callStatus: CallStatus.missed,
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      duration: Duration.zero,
    ),
    CallRecord(
      contactName: 'Emma Davis',
      contactPhone: '+1234567893',
      callType: CallType.outgoing,
      callStatus: CallStatus.declined,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      duration: Duration.zero,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calls'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showCallMenu();
            },
          ),
        ],
      ),
      body: _callRecords.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.call,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No calls yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Make your first call to a customer',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _callRecords.length,
              itemBuilder: (context, index) {
                final call = _callRecords[index];
                return _buildCallItem(call);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewCallDialog,
        child: const Icon(Icons.add_call),
      ),
    );
  }

  Widget _buildCallItem(CallRecord call) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          _getInitials(call.contactName),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(call.contactName),
      subtitle: Row(
        children: [
          Icon(
            _getCallIcon(call.callType, call.callStatus),
            size: 16,
            color: _getCallIconColor(call.callStatus),
          ),
          const SizedBox(width: 4),
          Text(_formatCallTime(call.timestamp)),
          if (call.duration.inSeconds > 0) ...[
            const Text(' • '),
            Text(_formatDuration(call.duration)),
          ],
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () => _makeCall(call.contactPhone, false),
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () => _makeCall(call.contactPhone, true),
          ),
        ],
      ),
      onTap: () => _showCallDetails(call),
    );
  }

  IconData _getCallIcon(CallType type, CallStatus status) {
    if (status == CallStatus.missed) {
      return Icons.call_received;
    }
    
    switch (type) {
      case CallType.incoming:
        return Icons.call_received;
      case CallType.outgoing:
        return Icons.call_made;
    }
  }

  Color _getCallIconColor(CallStatus status) {
    switch (status) {
      case CallStatus.answered:
        return Colors.green;
      case CallStatus.missed:
        return Colors.red;
      case CallStatus.declined:
        return Colors.red;
    }
  }

  String _getInitials(String name) {
    final words = name.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words.isNotEmpty) {
      return words[0][0].toUpperCase();
    }
    return '?';
  }

  String _formatCallTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }

  void _makeCall(String phoneNumber, bool isVideo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isVideo ? 'Video Call' : 'Voice Call'),
        content: Text('Calling $phoneNumber...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showCallDetails(CallRecord call) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(call.contactName),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phone: ${call.contactPhone}'),
            const SizedBox(height: 8),
            Text('Type: ${call.callType.name.toUpperCase()}'),
            Text('Status: ${call.callStatus.name.toUpperCase()}'),
            Text('Time: ${_formatCallTime(call.timestamp)}'),
            if (call.duration.inSeconds > 0)
              Text('Duration: ${_formatDuration(call.duration)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _makeCall(call.contactPhone, false);
            },
            child: const Text('Call Back'),
          ),
        ],
      ),
    );
  }

  void _showNewCallDialog() {
    final TextEditingController phoneController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Call'),
        content: TextField(
          controller: phoneController,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            hintText: '+1234567890',
          ),
          keyboardType: TextInputType.phone,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (phoneController.text.isNotEmpty) {
                Navigator.pop(context);
                _makeCall(phoneController.text, false);
              }
            },
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }

  void _showCallMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.clear_all),
            title: const Text('Clear call log'),
            onTap: () {
              Navigator.pop(context);
              _clearCallLog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Call settings'),
            onTap: () {
              Navigator.pop(context);
              _showCallSettings();
            },
          ),
        ],
      ),
    );
  }

  void _clearCallLog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear call log'),
        content: const Text('Are you sure you want to clear all call records?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _callRecords.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showCallSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Call Settings'),
        content: const Text('Call settings will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class CallRecord {
  final String contactName;
  final String contactPhone;
  final CallType callType;
  final CallStatus callStatus;
  final DateTime timestamp;
  final Duration duration;

  CallRecord({
    required this.contactName,
    required this.contactPhone,
    required this.callType,
    required this.callStatus,
    required this.timestamp,
    required this.duration,
  });
}

enum CallType {
  incoming,
  outgoing,
}

enum CallStatus {
  answered,
  missed,
  declined,
}