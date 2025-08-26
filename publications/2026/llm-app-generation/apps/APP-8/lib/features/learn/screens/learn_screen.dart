import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/user.dart';
import '../../../shared/models/lesson.dart';
import '../widgets/learning_path.dart';
import '../widgets/top_bar.dart';
import '../widgets/daily_goal_progress.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  // Mock user data - will be replaced with actual provider data
  final User mockUser = User(
    id: '1',
    username: 'learner123',
    email: 'learner@example.com',
    totalXP: 1250,
    currentStreak: 7,
    gems: 450,
    hearts: 4,
    currentLanguage: 'Spanish',
    lastActiveDate: DateTime.now(),
    joinDate: DateTime.now().subtract(const Duration(days: 30)),
  );

  // Mock lessons data
  final List<Lesson> mockLessons = [
    Lesson(
      id: '1',
      title: 'Basics 1',
      description: 'Learn basic greetings and introductions',
      type: LessonType.basic,
      status: LessonStatus.completed,
      unitNumber: 1,
      lessonNumber: 1,
      exercises: [],
      language: 'Spanish',
    ),
    Lesson(
      id: '2',
      title: 'Basics 2',
      description: 'Learn numbers and colors',
      type: LessonType.basic,
      status: LessonStatus.available,
      unitNumber: 1,
      lessonNumber: 2,
      exercises: [],
      language: 'Spanish',
    ),
    Lesson(
      id: '3',
      title: 'Family',
      description: 'Learn family members',
      type: LessonType.basic,
      status: LessonStatus.locked,
      unitNumber: 1,
      lessonNumber: 3,
      exercises: [],
      language: 'Spanish',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.lightGray,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with streak, gems, hearts
            TopBar(user: mockUser),
            
            // Daily goal progress
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              child: DailyGoalProgress(
                currentXP: 15,
                goalXP: mockUser.dailyXPGoal,
              ),
            ),
            
            // Learning path
            Expanded(
              child: LearningPath(
                lessons: mockLessons,
                onLessonTap: _onLessonTap,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onLessonTap(Lesson lesson) {
    if (lesson.status == LessonStatus.locked) {
      _showLockedLessonDialog();
      return;
    }

    // Navigate to lesson screen
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => LessonScreen(lesson: lesson),
    //   ),
    // );
    
    // For now, show a placeholder dialog
    _showLessonDialog(lesson);
  }

  void _showLockedLessonDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lesson Locked'),
        content: const Text('Complete previous lessons to unlock this one.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLessonDialog(Lesson lesson) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(lesson.title),
        content: Text(lesson.description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Start lesson
            },
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }
}