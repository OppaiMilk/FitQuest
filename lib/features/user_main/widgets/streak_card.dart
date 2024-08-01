import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class StreakCard extends StatelessWidget {
  final VoidCallback onSharePressed;
  final int streakDays;
  final bool allQuestsCompletedToday;

  const StreakCard({
    Key? key,
    required this.onSharePressed,
    required this.streakDays,
    required this.allQuestsCompletedToday,
  }) : super(key: key);

  int get currentDayIndex {
    final now = DateTime.now();
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
        padding: const EdgeInsets.all(18),
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
              '${allQuestsCompletedToday ? streakDays : streakDays - 1} Days',
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
      width: isCurrentDay ? 22 : 16,
      height: isCurrentDay ? 26 : 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isStreakDay ? AppTheme.primaryColor : AppTheme.tertiaryColor,
      ),
    );
  }

  bool _isStreakDay(int index) {
    int streakToShow = allQuestsCompletedToday ? streakDays : streakDays - 1;
    int daysAgo = (currentDayIndex - index + 7) % 7;
    return daysAgo < streakToShow;
  }
}