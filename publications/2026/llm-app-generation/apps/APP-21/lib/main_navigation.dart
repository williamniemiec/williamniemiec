import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/home/screens/home_screen.dart';
import 'features/explore/screens/explore_screen.dart';
import 'features/library/screens/library_screen.dart';
import 'features/search/screens/search_screen.dart';
import 'core/constants/app_colors.dart';

// Provider for managing the current tab index
final currentTabProvider = StateProvider<int>((ref) => 0);

class MainNavigation extends ConsumerWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentTabProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          HomeScreen(),
          ExploreScreen(),
          SearchScreen(),
          LibraryScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.bottomNavDark,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context: context,
                  ref: ref,
                  index: 0,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: 'Home',
                ),
                _buildNavItem(
                  context: context,
                  ref: ref,
                  index: 1,
                  icon: Icons.explore_outlined,
                  activeIcon: Icons.explore,
                  label: 'Explore',
                ),
                _buildNavItem(
                  context: context,
                  ref: ref,
                  index: 2,
                  icon: Icons.search_outlined,
                  activeIcon: Icons.search,
                  label: 'Search',
                ),
                _buildNavItem(
                  context: context,
                  ref: ref,
                  index: 3,
                  icon: Icons.library_music_outlined,
                  activeIcon: Icons.library_music,
                  label: 'Library',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required WidgetRef ref,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final currentIndex = ref.watch(currentTabProvider);
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () {
        ref.read(currentTabProvider.notifier).state = index;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                color: isActive 
                    ? AppColors.primary 
                    : AppColors.textSecondaryDark,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive 
                    ? AppColors.primary 
                    : AppColors.textSecondaryDark,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}