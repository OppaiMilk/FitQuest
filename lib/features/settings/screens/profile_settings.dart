import 'package:calories_tracking/features/settings/screens/app_support.dart';
import 'package:flutter/material.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: [_buildProfileInfo()],
      ),
    );
  }

  Widget _buildProfileInfo() {
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
                  'Session in the last X days',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildModifyProfile(),
        ],
      ),
    );
  }

  Widget _buildModifyProfile() {
    List<String> profileSettings = [
      'Change Profile Picture',
      'Change Username',
      'Change Email',
      'Change Password',
    ];

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profile',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...profileSettings.asMap().entries.map((entry) {
            int index = entry.key;
            String setting = entry.value;
            return Card(
              child: ListTile(
                title: Text(setting),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _navigateToProfileSettings(index);
                },
              ),
            );
          }),
          const SizedBox(height: 20),
          _buildOthersSupport()
        ],
      ),
    );
  }

  Widget _buildOthersSupport() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Others',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: const Text('Support'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SupportScreen()));
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

  void _navigateToProfileSettings(int index) {
    switch (index) {
      case 0:
        print('1');
        break;
      case 1:
        print('2');
        break;
      case 2:
        print('3');
        break;
      case 3:
        print('4');
        break;
      default:
        print('ERROR');
        break;
    }
  }
}
