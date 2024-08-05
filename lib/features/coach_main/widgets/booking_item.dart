import 'package:flutter/material.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';

class BookingItem extends StatelessWidget {
  final String client;
  final String location;

  const BookingItem({
    super.key,
    required this.client,
    required this.location,
  });

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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Booking by $client',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.tertiaryTextColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Location at $location',
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
          const Padding(
            padding: EdgeInsets.all(16),
            child: Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.tertiaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}