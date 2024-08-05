import 'package:calories_tracking/features/admin_main/screens/User_Manage/user_details_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManageScreen extends StatefulWidget {
  const UserManageScreen({super.key});

  @override
  _UserManageScreenState createState() => _UserManageScreenState();
}

class _UserManageScreenState extends State<UserManageScreen> {
  Stream<List<Map<String, dynamic>>> _getCoachesStream() {
    return FirebaseFirestore.instance
        .collection('Users')
        .where('role', isEqualTo: 'coach')
        .snapshots()
        .map((snapshot) {
      print('Data snapshot received: ${snapshot.docs.length} documents');
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['docId'] = doc.id; // 如果没有 uid 字段，使用 doc.id
        return data;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Search',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          // 使用 StreamBuilder 代替 FutureBuilder 来监听实时数据变化
          child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: _getCoachesStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading users'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No coaches found'));
              } else {
                final coaches = snapshot.data!;
                return ListView.builder(
                  itemCount: coaches.length,
                  itemBuilder: (context, index) {
                    final coach = coaches[index];
                    return ListTile(
                      leading: const Icon(CupertinoIcons.profile_circled),
                      title: Text(coach['name'] ?? 'No Name'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            // 如果没有 uid 字段，使用 docId
                            builder: (context) => UserDetailsScreen(userId: coach['uid'] ?? coach['docId']),
                          ),
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
