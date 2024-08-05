import 'package:flutter/material.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';

enum appbarType { user, coach, admin }

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final appbarType role;
  final int currentIndex;
  final String name;

  const CustomAppBar({
    super.key,
    required this.role,
    required this.currentIndex,
    required this.name,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    switch (role) {
      case appbarType.user:
        return _buildUserAppBar();
      case appbarType.coach:
        return _buildCoachAppBar();
      case appbarType.admin:
        return _buildAdminAppBar();
    }
  }

  /// ------------------------------Admin------------------------------ ///

  Widget _buildAdminAppBar() {
    String titleText;
    List<Widget> actions = [];

    switch (currentIndex) {
      case 0:
        titleText = "Dashboard";
        actions = [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppTheme.primaryTextColor),
            onPressed: () {},
          ),
        ];
        break;
      case 1:
        titleText = "User Management";
        break;
      case 2:
        titleText = "Feedback";
        break;
      default:
        titleText = "Error";
        break;
    }

    return AppBar(
      backgroundColor: AppTheme.primaryColor,
      elevation: 0,
      title: titleText == "Dashboard"
          ? _buildWelcomeText(name)
          : Text(
              titleText,
              style: const TextStyle(
                color: AppTheme.primaryTextColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
      actions: actions,
    );
  }

  /// ------------------------------User------------------------------ ///

  Widget _buildUserAppBar() {
    String titleText;
    List<Widget> actions = [];

    switch (currentIndex) {
      // case ?:
      //   titleText = "";
      //   actions = [
      //     IconButton(
      //       icon: const Icon(Icons.notifications_outlined, color: AppTheme.primaryTextColor),
      //       onPressed: () {
      //
      //       },
      //     ),
      //   ];
      //   break;
      case 0:
        titleText = "Dashboard";
        actions = [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppTheme.primaryTextColor),
            onPressed: () {},
          ),
        ];
        break;
      case 1:
        titleText = "User Management";
        break;
      case 2:
        titleText = "Feedback";
        break;
      default:
        titleText = "Error";
        break;
    }

    return AppBar(
      backgroundColor: AppTheme.primaryColor,
      elevation: 0,
      title: titleText == "Dashboard"
          ? _buildWelcomeText(name)
          : Text(
              titleText,
              style: const TextStyle(
                color: AppTheme.primaryTextColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
      actions: actions,
    );
  }

  ///  ------------------------------Coach------------------------------ ///

  Widget _buildCoachAppBar() {
    String titleText;
    List<Widget> actions = [];

    switch (currentIndex) {
      // case ?:
      //   titleText = "";
      //   actions = [
      //     IconButton(
      //       icon: const Icon(Icons.notifications_outlined, color: AppTheme.primaryTextColor),
      //       onPressed: () {
      //
      //       },
      //     ),
      //   ];
      //   break;
      case 0:
        titleText = "Dashboard";
        actions = [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppTheme.primaryTextColor),
            onPressed: () {},
          ),
        ];
        break;
      case 1:
        titleText = "Calendar";
        break;
      case 2:
        titleText = "Chat";
        break;
      case 3:
        titleText = "Settings";
        break;
      default:
        titleText = "Error";
        break;
    }

    return AppBar(
      backgroundColor: AppTheme.primaryColor,
      elevation: 0,
      title: titleText == "Dashboard"
          ? _buildWelcomeText("userName")
          : Text(
              titleText,
              style: const TextStyle(
                color: AppTheme.primaryTextColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
      actions: actions,
    );
  }

  ///  ------------------------------Widget------------------------------ ///
  Widget _buildWelcomeText(String userName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome Back',
          style: TextStyle(
            color: AppTheme.primaryTextColor,
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
        Text(
          userName,
          style: const TextStyle(
            color: AppTheme.primaryTextColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
