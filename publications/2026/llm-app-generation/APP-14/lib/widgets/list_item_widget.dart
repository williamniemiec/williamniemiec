import 'package:flutter/material.dart';
import 'package:one_list/models/list_item.dart';

class ListItemWidget extends StatelessWidget {
  final ListItem item;
  final VoidCallback onToggle;

  const ListItemWidget({
    super.key,
    required this.item,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        item.category == ItemCategory.shopping
            ? Icons.shopping_cart
            : Icons.check_box_outline_blank,
      ),
      title: Text(
        item.text,
        style: TextStyle(
          decoration: item.isCompleted
              ? TextDecoration.lineThrough
              : TextDecoration.none,
          color: item.isCompleted ? Colors.grey : Colors.black,
        ),
      ),
      onTap: onToggle,
    );
  }
}