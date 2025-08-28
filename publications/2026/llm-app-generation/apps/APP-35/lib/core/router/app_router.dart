import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/leagues/screens/leagues_screen.dart';
import '../../features/leagues/screens/league_detail_screen.dart';
import '../../features/leagues/screens/create_league_screen.dart';
import '../../features/draft/screens/draft_room_screen.dart';
import '../../features/picks/screens/picks_screen.dart';
import '../../features/picks/screens/pick_entry_screen.dart';
import '../../features/feed/screens/feed_screen.dart';
import '../../features/messages/screens/messages_screen.dart';
import '../../features/messages/screens/chat_screen.dart';
import '../widgets/main_navigation.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/leagues',
    routes: [
      // Auth Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Main App Shell with Bottom Navigation
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigation(child: child);
        },
        routes: [
          // Leagues Tab
          GoRoute(
            path: '/leagues',
            name: 'leagues',
            builder: (context, state) => const LeaguesScreen(),
            routes: [
              GoRoute(
                path: '/create',
                name: 'create-league',
                builder: (context, state) => const CreateLeagueScreen(),
              ),
              GoRoute(
                path: '/:leagueId',
                name: 'league-detail',
                builder: (context, state) {
                  final leagueId = state.pathParameters['leagueId']!;
                  return LeagueDetailScreen(leagueId: leagueId);
                },
                routes: [
                  GoRoute(
                    path: '/draft',
                    name: 'draft-room',
                    builder: (context, state) {
                      final leagueId = state.pathParameters['leagueId']!;
                      return DraftRoomScreen(leagueId: leagueId);
                    },
                  ),
                ],
              ),
            ],
          ),

          // Picks Tab
          GoRoute(
            path: '/picks',
            name: 'picks',
            builder: (context, state) => const PicksScreen(),
            routes: [
              GoRoute(
                path: '/entry',
                name: 'pick-entry',
                builder: (context, state) => const PickEntryScreen(),
              ),
            ],
          ),

          // Feed Tab
          GoRoute(
            path: '/feed',
            name: 'feed',
            builder: (context, state) => const FeedScreen(),
          ),

          // Messages Tab
          GoRoute(
            path: '/messages',
            name: 'messages',
            builder: (context, state) => const MessagesScreen(),
            routes: [
              GoRoute(
                path: '/:channelId',
                name: 'chat',
                builder: (context, state) {
                  final channelId = state.pathParameters['channelId']!;
                  final channelName = state.uri.queryParameters['name'];
                  return ChatScreen(
                    channelId: channelId,
                    channelName: channelName,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/leagues'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );

  // Navigation helpers
  static void goToLeagues(BuildContext context) {
    context.go('/leagues');
  }

  static void goToLeagueDetail(BuildContext context, String leagueId) {
    context.go('/leagues/$leagueId');
  }

  static void goToDraftRoom(BuildContext context, String leagueId) {
    context.go('/leagues/$leagueId/draft');
  }

  static void goToPicks(BuildContext context) {
    context.go('/picks');
  }

  static void goToPickEntry(BuildContext context) {
    context.go('/picks/entry');
  }

  static void goToFeed(BuildContext context) {
    context.go('/feed');
  }

  static void goToMessages(BuildContext context) {
    context.go('/messages');
  }

  static void goToChat(BuildContext context, String channelId, {String? channelName}) {
    final uri = Uri(
      path: '/messages/$channelId',
      queryParameters: channelName != null ? {'name': channelName} : null,
    );
    context.go(uri.toString());
  }

  static void goToCreateLeague(BuildContext context) {
    context.go('/leagues/create');
  }

  static void goToLogin(BuildContext context) {
    context.go('/login');
  }

  static void goToSignup(BuildContext context) {
    context.go('/signup');
  }

  static void goToOnboarding(BuildContext context) {
    context.go('/onboarding');
  }
}