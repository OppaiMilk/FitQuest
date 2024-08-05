import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class UserDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.tertiaryColor,
      appBar: AppBar(
        title: Text('User Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'James Waltz',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('jameswaltz@gmail.com'), //Email
            Text('Seri Kembangan'), // Location
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        buildInfoCard('35', 'Days of Streaks'),
                        buildInfoCard('2351', 'Total Points'),
                        buildInfoCard('22', 'Completed Sessions'),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(onPressed: () {}, child: Text('Edit')),
                        ElevatedButton(onPressed: () {}, child: Text('Delete')),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 32),
            Text(
              'Recent Workouts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 3 / 2,
                ),
                itemCount: 2, // Change this to your actual workout count
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.grey.shade300,
                    child: Center(child: Text('Workout Name')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard(String value, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: <Widget>[
            Text(
              value,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(label),
          ],
        ),
      ),
    );
  }
}
