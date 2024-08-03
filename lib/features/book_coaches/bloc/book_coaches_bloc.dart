import 'package:calories_tracking/features/book_coaches/models/coach.dart';
import 'package:calories_tracking/features/book_coaches/repositories/coach_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class BookCoachesEvent {}

class LoadCoaches extends BookCoachesEvent {}

// States
abstract class BookCoachesState {}

class BookCoachesLoading extends BookCoachesState {}

class BookCoachesLoaded extends BookCoachesState {
  final List<Coach> coaches;

  BookCoachesLoaded(this.coaches);
}

class BookCoachesError extends BookCoachesState {
  final String message;

  BookCoachesError(this.message);
}

// Bloc
class BookCoachesBloc extends Bloc<BookCoachesEvent, BookCoachesState> {
  final CoachRepository _coachRepository;

  BookCoachesBloc(this._coachRepository) : super(BookCoachesLoading()) {
    on<LoadCoaches>((event, emit) async {
      emit(BookCoachesLoading());
      try {
        final coaches = await _coachRepository.getCoaches();
        emit(BookCoachesLoaded(coaches));
      } catch (e) {
        emit(BookCoachesError(e.toString()));
      }
    });
  }
}
