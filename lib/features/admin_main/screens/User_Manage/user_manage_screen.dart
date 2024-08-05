import 'package:calories_tracking/features/admin_main/screens/User_Manage/user_details_screen.dart';
import 'package:flutter/material.dart';

class UserManageScreen extends StatelessWidget{
  const UserManageScreen({super.key});


  @override
  Widget build(BuildContext context){
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
          child: ListView.builder(
            itemCount: 4, // Change this to your actual user count
            itemBuilder: (context, index) {
              return ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.grey,
                ),
                title: const Text('Jane Doe'),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  UserDetailsScreen(),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}