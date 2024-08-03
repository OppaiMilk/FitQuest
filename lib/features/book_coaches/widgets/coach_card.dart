import 'package:calories_tracking/features/book_coaches/models/coach.dart';
import 'package:flutter/material.dart';

class CoachCard extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final Color gradientColor;
  final Color starColor;
  final Coach coach;
  final Function(BuildContext, Coach) onTap;

  const CoachCard({
    super.key,
    required this.backgroundColor,
    required this.textColor,
    required this.gradientColor,
    required this.starColor,
    required this.coach,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context, coach),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildCoachImage(),
            _buildGradientOverlay(),
            _buildCoachInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildCoachImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        coach.profileUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: backgroundColor,
            child: Icon(Icons.person, size: 50, color: gradientColor),
          );
        },
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            gradientColor.withOpacity(0.0),
            gradientColor.withOpacity(0.7),
          ],
        ),
      ),
    );
  }

  Widget _buildCoachInfo() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            coach.name,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '${coach.rating}',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 2),
              Icon(
                Icons.star,
                size: 16,
                color: starColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
