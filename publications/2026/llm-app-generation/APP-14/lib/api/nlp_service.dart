import 'package:one_list/models/list_item.dart';

class NlpService {
  ListItem parseText(String text) {
    // This is a placeholder for a real NLP model.
    // For now, we'll use simple keyword-based detection.
    final lowercasedText = text.toLowerCase();
    
    // Keywords for shopping
    const shoppingKeywords = ['buy', 'get', 'pick up'];

    // Default to 'todo'
    var category = ItemCategory.todo;

    for (final keyword in shoppingKeywords) {
      if (lowercasedText.startsWith(keyword)) {
        category = ItemCategory.shopping;
        break;
      }
    }

    // Placeholder for date/time parsing
    // In a real app, this would use a library like `chrono` or a custom parser.
    DateTime? reminder;
    if (lowercasedText.contains('tomorrow')) {
      reminder = DateTime.now().add(const Duration(days: 1));
    }

    return ListItem(
      text: text,
      category: category,
      reminder: reminder,
    );
  }
}