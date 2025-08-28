import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

class MainNavigation extends StatelessWidget {
  final Widget child;

  const MainNavigation({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _buildBottomNavigationBar(context),
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;
    
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _getCurrentIndex(currentLocation),
        onTap: (index) => _onTabTapped(context, index),
        selectedItemColor: AppTheme.xBlue,
        unselectedItemColor: AppTheme.xGray,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'TwitterChirp',
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          fontFamily: 'TwitterChirp',
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Communities',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail_outline),
            activeIcon: Icon(Icons.mail),
            label: 'Messages',
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => context.push(AppConstants.composeRoute),
      backgroundColor: AppTheme.xBlue,
      foregroundColor: Colors.white,
      elevation: 4,
      child: const Icon(Icons.add, size: 28),
    );
  }

  int _getCurrentIndex(String location) {
    switch (location) {
      case AppConstants.homeRoute:
        return 0;
      case AppConstants.exploreRoute:
        return 1;
      case AppConstants.communitiesRoute:
        return 2;
      case AppConstants.notificationsRoute:
        return 3;
      case AppConstants.messagesRoute:
        return 4;
      default:
        return 0;
    }
  }

  void _onTabTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppConstants.homeRoute);
        break;
      case 1:
        context.go(AppConstants.exploreRoute);
        break;
      case 2:
        context.go(AppConstants.communitiesRoute);
        break;
      case 3:
        context.go(AppConstants.notificationsRoute);
        break;
      case 4:
        context.go(AppConstants.messagesRoute);
        break;
    }
  }
}