import 'package:flutter/material.dart';

class UserDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Text('jameswaltz@gmail.com'),
            Text('Seri Kembangan'),
            SizedBox(height: 16),
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
                ElevatedButton(onPressed: () {}, child: Text('Message')),
                ElevatedButton(onPressed: () {}, child: Text('Edit')),
                ElevatedButton(onPressed: () {}, child: Text('Delete')),
              ],
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
    return Column(
      children: <Widget>[
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
