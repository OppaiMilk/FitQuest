import 'package:calories_tracking/features/admin_main/bloc/admin_approve_coach_bloc.dart';
import 'package:calories_tracking/features/admin_main/screens/Feedback_Manage/feedback_admin_screen.dart';
import 'package:calories_tracking/features/admin_main/screens/User_Manage/user_manage_screen.dart';
import 'package:calories_tracking/features/commonWidget/appbar.dart';
import 'package:calories_tracking/features/commonWidget/rectangle_custom_button.dart';
import 'package:calories_tracking/features/onboarding/model/User.dart';
import 'package:calories_tracking/helper/screen_height_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import '../../commonWidget/bottom_navigation.dart';

class AdminMainScreen extends StatefulWidget {
  final SystemUser admin;

  const AdminMainScreen({Key? key, required this.admin}) : super(key: key);

  @override
  _AdminMainScreenState createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _currentIndex = 0;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CoachApprovalBloc(FirebaseFirestore.instance)
        ..add(LoadPendingApprovals()),
      child: Scaffold(
        backgroundColor: AppTheme.tertiaryColor,
        appBar: CustomAppBar(
          role: appbarType.admin,
          currentIndex: _currentIndex,
          name: widget.admin.name!,
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _buildMainContent(),
            UserManageScreen(),
            FeedbackManageScreen(),
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
      ),
    );
  }

  Widget _buildMainContent() {
    return BlocBuilder<CoachApprovalBloc, CoachApprovalState>(
      builder: (context, state) {
        if (state is CoachApprovalLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is CoachApprovalLoaded) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 40),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${state.pendingApprovals.length}',
                        style: TextStyle(
                          fontSize: 35,
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
                _buildPendingApprovalsSection(state.pendingApprovals),
              ],
            ),
          );
        } else if (state is CoachApprovalError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return Center(child: Text('No pending approvals'));
        }
      },
    );
  }

  Widget _buildPendingApprovalsSection(List<QueryDocumentSnapshot> approvals) {
    List<QueryDocumentSnapshot> filteredApprovals = approvals
        .where((approval) => approval['name']
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                    var approval = filteredApprovals[index];
                    var userId = approval.id; // 获取 document ID 作为 userId
                    var userName = approval['name'] as String; // 确保是 String 类型

                    return Card(
                      child: ListTile(
                        title: Text(userName),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          _navigateToApprovalDetail(userId);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
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

  void _navigateToApprovalDetail(String userId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApprovalDetailsScreen(
          userId: userId,
        ),
      ),
    );
    if (result == true) {
      setState(() {
        context.read<CoachApprovalBloc>().add(LoadPendingApprovals());
      });
    }
  }
}

class ApprovalDetailsScreen extends StatelessWidget {
  final String userId;

  ApprovalDetailsScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CoachApprovalBloc(FirebaseFirestore.instance),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Approval Details'),
          ),
          body: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('Users')
                .doc(userId)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(child: Text('No data found'));
              }

              var userData = snapshot.data!.data() as Map<String, dynamic>;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData['name'] ?? 'No Name',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Email: ${userData['email'] ?? 'N/A'}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('Status: ${userData['status'] ?? 'N/A'}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 16),
                        Text(
                          'Attached Qualifications',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Container(
                          height: ScreenHeightHelper(context).getScreenHeight()/2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white
                          ),
                          child: PDF().cachedFromUrl(
                            userData['qualification'],
                            placeholder: (double progress) => Center(child: Text('$progress %')),
                            errorWidget: (dynamic error) => Center(child: Text(error.toString())),
                          ),
                        ),
                        SizedBox(height: 16),
                        Spacer(),
                        _buildActionButton(context, userData['status']),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }

  Widget _buildActionButton(BuildContext context, String status) {
    String newStatus = status == 'pending' ? 'approved' : 'pending';
    return RectangleCustomButton(
      buttonText: 'Change Status to $newStatus',
      onPressed: () async {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .update({
          'status': newStatus,
        });

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Status updated to $newStatus')));

        Navigator.pop(context, true);
      },
    );
  }
}
