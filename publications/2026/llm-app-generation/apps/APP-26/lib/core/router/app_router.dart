import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/explore/screens/explore_screen.dart';
import '../../features/communities/screens/communities_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/messages/screens/messages_screen.dart';
import '../../features/messages/screens/conversation_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/compose/screens/compose_screen.dart';
import '../../features/spaces/screens/spaces_screen.dart';
import '../../features/spaces/screens/space_detail_screen.dart';
import '../../shared/widgets/main_navigation.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter createRouter() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: AppConstants.homeRoute,
      routes: [
        // Auth routes (outside shell)
        GoRoute(
          path: AppConstants.loginRoute,
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppConstants.registerRoute,
          name: 'register',
          builder: (context, state) => const RegisterScreen(),
        ),
        
        // Main app shell with bottom navigation
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return MainNavigation(child: child);
          },
          routes: [
            // Home
            GoRoute(
              path: AppConstants.homeRoute,
              name: 'home',
              builder: (context, state) => const HomeScreen(),
            ),
            
            // Explore
            GoRoute(
              path: AppConstants.exploreRoute,
              name: 'explore',
              builder: (context, state) => const ExploreScreen(),
            ),
            
            // Communities
            GoRoute(
              path: AppConstants.communitiesRoute,
              name: 'communities',
              builder: (context, state) => const CommunitiesScreen(),
            ),
            
            // Notifications
            GoRoute(
              path: AppConstants.notificationsRoute,
              name: 'notifications',
              builder: (context, state) => const NotificationsScreen(),
            ),
            
            // Messages
            GoRoute(
              path: AppConstants.messagesRoute,
              name: 'messages',
              builder: (context, state) => const MessagesScreen(),
            ),
          ],
        ),
        
        // Full screen routes (outside shell)
        GoRoute(
          path: '/conversation/:id',
          name: 'conversation',
          builder: (context, state) {
            final conversationId = state.pathParameters['id']!;
            return ConversationScreen(conversationId: conversationId);
          },
        ),
        
        GoRoute(
          path: '/profile/:username',
          name: 'profile',
          builder: (context, state) {
            final username = state.pathParameters['username']!;
            return ProfileScreen(username: username);
          },
        ),
        
        GoRoute(
          path: '/profile/:username/edit',
          name: 'edit_profile',
          builder: (context, state) {
            final username = state.pathParameters['username']!;
            return EditProfileScreen(username: username);
          },
        ),
        
        GoRoute(
          path: AppConstants.composeRoute,
          name: 'compose',
          builder: (context, state) {
            final replyToId = state.uri.queryParameters['replyTo'];
            final quoteId = state.uri.queryParameters['quote'];
            return ComposeScreen(
              replyToId: replyToId,
              quoteId: quoteId,
            );
          },
        ),
        
        GoRoute(
          path: '/post/:id',
          name: 'post_detail',
          builder: (context, state) {
            final postId = state.pathParameters['id']!;
            return PostDetailScreen(postId: postId);
          },
        ),
        
        GoRoute(
          path: AppConstants.spacesRoute,
          name: 'spaces',
          builder: (context, state) => const SpacesScreen(),
        ),
        
        GoRoute(
          path: '/space/:id',
          name: 'space_detail',
          builder: (context, state) {
            final spaceId = state.pathParameters['id']!;
            return SpaceDetailScreen(spaceId: spaceId);
          },
        ),
        
        GoRoute(
          path: '/community/:id',
          name: 'community_detail',
          builder: (context, state) {
            final communityId = state.pathParameters['id']!;
            return CommunityDetailScreen(communityId: communityId);
          },
        ),
        
        GoRoute(
          path: AppConstants.settingsRoute,
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
      
      redirect: (context, state) {
        final authProvider = context.read<AuthProvider>();
        final isLoggedIn = authProvider.isAuthenticated;
        final isLoggingIn = state.matchedLocation == AppConstants.loginRoute ||
                           state.matchedLocation == AppConstants.registerRoute;

        // If not logged in and not on auth pages, redirect to login
        if (!isLoggedIn && !isLoggingIn) {
          return AppConstants.loginRoute;
        }

        // If logged in and on auth pages, redirect to home
        if (isLoggedIn && isLoggingIn) {
          return AppConstants.homeRoute;
        }

        return null; // No redirect needed
      },
      
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Page not found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                state.error?.toString() ?? 'Unknown error',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go(AppConstants.homeRoute),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder screens that we'll implement later
class PostDetailScreen extends StatelessWidget {
  final String postId;
  
  const PostDetailScreen({super.key, required this.postId});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: Center(child: Text('Post Detail: $postId')),
    );
  }
}

class CommunityDetailScreen extends StatelessWidget {
  final String communityId;
  
  const CommunityDetailScreen({super.key, required this.communityId});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community')),
      body: Center(child: Text('Community Detail: $communityId')),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Screen')),
    );
  }
}