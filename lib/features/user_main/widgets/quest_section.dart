import 'package:calories_tracking/features/user_main/models/quest.dart';
import 'package:calories_tracking/features/user_main/widgets/quest_item.dart';
import 'package:flutter/material.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';

class QuestSection extends StatelessWidget {
  final List<Quest> quests;
  final List<bool> questCompletionStatus;
  final double completionPercentage;
  final void Function(int index, bool status) onQuestStatusChanged;

  const QuestSection({
    super.key,
    required this.quests,
    required this.questCompletionStatus,
    required this.completionPercentage,
    required this.onQuestStatusChanged,
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
                  icon: const Icon(Icons.share,
                      color: AppTheme.tertiaryTextColor),
                  onPressed: () {},
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
            itemBuilder: (context, index) {
              final quest = quests[index];
              return QuestItem(
                name: quest.title,
                description: quest.description,
                isCompleted: questCompletionStatus[index],
                onStatusChanged: (status) {
                  onQuestStatusChanged(index, status);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
