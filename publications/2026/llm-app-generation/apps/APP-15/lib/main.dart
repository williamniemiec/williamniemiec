import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/utils/app_router.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/content/providers/content_provider.dart';
import 'shared/models/user.dart';
import 'shared/models/content.dart';
import 'shared/models/membership.dart';
import 'shared/models/guest.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(MembershipTypeAdapter());
  Hive.registerAdapter(ContentAdapter());
  Hive.registerAdapter(ContentTypeAdapter());
  Hive.registerAdapter(ContentCategoryAdapter());
  Hive.registerAdapter(DifficultyLevelAdapter());
  Hive.registerAdapter(MembershipAdapter());
  Hive.registerAdapter(MembershipPlanAdapter());
  Hive.registerAdapter(MembershipStatusAdapter());
  Hive.registerAdapter(PaymentMethodAdapter());
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(TransactionTypeAdapter());
  Hive.registerAdapter(TransactionStatusAdapter());
  Hive.registerAdapter(GuestAdapter());
  Hive.registerAdapter(GuestStatusAdapter());
  
  // Open Hive boxes
  await Hive.openBox<User>(AppConstants.userBox);
  await Hive.openBox<Content>(AppConstants.contentBox);
  await Hive.openBox<Membership>(AppConstants.membershipBox);
  await Hive.openBox<Guest>(AppConstants.guestBox);
  await Hive.openBox(AppConstants.settingsBox);
  
  runApp(const BlinkFitnessApp());
}

class BlinkFitnessApp extends StatelessWidget {
  const BlinkFitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ContentProvider()),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
