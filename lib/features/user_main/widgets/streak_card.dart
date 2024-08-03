import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/core/utils/time_parser.dart';
import 'package:flutter/material.dart';

class StreakCard extends StatelessWidget {
  final VoidCallback onSharePressed;
  final int currentStreak;
  final bool allQuestsCompletedToday;
  final DateTime lastCompletedDate;

  const StreakCard({
    super.key,
    required this.onSharePressed,
    required this.currentStreak,
    required this.allQuestsCompletedToday,
    required this.lastCompletedDate,
  });

  int get currentDayIndex {
    final now = TimeParser.getMalaysiaTime();
    return now.weekday % 7; // 0 for Sunday, 1 for Monday, ..., 6 for Saturday
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Streak',
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
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                7,
                    (index) => _buildStreakCircle(index),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '$currentStreak Days',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppTheme.tertiaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCircle(int index) {
    bool isCurrentDay = index == currentDayIndex;
    bool isStreakDay = _isStreakDay(index);

    return Container(
      width: isCurrentDay ? 28 : 16,
      height: isCurrentDay ? 28 : 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isStreakDay ? AppTheme.primaryColor : AppTheme.tertiaryColor,
        border: isCurrentDay ? Border.all(color: AppTheme.primaryTextColor, width: 2) : null,
      ),
    );
  }

  bool _isStreakDay(int index) {
    final today = TimeParser.getMalaysiaTime();
    final lastCompletedIndex = lastCompletedDate.weekday % 7;
    final todayIndex = today.weekday % 7;

    if (index > todayIndex) {
      return false;
    }

    if (index == todayIndex) {
      return allQuestsCompletedToday;
    }

    int streakToShow = currentStreak;
    if (allQuestsCompletedToday && TimeParser.isConsecutiveDay(lastCompletedDate)) {
      streakToShow += 1;
    }

    for (int i = 0; i < streakToShow && i < 7; i++) {
      int checkIndex = (lastCompletedIndex - i + 7) % 7;
      if (checkIndex == index) return true;
    }

    // Check if today should be colored (when all quests are completed today)
    if (allQuestsCompletedToday && index == todayIndex) return true;

    return false;
  }
}