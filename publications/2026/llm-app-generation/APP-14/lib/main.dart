import 'package:flutter/material.dart';
import 'package:one_list/screens/main_screen.dart';
import 'package:one_list/services/location_service.dart';
import 'package:one_list/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await LocationService().init();
  runApp(const OneListApp());
}

class OneListApp extends StatelessWidget {
  const OneListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OneList',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xFFF5F5F7),
          foregroundColor: Colors.black,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
