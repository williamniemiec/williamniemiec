import 'package:flutter/material.dart';

class FeedTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController controller;

  const FeedTabBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: TabBar(
        controller: controller,
        indicatorColor: Theme.of(context).primaryColor,
        indicatorWeight: 2,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Theme.of(context).textTheme.bodySmall?.color,
        labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.normal,
        ),
        tabs: const [
          Tab(text: 'For you'),
          Tab(text: 'Following'),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}