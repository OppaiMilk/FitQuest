import 'package:flutter/material.dart';
import '../models/coach.dart';

class CoachGrid extends StatelessWidget {
  final List<Coach> coaches;
  final String searchQuery;
  final Widget Function(Coach) coachBuilder;

  const CoachGrid({
    super.key,
    required this.coaches,
    required this.searchQuery,
    required this.coachBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final filteredCoaches = coaches
        .where((coach) => coach.name.toLowerCase().contains(searchQuery))
        .toList();

    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
      ),
      itemCount: filteredCoaches.length,
      itemBuilder: (context, index) => coachBuilder(filteredCoaches[index]),
    );
  }
}