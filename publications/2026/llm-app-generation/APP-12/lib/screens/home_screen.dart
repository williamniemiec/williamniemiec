import 'package:flow_launcher/screens/app_library_screen.dart';
import 'package:flow_launcher/widgets/smart_stack.dart';
import 'package:flow_launcher/widgets/unified_search_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          // Swipe up
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AppLibraryScreen()),
          );
        } else if (details.primaryVelocity! > 0) {
          // Swipe down
          // TODO: Implement search activation
          print("Swipe Down");
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Smart Stack Area
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: SmartStack(),
            ),
            // Search Bar Area
            Positioned(
              bottom: 50,
              left: 20,
              right: 20,
              child: UnifiedSearchBar(),
            ),
          ],
        ),
      ),
    );
  }
}