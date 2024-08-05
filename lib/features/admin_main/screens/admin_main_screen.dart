import 'package:calories_tracking/features/admin_main/screens/Feedback_Manage/feedback_admin_screen.dart';
import 'package:calories_tracking/features/admin_main/screens/User_Manage/user_manage_screen.dart';
import 'package:calories_tracking/features/commonWidget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import '../../commonWidget/bottom_navigation.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  _AdminMainScreenState createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _currentIndex = 0;
  List<String> approvals = [
    'Approval 1',
    'Approval 2',
    'Approval 3',
    'Approval 4',
    'Approval 5'
  ];
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.tertiaryColor,
      appBar: CustomAppBar(
        role: appbarType.admin,
        currentIndex: _currentIndex,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildMainContent(),
          const UserManageScreen(),
          const AdminFeedbackScreen(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        role: UserRole.admin,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                Text(
                  '5',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Coach Registrations Pending Approval',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildPendingApprovalsSection(),
        ],
      ),
    );
  }

  Widget _buildPendingApprovalsSection() {
    List<String> filteredApprovals = approvals
        .where((approval) =>
            approval.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pending Approvals',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          _buildSearchBox(),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: filteredApprovals.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(filteredApprovals[index]),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // 实现导航到详细信息页面
                      _navigateToApprovalDetail(filteredApprovals[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return TextField(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: 'Search',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
    );
  }

  void _navigateToApprovalDetail(String approval) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApprovalDetailScreen(approval: approval),
      ),
    );
  }
}

class ApprovalDetailScreen extends StatelessWidget {
  final String approval;

  const ApprovalDetailScreen({super.key, required this.approval});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approval Detail'),
      ),
      body: Center(
        child: Text('Details for $approval'),
      ),
    );
  }
}
