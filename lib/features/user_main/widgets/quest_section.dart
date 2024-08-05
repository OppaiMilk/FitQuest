  import 'package:flutter/material.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';

class QuestSection extends StatelessWidget {
  final List<QuestData> quests;
  final double completionPercentage;
  final Widget Function(BuildContext, int) questItemBuilder;
  final VoidCallback onSharePressed;

  const QuestSection({
    super.key,
    required this.quests,
    required this.completionPercentage,
    required this.questItemBuilder,
    required this.onSharePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.tertiaryColor,
        border: Border.all(
          color: AppTheme.secondaryColor,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Today's Quest",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.tertiaryTextColor,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: AppTheme.tertiaryTextColor),
                  onPressed: onSharePressed,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: completionPercentage,
                      backgroundColor: AppTheme.secondaryColor,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${(completionPercentage * 100).toInt()}% Completed',
                  style: const TextStyle(
                    color: AppTheme.tertiaryTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: quests.length,
            itemBuilder: questItemBuilder,
          ),
        ],
      ),
    );
  }
}

class QuestData {
  final String title;
  final String description;
  final bool isCompleted;

  const QuestData({
    required this.title,
    required this.description,
    required this.isCompleted,
  });
}