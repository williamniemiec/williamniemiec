import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

class NetflixAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackground;
  final List<Widget>? actions;
  final Widget? title;

  const NetflixAppBar({
    super.key,
    this.showBackground = false,
    this.actions,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: showBackground 
          ? AppTheme.netflixBlack.withOpacity(0.9)
          : Colors.transparent,
      elevation: 0,
      title: title ?? Row(
        children: [
          Image.asset(
            'assets/images/netflix_logo.png',
            height: 28,
            errorBuilder: (context, error, stackTrace) {
              return Text(
                'NETFLIX',
                style: TextStyle(
                  color: AppTheme.netflixRed,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              // TODO: Filter TV Shows
            },
            child: const Text(
              'TV Shows',
              style: TextStyle(
                color: AppTheme.netflixWhite,
                fontSize: 16,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Filter Movies
            },
            child: const Text(
              'Movies',
              style: TextStyle(
                color: AppTheme.netflixWhite,
                fontSize: 16,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Show categories
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Categories',
                  style: TextStyle(
                    color: AppTheme.netflixWhite,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppTheme.netflixWhite,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: actions,
      titleSpacing: AppConstants.defaultPadding,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}