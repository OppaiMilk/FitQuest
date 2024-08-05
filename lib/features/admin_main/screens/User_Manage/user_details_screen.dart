import 'package:flutter/material.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'James Waltz',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text('jameswaltz@gmail.com'),
            const Text('Seri Kembangan'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildInfoCard('35', 'Days of Streaks'),
                buildInfoCard('2351', 'Total Points'),
                buildInfoCard('22', 'Completed Sessions'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(onPressed: () {}, child: const Text('Message')),
                ElevatedButton(onPressed: () {}, child: const Text('Edit')),
                ElevatedButton(onPressed: () {}, child: const Text('Delete')),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Recent Workouts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 3 / 2,
                ),
                itemCount: 2, // Change this to your actual workout count
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.grey.shade300,
                    child: const Center(child: Text('Workout Name')),
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
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
