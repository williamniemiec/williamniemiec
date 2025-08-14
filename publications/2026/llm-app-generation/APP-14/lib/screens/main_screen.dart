import 'package:flutter/material.dart';
import 'package:one_list/api/nlp_service.dart';
import 'package:one_list/models/list_item.dart';
import 'package:one_list/services/notification_service.dart';
import 'package:one_list/utils/filter_options.dart';
import 'package:one_list/widgets/filter_pill.dart';
import 'package:one_list/widgets/list_item_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ListItem> _items = [];
  final NlpService _nlpService = NlpService();
  final NotificationService _notificationService = NotificationService();
  FilterOption _selectedFilter = FilterOption.all;

  List<ListItem> get _filteredItems {
    switch (_selectedFilter) {
      case FilterOption.todo:
        return _items.where((item) => item.category == ItemCategory.todo).toList();
      case FilterOption.shopping:
        return _items.where((item) => item.category == ItemCategory.shopping).toList();
      case FilterOption.all:
      default:
        return _items;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OneList'),
      ),
      body: Column(
        children: [
          _buildFilterPills(),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return ListItemWidget(
                  item: item,
                  onToggle: () {
                    setState(() {
                      item.isCompleted = !item.isCompleted;
                    });
                  },
                );
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _textController,
        decoration: const InputDecoration(
          hintText: 'What do you need to do?',
        ),
        onSubmitted: (text) {
          final newItem = _nlpService.parseText(text);
          if (newItem.reminder != null) {
            _notificationService.scheduleNotification(
              id: _items.length, // simple unique id
              title: 'Reminder',
              body: newItem.text,
              scheduledDate: newItem.reminder!,
            );
          }
          setState(() {
            _items.add(newItem);
          });
          _textController.clear();
        },
      ),
    );
  }

  Widget _buildFilterPills() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FilterPill(
            label: 'All',
            isSelected: _selectedFilter == FilterOption.all,
            onTap: () => setState(() => _selectedFilter = FilterOption.all),
          ),
          FilterPill(
            label: 'To-Do',
            isSelected: _selectedFilter == FilterOption.todo,
            onTap: () => setState(() => _selectedFilter = FilterOption.todo),
          ),
          FilterPill(
            label: 'Shopping',
            isSelected: _selectedFilter == FilterOption.shopping,
            onTap: () => setState(() => _selectedFilter = FilterOption.shopping),
          ),
        ],
      ),
    );
  }
}