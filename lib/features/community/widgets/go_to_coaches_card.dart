import 'package:flutter/material.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';

class ContactCoachesCard extends StatelessWidget {
  final VoidCallback onTap;

  const ContactCoachesCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: AppTheme.secondaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildPlaceholderImage(),
            _buildGradientOverlay(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        'lib/core/assets/pic/workout.jpg',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppTheme.secondaryColor,
            child: const Icon(
                Icons.group, size: 50, color: AppTheme.primaryColor),
          );
        },
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.primaryColor.withOpacity(0.0),
            AppTheme.primaryColor.withOpacity(0.7),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text aligned to the bottom-left
              Expanded(
                child: Text(
                  'Get in Contact With Coaches',
                  style: TextStyle(
                    color: AppTheme.primaryTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Arrow icon aligned to the bottom-right
              Icon(Icons.arrow_forward, color: AppTheme.primaryTextColor),
            ],
          ),
        ],
      ),
    );
  }
}
