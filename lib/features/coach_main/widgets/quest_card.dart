import 'package:flutter/material.dart';

class QuestCard extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final Color gradientColor;
  final String questTitle;
  // final String points;

  const QuestCard({
    super.key,
    required this.backgroundColor,
    required this.textColor,
    required this.gradientColor,
    required this.questTitle,
    // required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // _buildImage(),
          _buildGradientOverlay(),
          _buildQuestInfo(),
        ],
      ),
    );
  }

  // Widget _buildImage() {
  //   return ClipRRect(
  //     borderRadius: BorderRadius.circular(8),
  //     child: Image.network(
  //       imageUrl, // Use the fetched image URL
  //       fit: BoxFit.cover,
  //       errorBuilder: (context, error, stackTrace) {
  //         return Container(
  //           color: backgroundColor,
  //           child: Icon(
  //             Icons.fitness_center,
  //             size: 50,
  //             color: gradientColor,
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

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

  Widget _buildQuestInfo() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            questTitle,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
