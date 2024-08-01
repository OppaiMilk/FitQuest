import 'package:calories_tracking/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/coach_repository.dart';
import '../bloc/book_coaches_bloc.dart';
import '../widgets/search_field.dart';
import '../widgets/coach_grid.dart';
import '../widgets/coach_card.dart';
import 'coach_details_screen.dart';

class CoachListScreen extends StatelessWidget {
  final CoachRepository coachRepository;

  const CoachListScreen({super.key, required this.coachRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookCoachesBloc(coachRepository)..add(LoadCoaches()),
      child: const _CoachListView(),
    );
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.primaryTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Coaches', style: TextStyle(color: AppTheme.primaryTextColor, fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Column(
        children: [
          SearchField(
            onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
            backgroundColor: AppTheme.tertiaryColor,
            textColor: AppTheme.tertiaryTextColor,
          ),
          Expanded(
            child: BlocBuilder<BookCoachesBloc, BookCoachesState>(
              builder: (context, state) {
                return _buildContent(context, state);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, BookCoachesState state) {
    return switch (state) {
      BookCoachesLoading() => const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
      BookCoachesLoaded() => CoachGrid(
        coaches: state.coaches,
        searchQuery: _searchQuery,
        coachBuilder: (coach) => CoachCard(
          coach: coach,
          onTap: (context, coach) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CoachDetailsScreen(coach: coach),
              ),
            );
          },
          backgroundColor: AppTheme.secondaryColor,
          textColor: AppTheme.primaryTextColor,
          gradientColor: AppTheme.primaryColor,
          starColor: AppTheme.starColor,
        ),
      ),
      BookCoachesError() => Center(
        child: Text(state.message, style: const TextStyle(color: AppTheme.primaryColor, fontSize: 16)),
      ),
      _ => const Center(
        child: Text('No coaches available', style: TextStyle(color: AppTheme.tertiaryTextColor, fontSize: 16)),
      ),
    };
  }
}
