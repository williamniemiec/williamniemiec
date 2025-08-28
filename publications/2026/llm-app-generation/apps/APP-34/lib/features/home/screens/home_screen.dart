import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/video.dart';
import '../../../shared/models/user.dart';
import '../widgets/video_feed.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top Tab Bar
            Container(
              height: 50,
              decoration: const BoxDecoration(
                color: AppConstants.backgroundColor,
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: AppConstants.textPrimaryColor,
                indicatorWeight: 2,
                labelColor: AppConstants.textPrimaryColor,
                unselectedLabelColor: AppConstants.textSecondaryColor,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                tabs: const [
                  Tab(text: 'For You'),
                  Tab(text: 'Following'),
                ],
              ),
            ),
            // Video Feed
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  VideoFeed(feedType: FeedType.forYou),
                  VideoFeed(feedType: FeedType.following),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}