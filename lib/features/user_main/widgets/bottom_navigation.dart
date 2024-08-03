import 'package:flutter/material.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';

enum UserRole { user, coach, admin }

class CustomBottomNavigationBar extends StatelessWidget {
  final UserRole role;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.role,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    switch (role) {
      case UserRole.user:
        return _buildUserNavigationBar();
      case UserRole.coach:
        return _buildCoachNavigationBar();
      case UserRole.admin:
        return _buildAdminNavigationBar();
    }
  }

  Widget _buildUserNavigationBar() {
    final List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(top:8.0, left:8.0, right:8.0, bottom:2.0),
          child: Icon(Icons.home),
        ),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(top:8.0, left:8.0, right:8.0, bottom:2.0),
          child: Icon(Icons.calendar_today),
        ),
        label: 'Calendar',
      ),
      const BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(top:8.0, left:8.0, right:8.0, bottom:2.0),
          child: Icon(Icons.chat),
        ),
        label: 'Chat',
      ),
      const BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(top:8.0, left:8.0, right:8.0, bottom:2.0),
          child: Icon(Icons.group),
        ),
        label: 'Community',
      ),
      const BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(top:8.0, left:8.0, right:8.0, bottom:2.0),
          child: Icon(Icons.settings),
        ),
        label: 'Settings',
      ),
    ];

    return BottomNavigationBar(
      backgroundColor: AppTheme.primaryColor,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.tertiaryColor,
      unselectedItemColor: AppTheme.primaryTextColor.withOpacity(0.6),
      currentIndex: currentIndex,
      items: items,
      onTap: onTap,
    );
  }

  Widget _buildCoachNavigationBar() {
    final List<BottomNavigationBarItem> items = [
    // TODO: Implement coach navigation bar
    ];

    return BottomNavigationBar(
      backgroundColor: AppTheme.primaryColor,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.tertiaryColor,
      unselectedItemColor: AppTheme.primaryTextColor.withOpacity(0.6),
      currentIndex: currentIndex,
      items: items,
      onTap: onTap,
    );
  }

  Widget _buildAdminNavigationBar() {
    final List<BottomNavigationBarItem> items = [
      // TODO: Implement coach navigation bar
    ];

    return BottomNavigationBar(
      backgroundColor: AppTheme.primaryColor,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppTheme.tertiaryColor,
      unselectedItemColor: AppTheme.primaryTextColor.withOpacity(0.6),
      currentIndex: currentIndex,
      items: items,
      onTap: onTap,
    );
  }
}