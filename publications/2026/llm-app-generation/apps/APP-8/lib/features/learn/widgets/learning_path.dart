import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/lesson.dart';

class LearningPath extends StatelessWidget {
  final List<Lesson> lessons;
  final Function(Lesson) onLessonTap;

  const LearningPath({
    super.key,
    required this.lessons,
    required this.onLessonTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      child: Column(
        children: [
          // Unit header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.spacingM),
            margin: const EdgeInsets.only(bottom: AppConstants.spacingL),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppConstants.primaryGreen, AppConstants.lightGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Unit 1',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.white,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingXS),
                const Text(
                  'Form basic sentences',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppConstants.white,
                  ),
                ),
              ],
            ),
          ),
          
          // Learning path with lessons
          ...lessons.asMap().entries.map((entry) {
            final index = entry.key;
            final lesson = entry.value;
            final isEven = index % 2 == 0;
            
            return Container(
              margin: const EdgeInsets.only(bottom: AppConstants.spacingL),
              child: Row(
                children: [
                  if (!isEven) const Spacer(),
                  Expanded(
                    flex: 2,
                    child: LessonNode(
                      lesson: lesson,
                      onTap: () => onLessonTap(lesson),
                    ),
                  ),
                  if (isEven) const Spacer(),
                ],
              ),
            );
          }).toList(),
          
          // Continue path indicator
          Container(
            height: 60,
            width: 4,
            decoration: BoxDecoration(
              color: AppConstants.gray.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          const SizedBox(height: AppConstants.spacingM),
          
          // Coming soon indicator
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            decoration: BoxDecoration(
              color: AppConstants.lightGray,
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
              border: Border.all(
                color: AppConstants.gray.withOpacity(0.3),
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.lock_outline,
                  color: AppConstants.gray,
                  size: 32,
                ),
                SizedBox(height: AppConstants.spacingS),
                Text(
                  'More lessons coming soon!',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppConstants.darkGray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LessonNode extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback onTap;

  const LessonNode({
    super.key,
    required this.lesson,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color nodeColor;
    Color borderColor;
    IconData icon;
    
    switch (lesson.status) {
      case LessonStatus.completed:
        nodeColor = AppConstants.primaryGreen;
        borderColor = AppConstants.darkGreen;
        icon = Icons.check;
        break;
      case LessonStatus.available:
        nodeColor = AppConstants.blue;
        borderColor = AppConstants.darkBlue;
        icon = Icons.play_arrow;
        break;
      case LessonStatus.locked:
        nodeColor = AppConstants.gray;
        borderColor = AppConstants.darkGray;
        icon = Icons.lock;
        break;
      case LessonStatus.perfect:
        nodeColor = AppConstants.yellow;
        borderColor = AppConstants.orange;
        icon = Icons.star;
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // Lesson node
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: nodeColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor,
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: nodeColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: AppConstants.white,
              size: 32,
            ),
          ),
          
          const SizedBox(height: AppConstants.spacingS),
          
          // Lesson title
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingS,
              vertical: AppConstants.spacingXS,
            ),
            decoration: BoxDecoration(
              color: AppConstants.white,
              borderRadius: BorderRadius.circular(AppConstants.radiusS),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.gray.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              lesson.title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppConstants.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}