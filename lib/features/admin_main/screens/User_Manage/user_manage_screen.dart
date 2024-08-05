import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManageScreen extends StatefulWidget {
  const UserManageScreen({super.key});

  @override
  _UserManageScreenState createState() => _UserManageScreenState();
}

class _UserManageScreenState extends State<UserManageScreen> {
  late Future<List<Map<String, dynamic>>> _coaches;

  Future<List<Map<String, dynamic>>> _getCoaches() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('role', isEqualTo: 'coach')
          .get();

      List<Map<String, dynamic>> coaches = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['docId'] = doc.id; // 添加文档的id到数据中
        return data;
      }).toList();

      return coaches;
    } catch (e) {
      print('Error getting coaches: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _coaches = _getCoaches();
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
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _coaches,
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
                      leading: Icon(CupertinoIcons.profile_circled),
                      title: Text(coach['name'] ?? 'No Name'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => UserDetailsScreen(userId: coach['uid']),
                        //   ),
                        // );
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
