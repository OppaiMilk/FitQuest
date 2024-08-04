import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/community/bloc/activity_bloc.dart';

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
        return buildUserNavigationBar(context);
      case UserRole.coach:
        return buildCoachNavigationBar(context);
      case UserRole.admin:
        return buildAdminNavigationBar(context);
    }
  }

  Widget buildUserNavigationBar(BuildContext context) {
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
          child: Icon(Icons.leaderboard),
        ),
        label: 'Leaderboard',
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
      onTap: (index) {
        if (index == 3) {
          context.read<ActivityBloc>().add(LoadActivities());
        }
        onTap(index);
      },
    );
  }

  Widget buildCoachNavigationBar(BuildContext context) {
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

  Widget buildAdminNavigationBar(BuildContext context) {
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
          child: Icon(Icons.group),
        ),
        label: 'User Manage',
      ),
      const BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(top:8.0, left:8.0, right:8.0, bottom:2.0),
          child: Icon(Icons.settings),
        ),
        label: 'Feedback Manage',
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
}