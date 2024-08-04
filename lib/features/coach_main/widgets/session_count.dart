import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SessionCount extends StatelessWidget {
  final int sessionCount;

  const SessionCount({
    super.key,
    required this.sessionCount,
  });

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$sessionCount',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.tertiaryTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'total completed sessions',
              style: TextStyle(
                fontSize: 20,
                color: AppTheme.tertiaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}