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
        return _buildDialog(
          title: 'Confirm Quest Completion',
          content: 'Are you sure you its completed?\n'
              'You are unable to revert this decision.',
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                'Confirm',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                onStatusChanged(true); // Mark quest as completed
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialog({
    required String title,
    required String content,
    required List<Widget> actions,
  }) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 300, // Set a fixed width for the dialog
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.tertiaryColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                color: AppTheme.tertiaryTextColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: TextStyle(
                color: AppTheme.tertiaryTextColor,
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions,
            ),
          ],
        ),
      ),
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
                    style: TextStyle(
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
                  style: TextStyle(
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
                        ? Icon(
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
