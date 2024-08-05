import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/user_main/bloc/user_bloc.dart';
import 'package:calories_tracking/features/user_main/models/user.dart';
import 'package:calories_tracking/features/user_main/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final UserRepository _userRepository = UserRepository();
  List<User> _users = [];
  bool _isLoading = true;
  String? _userId;
  final ScrollController _scrollController = ScrollController();
  bool _isCurrentUserVisible = false;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
    _scrollController.addListener(_checkCurrentUserVisibility);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_checkCurrentUserVisibility);
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchUserId() async {
    final userBloc = BlocProvider.of<UserBloc>(context);

    userBloc.stream.listen((state) {
      if (state is UserLoaded) {
        setState(() {
          _userId = state.user.uid;
          print('Current user ID: $_userId');
          _loadUsers();
        });
      }
    });

    if (userBloc.state is! UserLoaded) {
      String? currentUserId = '';
      if (currentUserId.isNotEmpty) {
        userBloc.add(FetchUser(currentUserId));
      } else {
        print('No user ID available. User might need to log in.');
      }
    }
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkCurrentUserVisibility();
      });
    } catch (e) {
      print('Error loading users: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load users. Please try again.')),
      );
    }
  }

  void _checkCurrentUserVisibility() {
    if (_userId == null || _users.isEmpty) return;

    final currentUserIndex = _users.indexWhere((user) => user.uid == _userId);
    if (currentUserIndex == -1) return;

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final viewportHeight = renderBox.size.height;
    final scrollOffset = _scrollController.offset;
    const itemHeight = 60.0; // Approximate height of a ListTile
    const topThreeHeight = 150.0; // Approximate height of the top three section

    final itemPosition = (currentUserIndex * itemHeight) + topThreeHeight;

    // Check if the item is about to leave the visible area
    const buffer = itemHeight * 2; // Show sticky when user's entry is within 2 items of leaving the screen
    final isVisible = (itemPosition >= scrollOffset) && (itemPosition < scrollOffset + viewportHeight - buffer);

    if (isVisible != _isCurrentUserVisible) {
      setState(() {
        _isCurrentUserVisible = isVisible;
      });
    }
  }

  void _scrollToCurrentUser() {
    if (_userId == null || _users.isEmpty) return;

    final currentUserIndex = _users.indexWhere((user) => user.uid == _userId);
    if (currentUserIndex == -1) return;

    const itemHeight = 60.0; // Approximate height of a ListTile
    const topThreeHeight = 150.0; // Approximate height of the top three section

    _scrollController.animateTo(
      (currentUserIndex * itemHeight) + topThreeHeight,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _refreshLeaderboard() async {
    await _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.tertiaryColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          RefreshIndicator(
            color: AppTheme.primaryColor,
            backgroundColor: AppTheme.secondaryColor,
            onRefresh: _refreshLeaderboard,
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: _buildTopThree(),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final user = _users[index];
                      return _buildUserListItem(user, index + 1);
                    },
                    childCount: _users.length,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 80),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedOpacity(
              opacity: _isCurrentUserVisible ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: GestureDetector(
                onTap: _scrollToCurrentUser,
                child: _buildCurrentUserSticky(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopThree() {
    return Container(
      color: AppTheme.tertiaryColor,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: _users.isEmpty
          ? const Center(child: Text('No users to display'))
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

  Widget _buildCurrentUserSticky() {
    final currentUser = _users.firstWhere(
          (user) => user.uid == _userId,
    );

    if (currentUser.uid.isEmpty) return const SizedBox.shrink();

    final userIndex = _users.indexWhere((user) => user.uid == currentUser.uid) + 1;

    return Material(
      color: AppTheme.primaryColor,
      child: SafeArea(
        top: false,
        child: ListTile(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 24,
                child: Text(
                  '$userIndex',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: AppTheme.secondaryColor,
                backgroundImage: currentUser.profileUrl.isNotEmpty
                    ? NetworkImage(currentUser.profileUrl)
                    : null,
                child: currentUser.profileUrl.isEmpty
                    ? Text(currentUser.name[0])
                    : null,
              ),
            ],
          ),
          title: Text(currentUser.name,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          subtitle: Text(currentUser.location, style: const TextStyle(color: Colors.white70)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              Text('${currentUser.totalPoints} Points', style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserListItem(User user, int index) {
    return Material(
      color: user.uid == _userId ? AppTheme.primaryColor.withOpacity(0.2) : AppTheme.tertiaryColor,
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 24,
              child: Text(
                '$index',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: AppTheme.secondaryColor,
              backgroundImage: user.profileUrl.isNotEmpty
                  ? NetworkImage(user.profileUrl)
                  : null,
              child: user.profileUrl.isEmpty ? Text(user.name[0]) : null,
            ),
          ],
        ),
        title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(user.location),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, size: 16, color: Colors.amber),
            const SizedBox(width: 4),
            Text('${user.totalPoints} Points'),
          ],
        ),
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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: AppTheme.primaryColor,  // Changed from Colors.white
          ),
        ),
        const SizedBox(height: 8),
        CircleAvatar(
          radius: size / 2,
          backgroundColor: AppTheme.secondaryColor,
          backgroundImage: user.profileUrl.isNotEmpty ? NetworkImage(user.profileUrl) : null,
          child: user.profileUrl.isEmpty
              ? Text(
            user.name[0],
            style: TextStyle(
              fontSize: size / 3,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          )
              : null,
        ),
        const SizedBox(height: 8),
        Text(
          user.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, size: 16, color: Colors.amber),
            const SizedBox(width: 4),
            Text(
              '${user.totalPoints} Points',
              style: const TextStyle(color: AppTheme.primaryColor),
            ),
          ],
        ),
      ],
    );
  }
}