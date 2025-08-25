import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'shared/models/user.dart';
import 'shared/models/message.dart';
import 'shared/models/team.dart';
import 'shared/models/chat.dart';
import 'shared/models/meeting.dart';
import 'shared/models/activity.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive Adapters
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(UserStatusAdapter());
  Hive.registerAdapter(UserRoleAdapter());
  Hive.registerAdapter(MessageAdapter());
  Hive.registerAdapter(MessageTypeAdapter());
  Hive.registerAdapter(MessageStatusAdapter());
  Hive.registerAdapter(MessageAttachmentAdapter());
  Hive.registerAdapter(MessageReactionAdapter());
  Hive.registerAdapter(TeamAdapter());
  Hive.registerAdapter(TeamTypeAdapter());
  Hive.registerAdapter(TeamVisibilityAdapter());
  Hive.registerAdapter(ChannelAdapter());
  Hive.registerAdapter(ChannelTypeAdapter());
  Hive.registerAdapter(ChatAdapter());
  Hive.registerAdapter(ChatTypeAdapter());
  Hive.registerAdapter(MeetingAdapter());
  Hive.registerAdapter(MeetingTypeAdapter());
  Hive.registerAdapter(MeetingStatusAdapter());
  Hive.registerAdapter(ActivityAdapter());
  Hive.registerAdapter(ActivityTypeAdapter());
  Hive.registerAdapter(ActivityPriorityAdapter());
  
  // Open Hive boxes
  await Hive.openBox<User>(AppConstants.userBox);
  await Hive.openBox<Message>(AppConstants.messageBox);
  await Hive.openBox<Chat>(AppConstants.chatBox);
  await Hive.openBox<Team>(AppConstants.teamBox);
  await Hive.openBox<Meeting>(AppConstants.meetingBox);
  await Hive.openBox<Activity>(AppConstants.activityBox);
  
  runApp(
    const ProviderScope(
      child: TeamsApp(),
    ),
  );
}

class TeamsApp extends ConsumerWidget {
  const TeamsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    
    return authState.when(
      initial: () => const SplashScreen(),
      loading: () => const SplashScreen(),
      authenticated: (user) => const MainAppScreen(),
      unauthenticated: () => const LoginScreen(),
      error: (message) => const LoginScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Teams Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.groups,
                color: AppTheme.primaryBlue,
                size: 60,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // App Name
            Text(
              AppConstants.appName,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppTheme.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Loading Indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.white),
            ),
          ],
        ),
      ),
    );
  }
}

// Extension to handle AuthState pattern matching
extension AuthStateExtension on AuthState {
  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(User user) authenticated,
    required T Function() unauthenticated,
    required T Function(String message) error,
  }) {
    if (this is AuthStateInitial) {
      return initial();
    } else if (this is AuthStateLoading) {
      return loading();
    } else if (this is AuthStateAuthenticated) {
      return authenticated((this as AuthStateAuthenticated).user);
    } else if (this is AuthStateUnauthenticated) {
      return unauthenticated();
    } else if (this is AuthStateError) {
      return error((this as AuthStateError).message);
    } else {
      return initial();
    }
  }
}
