import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/community/screens/community_screen.dart';
import 'package:calories_tracking/features/user_main/screens/user_main_screen.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;

  const BottomNavigationBarWidget({super.key, this.currentIndex = 2});

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
        currentIndex: currentIndex,
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
          if (index != currentIndex) {
            switch (index) {
              case 2: // Home tab
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const UserMainScreen()),
                      (Route<dynamic> route) => false,
                );
                break;
              case 4: // Community tab
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const CommunityScreen(),
                ));
                break;
              default:
              // For other tabs, just pop back to the previous screen
                if (currentIndex == 4) {
                  Navigator.of(context).pop();
                }
                // TODO: Implement navigation for other tabs
                break;
            }
          }
        },
      ),
    );
  }
}