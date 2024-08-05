import 'package:flutter/material.dart';
import 'package:calories_tracking/features/community/models/activity.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/core/utils/time_parser.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Card(
        color: AppTheme.secondaryColor,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.tertiaryTextColor,
                ),
                maxLines: 2, // Limit to 2 lines
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Text(
                TimeParser.formatReadableDateTime(activity.timestamp),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}