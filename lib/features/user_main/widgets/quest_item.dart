import 'package:flutter/material.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';

class QuestItem extends StatelessWidget {
  final String name;
  final String description;
  final int points;
  final bool isCompleted;
  final void Function(bool status) onStatusChanged;

  const QuestItem({
    super.key,
    required this.name,
    required this.description,
    required this.points,
    required this.isCompleted,
    required this.onStatusChanged,
  });

  void _showCompletionConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm Quest Completion',
            style: TextStyle(color: AppTheme.tertiaryTextColor),
          ),
          content: const Text(
            'Are you sure it\'s completed?\nYou are unable to revert this decision.',
            style: TextStyle(color: AppTheme.tertiaryTextColor),
          ),
          actions: [
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppTheme.primaryColor),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text(
                'Confirm',
                style: TextStyle(color: AppTheme.primaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onStatusChanged(true); // Mark quest as completed
              },
            ),
          ],
          backgroundColor: AppTheme.tertiaryColor,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.tertiaryTextColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      color: AppTheme.secondaryTextColor.withOpacity(0.7),
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '+$points pts',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 8), // Add space between points and circle
                GestureDetector(
                  onTap: isCompleted
                      ? null
                      : () => _showCompletionConfirmationDialog(context),
                  child: Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppTheme.primaryColor,
                        width: 2.0,
                      ),
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? AppTheme.primaryColor
                          : Colors.transparent,
                    ),
                    child: isCompleted
                        ? const Icon(
                      Icons.check,
                      size: 16,
                      color: AppTheme.tertiaryColor,
                    )
                        : null,
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