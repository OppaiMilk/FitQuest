import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class StreakCard extends StatelessWidget {
  final VoidCallback onSharePressed;

  const StreakCard({
    super.key,
    required this.onSharePressed,
  });

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
                  icon: const Icon(Icons.share,
                      color: AppTheme.tertiaryTextColor),
                  onPressed: onSharePressed,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                7,
                (index) => Container(
                  width: index == 3 ? 22 : 16,
                  height: index == 3 ? 26 : 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index <= 3
                        ? AppTheme.primaryColor
                        : AppTheme.tertiaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '4 Days',
              style: TextStyle(
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
}
