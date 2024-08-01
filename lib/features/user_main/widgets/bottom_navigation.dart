import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      color: AppTheme.primaryColor,
      child: BottomNavigationBar(
        backgroundColor: AppTheme.primaryColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.tertiaryColor,
        unselectedItemColor: AppTheme.primaryTextColor.withOpacity(0.6),
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Community',
          ),
        ],
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }
}
