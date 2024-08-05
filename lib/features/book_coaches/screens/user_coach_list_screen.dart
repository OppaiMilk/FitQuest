import 'package:calories_tracking/features/community/bloc/activity_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:calories_tracking/features/book_coaches/bloc/book_coaches_bloc.dart';
import 'package:calories_tracking/features/book_coaches/screens/user_coach_details_screen.dart';
import 'package:calories_tracking/features/book_coaches/widgets/coach_card.dart';
import 'package:calories_tracking/features/book_coaches/widgets/coach_grid.dart';
import 'package:calories_tracking/features/book_coaches/widgets/search_field.dart';

class CoachListScreen extends StatelessWidget {
  const CoachListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CoachListView();
  }
}

class _CoachListView extends StatefulWidget {
  const _CoachListView();

  @override
  _CoachListViewState createState() => _CoachListViewState();
}

class _CoachListViewState extends State<_CoachListView> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    print('CoachListScreen: initState called');
    _loadCoaches();
  }

  void _loadCoaches() {
    print('CoachListScreen: Loading coaches');
    context.read<BookCoachesBloc>().add(LoadCoaches());
  }

  Future<void> _navigateToCoachDetails(
      BuildContext context, String coachId) async {
    print('CoachListScreen: Navigating to CoachDetailsScreen');
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => CoachDetailsScreen(coachId: coachId),
      ),
    );

    print(
        'CoachListScreen: Returned from CoachDetailsScreen with result: $result');
    if (result == true) {
      print('CoachListScreen: Refreshing coaches after returning from details');
      _loadCoaches();
    } else {
      print('CoachListScreen: No refresh needed');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('CoachListScreen: build method called');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryTextColor),
          onPressed: () {
            print('CoachListScreen: Back button pressed');
            context.read<ActivityBloc>().add(LoadActivities());
            Navigator.pop(context);
          },
        ),
        title: const Text('Coaches',
            style: TextStyle(
                color: AppTheme.primaryTextColor,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Column(
        children: [
          SearchField(
            onChanged: (value) {
              print('CoachListScreen: Search query changed to: $value');
              setState(() => _searchQuery = value.toLowerCase());
            },
            backgroundColor: AppTheme.tertiaryColor,
            textColor: AppTheme.tertiaryTextColor,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                print('CoachListScreen: Manual refresh triggered');
                _loadCoaches();
              },
              color: AppTheme.primaryColor,
              backgroundColor: AppTheme.tertiaryColor,
              child: BlocBuilder<BookCoachesBloc, BookCoachesState>(
                builder: (context, state) {
                  print(
                      'CoachListScreen: BlocBuilder rebuilding with state: ${state.runtimeType}');
                  return _buildContent(context, state);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, BookCoachesState state) {
    if (state is BookCoachesLoading) {
      print('CoachListScreen: Showing loading indicator');
      return const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor));
    } else if (state is BookCoachesLoaded) {
      print('CoachListScreen: Coaches loaded, count: ${state.coaches.length}');
      return CoachGrid(
        coaches: state.coaches,
        searchQuery: _searchQuery,
        coachBuilder: (coach) => CoachCard(
          coach: coach,
          onTap: (context, coach) {
            print('CoachListScreen: Coach card tapped for coach: ${coach.id}');
            _navigateToCoachDetails(context, coach.id);
          },
          backgroundColor: AppTheme.secondaryColor,
          textColor: AppTheme.primaryTextColor,
          gradientColor: AppTheme.primaryColor,
          starColor: AppTheme.starColor,
        ),
      );
    } else if (state is BookCoachesError) {
      print('CoachListScreen: Error state: ${state.message}');
      return Center(
        child: Text(state.message,
            style: const TextStyle(color: AppTheme.primaryColor, fontSize: 16)),
      );
    } else {
      print('CoachListScreen: Unknown state');
      return const Center(
        child: Text('No coaches available',
            style: TextStyle(color: AppTheme.tertiaryTextColor, fontSize: 16)),
      );
    }
  }
}
