import 'package:flutter/material.dart';
import 'package:calories_tracking/features/user_main/models/user.dart';
import 'package:calories_tracking/features/user_main/repositories/user_repository.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final UserRepository _userRepository = UserRepository();
  List<User> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<User> users = await _userRepository.getAllUsers();
      users.sort((a, b) => b.totalPoints.compareTo(a.totalPoints));
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading users: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Implement share functionality
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _buildTopThree(),
          Expanded(
            child: _users.length > 3
                ? ListView.builder(
              itemCount: _users.length - 3,
              itemBuilder: (context, index) {
                return _buildUserListItem(_users[index + 3], index + 4);
              },
            )
                : Center(child: Text('No more users to display')),
          ),
        ],
      ),
    );
  }

  Widget _buildTopThree() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: _users.isEmpty
          ? Center(child: Text('No users to display'))
          : Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_users.length > 1) _buildTopUserItem(_users[1], 2),
          _buildTopUserItem(_users[0], 1),
          if (_users.length > 2) _buildTopUserItem(_users[2], 3),
        ],
      ),
    );
  }

  Widget _buildTopUserItem(User user, int rank) {
    double size = rank == 1 ? 100 : 80;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$rank',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        SizedBox(height: 8),
        CircleAvatar(
          radius: size / 2,
          backgroundColor: Colors.grey[300],
          child: Text(
            user.name[0],
            style: TextStyle(fontSize: size / 3, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 8),
        Text(
          user.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, size: 16, color: Colors.amber),
            SizedBox(width: 4),
            Text('${user.totalPoints} Points'),
          ],
        ),
      ],
    );
  }

  Widget _buildUserListItem(User user, int index) {
    return ListTile(
      leading: Text(
        '$index',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      title: Text(user.name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(user.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 16, color: Colors.amber),
          SizedBox(width: 4),
          Text('${user.totalPoints} Points'),
        ],
      ),
    );
  }
}