import 'package:flutter/material.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';

class QuestItem extends StatelessWidget {
  final String name;
  final String description;
  final bool isCompleted;
  final void Function(bool status) onStatusChanged;

  const QuestItem({
    super.key,
    required this.name,
    required this.description,
    required this.isCompleted,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppTheme.tertiaryTextColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: AppTheme.secondaryTextColor.withOpacity(0.7),
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                onStatusChanged(!isCompleted);
              },
              child: Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.primaryColor,
                    width: 2.0,
                  ),
                  shape: BoxShape.circle,
                  color:
                      isCompleted ? AppTheme.primaryColor : Colors.transparent,
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
          ),
        ],
      ),
    );
  }
}
