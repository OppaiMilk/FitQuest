import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/book_coaches/models/coach.dart';
import 'package:calories_tracking/features/book_coaches/repositories/coach_repository.dart';
import 'package:calories_tracking/features/book_coaches/widgets/square_info_card.dart';
import 'package:calories_tracking/features/settings/screens/app_support.dart';
import 'package:flutter/material.dart';

class ProfileSettings extends StatefulWidget {
  final String coachId;
  const ProfileSettings({super.key, required this.coachId});

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  final CoachRepository _coachRepository = CoachRepository();
  Coach? coach;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final coachDetails = await _coachRepository.getCoachDetails(widget.coachId);
    setState(() {
      coach = coachDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: [_buildProfileInfo()],
      ),
    );
  }

  Widget _buildProfileInfo() {
    if (coach == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileHeader(coach!),
            const SizedBox(height: 20),
            _buildCoachInfo(coach!),
            const SizedBox(height: 20),
            _buildInfoCards(context, coach!),
            const SizedBox(height: 20),
            _buildModifyProfile(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Coach coach) {
    return Center(
      child: CircleAvatar(
        backgroundColor: AppTheme.secondaryColor,
        radius: 70,
        child: ClipOval(
          child: Image.network(
            coach.profileUrl,
            width: 140,
            height: 140,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.person,
                size: 70,
                color: AppTheme.primaryColor,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCoachInfo(Coach coach) {
    return Center(
      child: Column(
        children: [
          Text(
            coach.name,
            style: const TextStyle(
              color: AppTheme.tertiaryTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            coach.email,
            style: const TextStyle(
              color: AppTheme.secondaryTextColor,
              fontSize: 16,
            ),
          ),
          Text(
            coach.location,
            style: const TextStyle(
              color: AppTheme.secondaryTextColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCards(BuildContext context, Coach coach) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        color: AppTheme.secondaryColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    _buildSquareInfoCard(
                        '${coach.yearsOfExperience}', 'Years of\nExperience'),
                    const SizedBox(width: 8),
                    _buildSquareInfoCard(
                        coach.rating.toStringAsFixed(1), 'User\nRating'),
                    const SizedBox(width: 8),
                    _buildSquareInfoCard(
                        '${coach.completedSessions}', 'Completed\nSessions'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSquareInfoCard(String value, String label) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: SquareInfoCard(
          value: value,
          label: label,
          backgroundColor: AppTheme.tertiaryColor,
          textColor: AppTheme.tertiaryTextColor,
        ),
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

    return Column(
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
    );
  }

  Widget _buildOthersSupport() {
    return Column(
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
        Card(
          child: ListTile(
            title: const Text('Support'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SupportScreen()),
              );
            },
          ),
        ),
      ],
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
