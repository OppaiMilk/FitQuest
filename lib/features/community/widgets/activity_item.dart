import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ActivityItem extends StatelessWidget {
  final String activity;

  const ActivityItem({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            activity,
            style: const TextStyle(
              color: AppTheme.tertiaryTextColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}