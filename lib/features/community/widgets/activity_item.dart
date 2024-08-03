import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ActivityItem extends StatefulWidget {
  final String activity;

  const ActivityItem({
    super.key,
    required this.activity,
  });

  @override
  State<ActivityItem> createState() => _ActivityItemState();
}

class _ActivityItemState extends State<ActivityItem> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                widget.activity,
                style: const TextStyle(
                  color: AppTheme.tertiaryTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : AppTheme.tertiaryTextColor,
            ),
            onPressed: () {
              setState(() {
                isLiked = !isLiked;
              });
            },
          ),
        ],
      ),
    );
  }
}