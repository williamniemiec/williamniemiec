enum ItemCategory {
  todo,
  shopping,
}

class ListItem {
  final String text;
  final ItemCategory category;
  bool isCompleted;
  final DateTime? reminder;

  ListItem({
    required this.text,
    required this.category,
    this.isCompleted = false,
    this.reminder,
  });
}