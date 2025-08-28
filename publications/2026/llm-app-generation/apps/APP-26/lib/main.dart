import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/home/providers/home_provider.dart';
import 'features/explore/providers/explore_provider.dart';
import 'features/messages/providers/messages_provider.dart';
import 'features/notifications/providers/notifications_provider.dart';
import 'features/profile/providers/profile_provider.dart';
import 'shared/models/models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters
  _registerHiveAdapters();
  
  runApp(const XApp());
}

void _registerHiveAdapters() {
  // Register all Hive type adapters
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(PostAdapter());
  Hive.registerAdapter(PollAdapter());
  Hive.registerAdapter(PollOptionAdapter());
  Hive.registerAdapter(CommunityAdapter());
  Hive.registerAdapter(CommunitySettingsAdapter());
  Hive.registerAdapter(MessageAdapter());
  Hive.registerAdapter(MessageTypeAdapter());
  Hive.registerAdapter(ConversationAdapter());
  Hive.registerAdapter(XNotificationAdapter());
  Hive.registerAdapter(NotificationTypeAdapter());
  Hive.registerAdapter(SpaceAdapter());
  Hive.registerAdapter(SpaceStateAdapter());
  Hive.registerAdapter(TrendAdapter());
  Hive.registerAdapter(TrendTypeAdapter());
}

class XApp extends StatelessWidget {
  const XApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ExploreProvider()),
        ChangeNotifierProvider(create: (_) => MessagesProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp.router(
            title: 'X',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            routerConfig: AppRouter.createRouter(),
          );
        },
      ),
    );
  }
}
